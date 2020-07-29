function getGeneric() {
  return "Generic Nodejs";
}

function getVersion() {
  return process.env.MONOREPO_VERSION || "0.1.0";
}

module.exports = {
  getGeneric,
  getVersion,
};
