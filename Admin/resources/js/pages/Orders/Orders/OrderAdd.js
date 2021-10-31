import React from 'react';
import PageLayout from "../../../layouts/PageLayout";
import {
    Breadcrumb,
    Radio,
    Layout,
    Card,
    Button,
    PageHeader,
    Typography,
    Table,
    Alert,
    InputNumber,
    Form,
    Select, Input, DatePicker
} from "antd";

const {Text} = Typography;
import {Link} from 'react-router-dom';
import bannerSave from "../../../requests/Banners/BannerSave";
import clientActive from "../../../requests/Clients/ClientActive";
import addressActive from "../../../requests/Address/AddressActive";
import shopActive from "../../../requests/Shops/ShopActive";
import paymentStatusActive from "../../../requests/PaymentStatusActive";
import orderStatusActive from "../../../requests/OrderStatusActive";
import paymentMethodActive from "../../../requests/PaymentMethodActive";
import productActive from "../../../requests/Products/ProductActive";

const {Content} = Layout;
const {Option} = Select;
const {TextArea} = Input;
import {MinusOutlined, PlusOutlined} from "@ant-design/icons";
import timeUnitActive from "../../../requests/TimeUnits/TimeUnitActive";
import orderSave from "../../../requests/Orders/OrderSave";
import deliveryBoyActive from "../../../requests/DeliveryBoy/DeliveryBoyActive";
import orderGet from "../../../requests/Orders/OrderGet";
import * as moment from "moment";

class OrderAdd extends React.Component {
    formRef = React.createRef();

    columns = [
        {
            title: 'Name',
            dataIndex: 'name',
        },
        {
            title: 'In stock',
            dataIndex: 'in_stock',
        },
        {
            title: 'Price',
            dataIndex: 'price',
        },
        {
            title: 'Discount',
            dataIndex: 'discount',
        },
        {
            title: 'Quantity',
            dataIndex: 'quantity',
            render: (quantity, row) => {
                return (
                    <div className="row" style={{width: '200px'}}>
                        <Button type="primary" disabled={quantity === 1} icon={<MinusOutlined/>}
                                onClick={() => this.onDecrement(row.id)}/>
                        <div className="col col-md-6 col-sm-6"><InputNumber min={1} max={100000}
                                                                            value={quantity}/></div>
                        <Button type="primary" icon={<PlusOutlined/>} onClick={() => this.onIncrement(row.id)}/>
                    </div>
                );
            }
        },
        {
            title: 'Price total',
            dataIndex: 'price_total',
        },
        {
            title: 'Discount total',
            dataIndex: 'discount_total',
        },
        {
            title: 'Total',
            dataIndex: 'total',
        },
        {
            title: 'Options',
            dataIndex: 'options',
        },
    ];

    constructor(props) {
        super(props);

        this.state = {
            clients: [],
            client_id: -1,
            addresses: [],
            address_id: -1,
            shops: [],
            shop_id: -1,
            delivery_date: "",
            order_statuses: [],
            payment_statuses: [],
            products: [],
            product_details: [],
            payment_methods: [],
            delivery_boys: [],
            delivery_boy_id: -1,
            time_units: [],
            selected_product: -1,
            total_amount: 0,
            total_discount: 0,
            total: 0,
            delivery_fee: 0,
            order_status: -1,
            payment_status: -1,
            payment_method: -1,
            tax: 0,
            id: props.location.state ? props.location.state.id : 0,
            edit: props.location.state ? props.location.state.edit : false,
        }

        this.onChangeClient = this.onChangeClient.bind(this);
        this.onChangeAddress = this.onChangeAddress.bind(this);
        this.onChangeShop = this.onChangeShop.bind(this);
        this.getActiveClient = this.getActiveClient.bind(this);
        this.getActiveShops = this.getActiveShops.bind(this);
        this.getActiveAddress = this.getActiveAddress.bind(this);
        this.getActiveOrderStatus = this.getActiveOrderStatus.bind(this);
        this.getActivePaymentStatus = this.getActivePaymentStatus.bind(this);
        this.getActivePaymentMethods = this.getActivePaymentMethods.bind(this);
        this.getActiveProducts = this.getActiveProducts.bind(this);
        this.getActiveTimeUnits = this.getActiveTimeUnits.bind(this);
        this.getActiveDeliveryBoys = this.getActiveDeliveryBoys.bind(this);
        this.onChangeProduct = this.onChangeProduct.bind(this);
        this.onChangeDate = this.onChangeDate.bind(this);
        this.onSelectProduct = this.onSelectProduct.bind(this);
        this.onDecrement = this.onDecrement.bind(this);
        this.onIncrement = this.onIncrement.bind(this);

        if (this.state.edit)
            this.getInfoById(this.state.id);

        this.getActiveClient();
        this.getActiveShops();
        this.getActivePaymentStatus();
        this.getActiveOrderStatus();
        this.getActivePaymentMethods();
    }

    getInfoById = async (id) => {
        let data = await orderGet(id);
        if (data.data.success) {
            let order = data.data.data.order;
            let order_comment = data.data.data.order_comment;
            let order_detail = data.data.data.order_detail;

            this.getActiveProducts(order.id_shop);
            this.getActiveTimeUnits(order.id_shop);
            this.getActiveDeliveryBoys(order.id_shop);
            this.getActiveAddress(order.id_user);

            var product_detail = this.state.product_details;
            var total_amount = 0;
            var total_discount = 0;
            var total = 0;

            for (let i = 0; i < order_detail.length; i++) {
                var productObject = {
                    id: order_detail[i].id_product,
                    name: order_detail[i].name,
                    price: order_detail[i].price,
                    in_stock: order_detail[i].product_quantity,
                    discount: order_detail[i].discount,
                    price_total: +(order_detail[i].price * order_detail[i].quantity).toFixed(2),
                    discount_total: +(order_detail[i].discount * order_detail[i].quantity).toFixed(2),
                    total: +((order_detail[i].price - order_detail[i].discount) * order_detail[i].quantity).toFixed(2),
                    quantity: order_detail[i].quantity
                };

                total_amount += productObject.price_total;
                total_discount += productObject.discount_total;
                total += productObject.total;

                product_detail.push(productObject);
            }

            total += parseFloat(order.delivery_fee);
            total = parseFloat(total).toFixed(2);
            total_amount = parseFloat(total_amount).toFixed(2);
            total_discount = parseFloat(total_discount).toFixed(2);

            this.formRef.current.setFieldsValue({
                client: order.id_user,
                address: order.id_delivery_address,
                shop: order.id_shop,
                order_status: order.order_status,
                payment_status: order.payment_status,
                payment_method: order.payment_method,
                delivery_type: order.type + "",
                delivery_boy_comment: order.comment,
                delivery_boy: order.delivery_boy,
                delivery_time: order.delivery_time_id,
                delivery_date: moment(order.delivery_date, 'HH:mm:ss'),
                total_amount: total_amount,
                total_discount: total_discount,
            });

            this.setState({
                order_status: order.order_status,
                payment_status: order.payment_status,
                payment_method: order.payment_method,
                client_id: order.id_user,
                address_id: order.id_delivery_address,
                shop_id: order.id_shop,
                delivery_boy_id: order.delivery_boy,
                delivery_fee: order.delivery_fee,
                tax: order.tax,
                delivery_date: order.delivery_date,
                product_details: product_detail,
                total_amount: total_amount,
                total_discount: total_discount,
                total: total
            });
        }
    }

    onDecrement = (id) => {
        var index = this.state.product_details.findIndex((val) => val.id === id);
        if (index > -1) {
            var product_details = this.state.product_details;
            if (product_details[index].quantity > 1) {
                product_details[index].quantity -= 1;
                product_details[index].price_total = product_details[index].price * product_details[index].quantity;
                product_details[index].discount_total = product_details[index].discount * product_details[index].quantity;
                product_details[index].total = (product_details[index].price - product_details[index].discount) * product_details[index].quantity;

                var total_amount = this.state.total_amount - product_details[index].price;
                var total_discount = this.state.total_discount - product_details[index].discount;

                this.setState({
                    product_details: product_details,
                    total_amount: total_amount,
                    total_discount: total_discount,
                    total: this.state.total - (product_details[index].price - product_details[index].discount)
                });

                this.formRef.current.setFieldsValue({
                    total_amount: this.state.total_amount,
                    total_discount: this.state.total_discount,
                });
            }
        }
    }

    onIncrement = (id) => {
        var index = this.state.product_details.findIndex((val) => val.id === id);

        if (index > -1) {
            var product_details = this.state.product_details;

            product_details[index].quantity += 1;
            product_details[index].price_total = product_details[index].price * product_details[index].quantity;
            product_details[index].discount_total = product_details[index].discount * product_details[index].quantity;
            product_details[index].total = (product_details[index].price - product_details[index].discount) * product_details[index].quantity;

            var total_amount = this.state.total_amount + product_details[index].price;
            var total_discount = this.state.total_discount + product_details[index].discount;

            this.setState({
                product_details: product_details,
                total_amount: total_amount,
                total_discount: total_discount,
                total: this.state.total + (product_details[index].price - product_details[index].discount)
            });

            this.formRef.current.setFieldsValue({
                total_amount: total_amount,
                total_discount: total_discount,
            });
        }
    }

    onSelectProduct = () => {
        var index = this.state.products.findIndex((val) => val.id_product === this.state.selected_product);
        if (index > -1) {
            var product = this.state.products[index];

            var productObject = {
                id: this.state.selected_product,
                name: product.name,
                price: product.price,
                in_stock: product.quantity,
                discount: product.price - product.discount_price,
                price_total: product.price,
                discount_total: product.price - product.discount_price,
                total: product.price - (product.price - product.discount_price),
                quantity: 1
            };

            var product_details = this.state.product_details;
            product_details.push(productObject);

            var total_amount = this.state.total_amount + productObject.price_total;
            var total_discount = this.state.total_discount + productObject.discount_total;

            this.setState({
                product_details: product_details,
                total_amount: total_amount,
                total_discount: total_discount,
                total: this.state.total + productObject.total
            });

            this.formRef.current.setFieldsValue({
                total_amount: total_amount,
                total_discount: total_discount,
            });
        }
    }

    getActiveShops = async () => {
        let data = await shopActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            if (this.state.edit)
                this.setState({
                    shops: data.data.data,
                });
            else {
                this.setState({
                    shops: data.data.data,
                    shop_id: data.data.data[0].id,
                    delivery_fee: data.data.data[0].delivery_price,
                    tax: data.data.data[0].tax,
                });

                this.getActiveProducts(data.data.data[0].id);
                this.getActiveTimeUnits(data.data.data[0].id);
                this.getActiveDeliveryBoys(data.data.data[0].id);
            }

            if (this.formRef.current != null && !this.state.edit)
                this.formRef.current.setFieldsValue({
                    shop: data.data.data[0].id
                });
        }
    }

    getActiveDeliveryBoys = async (shop_id) => {
        let data = await deliveryBoyActive(shop_id);
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                delivery_boys: data.data.data
            });

            if (this.formRef.current != null)
                this.formRef.current.setFieldsValue({
                    delivery_boy: this.state.delivery_boy_id > 0 ? this.state.delivery_boy_id : data.data.data[0].id,
                });
        }
    }

    getActiveTimeUnits = async (shop_id) => {
        let data = await timeUnitActive(shop_id);
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                time_units: data.data.data
            });
        }
    }

    getActiveClient = async () => {
        let data = await clientActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                clients: data.data.data
            });

            if (this.formRef.current != null)
                this.formRef.current.setFieldsValue({
                    client: this.state.client_id > 0 ? this.state.client_id : data.data.data[0].id,
                });
        }
    }

    getActiveProducts = async (shop_id) => {
        let data = await productActive(shop_id);
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                products: data.data.data,
            });
        }
    }

    getActivePaymentStatus = async () => {
        let data = await paymentStatusActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                payment_statuses: data.data.data
            });

            if (this.formRef.current != null)
                this.formRef.current.setFieldsValue({
                    payment_status: this.state.payment_status > 0 ? this.state.payment_status : data.data.data[0].id
                });
        }
    }

    getActivePaymentMethods = async () => {
        let data = await paymentMethodActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                payment_methods: data.data.data
            });

            if (this.formRef.current != null)
                this.formRef.current.setFieldsValue({
                    payment_method: this.state.payment_method > 0 ? this.state.payment_method : data.data.data[0].id
                });
        }
    }

    getActiveOrderStatus = async () => {
        let data = await orderStatusActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                order_statuses: data.data.data
            });

            if (this.formRef.current != null)
                this.formRef.current.setFieldsValue({
                    order_status: this.state.order_status > 0 ? this.state.order_status : data.data.data[0].id
                });
        }
    }

    getActiveAddress = async (client_id) => {
        let data = await addressActive(client_id);
        if (data.data.success == 1 && data.data.data.length > 0) {
            if (this.state.edit)
                this.setState({
                    addresses: data.data.data,
                });
            else {
                this.setState({
                    addresses: data.data.data,
                    address_id: this.state.address_id > 0 ? this.state.address_id : data.data.data[0].id
                });

                this.formRef.current.setFieldsValue({
                    address: this.state.address_id > 0 ? this.state.address_id : data.data.data[0].id
                });
            }
        }
    }

    onChangeClient(e) {
        this.setState({
            client_id: e
        });

        this.getActiveAddress(e);
    }

    onChangeDate = (value, dateString) => {
        this.setState({
            delivery_date: dateString
        })
    }

    onChangeAddress(e) {
        this.setState({
            address_id: e
        })
    }

    onChangeProduct(e) {
        this.setState({
            selected_product: e
        })
    }

    onChangeShop(e) {
        this.setState({
            shop_id: e
        });

        var index = this.state.shops.findIndex((val) => val.id === e);
        if (index > -1)
            this.setState({
                delivery_fee: this.state.shops[index].delivery_price,
                tax: this.state.shops[index].tax,
            });

        this.getActiveProducts(e);
        this.getActiveTimeUnits(e);
        this.getActiveDeliveryBoys(e);
    }

    onFinish = async (values) => {
        let data = await orderSave(values, this.state, this.state.id);

        if (data.data.success == 1)
            window.history.back();
    };

    onFinishFailed = (errorInfo) => {
    };

    render() {
        return (
            <PageLayout>
                <Breadcrumb style={{margin: '16px 0'}}>
                    <Breadcrumb.Item><Link to="/orders" className="nav-text">Orders</Link></Breadcrumb.Item>
                    <Breadcrumb.Item>{this.state.edit ? "Edit" : "Add"}</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    className="site-page-header"
                    title="Orders"
                >
                    <Content
                        className="site-layout-background">
                        <Form
                            ref={this.formRef}
                            name="basic"
                            initialValues={{
                                total_amount: 0,
                                total_discount: 0,
                                delivery_type: "1",
                                client: this.state.client_id
                            }}
                            layout="vertical"
                            onFinish={this.onFinish}
                            onFinishFailed={this.onFinishFailed}
                        >
                            <div className="row">
                                <div className="col-md-6 col-sm-12">
                                    <Card title="Client info" type="inner" size="small">
                                        <div className="row">
                                            <div className="col-md-9 col-sm-12">
                                                <Form.Item label="Clients" name="client"
                                                           rules={[{required: true, message: 'Missing client'}]}
                                                           tooltip="Select client">
                                                    <Select placeholder="Select client" onChange={this.onChangeClient}>
                                                        {
                                                            this.state.clients.map((item) => {
                                                                return (
                                                                    <Option value={item.id}
                                                                            key={item.id}>{item.name}</Option>);
                                                            })
                                                        }
                                                    </Select>
                                                </Form.Item>
                                            </div>
                                            <div className="col-md-3 col-sm-12">
                                                <Link className="btn btn-success" to="/clients/add"
                                                      style={{marginTop: '30px'}}>Add client</Link>
                                            </div>
                                            {
                                                this.state.client_id > 0 && (<>
                                                    <div className="col-md-9 col-sm-12">
                                                        <Form.Item label="Address" name="address"
                                                                   rules={[{
                                                                       required: true,
                                                                       message: 'Missing address'
                                                                   }]}
                                                                   tooltip="Select address">
                                                            <Select placeholder="Select address"
                                                                    onChange={this.onChangeAddress}>
                                                                {
                                                                    this.state.addresses.map((item) => {
                                                                        return (
                                                                            <Option value={item.id}
                                                                                    key={item.id}>{item.address}</Option>);
                                                                    })
                                                                }
                                                            </Select>
                                                        </Form.Item>
                                                    </div>
                                                    <div className="col-md-3 col-sm-12">
                                                        <Link className="btn btn-success" to={{
                                                            pathname: "/client-addresses/add",
                                                            state: {client_id: this.state.client_id}
                                                        }}
                                                              style={{marginTop: '30px'}}>Add new address</Link>
                                                    </div>
                                                </>)
                                            }
                                        </div>
                                    </Card>
                                </div>
                                {
                                    this.state.address_id > 0 && (
                                        <>
                                            <div className="col-md-6 col-sm-12">
                                                <Card title="Shop info" type="inner" size="small">
                                                    <div className="col-md-6 col-sm-12">
                                                        <Form.Item label="Shops" name="shop"
                                                                   rules={[{required: true, message: 'Missing shop'}]}
                                                                   tooltip="Select shop">
                                                            <Select placeholder="Select shop"
                                                                    onChange={this.onChangeShop}>
                                                                {
                                                                    this.state.shops.map((item) => {
                                                                        return (
                                                                            <Option value={item.id}
                                                                                    key={item.id}>{item.name}</Option>);
                                                                    })
                                                                }
                                                            </Select>
                                                        </Form.Item>
                                                    </div>
                                                </Card>
                                            </div>
                                            <div className="col-md-6 col-sm-12" style={{marginTop: '30px'}}>
                                                <Card title="Order info" type="inner" size="small">
                                                    <div className="row">
                                                        <div className="col-md-6 col-sm-12">
                                                            <Form.Item label="Total amount" name="total_amount"
                                                                       rules={[{
                                                                           required: true,
                                                                           message: 'Missing total amount'
                                                                       }]}
                                                                       tooltip="Enter total amount">
                                                                <Input placeholder="Total amount" disabled/>
                                                            </Form.Item>
                                                        </div>
                                                        <div className="col-md-6 col-sm-12">
                                                            <Form.Item label="Total discount" name="total_discount"
                                                                       rules={[{
                                                                           required: true,
                                                                           message: 'Missing total discount'
                                                                       }]}
                                                                       tooltip="Enter total discount">
                                                                <Input placeholder="Total discount" disabled/>
                                                            </Form.Item>
                                                        </div>
                                                        <div className="col-md-6 col-sm-12">
                                                            <Form.Item label="Order status" name="order_status"
                                                                       rules={[{
                                                                           required: true,
                                                                           message: 'Missing order status'
                                                                       }]}
                                                                       tooltip="Select order status">
                                                                <Select placeholder="Select order status">
                                                                    {
                                                                        this.state.order_statuses.map((item) => {
                                                                            return (
                                                                                <Option value={item.id}
                                                                                        key={item.id}>{item.name}</Option>);
                                                                        })
                                                                    }
                                                                </Select>
                                                            </Form.Item>
                                                        </div>
                                                        <div className="col-md-6 col-sm-12">
                                                            <Form.Item label="Payment status" name="payment_status"
                                                                       rules={[{
                                                                           required: true,
                                                                           message: 'Missing payment status'
                                                                       }]}
                                                                       tooltip="Select payment status">
                                                                <Select placeholder="Select payment status">
                                                                    {
                                                                        this.state.payment_statuses.map((item) => {
                                                                            return (
                                                                                <Option value={item.id}
                                                                                        key={item.id}>{item.name}</Option>);
                                                                        })
                                                                    }
                                                                </Select>
                                                            </Form.Item>
                                                        </div>
                                                        <div className="col-md-6 col-sm-12">
                                                            <Form.Item label="Payment method" name="payment_method"
                                                                       rules={[{
                                                                           required: true,
                                                                           message: 'Missing payment method'
                                                                       }]}
                                                                       tooltip="Select payment method">
                                                                <Select placeholder="Select payment method">
                                                                    {
                                                                        this.state.payment_methods.map((item) => {
                                                                            return (
                                                                                <Option value={item.id}
                                                                                        key={item.id}>{item.name}</Option>);
                                                                        })
                                                                    }
                                                                </Select>
                                                            </Form.Item>
                                                        </div>
                                                        <div className="col-md-6 col-sm-12">
                                                            <Form.Item
                                                                label="Order's Comment"
                                                                name="order_comment"
                                                                tooltip="Enter order's comment"
                                                            >
                                                                <TextArea showCount maxLength={100}/>
                                                            </Form.Item>
                                                        </div>
                                                    </div>
                                                </Card>
                                            </div>
                                            <div className="col-md-6 col-sm-12" style={{marginTop: '30px'}}>
                                                <Card title="Delivery info" type="inner" size="small">
                                                    <div className="row">
                                                        <div className="col-md-4 col-sm-12">
                                                            <Form.Item name="delivery_type" label="Delivery type"
                                                                       tooltip="Enter shop delivery type">
                                                                <Radio.Group>
                                                                    <Radio value="1">Delivery</Radio>
                                                                    <Radio value="2">Pickup</Radio>
                                                                </Radio.Group>
                                                            </Form.Item>
                                                        </div>
                                                        <div className="col-md-8 col-sm-12">
                                                            <div className="row">
                                                                <div className="col-md-6 col-sm-12">
                                                                    <Form.Item name="delivery_date"
                                                                               label="Delivery date"
                                                                               tooltip="Enter order delivery date"
                                                                               rules={[{
                                                                                   required: true,
                                                                                   message: 'Missing order delivery date'
                                                                               }]}>
                                                                        <DatePicker onChange={this.onChangeDate}/>
                                                                    </Form.Item>
                                                                </div>
                                                                <div className="col-md-6 col-sm-12">
                                                                    <Form.Item label="Delivery time"
                                                                               name="delivery_time"
                                                                               rules={[{
                                                                                   required: true,
                                                                                   message: 'Missing delivery time'
                                                                               }]}
                                                                               tooltip="Select delivery time">
                                                                        <Select placeholder="Select delivery time">
                                                                            {
                                                                                this.state.time_units.map((item) => {
                                                                                    return (
                                                                                        <Option value={item.id}
                                                                                                key={item.id}>{item.name}</Option>);
                                                                                })
                                                                            }
                                                                        </Select>
                                                                    </Form.Item>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div className="col-md-6 col-sm-12">
                                                            <Form.Item label="Delivery boy"
                                                                       name="delivery_boy"
                                                                       tooltip="Select delivery boy">
                                                                <Select placeholder="Select delivery boy">
                                                                    {
                                                                        this.state.delivery_boys.map((item) => {
                                                                            return (
                                                                                <Option value={item.id}
                                                                                        key={item.id}>{item.name} {item.surname}</Option>);
                                                                        })
                                                                    }
                                                                </Select>
                                                            </Form.Item>
                                                        </div>
                                                        <div className="col-md-6 col-sm-12">
                                                            <Form.Item
                                                                label="Delivery boy's Comment"
                                                                name="delivery_boy_comment"
                                                                tooltip="Enter delivery boy's comment"
                                                            >
                                                                <TextArea showCount maxLength={100}/>
                                                            </Form.Item>
                                                        </div>
                                                    </div>
                                                </Card>
                                            </div>
                                            <div className="col-md-12 col-sm-12" style={{marginTop: '30px'}}>
                                                <Card title="Order detail info"
                                                      extra={<div className="row"
                                                                  style={{marginRight: '10px'}}>
                                                          <Select showSearch
                                                                  onChange={this.onChangeProduct}
                                                                  optionFilterProp="children"
                                                                  filterOption={(input, option) =>
                                                                      option.children.toLowerCase().indexOf(input.toLowerCase()) >= 0
                                                                  }
                                                                  placeholder="Select product">
                                                              {
                                                                  this.state.products.map((item) => {
                                                                      return (
                                                                          <Option value={item.id_product}
                                                                                  key={item.id_product}>{item.name}</Option>);
                                                                  })
                                                              }
                                                          </Select>
                                                          <Button className="btn-success" onClick={this.onSelectProduct}
                                                                  style={{marginLeft: '10px'}}>Add
                                                              product</Button>
                                                      </div>} type="inner" size="small">
                                                    {
                                                        this.state.product_details.length > 0 ? (
                                                            <>
                                                                <Form.Item>
                                                                    <Table
                                                                        pagination={false}
                                                                        dataSource={this.state.product_details}
                                                                        columns={this.columns}
                                                                        rowKey="id"
                                                                        summary={pageData => {
                                                                            return (
                                                                                <>
                                                                                    <Table.Summary.Row>
                                                                                        <Table.Summary.Cell
                                                                                            colSpan={6}></Table.Summary.Cell>
                                                                                        <Table.Summary.Cell>Price
                                                                                            total</Table.Summary.Cell>
                                                                                        <Table.Summary.Cell colSpan={2}>
                                                                                            <Text
                                                                                                type="danger">{this.state.total_amount}</Text>
                                                                                        </Table.Summary.Cell>
                                                                                    </Table.Summary.Row>
                                                                                    <Table.Summary.Row>
                                                                                        <Table.Summary.Cell
                                                                                            colSpan={6}></Table.Summary.Cell>
                                                                                        <Table.Summary.Cell>Discount
                                                                                            total</Table.Summary.Cell>
                                                                                        <Table.Summary.Cell colSpan={2}>
                                                                                            <Text
                                                                                                type="danger">{this.state.total_discount}</Text>
                                                                                        </Table.Summary.Cell>
                                                                                    </Table.Summary.Row>
                                                                                    <Table.Summary.Row>
                                                                                        <Table.Summary.Cell
                                                                                            colSpan={6}></Table.Summary.Cell>
                                                                                        <Table.Summary.Cell>Delivery
                                                                                            fee</Table.Summary.Cell>
                                                                                        <Table.Summary.Cell colSpan={2}>
                                                                                            <Text
                                                                                                type="danger">{this.state.delivery_fee}</Text>
                                                                                        </Table.Summary.Cell>
                                                                                    </Table.Summary.Row>
                                                                                    {
                                                                                        false && (<Table.Summary.Row>
                                                                                            <Table.Summary.Cell
                                                                                                colSpan={6}></Table.Summary.Cell>
                                                                                            <Table.Summary.Cell>Tax</Table.Summary.Cell>
                                                                                            <Table.Summary.Cell
                                                                                                colSpan={2}>
                                                                                                <Text
                                                                                                    type="danger">{this.state.tax}</Text>
                                                                                            </Table.Summary.Cell>
                                                                                        </Table.Summary.Row>)
                                                                                    }
                                                                                    <Table.Summary.Row>
                                                                                        <Table.Summary.Cell
                                                                                            colSpan={6}></Table.Summary.Cell>
                                                                                        <Table.Summary.Cell>Amount to
                                                                                            pay</Table.Summary.Cell>
                                                                                        <Table.Summary.Cell colSpan={2}>
                                                                                            <Text
                                                                                                type="danger">{this.state.total}</Text>
                                                                                        </Table.Summary.Cell>
                                                                                    </Table.Summary.Row>
                                                                                </>
                                                                            );
                                                                        }}
                                                                    />
                                                                    <Button type="primary" className="btn-success"
                                                                            style={{marginTop: '40px'}}
                                                                            htmlType="submit">Save</Button>
                                                                </Form.Item>
                                                            </>
                                                        ) : (
                                                            <Alert
                                                                message="To save order, please add products to orders"
                                                                type="info"/>
                                                        )
                                                    }
                                                </Card>
                                            </div>
                                        </>
                                    )
                                }
                            </div>
                        </Form>
                    </Content>
                </PageHeader>
            </PageLayout>
        );
    }
}

export default OrderAdd;
