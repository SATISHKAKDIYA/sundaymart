import axios from "axios";

const currencySave = async (name, symbol, active, id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/currency/save";
    const body = {
        name: name,
        symbol: symbol,
        active: active,
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

export default currencySave;
