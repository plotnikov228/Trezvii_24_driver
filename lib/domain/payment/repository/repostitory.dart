import 'package:trezvii_24_driver/domain/payment/models/card.dart';
import 'package:trezvii_24_driver/domain/payment/models/output_request.dart';

import '../models/payment_ui_model.dart';
import '../models/promo_code.dart';
import '../models/tariff.dart';

abstract class PaymentRepository {
  List<PaymentUiModel> getCurrentPaymentUiModels(bool functionalOn,
      {Function? onPromoTap,
      Function? onBonusTap,
      Function? onCashTap,
      Function? onCardTap,
      List<UserCard> cards = const []});

  Future<PaymentUiModel> getCurrentPaymentUiModel();

  Future<PaymentUiModel> setCurrentPaymentUiModel(
      PaymentUiModel newPaymentUiModel);

  Future<PromoCode?> activatePromo(String promo);

  Future setActivatedPromo(PromoCode promoCode);

  Future<PromoCode?> checkPromoForActivity();

  Future<String> cardPay(UserCard card);

  Future<int> addBonusesToBalance(int quantity);

  Future<int> getBonusesBalance();

  Future activateBonuses();

  Future<int?> checkBonusesForActivity();

  Future spendBonuses();

  Future<double> getCosts(Tariff tariff, {bool getHourPrice = true, getKmPrice = false, bool getStartPrice = false, bool getPriceOfFirstHours = false});

  Future createALocalOutputRequest ({required LocalOutputRequest localOutputRequest});

  Future completeAOutputRequest({required LocalOutputRequest localOutputRequest});

  Future<List<LocalOutputRequest>> getRequests ();

  Future cancelOutputRequest(
      {required LocalOutputRequest localOutputRequest});
}
