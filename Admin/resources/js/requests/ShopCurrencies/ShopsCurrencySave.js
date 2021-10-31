import axios from "axios";

const shopsCurrencySave = async (id_shop, id_currency, defaultC, value, id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/shops-currency/save";
    const body = {
        shop_id: id_shop,
        currency_id: id_currency,
        value: value,
        default: defaultC,
        id: id
    };

    const headers = {
        "Authorization": "Bearer " + token
    }

    const response = await axios({
        method: 'post',
        url: url,
        data: body,
        headers: headers
    });

    return response;
}

export default shopsCurrencySave;
