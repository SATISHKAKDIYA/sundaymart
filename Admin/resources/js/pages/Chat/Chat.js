import React from 'react';
import PageLayout from "../../layouts/PageLayout";
import {Breadcrumb, Layout, PageHeader} from "antd";

const {Content} = Layout;

class Chat extends React.Component {
    render() {
        return (
            <PageLayout>
                <PageHeader
                    style={{margin: '16px 0'}}
                    className="site-page-header"
                >
                    <Content
                        className="site-layout-background">
                        <div className="row">
                            <div className="col-lg-4 col-md-4 border-right">
                                <h5>My chats</h5>
                            </div>
                            <div className="col-lg-8 col-md-8">
                                <div style={{minHeight: '80vh'}}>

                                </div>
                            </div>
                        </div>
                    </Content>
                </PageHeader>
            </PageLayout>
        );
    }
}

export default Chat;
