import React from 'react';
import PageLayout from "../../../layouts/PageLayout";
import {
    Breadcrumb,
    Button,
    Layout,
    Table,
    PageHeader,
    Input,
    message
} from "antd";

const {Content} = Layout;
import reqwest from 'reqwest';
import appLanguageSave from "../../../requests/AppLanguage/AppLanguageSave";

class AppLanguageAdd extends React.Component {
    columns = [
        {
            title: 'Word',
            dataIndex: 'word',
        },
        {
            title: 'Translation',
            dataIndex: 'translation',
            render: (translation, row) => {
                return (
                    <Input placeholder="Translation" defaultValue={translation}
                           onChange={(e) => this.onChangeInput(e, row.id)}/>
                );
            }
        },
        {
            title: 'Options',
            dataIndex: 'options',
            render: (options, row) => {
                return (<Button type="link" className="text-success" onClick={() => this.onClickSave(row.id)}>
                    Save
                </Button>);
            },
        },
    ];

    constructor(props) {
        super(props);

        this.state = {
            data: [],
            pagination: {
                current: 1,
                pageSize: 10,
            },
            translations: {},
            reload: false,
            id: props.location.state ? props.location.state.id : 0,
            name: props.location.state ? props.location.state.name : ""
        };

        this.handleTableChange = this.handleTableChange.bind(this);
        this.onChangeInput = this.onChangeInput.bind(this);
        this.onClickSave = this.onClickSave.bind(this);
    }

    componentDidMount() {
        const {pagination} = this.state;
        this.fetch({pagination});
    }

    onChangeInput = (e, id) => {
        var translations = this.state.translations;
        translations[id] = e.target.value;

        this.setState({
            translations: translations
        });
    }

    onClickSave = async (id) => {
        var data = await appLanguageSave(this.state.id, this.state.translations[id], id);

        if(data.data.success == 1)
            message.success("Successfully saved");

        this.setState({
            reload: !this.state.reload
        });
    }

    fetch = (params = {}) => {
        const token = localStorage.getItem('jwt_token');
        this.setState({loading: true});
        reqwest({
            url: '/api/auth/app-language/datatableWord',
            method: 'post',
            type: 'json',
            headers: {
                "Authorization": "Bearer " + token
            },
            data: {
                id_lang: this.state.id,
                length: params.pagination.pageSize,
                start: (params.pagination.current - 1) * params.pagination.pageSize,
            },
        }).then(data => {
            this.setState({
                loading: false,
                data: data.data,
                pagination: {
                    current: params.pagination.current,
                    pageSize: 10,
                    total: data.total,
                },
            });
        });
    };

    handleTableChange = (pagination, filters, sorter) => {
        this.fetch({
            sortField: sorter.field,
            sortOrder: sorter.order,
            pagination,
            ...filters,
        });

        this.setState({pagination});
    };

    render() {
        const {data, pagination, loading} = this.state;

        return (
            <PageLayout>
                <Breadcrumb style={{margin: '16px 0'}}>
                    <Breadcrumb.Item>App languages</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    className="site-page-header"
                    title={this.state.name}
                >
                    <Content
                        className="site-layout-background">
                        <Table
                            columns={this.columns}
                            rowKey={record => record.id}
                            dataSource={data}
                            pagination={pagination}
                            loading={loading}
                            onChange={this.handleTableChange}
                        />
                    </Content>
                </PageHeader>
            </PageLayout>
        );
    }
}

export default AppLanguageAdd;
