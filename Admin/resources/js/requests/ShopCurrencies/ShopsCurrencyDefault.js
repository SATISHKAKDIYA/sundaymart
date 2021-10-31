import axios from "axios";

const shopsCurrencyDefault = async (id_shop) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/shops-currency/currency";
    const body = {
        shop_id: id_shop
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

export default shopsCurrencyDefault;
