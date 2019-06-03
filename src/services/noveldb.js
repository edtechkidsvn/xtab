import PouchDB from 'pouchdb';

const db = new PouchDB('novels-db');

export default db;