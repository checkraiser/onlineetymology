/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

var React = require('react-native');
var {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Image,
  NativeModules,
  TouchableHighlight,
  ListView,
  NavigatorIOS,
  ScrollView,
  TextInput
} = React;

var AdmobTest = React.createClass({
  render: function(){
    return (
      <React.NavigatorIOS
        style={styles.navigator}
        initialRoute={
          {component: EtyList,
            title: 'Etymology'}
        } />
    )
  }
})
var EtyList = React.createClass({
  getInitialState: function(){
    return {user: new ListView.DataSource({
      rowHasChanged:(row1, row2) => row1 != row2}), loaded: false};
  },
  componentDidMount: function(){
    NativeModules.SQLiteManager.initDatabase(this.rowCallback);
  },
  rowCallback: function(row){
    this.setState({user: this.state.user.cloneWithRows(row), loaded: true});
  },
   onPress: function(){
      React.NativeModules.MyViewController.gameOver();
   },
   onPressed: function(item){
    this.props.navigator.push({
      title: item.value,
      component: EtyView,
      passProps: {id: item.key}
    })
   },
   renderItem: function(item, sectionID, rowID){
    return (
      <React.TouchableHighlight underlayColor='#dddddd' onPress={() => this.onPressed(item)}>
        <View>
          <View style={styles.rowContainer}>
            <View style={styles.textContainer}>
              <Text>{item.key}: {item.value}</Text>
            </View>
          </View>
          <View style={styles.separator} />
        </View>
      </React.TouchableHighlight>
      )
   },
  onChangeText: function(text){
    if (text.length >= 2){
      this.setState({loaded: false});
      React.NativeModules.SQLiteManager.filter(text, this.onFilter);
    }
    
  },
  onFilter: function(result){
    this.setState({user: this.state.user.cloneWithRows(result), loaded: true});
  },
  render: function() {
    if (!this.state.loaded) {
      return <LoadingView />;
    }
    return (
      <View style={{flex: 1}}>
        <React.ScrollView scrollEventThrottle={500} contentInset={{top: -100}}
          style={styles.scrollView}>
            <React.ListView dataSource={this.state.user}
            renderRow = {this.renderItem}
            style={styles.listView} />
          </React.ScrollView>
      </View>);
  }});
var LoadingView = React.createClass({
  render: function(){
    return (
      <View style={styles.container}>
        <Text>Loading ety...</Text>
      </View>
    )
  }
});
var EtyView = React.createClass({
  getInitialState: function(){
    return {definition: "", loaded: false}
  },
  fetchData: function(id){
    NativeModules.SQLiteManager.fetchDefinition(id, this.definitionCallback);
  },
  definitionCallback: function(definition){
    this.setState({definition: definition[0], loaded: true});
  },
  componentDidMount: function(){
    this.fetchData(this.props.id);
  },
  render: function(){
    if (!this.state.loaded){
      return <LoadingView />
    }
    return (
      <View style={styles.wrapText}>
        <TextInput placeholder='test' />
        <Text>{this.state.definition}</Text>
      </View>
    )
  }
});
var styles = StyleSheet.create({
  scrollView: {
    backgroundColor: '#6A85B1',
    height: 300,
    marginTop: 70
  },
  separator: {
    height: 1,
    backgroundColor: '#DDDDDD'
  },
  textContainer: {
    flex: 1
  },
  rowContainer: {
    flexDirection: 'row',
    padding: 10
  },
  navigator: {
    flex: 1
  },
  wrapText: {
    marginTop: 65,
    padding: 10,
    flexWrap: 'wrap'
  },
  container: {
    padding: 10,
    marginTop: 65,
    flex: 1,
    flexDirection: 'row',
   // justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
  },

  instructions: {
    textAlign: 'center',
    color: '#333333',
  },
  listView: {
    backgroundColor: '#FFFFFF'
  },
  name: {
    fontSize: 12,
    textAlign: 'left',
    color: '#656565'
  }
});

AppRegistry.registerComponent('AdmobTest', () => AdmobTest);
