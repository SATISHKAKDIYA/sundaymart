import React from 'react';
import {Breadcrumb, Button, Checkbox, Form, Input, Layout, Modal, PageHeader, Radio, Select, Spin, Upload} from "antd";
import {Link} from "react-router-dom";
import PageLayout from "../../layouts/PageLayout";
import unitSave from "../../requests/Units/UnitSave";
import unitGet from "../../requests/Units/UnitGet";
import languageActive from "../../requests/Language/LanguageActive";

const {Content} = Layout;

class UnitAdd extends React.Component {
    formRef = React.createRef();

    constructor(props) {
        super(props);

        this.state = {
            active: true,
            language: "en",
            languages: [],
            names: {},
            id: props.location.state ? props.location.state.id : 0,
            edit: props.location.state ? props.location.state.edit : false
        };

        this.getActiveLanguages = this.getActiveLanguages.bind(this);
        this.onChangeName = this.onChangeName.bind(this);
        this.onChangeLanguage = this.onChangeLanguage.bind(this);

        this.getActiveLanguages();

        if (this.state.edit)
            this.getInfoById(this.state.id);
    }

    getActiveLanguages = async () => {
        let data = await languageActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                languages: data.data.data,
                language: data.data.data[0].short_name
            });

            var namesArray = this.state.names;

            for (let i = 0; i < data.data.data.length; i++) {
                var lang = data.data.data[i].short_name;
                namesArray[lang] = "";
            }

            this.setState({
                names: namesArray
            });
        }
    }

    getInfoById = async (id) => {
        let data = await unitGet(id);
        if (data.data.success) {
            let units = data.data.data.units;
            let units_language = data.data.data.units_language;

            var namesArray = this.state.names;
            for (let i = 0; i < units_language.length; i++) {
                var lang = units_language[i].short_name;
                namesArray[lang] = units_language[i].name;
            }

            this.setState({
                active: units.active == 1 ? true : false,
                names: namesArray,
            });

            this.formRef.current.setFieldsValue({
                name: namesArray[this.state.language],
            });
        }
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
            name: this.state.names[lang]
        });
    };

    changeStatus = (e) => {
        this.setState({
            active: e.target.checked
        });
    }

    onFinish = async (values) => {
        let data = await unitSave(this.state.names, this.state.active, this.state.id);

        if (data.data.success == 1)
            window.history.back();
    };

    onFinishFailed = (errorInfo) => {
    };

    render() {
        return (
            <PageLayout>
                <Breadcrumb style={{margin: '16px 0'}}>
                    <Breadcrumb.Item><Link to="/units" className="nav-text">Units</Link></Breadcrumb.Item>
                    <Breadcrumb.Item>{this.state.edit ? "Edit" : "Add"}</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    onBack={() => window.history.back()}
                    className="site-page-header"
                    title={this.state.edit ? "Unit Edit" : "Unit Add"}
                >
                    <Content
                        className="site-layout-background padding-20">
                        {
                            (this.state.languages.length > 0) ? (<Form
                                ref={this.formRef}
                                name="basic"
                                initialValues={{}}
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
                                                   rules={[{required: true, message: 'Missing unit name'}]}
                                                   tooltip="Enter unit name">
                                            <Input placeholder="Name"
                                                   onChange={this.onChangeName}/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Status" name="active"
                                                   tooltip="Uncheck if unit is inactive">
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

export default UnitAdd;
