const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("HeavenTokenUpgradeableModule", (m) => {
    // 部署 HeavenToken 合约
    const implementation = m.contract("HeavenTokenUpgradeable");

    // 初始化参数
    const owner = m.getAccount(0);

    const initData = m.encodeFunctionCall(
      implementation,
      "initialize",
      [owner]
    );

    const proxy = m.contract("ERC1967Proxy", [
      implementation,
      initData,
    ]);


    const heavenToken = m.contractAt("HeavenTokenUpgradeable", proxy,{ id: "HeavenTokenProxy" });

    return {
      implementation,
      proxy,
      heavenToken,
    };
});