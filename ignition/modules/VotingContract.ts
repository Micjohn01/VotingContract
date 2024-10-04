import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const MicjohnModule = buildModule("MicjohnModule", (m) => {

    const votingContract = m.contract("VotingContract");

    return { votingContract };
});

export default MicjohnModule;