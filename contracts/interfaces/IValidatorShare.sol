// SPDX-FileCopyrightText: 2021 ShardLabs
// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.7;

interface IValidatorShare {
    function unbondNonces(address _address) external view returns (uint256);

    function activeAmount() external view returns (uint256);

    function validatorId() external returns (uint256);

    function withdrawRewards() external;

    function unstakeClaimTokens() external;

    function minAmount() external returns (uint256);

    function getLiquidRewards(address user) external view returns (uint256);

    function delegation() external view returns (bool);

    function updateDelegation(bool _delegation) external;

    function buyVoucher(uint256 _amount, uint256 _minSharesToMint)
        external
        returns (uint256);

    function sellVoucher_new(uint256 claimAmount, uint256 maximumSharesToBurn)
        external;

    function unstakeClaimTokens_new(uint256 unbondNonce) external;

    function getTotalStake(address user)
        external
        view
        returns (uint256, uint256);

    function owner() external view returns (address);

    function restake() external returns (uint256, uint256);

    function unlock() external;

    function lock() external;

    function drain(
        address token,
        address payable destination,
        uint256 amount
    ) external;

    function slash(uint256 _amount) external;

    function migrateOut(address user, uint256 amount) external;

    function migrateIn(address user, uint256 amount) external;
}
