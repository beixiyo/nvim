; extends
; 常量仅按关键字 const 高亮，不再按全大写命名
; @see nvim-treesitter queries/ecma/highlights.scm 中全大写即 @constant 的规则被下方 priority 覆盖

; const 声明的标识符 -> @constant（高 priority，优先于后续规则）
(
  (lexical_declaration
    kind: "const"
    (variable_declarator
      name: (identifier) @constant))
  (#set! "priority" 128)
)

; 全大写标识符改为 @variable，不再当作常量（覆盖 ecma 默认的 @constant）
(
  (identifier) @variable
  (#lua-match? @variable "^_*[A-Z][A-Z%d_]*$")
  (#set! "priority" 127)
)

(
  (shorthand_property_identifier) @variable
  (#lua-match? @variable "^_*[A-Z][A-Z%d_]*$")
  (#set! "priority" 127)
)
