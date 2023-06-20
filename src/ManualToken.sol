// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

error Insufficient__Balance(uint256 balance, uint256 amount);
error Insufficient__Allowance(uint256 allowance, uint256 amount);

contract ManualToken {
    mapping(address => uint256) _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}.
     */
    constructor(string memory name_, string memory symbol_, uint8 decimals_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
    }

    /**
     * @dev Returns the name of the token
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * Returns the number of decimals
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev Returns the total supply of the token
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Returns the balance of a given account
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev Make a transfer 'to' a given address for a given 'amount'
     */
    function transfer(address to, uint256 amount) public returns (bool) {
        if (_balances[msg.sender] < amount) {
            revert Insufficient__Balance(_balances[msg.sender], amount);
        }
        _balances[msg.sender] -= amount;
        _balances[to] += amount;

        return true;
    }

    /**
     * @dev Returns the allowance of a given spender for a given owner
     */
    function allowance(
        address owner,
        address spender
    ) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev Approve a given spender for a given amount
     */
    function approve(address spender, uint256 amount) public returns (bool) {
        if (_balances[msg.sender] < amount) {
            revert Insufficient__Balance(_balances[msg.sender], amount);
        }
        _allowances[msg.sender][spender] = amount;
        return true;
    }

    /**
     * @dev Transfer from a given address 'from' to a given address 'to' for a given 'amount'
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        if (_balances[from] < amount) {
            revert Insufficient__Balance(_balances[from], amount);
        }
        if (_allowances[from][to] < amount) {
            revert Insufficient__Allowance(_allowances[from][to], amount);
        }
        _balances[from] -= amount;
        _balances[to] += amount;
        _allowances[from][to] -= amount;
        return true;
    }

    /**
     * @dev Increase the allowance of a given spender for a given amount
     */
    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public virtual returns (bool) {
        approve(spender, addedValue);
        return true;
    }

    /**
     * @dev Decrease the allowance of a given spender for a given amount
     */
    function decreaseAllowance(
        address spender,
        uint256 substractedAllowance
    ) public returns (bool) {}
}
