import React from 'react';
import PageLayout from "../../layouts/PageLayout";
import {Breadcrumb, Button, Layout, Table, Space, PageHeader, Image, Checkbox, Tag, Popconfirm} from "antd";
import {Link} from 'react-router-dom';

const {Content} = Layout;
import reqwest from 'reqwest';
import {CheckCircleOutlined, CloseCircleOutlined} from "@ant-design/icons";
import brandsCategoryDelete from "../../requests/BrandCategories/BrandsCategoryDelete";
import {isAllowed} from "../../helpers/IsAllowed";

class BrandsCategories extends React.Component {
    columns = [
        {
            title: 'Name',
            dataIndex: 'name',
        },
        {
            title: 'Active',
            dataIndex: 'active',
            render: (active) => {
                if (active == 1)
                    return (<Tag icon={<CheckCircleOutlined/>} color="success">
                        Active
                    </Tag>);
                else
                    return (<Tag icon={<CloseCircleOutlined/>} color="error">
                        Inactive
                    </Tag>);
            },
        },
        {
            title: 'Options',
            dataIndex: 'options',
            render: (options, row) => {
                return (<div>
                    {
                        options.edit && isAllowed("/brands-categories/edit") && (
                            <Button type="link">
                                <Link to={{
                                    pathname: "/brands-categories/edit",
                                    state: {id: row.id, edit: true}
                                }} className="nav-text">Edit</Link>
                            </Button>
                        )
                    }
                    {
                        options.delete && isAllowed("/brands-categories/delete") && row.default != 1 && (<Popconfirm
                            title="Do you want to delete ?"
                            visible={this.state.visible}
                            onConfirm={() => this.handleOk(row.id)}
                            okButtonProps={{loading: this.state.confirmLoading}}
                            onCancel={this.handleCancel}
                        >
                            <Button type="link" className="text-danger" onClick={this.showPopconfirm}>
                                Delete
                            </Button>
                        </Popconfirm>)
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
        loading: false,
        visibleConfirm: false,
        confirmLoading: false
    };

    componentDidMount() {
        const {pagination} = this.state;
        this.fetch({pagination});
    }

    handleOk = async (id) => {
        this.setState({
            confirmLoading: true
        });

        let data = await brandsCategoryDelete(id);

        if (data.data.success == 1) {
            this.setState({
                confirmLoading: false,
                visibleConfirm: false
            });
        }

        const {pagination} = this.state;
        this.fetch({pagination});
    };

    handleCancel = () => {
        this.setState({
            visibleConfirm: false
        })
    };

    showPopconfirm = () => {
        this.setState({
            visibleConfirm: true
        })
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

    fetch = (params = {}) => {
        const token = localStorage.getItem('jwt_token');
        this.setState({loading: true});
        reqwest({
            url: '/api/auth/brand-category/datatable',
            method: 'post',
            type: 'json',
            headers: {
                "Authorization": "Bearer " + token
            },
            data: {
                length: this.state.pagination.pageSize,
                start: (this.state.pagination.current - 1) * this.state.pagination.pageSize,
            },
        }).then(data => {
            this.setState({
                loading: false,
                data: data.data,
                pagination: {
                    current: this.state.current,
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
                    <Breadcrumb.Item>Brands categories</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    className="site-page-header"
                    title="Brands categories"
                    subTitle="Create, remove and edit brand categories"
                    extra={isAllowed("/brands-categories/add") && [
                        <Link to="/brands-categories/add" key="add" className="btn btn-success">
                            Add Brands category
                        </Link>
                    ]}
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

export default BrandsCategories;
