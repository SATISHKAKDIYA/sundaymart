import React from 'react';
import {
    Breadcrumb,
    Button,
    Checkbox,
    Form,
    Input,
    InputNumber,
    Layout,
    Modal,
    PageHeader,
    Radio,
    Select,
    Spin, DatePicker
} from "antd";
import {Link} from "react-router-dom";
import PageLayout from "../../layouts/PageLayout";
import shopActive from "../../requests/Shops/ShopActive";
import languageActive from "../../requests/Language/LanguageActive";
import productActive from "../../requests/Products/ProductActive";
import couponSave from "../../requests/Coupons/CouponSave";
import couponGet from "../../requests/Coupons/CouponGet";
import * as moment from "moment";

const {Option} = Select;
const {Content} = Layout;
const {TextArea} = Input;

class CouponAdd extends React.Component {
    formRef = React.createRef();

    constructor(props) {
        super(props);

        this.state = {
            shops: [],
            shop_id: -1,
            products: [],
            language: "en",
            languages: [],
            descriptions: {},
            active: true,
            valid_date: "",
            id: props.location.state ? props.location.state.id : 0,
            edit: props.location.state ? props.location.state.edit : false
        };

        this.getActiveShops = this.getActiveShops.bind(this);
        this.getActiveProducts = this.getActiveProducts.bind(this);
        this.getActiveLanguages = this.getActiveLanguages.bind(this);
        this.changeStatus = this.changeStatus.bind(this);
        this.onChangeLanguage = this.onChangeLanguage.bind(this);
        this.onChangeShop = this.onChangeShop.bind(this);
        this.onChangeDescription = this.onChangeDescription.bind(this);
        this.getInfoById = this.getInfoById.bind(this);

        this.getActiveLanguages();
        this.getActiveShops();
    }

    componentDidMount() {
        if (this.state.edit)
            setTimeout(() => this.getInfoById(this.state.id), 1000);
    }

    getInfoById = async (id) => {
        let data = await couponGet(id);
        if (data.data.success) {
            let coupon = data.data.data.coupon;
            let coupon_language = data.data.data.coupon_language;
            let coupon_products = data.data.data.coupon_products;

            this.getActiveProducts(coupon.id_shop);

            var descriptionsArray = this.state.descriptions;
            for (let i = 0; i < coupon_language.length; i++) {
                var lang = coupon_language[i].short_name;
                descriptionsArray[lang] = coupon_language[i].description;
            }

            this.setState({
                active: coupon.active == 1 ? true : false,
                description: descriptionsArray,
                shop_id: coupon.id_shop,
            });

            var productsArray = [];
            if (coupon_products.length > 0) {
                for (var i = 0; i < coupon_products.length; i++) {
                    productsArray.push(coupon_products[i].id_product);
                }
            }

            this.formRef.current.setFieldsValue({
                description: descriptionsArray[this.state.language],
                shop: coupon.id_shop,
                name: coupon.name,
                discount_type: coupon.discount_type,
                discount: coupon.discount,
                usage_time: coupon.usage_time,
                valid: moment(coupon.valid_until, 'HH:mm:ss'),
                products: productsArray,
            });
        }
    }

    getActiveLanguages = async () => {
        let data = await languageActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                languages: data.data.data,
                language: data.data.data[0].short_name
            });

            var descriptionsArray = this.state.descriptions;

            for (let i = 0; i < data.data.data.length; i++) {
                var lang = data.data.data[i].short_name;
                descriptionsArray[lang] = "";
            }

            this.setState({
                descriptions: descriptionsArray
            });
        }
    }

    getActiveShops = async () => {
        let data = await shopActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.getActiveProducts(data.data.data[0].id);

            this.setState({
                shops: data.data.data,
                shop_id: data.data.data[0].id
            });

            this.formRef.current.setFieldsValue({
                shop: data.data.data[0].id
            });
        }
    }

    onChangeShop = (e) => {
        this.setState({
            shop_id: e
        });

        this.getActiveProducts(e);
    }

    onChangeDescription = (e) => {
        var descriptionArray = this.state.descriptions;
        descriptionArray[this.state.language] = e.target.value;
        this.setState({
            descriptions: descriptionArray
        });
    }

    getActiveProducts = async (shop_id) => {
        let data = await productActive(shop_id);
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                products: data.data.data,
            });
        }
    }

    changeStatus = (e) => {
        this.setState({
            active: e.target.checked
        });
    }

    onChangeLanguage = (e) => {// 99 805 5856
        let lang = e.target.value;
        this.setState({
            language: lang
        });

        this.formRef.current.setFieldsValue({
            description: this.state.descriptions[lang]
        });
    };

    onFinish = async (values) => {
        let data = await couponSave(values.name,
            this.state.descriptions,
            values.shop,
            values.discount_type,
            values.discount,
            values.usage_time,
            this.state.valid_date,
            values.products,
            this.state.active, this.state.id);

        if (data.data.success == 1)
            window.history.back();
    };

    onFinishFailed = (errorInfo) => {
    };

    onChangeDate = (value, dateString) => {
        this.setState({
            valid_date: dateString
        })
    }

    onOk = (value) => {
        console.log('onOk: ', value);
    }

    render() {
        return (
            <PageLayout>
                <Breadcrumb style={{margin: '16px 0'}}>
                    <Breadcrumb.Item><Link to="/coupons" className="nav-text">Coupons</Link></Breadcrumb.Item>
                    <Breadcrumb.Item>{this.state.edit ? "Edit" : "Add"}</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    onBack={() => window.history.back()}
                    className="site-page-header"
                    title={this.state.edit ? "Coupon Edit" : "Coupon Add"}
                >
                    <Content
                        className="site-layout-background padding-20">
                        {
                            (this.state.languages.length > 0) ? (<Form
                                ref={this.formRef}
                                name="basic"
                                initialValues={{
                                    discount_type: 1
                                }}
                                layout="vertical"
                                onFinish={this.onFinish}
                                onFinishFailed={this.onFinishFailed}
                            >
                                <div className="row">
                                    <div className="col-md-12 col-sm-12">
                                        <Radio.Group value={this.state.language} onChange={this.onChangeLanguage}
                                                     className="float-right">
                                            {
                                                this.state.languages.map((item) => {
                                                    return (
                                                        <Radio.Button value={item.short_name}
                                                                      key={item.short_name}>{item.name}</Radio.Button>);
                                                })
                                            }
                                        </Radio.Group>
                                    </div>
                                </div>
                                <div className="row">
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Name" name="name"
                                                   rules={[{required: true, message: 'Missing category name'}]}
                                                   tooltip="Enter category name">
                                            <Input placeholder="Name"/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item
                                            label="Description"
                                            name="description"
                                            rules={[{required: true, message: 'Missing coupon description'}]}
                                            tooltip="Enter coupon description"
                                        >
                                            <TextArea showCount maxLength={100} onChange={this.onChangeDescription}/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Shop" name="shop"
                                                   rules={[{required: true, message: 'Missing shop'}]}
                                                   tooltip="Select shop">
                                            <Select placeholder="Select shop" onChange={this.onChangeShop}>
                                                {
                                                    this.state.shops.map((item) => {
                                                        return (
                                                            <Option value={item.id} key={item.id}>{item.name}</Option>);
                                                    })
                                                }
                                            </Select>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Discount type" name="discount_type"
                                                   rules={[{required: true, message: 'Missing discount type'}]}
                                                   tooltip="Select discount type">
                                            <Select placeholder="Select discount type">
                                                <Option value={1} key={1}>Percentage</Option>
                                                <Option value={2} key={2}>Fixed price</Option>
                                            </Select>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Discount" name="discount"
                                                   rules={[{required: true, message: 'Missing discount'}]}
                                                   tooltip="Enter discount">
                                            <InputNumber placeholder="Discount"/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Usage times" name="usage_time"
                                                   rules={[{required: true, message: 'Missing discount'}]}
                                                   tooltip="Enter usage times">
                                            <InputNumber placeholder="Usage times"/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Products" name="products"
                                                   tooltip="Select products">
                                            <Select placeholder="Select products" mode="tags">
                                                {
                                                    this.state.products.map((item) => {
                                                        return (
                                                            <Option value={item.id} key={item.id}>{item.name}</Option>);
                                                    })
                                                }
                                            </Select>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-3 col-sm-6">
                                        <Form.Item name="valid" label="Valid until"
                                                   tooltip="Enter banner valid date"
                                                   rules={[{required: true, message: 'Missing banner valid date'}]}>
                                            <DatePicker showTime onChange={this.onChangeDate} onOk={this.onOk}/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-3 col-sm-6">
                                        <Form.Item label="Status" name="active"
                                                   tooltip="Uncheck if category is inactive">
                                            <Checkbox checked={this.state.active}
                                                      onChange={this.changeStatus}>{this.state.active ? "Active" : "Inactive"}</Checkbox>
                                        </Form.Item>
                                    </div>
                                </div>
                                <Form.Item>
                                    <Button type="primary" className="btn-success" style={{marginTop: '40px'}}
                                            htmlType="submit">Save</Button>
                                </Form.Item>
                            </Form>) : (
                                <div className="d-flex flex-row justify-content-center" style={{height: '400px'}}>
                                    <Spin style={{marginTop: 'auto', marginBottom: 'auto'}} size="large"/>
                                </div>)
                        }
                    </Content>
                </PageHeader>
            </PageLayout>
        );
    }
}

export default CouponAdd;
