$(document).on('ready pjax:complete', () => new AutoNumeric.multiple('.autonumeric', opcionesPesoAR) )

// The options are...optional :)
const opcionesPesoAR = {
    digitGroupSeparator        : '.',
    decimalCharacter           : ',',
    decimalCharacterAlternative: '.',
    currencySymbol             : '',
    currencySymbolPlacement    : AutoNumeric.options.currencySymbolPlacement.prefix,
    roundingMethod             : AutoNumeric.options.roundingMethod.halfUpSymmetric,
};
