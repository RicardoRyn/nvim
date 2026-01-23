-- 自定义 Python 配置，用于提取参数的默认值
local nodes_utils = require("neogen.utilities.nodes")
local helpers = require("neogen.utilities.helpers")
local extractors = require("neogen.utilities.extractors")
local locator = require("neogen.locators.default")
local i = require("neogen.types.template").item

local parent = {
  func = { "function_definition" },
  class = { "class_definition" },
  file = { "module" },
  type = { "expression_statement" },
}

--- 检查最近的父节点
local get_nearest_parent = function(node, type_name)
  local current = node
  while current ~= nil do
    if current:type() == type_name then
      return current
    end
    current = current:parent()
  end
  return nil
end

--- 去重异常节点
local deduplicate_throw_nodes = function(nodes)
  if not nodes[i.Throw] then
    return
  end
  local output = {}
  local seen = {}
  for _, node in ipairs(nodes[i.Throw]) do
    local text = helpers.get_node_text(node)[1]
    if not vim.tbl_contains(seen, text) then
      table.insert(seen, text)
      table.insert(output, node)
    end
  end
  nodes[i.Throw] = output
end

--- 验证裸返回
local validate_bare_returns = function(nodes)
  local return_nodes = nodes[i.Return]
  local has_data = false
  for _, node in pairs(return_nodes) do
    if node:child_count() > 1 then
      has_data = true
    end
  end
  if not has_data then
    nodes[i.Return] = nil
  end
end

--- 验证直接返回
local validate_direct_returns = function(nodes, parent)
  local return_nodes = nodes[i.Return]
  for _, node in pairs(return_nodes) do
    if get_nearest_parent(node, "function_definition") == parent then
      return
    end
  end
  nodes[i.Return] = nil
end

--- 验证yield节点
local validate_yield_nodes = function(nodes)
  if nodes[i.Yield] ~= nil and nodes[i.Return] ~= nil then
    nodes[i.Return] = nil
  end
end

return {
  parent = parent,
  data = {
    func = {
      ["function_definition"] = {
        ["0"] = {
          extract = function(node)
            local tree = {
              {
                retrieve = "all",
                node_type = "parameters",
                subtree = {
                  { retrieve = "all", node_type = "identifier", extract = true, as = i.Parameter },
                  {
                    retrieve = "all",
                    node_type = "default_parameter",
                    subtree = {
                      {
                        position = 1,
                        node_type = "identifier",
                        extract = true,
                        as = i.Parameter,
                      },
                    },
                  },
                  {
                    retrieve = "all",
                    node_type = "typed_parameter",
                    extract = true,
                    as = i.Tparam,
                  },
                  {
                    retrieve = "all",
                    node_type = "typed_default_parameter",
                    as = i.Tparam,
                    extract = true,
                  },
                  {
                    retrieve = "first",
                    node_type = "list_splat_pattern",
                    extract = true,
                    as = i.ArbitraryArgs,
                  },
                  {
                    retrieve = "first",
                    node_type = "dictionary_splat_pattern",
                    extract = true,
                    as = i.ArbitraryArgs,
                  },
                },
              },
              {
                retrieve = "first",
                node_type = "block",
                subtree = {
                  {
                    retrieve = "all",
                    node_type = "return_statement",
                    recursive = true,
                    extract = true,
                    as = i.Return,
                  },
                  {
                    retrieve = "all",
                    node_type = "expression_statement",
                    recursive = true,
                    subtree = {
                      {
                        retrieve = "first",
                        node_type = "yield",
                        recursive = true,
                        extract = true,
                        as = i.Yield,
                      },
                    },
                  },
                  {
                    retrieve = "all",
                    node_type = "raise_statement",
                    recursive = true,
                    subtree = {
                      {
                        retrieve = "first",
                        node_type = "call",
                        recursive = true,
                        subtree = {
                          {
                            retrieve = "first",
                            node_type = "identifier",
                            extract = true,
                            as = i.Throw,
                          },
                        },
                      },
                    },
                  },
                  {
                    retrieve = "all",
                    node_type = "raise_statement",
                    recursive = true,
                    subtree = {
                      {
                        retrieve = "first",
                        node_type = "call",
                        recursive = true,
                        subtree = {
                          {
                            retrieve = "first",
                            node_type = "attribute",
                            extract = true,
                            as = i.Throw,
                          },
                        },
                      },
                    },
                  },
                },
              },
              {
                retrieve = "all",
                node_type = "type",
                as = i.ReturnTypeHint,
                extract = true,
              },
            }

            local nodes = nodes_utils:matching_nodes_from(node, tree)
            local temp = {}

            if nodes[i.Tparam] then
              temp[i.Tparam] = {}
              temp["TparamWithDefault"] = {}

              for _, n in pairs(nodes[i.Tparam]) do
                local node_type = n:type()
                local is_default = node_type == "typed_default_parameter"

                local type_subtree = {
                  { retrieve = "all", node_type = "identifier", extract = true, as = i.Parameter },
                  { retrieve = "all", node_type = "type", extract = true, as = i.Type },
                }

                local typed_parameters = nodes_utils:matching_nodes_from(n, type_subtree)
                typed_parameters = extractors:extract_from_matched(typed_parameters)

                -- 如果有默认值，提取它
                if is_default then
                  -- 尝试不同的字段名提取默认值
                  local default_value_node = n:field("value")
                  if not default_value_node or #default_value_node == 0 then
                    default_value_node = n:field("default_value")
                  end

                  -- 如果字段方式不行，尝试直接获取最后一个子节点
                  if not default_value_node or #default_value_node == 0 then
                    local child_count = n:child_count()
                    if child_count >= 4 then
                      local last_child = n:child(child_count - 1)
                      if last_child and last_child:type() ~= "=" then
                        local default_text = helpers.get_node_text(last_child)[1]
                        typed_parameters.default = { default_text }
                        table.insert(temp["TparamWithDefault"], typed_parameters)
                      else
                        table.insert(temp[i.Tparam], typed_parameters)
                      end
                    else
                      table.insert(temp[i.Tparam], typed_parameters)
                    end
                  else
                    local default_text = helpers.get_node_text(default_value_node[1])[1]
                    typed_parameters.default = { default_text }
                    table.insert(temp["TparamWithDefault"], typed_parameters)
                  end
                else
                  table.insert(temp[i.Tparam], typed_parameters)
                end
              end
            end

            if nodes[i.Return] then
              validate_direct_returns(nodes, node)
            end

            if nodes[i.Return] then
              validate_bare_returns(nodes)
            end

            validate_yield_nodes(nodes)
            deduplicate_throw_nodes(nodes)

            local res = extractors:extract_from_matched(nodes)
            res[i.Tparam] = temp[i.Tparam]
            res["TparamWithDefault"] = temp["TparamWithDefault"] -- 新增

            if res[i.ReturnTypeHint] then
              res[i.HasReturn] = nil
              if res[i.ReturnTypeHint][1] == "None" then
                res[i.ReturnTypeHint] = nil
              end
            end

            -- 处理类方法中的 self 参数
            if res[i.Parameter] and locator({ current = node }, parent.class) then
              local remove_identifier = true
              if node:parent():type() == "decorated_definition" then
                local decorator = nodes_utils:matching_child_nodes(node:parent(), "decorator")
                decorator = helpers.get_node_text(decorator[1])[1]
                if decorator == "@staticmethod" then
                  remove_identifier = false
                end
              elseif node:parent():parent():type() == "function_definition" then
                remove_identifier = false
              end

              if remove_identifier then
                table.remove(res[i.Parameter], 1)
                if vim.tbl_isempty(res[i.Parameter]) then
                  res[i.Parameter] = nil
                end
              end
            end

            local results = helpers.copy({
              [i.HasParameter] = function(t)
                return (t[i.Parameter] or t[i.Tparam] or t["TparamWithDefault"]) and { true }
              end,
              [i.HasReturn] = function(t)
                return (not t[i.Yield] and (t[i.ReturnTypeHint] or t[i.Return]) and { true })
              end,
              [i.HasThrow] = function(t)
                return t[i.Throw] and { true }
              end,
              [i.Type] = true,
              [i.Parameter] = true,
              [i.Return] = true,
              [i.ReturnTypeHint] = true,
              [i.HasYield] = function(t)
                return t[i.Yield] and { true }
              end,
              [i.ArbitraryArgs] = true,
              [i.Kwargs] = true,
              [i.Throw] = true,
              [i.Tparam] = true,
              ["TparamWithDefault"] = true, -- 新增
            }, res) or {}

            if results[i.ReturnTypeHint] then
              results[i.Return] = nil
            end

            return results
          end,
        },
      },
    },
    class = {
      ["class_definition"] = {
        ["0"] = {
          extract = function()
            return {}
          end,
        },
      },
    },
    file = {
      ["module"] = {
        ["0"] = {
          extract = function()
            return {}
          end,
        },
      },
    },
    type = {
      ["0"] = {
        extract = function()
          return {}
        end,
      },
    },
  },
  locator = nil,
  granulator = nil,
  generator = nil,
  template = {
    annotation_convention = "my_google_zh",
    my_google_zh = require("neogen.python.template"),
    position = function(node, type)
      if type == "file" then
        for child in node:iter_children() do
          if child:type() == "comment" then
            local start_row = child:start()
            if start_row == 0 then
              if vim.startswith(helpers.get_node_text(node)[1], "#!") then
                return 1, 0
              end
            end
          end
        end
        return 0, 0
      end
    end,
  },
}
