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
    Spin,
    Upload,
    Tabs
} from "antd";
import {Link} from "react-router-dom";
import PageLayout from "../../../layouts/PageLayout";
import {PlusOutlined} from "@ant-design/icons";
import shopActive from "../../../requests/Shops/ShopActive";
import languageActive from "../../../requests/Language/LanguageActive";
import categoryActive from "../../../requests/Categories/CategoryActive";
import brandActive from "../../../requests/Brands/BrandActive";
import unitActive from "../../../requests/Units/UnitActive";
import productSave from "../../../requests/Products/ProductSave";
import productGet from "../../../requests/Products/ProductGet";
import ExtrasGroup from "../ExtrasGroups/ExtrasGroup";
import ExtrasGroupAdd from "../ExtrasGroups/ExtrasGroupAdd";
import Extras from "../Extras/Extras";
import ExtrasAdd from "../Extras/ExtrasAdd";
import CharacteristicsAdd from "../Characteristics/CharacteristicsAdd";
import Characteristics from "../Characteristics/Characteristics";

const {Option} = Select;
const {Content} = Layout;
const {TextArea} = Input;
const {TabPane} = Tabs;

class ProductAdd extends React.Component {
    formRef = React.createRef();

    constructor(props) {
        super(props);

        this.state = {
            previewImage: "",
            previewVisible: false,
            previewTitle: "",
            fileList: [],
            shops: [],
            shop_id: -1,
            category_id: -1,
            categories: [],
            brand_id: -1,
            brands: [],
            units: [],
            unit_id: -1,
            language: "en",
            languages: [],
            names: {},
            descriptions: {},
            activeExtra: {},
            extrasPrice: {},
            extra_names: {},
            extra_descriptions: {},
            active: true,
            id_extra_group_type: -1,
            feature_type: -1,
            extras_count: 1,
            extra_group_id: -1,
            characteristics_id: -1,
            extra_id: -1,
            tab_id: "1",
            extras_group_type: -1,
            id: props.location.state ? props.location.state.id : 0,
            edit: props.location.state ? props.location.state.edit : false,
            characteristics_edit: false,
            extras_group_edit: false,
            extras_edit: false
        };

        this.getActiveShops = this.getActiveShops.bind(this);
        this.getActiveCategory = this.getActiveCategory.bind(this);
        this.getActiveBrands = this.getActiveBrands.bind(this);
        this.getActiveLanguages = this.getActiveLanguages.bind(this);
        this.changeStatus = this.changeStatus.bind(this);
        this.onChangeLanguage = this.onChangeLanguage.bind(this);
        this.onChangeName = this.onChangeName.bind(this);
        this.onChangeShop = this.onChangeShop.bind(this);
        this.getInfoById = this.getInfoById.bind(this);
        this.onChangeDescription = this.onChangeDescription.bind(this);
        this.onChangeTab = this.onChangeTab.bind(this);
        this.onSaveExtrasGroup = this.onSaveExtrasGroup.bind(this);
        this.onSaveExtras = this.onSaveExtras.bind(this);
        this.onEditExtrasGroup = this.onEditExtrasGroup.bind(this);
        this.onEditExtras = this.onEditExtras.bind(this);
        this.onEditCharacteristics = this.onEditCharacteristics.bind(this);
        this.onSaveCharacteristics = this.onSaveCharacteristics.bind(this);

        this.getActiveLanguages();
        this.getActiveShops();
        this.getActiveUnits();
    }


    getInfoById = async (id) => {
        let data = await productGet(id);
        if (data.data.success) {
            let product = data.data.data.product;
            let product_language = data.data.data.product_language;
            let product_images = data.data.data.product_image;

            this.getActiveCategory(product.id_shop);
            this.getActiveBrands(product.id_shop);

            var namesArray = this.state.names;
            var descriptionsArray = this.state.descriptions;
            for (let i = 0; i < product_language.length; i++) {
                var lang = product_language[i].short_name;
                namesArray[lang] = product_language[i].name;
                descriptionsArray[lang] = product_language[i].description;
            }

            var fileListArray = [];
            for (let m = 0; m < product_images.length; m++) {
                fileListArray.push({
                    uid: -m,
                    name: product_images[m].image_url,
                    status: 'done',
                    url: '/uploads/' + product_images[m].image_url,
                });
            }

            this.setState({
                active: product.active == 1 ? true : false,
                names: namesArray,
                shop_id: product.id_shop,
                brand_id: product.id_brand,
                category_id: product.id_category,
                fileList: fileListArray,
                feature_type: parseInt(product.show_type),
            });

            this.formRef.current.setFieldsValue({
                dragger: this.state.fileList,
                name: namesArray[this.state.language],
                description: descriptionsArray[this.state.language],
                shop: product.id_shop,
                brand: product.id_brand,
                category: product.id_category,
                price: product.price,
                weight: product.weight,
                quantity: product.quantity,
                package_count: product.pack_quantity,
                unit: product.id_unit,
                feature_type: parseInt(product.show_type)
            });
        }
    }


    getActiveUnits = async () => {
        let data = await unitActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                units: data.data.data,
            });

            const index = data.data.data.findIndex((element, index) => {
                if (element.id === this.state.unit_id) {
                    return true
                }
            });

            this.formRef.current.setFieldsValue({
                unit: index > -1 ? this.state.unit_id : data.data.data[0].id
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

            var namesArray = this.state.names;
            var descriptionArray = this.state.descriptions;

            for (let i = 0; i < data.data.data.length; i++) {
                var lang = data.data.data[i].short_name;
                namesArray[lang] = "";
                descriptionArray[lang] = "";
            }

            this.setState({
                names: namesArray,
                descriptions: descriptionArray,
            });

            if (this.state.edit)
                setTimeout(() => this.getInfoById(this.state.id), 1000);
        }
    }

    getActiveShops = async () => {
        let data = await shopActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.getActiveCategory(data.data.data[0].id);
            this.getActiveBrands(data.data.data[0].id);

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
            shop_id: e,
            categories: [],
            brands: [],
            category_id: -1,
            brand_id: -1,
        });

        this.getActiveCategory(e);
        this.getActiveBrands(e);
    }

    getActiveCategory = async (shop_id) => {
        let data = await categoryActive(shop_id);
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                categories: data.data.data,
            });

            const index = data.data.data.findIndex((element, index) => {
                if (element.id === this.state.category_id) {
                    return true
                }
            });

            this.formRef.current.setFieldsValue({
                category: index > -1 ? this.state.category_id : data.data.data[0].id
            });
        }
    }

    getActiveBrands = async (shop_id) => {
        let data = await brandActive(shop_id);
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                brands: data.data.data,
            });

            // const index = data.data.data.findIndex((element, index) => {
            //     if (element.id === this.state.brand_id) {
            //         return true
            //     }
            // });

            this.formRef.current.setFieldsValue({
                brand: this.state.brand_id > 0 ? this.state.brand_id : data.data.data[0].id
            });
        }
    }

    changeStatus = (e) => {
        this.setState({
            active: e.target.checked
        });
    }

    onChangeName = (e) => {
        var namesArray = this.state.names;
        namesArray[this.state.language] = e.target.value;
        this.setState({
            names: namesArray
        });
    }

    onChangeLanguage = (e) => {// 99 805 5856
        let lang = e.target.value;
        this.setState({
            language: lang
        });

        this.formRef.current.setFieldsValue({
            name: this.state.names[lang],
            description: this.state.descriptions[lang],
        });
    };

    onFinish = async (values) => {
        let data = await productSave(values, this.state.names, this.state.descriptions, this.state.fileList, this.state.active, this.state.id);

        if (data.data.success == 1)
            window.history.back();
    };

    onFinishFailed = (errorInfo) => {
    };

    normFile = (e) => {
        if (Array.isArray(e)) {
            return e;
        }

        return e && e.fileList;
    };

    getBase64 = (file) => {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.readAsDataURL(file);
            reader.onload = () => resolve(reader.result);
            reader.onerror = error => reject(error);
        });
    }

    handleCancel = () => this.setState({previewVisible: false});

    handlePreview = async file => {
        if (!file.url && !file.preview) {
            file.preview = await this.getBase64(file.originFileObj);
        }

        this.setState({
            previewImage: file.url || file.preview,
            previewVisible: true,
            previewTitle: file.name || file.url.substring(file.url.lastIndexOf('/') + 1),
        });
    };

    handleChange = ({fileList}) => {
        fileList = fileList.map(file => {
            if (file.response) {
                return {
                    uid: file.uid,
                    name: file.response.name,
                    status: 'done',
                    url: '/uploads/' + file.response.name,
                };
            }
            return file;
        });

        this.setState({fileList});
    };

    onChangeDescription = (e) => {
        var descriptionArray = this.state.descriptions;
        descriptionArray[this.state.language] = e.target.value;
        this.setState({
            descriptions: descriptionArray
        });
    }

    onChangeTab = (e) => {
        this.setState({
            tab_id: e
        });
    }

    onSaveCharacteristics = () => {
        this.setState({
            characteristics_edit: false
        });
    }

    onSaveExtrasGroup = () => {
        this.setState({
            extras_group_edit: false
        });
    }

    onSaveExtras = () => {
        this.setState({
            extras_edit: false
        });
    }

    onEditCharacteristics = (id) => {
        this.setState({
            characteristics_id: id,
            characteristics_edit: true
        });
    }

    onEditExtrasGroup = (id) => {
        this.setState({
            extra_group_id: id,
            extras_group_edit: true
        });
    }

    onEditExtras = (id) => {
        this.setState({
            extra_id: id,
            extras_edit: true
        });
    }

    render() {
        return (
            <PageLayout>
                <Breadcrumb style={{margin: '16px 0'}}>
                    <Breadcrumb.Item><Link to="/products" className="nav-text">Products</Link></Breadcrumb.Item>
                    <Breadcrumb.Item>{this.state.edit ? "Edit" : "Add"}</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    onBack={() => window.history.back()}
                    className="site-page-header"
                    title={this.state.edit ? "Product Edit" : "Product Add"}
                >
                    <Content
                        className="site-layout-background padding-20">
                        {
                            (this.state.languages.length > 0) ? (
                                <Tabs defaultActiveKey={this.state.tab_id} onChange={this.onChangeTab}>
                                    <TabPane tab="Product" key="1">
                                        <Form
                                            ref={this.formRef}
                                            name="basic"
                                            initialValues={{
                                                feature_type: this.state.feature_type > -1 ? this.state.feature_type : 1
                                            }}
                                            layout="vertical"
                                            onFinish={this.onFinish}
                                            onFinishFailed={this.onFinishFailed}
                                        >
                                            <div className="row">
                                                <div className="col-md-12 col-sm-12">
                                                    <Radio.Group value={this.state.language}
                                                                 onChange={this.onChangeLanguage}
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
                                                               rules={[{
                                                                   required: true,
                                                                   message: 'Missing product name'
                                                               }]}
                                                               tooltip="Enter product name">
                                                        <Input placeholder="Name"
                                                               onChange={this.onChangeName}/>
                                                    </Form.Item>
                                                </div>
                                                <div className="col-md-6 col-sm-12">
                                                    <Form.Item
                                                        label="Description"
                                                        name="description"
                                                        rules={[{
                                                            required: true,
                                                            message: 'Missing product description'
                                                        }]}
                                                        tooltip="Enter product description"
                                                    >
                                                        <TextArea showCount maxLength={100}
                                                                  onChange={this.onChangeDescription}/>
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
                                                                        <Option value={item.id}
                                                                                key={item.id}>{item.name}</Option>);
                                                                })
                                                            }
                                                        </Select>
                                                    </Form.Item>
                                                </div>
                                                <div className="col-md-6 col-sm-12">
                                                    <Form.Item label="Brand" name="brand"
                                                               rules={[{required: true, message: 'Missing brand'}]}
                                                               tooltip="Select brand">
                                                        <Select placeholder="Select brand">
                                                            {
                                                                this.state.brands.map((item) => {
                                                                    return (
                                                                        <Option value={item.id}
                                                                                key={item.id}>{item.name}</Option>);
                                                                })
                                                            }
                                                        </Select>
                                                    </Form.Item>
                                                </div>
                                                <div className="col-md-6 col-sm-12">
                                                    <Form.Item label="Category" name="category"
                                                               rules={[{required: true, message: 'Missing category'}]}
                                                               tooltip="Select category">
                                                        <Select placeholder="Select category">
                                                            {
                                                                this.state.categories.map((item) => {
                                                                    return (
                                                                        <Option value={item.id}
                                                                                key={item.id}>{item.name}</Option>);
                                                                })
                                                            }
                                                        </Select>
                                                    </Form.Item>
                                                </div>
                                                <div className="col-md-3 col-sm-6">
                                                    <Form.Item label="Package count" name="package_count"
                                                               rules={[{
                                                                   required: true,
                                                                   message: 'Missing package count'
                                                               }]}
                                                               tooltip="Enter package count">
                                                        <InputNumber placeholder="Package count"/>
                                                    </Form.Item>
                                                </div>
                                                <div className="col-md-3 col-sm-6">
                                                    <Form.Item label="Price" name="price"
                                                               rules={[{required: true, message: 'Missing price'}]}
                                                               tooltip="Enter price">
                                                        <InputNumber placeholder="Price"/>
                                                    </Form.Item>
                                                </div>
                                                <div className="col-md-3 col-sm-6">
                                                    <Form.Item label="Quantity" name="quantity"
                                                               rules={[{required: true, message: 'Missing quantity'}]}
                                                               tooltip="Enter quantity">
                                                        <InputNumber placeholder="Quantity"/>
                                                    </Form.Item>
                                                </div>
                                                <div className="col-md-3 col-sm-6">
                                                    <Form.Item label="Weight" name="weight"
                                                               rules={[{required: true, message: 'Missing weight'}]}
                                                               tooltip="Enter weight">
                                                        <Input placeholder="Weight"
                                                               addonAfter={(<Form.Item name="unit" noStyle>
                                                                   <Select
                                                                       style={{
                                                                           width: 70,
                                                                       }}
                                                                   >
                                                                       {
                                                                           this.state.units.map((item) => {
                                                                               return (<Option key={item.id}
                                                                                               value={item.id}>{item.name}</Option>);
                                                                           })
                                                                       }
                                                                   </Select>
                                                               </Form.Item>)}/>
                                                    </Form.Item>
                                                </div>
                                                <div className="col-md-3 col-sm-6">
                                                    <Form.Item label="Status" name="active"
                                                               tooltip="Uncheck if product is inactive">
                                                        <Checkbox checked={this.state.active}
                                                                  onChange={this.changeStatus}>{this.state.active ? "Active" : "Inactive"}</Checkbox>
                                                    </Form.Item>
                                                </div>
                                                <div className="col-md-3 col-sm-12">
                                                    <Form.Item label="Product image" tooltip="Upload product image">
                                                        <Form.Item name="dragger" valuePropName="fileList"
                                                                   getValueFromEvent={this.normFile}
                                                                   rules={[{
                                                                       required: true,
                                                                       message: 'Missing product image'
                                                                   }]}
                                                                   noStyle>
                                                            <Upload
                                                                action="/api/auth/upload"
                                                                listType="picture-card"
                                                                fileList={this.state.fileList}
                                                                defaultFileList={this.state.fileList}
                                                                onPreview={this.handlePreview}
                                                                onChange={this.handleChange}
                                                            >
                                                                {this.state.fileList.length >= 8 ? null : (
                                                                    <div>
                                                                        <PlusOutlined/>
                                                                        <div style={{marginTop: 8}}>Upload</div>
                                                                    </div>
                                                                )}
                                                            </Upload>
                                                        </Form.Item>
                                                        <Modal
                                                            visible={this.state.previewVisible}
                                                            title={this.state.previewTitle}
                                                            footer={null}
                                                            onCancel={this.handleCancel}
                                                        >
                                                            <img alt="example" style={{width: '100%'}}
                                                                 src={this.state.previewImage}/>
                                                        </Modal>
                                                    </Form.Item>
                                                </div>
                                                <div className="col-md-3 col-sm-6">
                                                    <Form.Item name="feature_type" label="Feature type"
                                                               tooltip="Enter product feature type">
                                                        <Radio.Group>
                                                            <Radio value={1}>Default</Radio>
                                                            <Radio value={2}>New</Radio>
                                                            <Radio value={3}>Recommended</Radio>
                                                        </Radio.Group>
                                                    </Form.Item>
                                                </div>
                                            </div>
                                            <Form.Item>
                                                <Button type="primary" className="btn-success"
                                                        style={{marginTop: '40px'}}
                                                        htmlType="submit">Save</Button>
                                            </Form.Item>
                                        </Form>
                                    </TabPane>
                                    {
                                        this.state.id > 0 && (
                                            <>
                                                <TabPane tab="Characteristics" key="4">
                                                    {
                                                        this.state.characteristics_edit ?
                                                            <CharacteristicsAdd product_id={this.state.id}
                                                                                id={this.state.characteristics_id}
                                                                                onSave={this.onSaveCharacteristics}/> :
                                                            <Characteristics product_id={this.state.id}
                                                                             onEdit={this.onEditCharacteristics}/>
                                                    }
                                                </TabPane>
                                                <TabPane tab="Product extras group" key="2">
                                                    {
                                                        this.state.extras_group_edit ?
                                                            <ExtrasGroupAdd product_id={this.state.id}
                                                                            id={this.state.extra_group_id}
                                                                            onSave={this.onSaveExtrasGroup}/> :
                                                            <ExtrasGroup product_id={this.state.id}
                                                                         onEdit={this.onEditExtrasGroup}/>
                                                    }
                                                </TabPane>
                                                <TabPane tab="Product extras" key="3">
                                                    {
                                                        this.state.extras_edit ?
                                                            <ExtrasAdd product_id={this.state.id}
                                                                       id={this.state.extra_id}
                                                                       onSave={this.onSaveExtras}/> :
                                                            <Extras product_id={this.state.id}
                                                                    onEdit={this.onEditExtras}/>
                                                    }
                                                </TabPane>
                                            </>
                                        )
                                    }
                                </Tabs>) : (
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

export default ProductAdd;
