#!/bin/bash

	echo "パスワードマネージャへようこそ！"
while true;
do
	read -p "次の選択肢から入力してください(Add Password/Get Password/Exit)：" select

	case $select in
	        "Add Password")
			read -p "サービス名を入力してください：" service
			read -p "ユーザ名を入力してください："   name
			read -p "パスワードを入力してください：" password
			read -p "GPGで設定したメールアドレスを入力してください。" mail
			gpg -d ~/.Password-Manager.gpg > ~/.Password-Manager.txt 2> /dev/null
			echo "$service:$name:$password" >> ~/.Password-Manager.txt
			gpg -r "$mail" -e -o ~/.Password-Manager.gpg ~/.Password-Manager.txt
			echo "パスワードの追加は成功しました。"
			echo
			;;
                "Get Password")
			read -p "サービス名を入力してください:" service
			read -p "GPGで設定したメールアドレスを入力してください。" mail
			gpg -d ~/.Password-Manager.gpg > ~/.Password-Manager.txt 2> /dev/null
			ext_password=$(grep "^$service" ~/.Password-Manager.txt | awk -F':' '{print $3}')
			
			if [ -z "$ext_password" ]; then
				echo "そのサービスは登録されていません。"
			else
				echo "サービス名：$service"
				echo "ユーザ名：$(grep "^$service" ~/.Password-Manager.txt | awk -F':' '{print $2}')"
				echo "パスワード：$ext_password"
				echo
			fi
			;;
		"Exit")
			echo "Thank you!"
			exit
			;;
		*)
			echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
			echo
	esac
rm ~/.Password-Manager.txt
done
