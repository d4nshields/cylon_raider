def add(x, y):
    return x + y

def subtract(x, y):
    return x - y

def multiply(x, y):
    return x * y

def divide(x, y):
    if y == 0:
        return "Error: Division by zero"
    return x / y

def calculator():
    print("Simple Calculator")
    print("Operations: +, -, *, /")
    print("Type 'quit' to exit")
    
    while True:
        try:
            user_input = input("\nEnter calculation (e.g., 5 + 3): ").strip()
            
            if user_input.lower() == 'quit':
                print("Goodbye!")
                break
            
            if '+' in user_input:
                parts = user_input.split('+')
                result = add(float(parts[0].strip()), float(parts[1].strip()))
            elif '-' in user_input:
                parts = user_input.split('-')
                result = subtract(float(parts[0].strip()), float(parts[1].strip()))
            elif '*' in user_input:
                parts = user_input.split('*')
                result = multiply(float(parts[0].strip()), float(parts[1].strip()))
            elif '/' in user_input:
                parts = user_input.split('/')
                result = divide(float(parts[0].strip()), float(parts[1].strip()))
            else:
                print("Invalid operation. Use +, -, *, or /")
                continue
            
            print(f"Result: {result}")
            
        except ValueError:
            print("Invalid input. Please enter numbers only.")
        except Exception as e:
            print(f"Error: {e}")

if __name__ == "__main__":
    calculator()