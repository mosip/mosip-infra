import base64

# Prompt the user for the password
password = input("Enter the password: ")

# Encode the password in base64
base64_password = base64.b64encode(password.encode()).decode()

# Create the YAML content
yaml_content = f"""
apiVersion: v1
kind: Secret
metadata:
  name: db-common-secrets
  namespace: postgres
type: Opaque
data:
  db-dbuser-password: {base64_password}
"""

# Write the YAML content to a file
with open("db-common-secrets.yaml", "w") as file:
    file.write(yaml_content)
