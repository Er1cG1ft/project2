# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Project1.Repo.insert!(%Project1.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Project1.Repo
alias Project1.Users.User

pwhash = Argon2.hash_pwd_salt("test")

Repo.insert!(%User{email: "admin@gmail.com", admin: true, password_hash: pwhash, first_name: "Admin", last_name: "User"})
Repo.insert!(%User{email: "bob@example.com", admin: false, password_hash: pwhash, first_name: "Demo", last_name: "User"})
