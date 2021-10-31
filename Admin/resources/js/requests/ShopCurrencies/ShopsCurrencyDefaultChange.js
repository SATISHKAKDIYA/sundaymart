import axios from "axios";

const shopsCurrencyDefaultChange = async (id_shop, id_shop_currency) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/shops-currency/change";
    const body = {
        shop_id: id_shop,
        id_shop_currency: id_shop_currency
    };

    console.log(body);

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

export default shopsCurrencyDefaultChange;
