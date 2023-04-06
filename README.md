# Some quick notes for if I forget.
*********************************

- For use with filezilla:
Portforwarding rules:
| Name | Protocol | Host IP | Host Port | Guest IP | Guest Port |
|---|---|---|---|---|---|
| http	| TCP 	| 127.0.0.42 | 8080 | | 80 |
| ssh	| TCP 	| 127.0.0.42 | 4242 | | 4242 |

Filezilla Login:
| Host | Username | Password | Port |
| 127.0.0.42 | dpentlan | ~pass~ | 4242 |


- Fail2ban
If you try to log in and get the ssh command hanging, it may be from fail2ban preventing you from logging in with your ip.
To undo this:
	sudo fail2ban-client -i
	>>> status sshd
	>>>	set sshd unbanip 10.0.2.2
	>>> exit