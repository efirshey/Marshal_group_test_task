# --- Netwatch//Telegram ---

resource "routeros_tool_netwatch" "wan2_monitor" {
  name     = "wan2_monitor"
  host     = "1.1.1.1"
  interval = "00:00:10"
  timeout  = "1000ms"

  down_script = <<-EOT
    :local t "Telegram bot API";
    :local c "user ID or -group ID";
    :local m "‼️ ALLARM ‼️ Сейчас к тебе могут звонить и просить помощи";
    /tool fetch url=("https://api.telegram.org/bot".$t."/sendMessage?chat_id=".$c."&text=".[/tool uri-encode \$m]) keep-result=no;
  EOT

  up_script = <<-EOT
    :local t "Telegram bot API";
    :local c "user ID or -group ID";
    :local m "✅ Отбой ✅ можешь включать телефон";
    /tool fetch url=("https://api.telegram.org/bot".$t."/sendMessage?chat_id=".$c."&text=".[/tool uri-encode \$m]) keep-result=no;
  EOT
}
