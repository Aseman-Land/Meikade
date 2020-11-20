import QtQuick 2.0
import AsemanQml.Base 2.0
import AsemanQml.Viewport 2.0
import AsemanQml.Models 2.0
import models 1.0
import views 1.0
import requests 1.0
import queries 1.0
import globals 1.0
import micros 1.0

PremiumConfirmView {
    id: home
    width: Viewport.viewport.width
    height: 450 * Devices.density

    busyIndicator.running: pkgReq.refreshing

    cancelBtn.onClicked: home.ViewportType.open = false;
    confirmBtn.onClicked: confirm()

    titleLabel.text: ""
    subtitleLabel.text: ""

    intervalPayCombo.textRole: "title"
    intervalPayCombo.model: AsemanListModel { id: paysModel }

    couponBtn.onClicked: couponReq.networkManager.get(couponReq)
    couponBusy.running: couponReq.refreshing

    TextFormater {
        id: formater
        delimiter: ","
        count: 3
    }

    CouponRequest {
        id: couponReq
        _coupon: home.couponField.text
        onSuccessfull: {
            try {
                paymentReq.coupon_uid = response.result.uid;
                couponBtn.enabled = false;
                couponField.readOnly = true;
                couponField.color = Subscription.premiumColor;
                couponField.text = GTranslations.translate( qsTr("%1% OFF Coupon").arg(response.result.discount) );
            } catch (e) {
                paymentReq.coupon_uid = "";
            }
            pkgReq.reload()
        }
    }

    InitPaymentRequest {
        id: paymentReq
        allowGlobalBusy: true
        package_id: {
            if (intervalPayCombo.count == 0)
                return 0;

            try {
                return paysModel.get(intervalPayCombo.currentIndex).id
            } catch (e) {
                return 0;
            }
        }
        onSuccessfull: {
            try {
                Qt.openUrlExternally(response.result.payment_url)
                home.ViewportType.open = false;
            } catch (e) {

            }
        }
    }

    PackagesRequest {
        id: pkgReq
        Component.onCompleted: pkgReq.networkManager.get(pkgReq)
        onResponseChanged: reload()

        function reload() {
            paysModel.clear();

            var couponPercent = 0;
            try {
                couponPercent = couponReq.response.result.discount;
            } catch (ce) {
                couponPercent = 0;
            }

            try {
                response.results.forEach( function(v){
                    if (v.price === 0)
                        return;

                    formater.input = v.price * (100 - couponPercent) / 100;

                    var mnth = Math.round(v.expire_in_days / 30);
                    if (mnth === 1)
                        titleLabel.text = GTranslations.translate( qsTr("%1 Tomans per Month").arg(formater.output) );
                    else
                    if (mnth === 12)
                        subtitleLabel.text = GTranslations.translate( qsTr("%1 Tomans per Year").arg(formater.output) )
                    else
                    if (mnth > 1 && subtitleLabel.text.length == 0)
                        subtitleLabel.text = GTranslations.translate( qsTr("%1 Tomans per %2 months").arg(formater.output).arg(mnth) )

                    var obj = Tools.toVariantMap(v);
                    obj.title = GTranslations.translate( obj.title + " - " + formater.output + qsTr("Toman") )

                    paysModel.append(obj);
                });
            } catch (e) {
            }

            intervalPayCombo.currentIndex = 0;
        }
    }

    function confirm() {
        console.debug(paymentReq.coupon_uid, paymentReq.package_id)
        paymentReq.networkManager.post(paymentReq, true);
    }
}
