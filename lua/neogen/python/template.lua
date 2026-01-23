local i = require("neogen.types.template").item

return {
  -- 无结果时的模板
  { nil, '"""$1"""', { no_results = true, type = { "class", "func" } } },
  { nil, '"""$1', { no_results = true, type = { "file" } } },
  { nil, "", { no_results = true, type = { "file" } } },
  { nil, "$1", { no_results = true, type = { "file" } } },
  { nil, '"""', { no_results = true, type = { "file" } } },
  { nil, "", { no_results = true, type = { "file" } } },

  { nil, "# $1", { no_results = true, type = { "type" } } },

  -- 文档字符串开始
  { nil, '"""$1' },
  { nil, "" },
  { nil, "" },

  -- 参数部分
  { i.HasParameter, "", { type = { "func" } } },
  { i.HasParameter, "Args:", { type = { "func" } } },
  -- 无类型参数
  { i.Parameter, "    %s: $1", { type = { "func" } } },
  -- 有类型但无默认值的参数
  { { i.Parameter, i.Type }, "    %s (%s): $1", { required = i.Tparam, type = { "func" } } },
  -- 有类型且有默认值的参数
  { { i.Parameter, i.Type, "default" }, "    %s (%s, 可选): $1。默认为 %s。", { required = "TparamWithDefault", type = { "func" } } },
  -- 可变参数
  { i.ArbitraryArgs, "    %s: $1", { type = { "func" } } },
  -- 关键字参数
  { i.Kwargs, "    %s: $1", { type = { "func" } } },
  -- 类属性
  { i.ClassAttribute, "    %s: $1", { before_first_item = { "", "Attributes:" } } },

  -- 返回值部分
  { i.HasReturn, "", { type = { "func" } } },
  { i.HasReturn, "Returns:", { type = { "func" } } },
  { i.ReturnTypeHint, "    %s: $1", { type = { "func" } } },
  { i.Return, "    $1", { type = { "func" } } },

  -- Yield 部分
  { i.HasYield, "", { type = { "func" } } },
  { i.HasYield, "Yields:", { type = { "func" } } },
  { i.Yield, "    $1", { type = { "func" } } },

  -- 异常部分
  { i.HasThrow, "", { type = { "func" } } },
  { i.HasThrow, "Raises:", { type = { "func" } } },
  { i.Throw, "    %s: $1", { type = { "func" } } },

  -- 文档字符串结束
  { nil, '"""' },
}
