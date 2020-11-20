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

    intervalPayCombo.textRole: "text"
    intervalPayCombo.model: AsemanListModel { id: paysModel }

    couponBtn.onClicked: couponReq.networkManager.get(couponReq)
    couponBusy.running: couponReq.refreshing

    packageColor: {
        if (intervalPayCombo.count == 0)
            return Subscription.premiumColor;

        try {
            return paysModel.get(intervalPayCombo.currentIndex).extra.color
        } catch (e) {
            return Subscription.premiumColor;
        }
    }
    titleLabel.text: {
        if (intervalPayCombo.count == 0)
            return "";

        try {
            return paysModel.get(intervalPayCombo.currentIndex).title;
        } catch (e) {
            return "";
        }
    }

    subtitleLabel.text: {
        if (intervalPayCombo.count == 0)
            return "";

        try {
            return paysModel.get(intervalPayCombo.currentIndex).priceFormated;
        } catch (e) {
            return "";
        }
    }

    items.model: AsemanListModel {
        data: {
            var extra = new Array;
            if (intervalPayCombo.count == 0)
                return extra;

            var lists_limits = 0;
            var notes_limits = 0;
            var offline_limits = 0;

            try {
                extra = paysModel.get(intervalPayCombo.currentIndex).extra;
                lists_limits = extra.lists_limits;
                notes_limits = extra.notes_limits;
                offline_limits = extra.offline_limits;
            } catch (e) {
                return extra;
            }

            return [
                {
                    title: GTranslations.translate( notes_limits === -1? qsTr("Unlimited Notes") : qsTr("%1 Notes").arg(notes_limits))
                },
                {
                    title: GTranslations.translate( lists_limits === -1? qsTr("Unlimited Lists") : qsTr("%1 Lists").arg(lists_limits))
                },
                {
                    title: GTranslations.translate( offline_limits === -1? qsTr("Unlimited Offline Poems") : qsTr("%1 Offline Poems").arg(offline_limits))
                }
            ]
        }
    }

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
                couponField.color = Qt.binding(function(){ return packageColor; });
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
            var lastIndex = intervalPayCombo.currentIndex;
            if (lastIndex < 0)
                lastIndex = 0;

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

                    var obj = Tools.toVariantMap(v);
                    obj.text = GTranslations.translate( obj.title + " - " + formater.output + qsTr("Toman") )
                    obj.priceFormated = GTranslations.translate(formater.output + qsTr("Toman"));

                    paysModel.append(obj);
                });
            } catch (e) {
            }

            intervalPayCombo.currentIndex = lastIndex;
        }
    }

    function confirm() {
        console.debug(paymentReq.coupon_uid, paymentReq.package_id)
        paymentReq.networkManager.post(paymentReq, true);
    }
}
