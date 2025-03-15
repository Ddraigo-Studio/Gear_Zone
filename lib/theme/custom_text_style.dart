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
    fontSize: 18.fsize,
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
    fontSize: 18.fsize,
  );

  static TextStyle get bodyLargeBalooBhaijaanDeeppurple50 =>
      theme.textTheme.bodyLarge!.balooBhaijaan.copyWith(
    color: appTheme.deepPurple50,
    fontSize: 18.fsize,
  );

  static TextStyle get bodyLargeBalooBhaijaanGray700 =>
    theme.textTheme.bodyLarge!.balooBhaijaan.copyWith(
  color: appTheme.gray700,
  fontSize: 18.fsize,
  );

  static TextStyle get bodyLargeBalooBhaijaanPrimary =>
      theme.textTheme.bodyLarge!.balooBhaijaan.copyWith(
    color: theme.colorScheme.primary,
  );

  static TextStyle get bodyLargeBalooBhaijaanWhiteA700 =>
      theme.textTheme.bodyLarge!.balooBhaijaan.copyWith(
    color: appTheme.whiteA700,
    fontSize: 18.fsize,
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

}

