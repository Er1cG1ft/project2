defmodule Project1.Mailer do
  @config domain: Application.get_env(:project1, :mailgun_domain),
          key: Application.get_env(:project1, :mailgun_key)
  use Mailgun.Client, @config
                      

  @from "Headache@sandbox08db4df44090454494b016ec8ab7f0c2.mailgun.org"

  def send_headache_text_email(content) do
    send_email to: content.email,
               from: @from,
               subject: "Hello from " <> content.first_name <> " " <> content.last_name,
               text: content.message
  end
end