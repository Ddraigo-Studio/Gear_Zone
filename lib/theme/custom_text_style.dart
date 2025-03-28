import 'package:flutter/material.dart';
import '../core/app_export.dart';

extension on TextStyle {
  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }

  TextStyle get balooBhai2 {
    return copyWith(
      fontFamily: 'Baloo Bhai 2',
    );
  }

  TextStyle get aoboshiOne {
    return copyWith(
      fontFamily: 'Aoboshi One',
    );
  }

  TextStyle get amaranth {
    return copyWith(
      fontFamily: 'Amaranth',
    );
  }

  TextStyle get encodeSans {
    return copyWith(
      fontFamily: 'Encode Sans',
    );
  }

  TextStyle get balooBhai {
    return copyWith(
      fontFamily: 'Baloo Bhai',
    );
  }

  TextStyle get sigmarOne {
  return copyWith(
    fontFamily: 'Sigmar One',
  );
  }

  TextStyle get archivoBlack {
    return copyWith(
      fontFamily: 'Archivo Black',
    );
  }

  TextStyle get gabarito {
    return copyWith(
      fontFamily: 'Gabarito',
    );
  }

  TextStyle get roboto {
    return copyWith(
      fontFamily: 'Roboto',
    );
  }

  TextStyle get balooBhaijaan2 {
    return copyWith(
      fontFamily: 'Baloo Bhaijaan 2',
    );
  }

  TextStyle get fredoka {
    return copyWith(
      fontFamily: 'Fredoka',
    );
  }

  TextStyle get basic {
    return copyWith(
      fontFamily: 'Basic',
    );
  }

  TextStyle get poppins {
    return copyWith(
      fontFamily: 'Poppins',
    );
  }

  TextStyle get alatsi {
    return copyWith(
      fontFamily: 'Alatsi',
    );
  }

  TextStyle get balooBhaijaan {
    return copyWith(
      fontFamily: 'Baloo Bhaijaan',
    );
  }

  TextStyle get baloo2 {
    return copyWith(
      fontFamily: 'Baloo 2',
    );
  }

  TextStyle get balooPaaji2 {
    return copyWith(
      fontFamily: 'Baloo Paaji 2',
    );
  }

  TextStyle get pPMori {
    return copyWith(
      fontFamily: 'PP Mori',
    );
  }
}

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.
class CustomTextStyles {
  // Body text style
  static TextStyle get bodyLarge18 => theme.textTheme.bodyLarge!.copyWith(
    fontSize: 18.fSize,
  );

  static TextStyle get labelLargeBluegray900 => 
    theme.textTheme.labelLarge!.copyWith(
      color: appTheme.blueGray900,
      fontWeight: FontWeight.w500,
  );

  static TextStyle get bodyLargeAmaranth => theme.textTheme.bodyLarge!.amaranth;

  static TextStyle get bodyLargeArchivoBlackWhiteA700 =>
      theme.textTheme.bodyLarge!.archivoBlack.copyWith(
    color: appTheme.whiteA700,
  );

  static TextStyle get bodyLargeBalooBhaijaanBlack900 =>
      theme.textTheme.bodyLarge!.balooBhaijaan.copyWith(
    color: appTheme.black900,
  );

  static TextStyle get bodyLargeBalooBhaijaanBlack900_1 =>
      theme.textTheme.bodyLarge!.balooBhaijaan.copyWith(
    color: appTheme.black900.withValues(
      alpha: 0.87,
    ),
  );

  static TextStyle get bodyLargeBalooBhaijaanDeeppurple400 =>
      theme.textTheme.bodyLarge!.balooBhaijaan.copyWith(
    color: appTheme.deepPurple400,
  );

  static TextStyle get bodyLargeBalooBhaijaanDeeppurple40018 =>
      theme.textTheme.bodyLarge!.balooBhaijaan.copyWith(
    color: appTheme.deepPurple400,
    fontSize: 18.fSize,
  );

  static TextStyle get bodyLargeBalooBhaijaanDeeppurple50 =>
      theme.textTheme.bodyLarge!.balooBhaijaan.copyWith(
    color: appTheme.deepPurple50,
    fontSize: 18.fSize,
  );

  static TextStyle get bodyLargeBalooBhaijaanGray700 =>
    theme.textTheme.bodyLarge!.balooBhaijaan.copyWith(
  color: appTheme.gray700,
  fontSize: 18.fSize,
  );

  static TextStyle get bodyLargeBalooBhaijaanPrimary =>
      theme.textTheme.bodyLarge!.balooBhaijaan.copyWith(
    color: theme.colorScheme.primary,
  );

  static TextStyle get bodyLargeBalooBhaijaanWhiteA700 =>
      theme.textTheme.bodyLarge!.balooBhaijaan.copyWith(
      color: appTheme.whiteA700,
      
      fontSize: 18.fSize,
  );

  static TextStyle get bodyLargeBlack900 => theme.textTheme.bodyLarge!.copyWith(
    color: appTheme.black900.withValues(
      alpha: 0.8,
    ),
  );

  static TextStyle get bodyLargeFredokaBluegray900 =>
      theme.textTheme.bodyLarge!.fredoka.copyWith(
    color: appTheme.blueGray900,
  );

  static TextStyle get bodyLargeGabaritoBluegray900 =>
      theme.textTheme.bodyLarge!.gabarito.copyWith(
    color: appTheme.blueGray900,
  );

  static TextStyle get bodyLargeGray50001 => theme.textTheme.bodyLarge!.copyWith(
    color: appTheme.gray50001,
  );

  static TextStyle get bodyLargeGray700 => theme.textTheme.bodyLarge!.copyWith(
    color: appTheme.gray700,
  );

  static TextStyle get bodyLargeGray900 => theme.textTheme.bodyLarge!.copyWith(
    color: appTheme.gray900.withValues(
      alpha: 0.5,
    ),
  );

  static TextStyle get bodyLargePrimary => theme.textTheme.bodyLarge!.copyWith(
    color: theme.colorScheme.primary,
  );

  static TextStyle get bodyLargeRed400 => theme.textTheme.bodyLarge!.copyWith(
    color: appTheme.red400,
  );

  static TextStyle get bodyLargeRed500 => theme.textTheme.bodyLarge!.copyWith(
    color: appTheme.red500,
  );

  static TextStyle get bodyLargeWhiteA700 =>
      theme.textTheme.bodyLarge!.copyWith(
    color: appTheme.whiteA700,
  );

  static TextStyle get bodyLargeWhiteA70018 =>
      theme.textTheme.bodyLarge!.copyWith(
    color: appTheme.whiteA700,
    fontSize: 18.fSize,
  );

  static TextStyle get bodyMedium13 => theme.textTheme.bodyMedium!.copyWith(
    fontSize: 13.fSize,
  );

  static TextStyle get bodyMediumAmaranthRed500 =>
      theme.textTheme.bodyMedium!.amaranth.copyWith(
    color: appTheme.red500,
  );

  static TextStyle get bodyMediumBalooBhaijaanDeeppurple500 =>
      theme.textTheme.bodyMedium!.balooBhaijaan.copyWith(
    color: appTheme.deepPurple500,
  );

  static TextStyle get bodyMediumBalooBhaijaanGray900 =>
      theme.textTheme.bodyMedium!.balooBhaijaan.copyWith(
    color: appTheme.gray900.withValues(
      alpha: 0.5,
    ),
  );

  static TextStyle get bodyMediumBalooBhaijaanGray900_1 =>
      theme.textTheme.bodyMedium!.balooBhaijaan.copyWith(
    color: appTheme.gray900,
  );

  static TextStyle get bodyMediumBalooBhaijaanRed500 =>
      theme.textTheme.bodyMedium!.balooBhaijaan.copyWith(
    color: appTheme.red500,
  );

  static TextStyle get bodyMediumBlack900 =>
      theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.black900.withValues(
      alpha: 0.87,
    ),
    fontSize: 15.fSize,
  );

  static TextStyle get bodyMediumBlack90015 =>
      theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.black900.withValues(
      alpha: 0.87,
    ),
    fontSize: 15.fSize,
  );

  static TextStyle get bodyMediumBlack900_1 =>
      theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.black900,
  );

  static TextStyle get bodyMediumBlack900_2 =>
      theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.black900.withValues(
      alpha: 0.87,
    ),
  );

  static TextStyle get bodyMediumDeeppurple400 =>
      theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.deepPurple400,
  );

  static TextStyle get bodyMediumEncodeSansWhiteA700 =>
      theme.textTheme.bodyMedium!.encodeSans.copyWith(
    color: appTheme.whiteA700,
  );

  static TextStyle get bodyMediumGray50001 =>
      theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.gray50001,
  );

  static TextStyle get bodyMediumGray900 =>
      theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.gray900,
  );

  static TextStyle get bodyMediumGray900_1 =>
      theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.gray900.withValues(
      alpha: 0.5,
    ),
  );

  static TextStyle get bodyMediumInter =>
      theme.textTheme.bodyMedium!.inter.copyWith(
    fontSize: 13.fSize,
  );

  static TextStyle get bodyMediumPoppinsBluegray300 =>
      theme.textTheme.bodyMedium!.poppins.copyWith(
    color: appTheme.blueGray300,
  );

  static TextStyle get bodyMediumRed400 =>
      theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.red400,
  );

  static TextStyle get bodyMediumRed500 =>
      theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.red500,
  );

  static TextStyle get bodyMediumTeal400 =>
      theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.teal400,
    fontSize: 13.fSize,
  );

  static TextStyle get bodyMediumWhiteA700 =>
      theme.textTheme.bodyMedium!.copyWith(
    color: appTheme.whiteA700,
  );

  static TextStyle get bodySmallAlatsiGray600 =>
      theme.textTheme.bodySmall!.alatsi.copyWith(
    color: appTheme.gray600,
    fontSize: 10.fSize,
  );

  static TextStyle get bodySmallBalooBhaiBlack900 =>
      theme.textTheme.bodySmall!.balooBhai.copyWith(
    color: appTheme.black900.withValues(
      alpha: 0.5,
    ),
  );

  static TextStyle get bodySmallBalooBhaiDeeppurple400 =>
      theme.textTheme.bodySmall!.balooBhai.copyWith(
    color: appTheme.deepPurple400,
  );

  static TextStyle get bodySmallBalooBhaiGray700 =>
      theme.textTheme.bodySmall!.balooBhai.copyWith(
    color: appTheme.gray700,
  );

  static TextStyle get bodySmallBalooBhaiGray900 =>
      theme.textTheme.bodySmall!.balooBhai.copyWith(
    color: appTheme.gray900,
  );

  static TextStyle get bodySmallBalooBhaiGray90010 =>
      theme.textTheme.bodySmall!.balooBhai.copyWith(
    color: appTheme.gray900,
    fontSize: 10.fSize,
  );

  static TextStyle get bodySmallBalooBhaiGray900_1 =>
      theme.textTheme.bodySmall!.balooBhai.copyWith(
    color: appTheme.gray900.withValues(
      alpha: 0.5,
    ),
  );

  static TextStyle get bodySmallBalooBhaiRed500 =>
      theme.textTheme.bodySmall!.balooBhai.copyWith(
    color: appTheme.red500,
  );

  static TextStyle get bodySmallBasicGray900 =>
      theme.textTheme.bodySmall!.basic.copyWith(
    color: appTheme.gray900,
  );

  static TextStyle get bodySmallBasicWhiteA700 =>
      theme.textTheme.bodySmall!.basic.copyWith(
    color: appTheme.whiteA700,
  );

  static TextStyle get bodySmallEncodeSansGray90001 =>
      theme.textTheme.bodySmall!.encodeSans.copyWith(
    color: appTheme.gray90001,
  );

  static TextStyle get bodySmallSigmarOneWhiteA700 =>
      theme.textTheme.bodySmall!.sigmarOne.copyWith(
    color: appTheme.whiteA700,
    fontSize: 11.fSize,
  );

  // Headline text style
  static TextStyle get headlineSmallAoboshiOneOrange300 =>
      theme.textTheme.headlineSmall!.aoboshiOne.copyWith(
    color: appTheme.orange300,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get headlineSmallBalooBhai =>
      theme.textTheme.headlineSmall!.balooBhai.copyWith(
    fontWeight: FontWeight.w400,
  );

  static TextStyle get headlineSmallBalooBhaijaan2 =>
      theme.textTheme.headlineSmall!.balooBhaijaan2.copyWith(
    fontWeight: FontWeight.w600,
  );

  static TextStyle get headlineSmallBalooBhaijaan2SemiBold =>
      theme.textTheme.headlineSmall!.balooBhaijaan2.copyWith(
    fontWeight: FontWeight.w600,
  );

  static TextStyle get headlineSmallBasic =>
      theme.textTheme.headlineSmall!.basic.copyWith(
    fontWeight: FontWeight.w400,
  );

  static TextStyle get headlineSmallRed500 =>
      theme.textTheme.headlineSmall!.copyWith(
    color: appTheme.red500,
  );

  static TextStyle get headlineSmallSemiBold =>
      theme.textTheme.headlineSmall!.copyWith(
    fontWeight: FontWeight.w600,
  );

  static get headlineSmall_1 => theme.textTheme.headlineSmall!;

  // Label text style
  static TextStyle get labelLargeBaloo2Gray900 =>
      theme.textTheme.labelLarge!.baloo2.copyWith(
    color: appTheme.gray900,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get labelLargeBalooPaaji2Black900 =>
      theme.textTheme.labelLarge!.balooPaaji2.copyWith(
    color: appTheme.black900.withValues(
      alpha: 0.87,
    ),
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelLargeBalooPaaji2Black900SemiBold =>
      theme.textTheme.labelLarge!.balooPaaji2.copyWith(
    color: appTheme.black900,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelLargeBalooPaaji2Gray900 =>
      theme.textTheme.labelLarge!.balooPaaji2.copyWith(
    color: appTheme.gray900,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelLargeGray60001 =>
      theme.textTheme.labelLarge!.copyWith(
    color: appTheme.gray60001,
  );

  static TextStyle get labelLargeGray900 =>
      theme.textTheme.labelLarge!.copyWith(
    color: appTheme.gray900,
  );

  static TextStyle get labelLargeInterBlue300 =>
      theme.textTheme.labelLarge!.inter.copyWith(
    color: appTheme.blue300,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelLargeInterDeeppurple400 =>
      theme.textTheme.labelLarge!.inter.copyWith(
    color: appTheme.deepPurple400,
    fontSize: 13.fSize,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get labelLargeInterDeeppurple500 =>
      theme.textTheme.labelLarge!.inter.copyWith(
    color: appTheme.deepPurple500,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelLargeInterGray50001 =>
      theme.textTheme.labelLarge!.inter.copyWith(
    color: appTheme.gray50001,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelLargeInterGray700 =>
      theme.textTheme.labelLarge!.inter.copyWith(
    color: appTheme.gray700,
    fontSize: 13.fSize,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get labelLargeInterRed400 =>
      theme.textTheme.labelLarge!.inter.copyWith(
    color: appTheme.red400,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelLargePPMoriBluegray900 =>
      theme.textTheme.labelLarge!.pPMori.copyWith(
    color: appTheme.blueGray900,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelLargePoppinsBlack900 =>
      theme.textTheme.labelLarge!.poppins.copyWith(
    color: appTheme.black900.withValues(
      alpha: 0.87,
    ),
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelLargePoppinsBlack900SemiBold =>
      theme.textTheme.labelLarge!.poppins.copyWith(
    color: appTheme.black900,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelLargePoppinsDeeppurple50 =>
      theme.textTheme.labelLarge!.poppins.copyWith(
    color: appTheme.deepPurple50,
    fontSize: 13.fSize,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelLargePoppinsDeeppurple500 =>
      theme.textTheme.labelLarge!.poppins.copyWith(
    color: appTheme.deepPurple500,
    fontSize: 13.fSize,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelLargePoppinsGray700 =>
      theme.textTheme.labelLarge!.poppins.copyWith(
    color: appTheme.gray700,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelLargePrimary =>
      theme.textTheme.labelLarge!.copyWith(
    color: theme.colorScheme.primary,
  );

  static TextStyle get labelLargeRed400 => theme.textTheme.labelLarge!.copyWith(
    color: appTheme.red400,
    fontSize: 13.fSize,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get labelMedium11 => theme.textTheme.labelMedium!.copyWith(
    fontSize: 11.fSize,
  );

  static TextStyle get labelMediumGray60001 =>
      theme.textTheme.labelMedium!.copyWith(
    color: appTheme.gray60001,
  );

  static TextStyle get labelMediumInter =>
      theme.textTheme.labelMedium!.inter.copyWith(
    fontWeight: FontWeight.w500,
  );

  static TextStyle get labelMediumInterDeeporange300 =>
      theme.textTheme.labelMedium!.inter.copyWith(
    color: appTheme.deepOrange300,
  );

  static TextStyle get labelMediumInterDeeporange400 =>
      theme.textTheme.labelMedium!.inter.copyWith(
    color: appTheme.deepOrange400,
    fontSize: 11.fSize,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get labelMediumInterGray50001 =>
      theme.textTheme.labelMedium!.inter.copyWith(
    color: appTheme.gray50001,
    fontSize: 11.fSize,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get labelMediumInterGray50001_1 =>
      theme.textTheme.labelMedium!.inter.copyWith(
    color: appTheme.gray50001,
  );

  static TextStyle get labelMediumInterGray900 =>
      theme.textTheme.labelMedium!.inter.copyWith(
    color: appTheme.gray900,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get labelMediumInterGreen400 =>
      theme.textTheme.labelMedium!.inter.copyWith(
    color: appTheme.green400,
  );

  static TextStyle get labelMediumInterRed50 =>
      theme.textTheme.labelMedium!.inter.copyWith(
    color: appTheme.red50,
    fontWeight: FontWeight.w800,
  );

static TextStyle get labelMediumInterRed500 =>
    theme.textTheme.labelMedium!.inter.copyWith(
  color: appTheme.red500,
  fontWeight: FontWeight.w800,
);

static TextStyle get labelMediumInterRedA200 =>
    theme.textTheme.labelMedium!.inter.copyWith(
  color: appTheme.redA200,
);

  // Title style
  static get titleLargeAoboshiOne => theme.textTheme.titleLarge!.aoboshiOne;

  static get titleLargeBalooBhaijaan => 
      theme.textTheme.titleLarge!.balooBhaijaan;

  static TextStyle get titleLargeBalooBhaijaanGray900 =>
      theme.textTheme.titleLarge!.balooBhaijaan.copyWith(
    color: appTheme.gray900,
  );

  static TextStyle get titleLargeGabaritoBlack900 =>
      theme.textTheme.titleLarge!.gabarito.copyWith(
    color: appTheme.black900,
    fontSize: 22.fSize,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get titleLargeGabaritoGray900 =>
      theme.textTheme.titleLarge!.gabarito.copyWith(
    color: appTheme.gray900,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get titleLargeInterBluegray600 =>
      theme.textTheme.titleLarge!.inter.copyWith(
    color: appTheme.blueGray600,
    fontSize: 22.fSize,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get titleLargeInterDeeppurple500 =>
      theme.textTheme.titleLarge!.inter.copyWith(
    color: appTheme.deepPurple500,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get titleLargeInterDeeppurple500Medium =>
      theme.textTheme.titleLarge!.inter.copyWith(
    color: appTheme.deepPurple500,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get titleLargeInterGray700 =>
      theme.textTheme.titleLarge!.inter.copyWith(
    color: appTheme.gray700,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get titleLargeInterGray700SemiBold =>
      theme.textTheme.titleLarge!.inter.copyWith(
    color: appTheme.gray700,
    fontSize: 22.fSize,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get titleLargeInterRed400 =>
      theme.textTheme.titleLarge!.inter.copyWith(
    color: appTheme.red400,
    fontSize: 22.fSize,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get titleLargeRobotoBluegray90001 =>
      theme.textTheme.titleLarge!.roboto.copyWith(
    color: appTheme.blueGray90001,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get titleMediumBaloo2Gray500 =>
      theme.textTheme.titleMedium!.baloo2.copyWith(
    color: appTheme.gray500,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get titleMediumBaloo2Gray500SemiBold =>
      theme.textTheme.titleMedium!.baloo2.copyWith(
    color: appTheme.gray500.withValues(
      alpha: 0.9,
    ),
    fontWeight: FontWeight.w600,
  );

  static TextStyle get titleMediumBalooBhai2Gray700 =>
      theme.textTheme.titleMedium!.balooBhai2.copyWith(
    color: appTheme.gray700,
    fontSize: 18.fSize,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get titleMediumBalooBhai2Gray900 =>
      theme.textTheme.titleMedium!.balooBhai2.copyWith(
    color: appTheme.gray900,
    fontWeight: FontWeight.w800,
  );

  static TextStyle get titleMediumBalooBhai2Red500 =>
      theme.textTheme.titleMedium!.balooBhai2.copyWith(
    color: appTheme.red500,
    fontSize: 18.fSize,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get titleMediumBalooBhaijaan2Gray900 =>
      theme.textTheme.titleMedium!.balooBhaijaan2.copyWith(
    color: appTheme.gray900,
    fontSize: 18.fSize,
  );

  static TextStyle get titleMediumGabaritoBlack900 =>
      theme.textTheme.titleMedium!.gabarito.copyWith(
    color: appTheme.black900,
    fontSize: 18.fSize,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get titleMediumGabaritoBlack900SemiBold =>
      theme.textTheme.titleMedium!.gabarito.copyWith(
    color: appTheme.black900,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get titleMediumGabaritoDeeppurple400 =>
      theme.textTheme.titleMedium!.gabarito.copyWith(
    color: appTheme.deepPurple400,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get titleMediumGabaritoGray900 =>
      theme.textTheme.titleMedium!.gabarito.copyWith(
    color: appTheme.gray900,
    fontSize: 18.fSize,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get titleMediumGabaritoGray900Bold =>
      theme.textTheme.titleMedium!.gabarito.copyWith(
    color: appTheme.gray900,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get titleMediumGabaritoGray900SemiBold =>
      theme.textTheme.titleMedium!.gabarito.copyWith(
    color: appTheme.gray900,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get titleMediumGabaritoPrimary =>
      theme.textTheme.titleMedium!.gabarito.copyWith(
    color: theme.colorScheme.primary,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get titleMediumGabaritoPrimaryBold =>
      theme.textTheme.titleMedium!.gabarito.copyWith(
    color: theme.colorScheme.primary,
    fontSize: 18.fSize,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get titleMediumGabaritoRed500 =>
      theme.textTheme.titleMedium!.gabarito.copyWith(
    color: appTheme.red500,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get titleMediumGabaritoRed500SemiBold =>
      theme.textTheme.titleMedium!.gabarito.copyWith(
    color: appTheme.red500,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get titleMediumGabaritoRedA200 =>
      theme.textTheme.titleMedium!.gabarito.copyWith(
    color: appTheme.redA200,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get titleMediumInterBluegray600 =>
      theme.textTheme.titleMedium!.inter.copyWith(
    color: appTheme.blueGray600,
    fontSize: 19.fSize,
  );

  static TextStyle get titleSmallBaloo2Primary =>
      theme.textTheme.titleSmall!.baloo2.copyWith(
    color: theme.colorScheme.primary,
    fontSize: 15.fSize,
  );

  static TextStyle get titleSmallGabaritoGray900 =>
      theme.textTheme.titleSmall!.gabarito.copyWith(
    color: appTheme.gray900.withValues(
      alpha: 0.5,
    ),
    fontWeight: FontWeight.w700,
  );

  static TextStyle get titleSmallGabaritoRed500 =>
      theme.textTheme.titleSmall!.gabarito.copyWith(
    color: appTheme.red500,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get titleSmallInterDeeporange400 =>
      theme.textTheme.titleSmall!.inter.copyWith(
    color: appTheme.deepOrange400,
  );

  static TextStyle get titleSmallInterDeeppurple400 =>
      theme.textTheme.titleSmall!.inter.copyWith(
    color: appTheme.deepPurple400,
  );

  static TextStyle get titleSmallInterGray700 =>
      theme.textTheme.titleSmall!.inter.copyWith(
    color: appTheme.gray700,
  );

static TextStyle get titleSmallInterRed500 =>
    theme.textTheme.titleSmall!.inter.copyWith(
  color: appTheme.red500,
);

  static TextStyle get titleSmallInterYellow900 =>
      theme.textTheme.titleSmall!.inter.copyWith(
    color: appTheme.yellow900,
  );

  static TextStyle get titleSmallWhiteA700 =>
      theme.textTheme.titleSmall!.copyWith(
    color: appTheme.whiteA700,
  );
}

