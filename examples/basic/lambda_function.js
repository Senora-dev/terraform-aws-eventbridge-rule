exports.handler = async (event) => { console.log("Event:", JSON.stringify(event, null, 2)); return { statusCode: 200, body: JSON.stringify("Event processed successfully!") }; };
