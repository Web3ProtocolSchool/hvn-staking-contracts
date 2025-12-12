const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("HeavenTokenV2Upgrade", (m) => {
    const PROXY_ADDRESS = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";

    const heavenTokenV2Impl = m.contract("HeavenTokenV2");


    const heavenProxy = m.contractAt(
        "HeavenTokenUpgradeable",
        PROXY_ADDRESS,
        { id: "HeavenTokenProxyForV2Upgrade" }
    );

    /**
   * OZ v5 UUPS 升级
   * data = "0x" 表示不执行额外逻辑
   */
    m.call(heavenProxy, "upgradeToAndCall", [heavenTokenV2Impl, "0x"]);

    return {
        heavenTokenV2Impl,
    };
});