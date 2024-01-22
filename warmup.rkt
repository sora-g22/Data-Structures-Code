#lang dssl2
    
# HW1: DSSL2 Warmup

###
### ACCOUNTS
###

# an Account is either a checking or a saving account
let account_type? = OrC("checking", "savings")

class Account:
    let id
    let type
    let balance

    # Constructs an account with the given ID number, account type, and
    # balance. The balance cannot be negative.
    # Note: nat = natural number (0, 1, 2, ...)
    def __init__(self, id, type, balance):
        if balance < 0: error('Account: negative balance')
        if not account_type?(type): error('Account: unknown type')
        self.id = id
        self.type = type
        self.balance = balance

    # .get_balance() -> num?
    def get_balance(self): return self.balance

    # .get_id() -> nat?
    def get_id(self): return self.id

    # .get_type() -> account_type?
    def get_type(self): return self.type

    # .deposit(num?) -> NoneC
    # Deposits `amount` in the account. `amount` must be non-negative.
    def deposit(self, amount):
        assert amount >= 0
        self.balance = self.balance + amount
        pass
    #   ^ YOUR CODE GOES HERE

    # .withdraw(num?) -> NoneC
    # Withdraws `amount` from the account. `amount` must be non-negative
    # and must not exceed the balance.
    def withdraw(self, amount):
        assert amount >= 0
        assert self.balance > amount
        self.balance = self.balance - amount
        pass
    #   ^ YOUR CODE GOES HERE

    # .transfer(num?, Account?) -> NoneC
    # Transfers the specified amount from this account to another. That is,
    # it subtracts `amount` from this account's balance and adds `amount`
    # to the `to` account's balance. `amount` must be non-negative.
    def transfer(self, amount, to):
        assert amount >= 0
        # If this was the over way around I'd need a way to catch an exception or panic so as to not leave the unfinished side effects
        self.withdraw(amount)
        to.deposit(amount)
        pass
    #   ^ YOUR CODE GOES HERE

test 'Account#withdraw':
    let account = Account(2, "checking", 32)
    assert account.get_balance() == 32
    account.withdraw(10)
    assert account.get_balance() == 22
    assert_error account.withdraw(-10)


###
### CUSTOMERS
###

# Customers have names and bank accounts.
struct customer:
    let name
    let bank_account
    

# max_account_id(VecC[customer?]) -> nat?
# Find the largest account id used by any of the given customers' accounts.
# Raise an error if no customers are provided.
def max_account_id(customers):
    def max_id_in_vec(vector):
        #assert vector.len() > 0
        let maxElem = 0
        for element in vector:
            if element > maxElem:
                maxElem = element
            else:
                continue
        return maxElem
    return max_id_in_vec(customers.map((lambda customer: customer.bank_account)))
    pass
#   ^ YOUR CODE GOES HERE

# open_account(str?, account_type?, VecC[customer?]) -> VecC[customer?]

# TODO What does he mean "new"? Does he want us to clone the vector even if there is room to just mutate a new customer in? -Sora
    
# Produce a new vector of customers, with a new customer added. That new
# customer has the provided name, and their new account has the given type and
# a balance of 0. The id of the new account should be one more than the current
# maximum, or 1 for the first account created.
def open_account(name, type, customers):
    def largest_free(vector):
        for idx, element in vector:
            if customer?(element):
                continue
            else:
                return idx
    def append_vec(vector, customer):
        let new_vec = vec(vector.len() * 2)
        for idx, element in vector:
            new_vec.put(idx, element)
        new_vec.put(vector.len(), customer)
        return new_vec

    assert str?(name)
    assert account_type?(type)
    assert VecC[customer?](customers)

    let idx = largest_free(customers)
    let max_id = max_account_id(customers)
    # TODO Need to figure out if I have to actively clone here or just a reference is OK, wording is vague -Sora
    let new_customers = customers
    if new_customers.mem?(idx):
        new_customers.put(idx, customer(name, max_id + 1))
    else:
        new_customers = append_vec(new_customers, customer(name, max_id + 1))
    return new_customers
#   ^ YOUR CODE GOES HERE


# check_sharing(VecC[customer?]) -> bool?
# Checks whether any of the given customers share an account number.
def check_sharing(customers):
    for customer in customers:
        if customers.filter((lambda possibleDupe: customer == possibleDupe)).len() > 1:
            return True
        else:
            continue
    return False
#   ^ YOUR CODE GOES HERE
