import React from 'react';
import PageLayout from "../../../layouts/PageLayout";
import {Breadcrumb, Button, Layout, Table, Space, PageHeader, Image, Checkbox, Tag, Popconfirm} from "antd";
import {Link} from 'react-router-dom';

const {Content} = Layout;
import reqwest from 'reqwest';
import {CheckCircleOutlined, CloseCircleOutlined} from "@ant-design/icons";
import {isAllowed} from "../../../helpers/IsAllowed";

class AppLanguage extends React.Component {
    columns = [
        {
            title: 'Language',
            dataIndex: 'language',
        },
        {
            title: 'Translation percentage',
            dataIndex: 'percentage',
        },
        {
            title: 'Options',
            dataIndex: 'options',
            render: (options, row) => {
                return (<div>
                    {
                        options.edit && isAllowed("/app-language/edit") && (
                            <Button type="link">
                                <Link to={{
                                    pathname: "/app-language/edit",
                                    state: {id: row.id, edit: true, name: row.language}
                                }} className="nav-text">Edit</Link>
                            </Button>
                        )
                    }
                </div>);
            },
        },
    ];

    state = {
        data: [],
        pagination: {
            current: 1,
            pageSize: 10,
        },
    };

    componentDidMount() {
        const {pagination} = this.state;
        this.fetch({pagination});
    }

    fetch = (params = {}) => {
        const token = localStorage.getItem('jwt_token');
        this.setState({loading: true});
        reqwest({
            url: '/api/auth/app-language/datatable',
            method: 'post',
            type: 'json',
            headers: {
                "Authorization": "Bearer " + token
            },
            data: {
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

    render() {
        const {data, pagination, loading} = this.state;

        return (
            <PageLayout>
                <Breadcrumb style={{margin: '16px 0'}}>
                    <Breadcrumb.Item>App languages</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    className="site-page-header"
                    title="App languages"
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

export default AppLanguage;
