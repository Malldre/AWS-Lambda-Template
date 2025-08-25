export const handler = async (event: any = {}): Promise<any> => {
    return {
        statusCode: 200,
        body: JSON.stringify({
            message: 'Order created successfully!',
        }),
    };
}

