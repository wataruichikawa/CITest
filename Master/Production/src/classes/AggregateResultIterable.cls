global class AggregateResultIterable implements Iterable<AggregateResult> {
    global String query;

    global Iterator<AggregateResult> Iterator(){
        return new AggregateResultIterator(query);
    }
}