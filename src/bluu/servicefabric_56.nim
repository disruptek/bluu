
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Service Fabric Client APIs
## version: 5.6.*
## termsOfService: (not provided)
## license: (not provided)
## 
## Service Fabric REST Client APIs allows management of Service Fabric clusters, applications and services.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_563564 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563564](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563564): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "servicefabric"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GetAadMetadata_563786 = ref object of OpenApiRestCall_563564
proc url_GetAadMetadata_563788(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetAadMetadata_563787(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets the Azure Active Directory metadata used for secured connection to cluster.
  ## This API is not supposed to be called separately. It provides information needed to set up an Azure Active Directory secured connection with a Service Fabric cluster.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "1.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563962 = query.getOrDefault("api-version")
  valid_563962 = validateParameter(valid_563962, JString, required = true,
                                 default = newJString("1.0"))
  if valid_563962 != nil:
    section.add "api-version", valid_563962
  var valid_563964 = query.getOrDefault("timeout")
  valid_563964 = validateParameter(valid_563964, JInt, required = false,
                                 default = newJInt(60))
  if valid_563964 != nil:
    section.add "timeout", valid_563964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563987: Call_GetAadMetadata_563786; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Azure Active Directory metadata used for secured connection to cluster.
  ## This API is not supposed to be called separately. It provides information needed to set up an Azure Active Directory secured connection with a Service Fabric cluster.
  ## 
  ## 
  let valid = call_563987.validator(path, query, header, formData, body)
  let scheme = call_563987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563987.url(scheme.get, call_563987.host, call_563987.base,
                         call_563987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563987, url, valid)

proc call*(call_564058: Call_GetAadMetadata_563786; apiVersion: string = "1.0";
          timeout: int = 60): Recallable =
  ## getAadMetadata
  ## Gets the Azure Active Directory metadata used for secured connection to cluster.
  ## This API is not supposed to be called separately. It provides information needed to set up an Azure Active Directory secured connection with a Service Fabric cluster.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "1.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  var query_564059 = newJObject()
  add(query_564059, "api-version", newJString(apiVersion))
  add(query_564059, "timeout", newJInt(timeout))
  result = call_564058.call(nil, query_564059, nil, nil, nil)

var getAadMetadata* = Call_GetAadMetadata_563786(name: "getAadMetadata",
    meth: HttpMethod.HttpGet, host: "azure.local:19080", route: "/$/GetAadMetadata",
    validator: validate_GetAadMetadata_563787, base: "", url: url_GetAadMetadata_563788,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetClusterHealthUsingPolicy_564110 = ref object of OpenApiRestCall_563564
proc url_GetClusterHealthUsingPolicy_564112(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetClusterHealthUsingPolicy_564111(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the health of a Service Fabric cluster.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the cluster based on the health state.
  ## Similarly, use NodesHealthStateFilter and ApplicationsHealthStateFilter to filter the collection of nodes and applications returned based on their aggregated health state.
  ## Use ClusterHealthPolicies to override the health policies used to evaluate the health.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationsHealthStateFilter: JInt
  ##                                : Allows filtering of the application health state objects returned in the result of cluster health
  ## query based on their health state.
  ## The possible values for this parameter include integer value obtained from members or bitwise operations
  ## on members of HealthStateFilter enumeration. Only applications that match the filter are returned.
  ## All applications are used to evaluate the aggregated health state. If not specified, all entries are returned.
  ## The state values are flag based enumeration, so the value could be a combination of these values obtained using bitwise 'OR' operator.
  ## For example, if the provided value is 6 then health state of applications with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   EventsHealthStateFilter: JInt
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   NodesHealthStateFilter: JInt
  ##                         : Allows filtering of the node health state objects returned in the result of cluster health query
  ## based on their health state. The possible values for this parameter include integer value of one of the
  ## following health states. Only nodes that match the filter are returned. All nodes are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned.
  ## The state values are flag based enumeration, so the value could be a combination of these values obtained using bitwise 'OR' operator.
  ## For example, if the provided value is 6 then health state of nodes with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564130 = query.getOrDefault("api-version")
  valid_564130 = validateParameter(valid_564130, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564130 != nil:
    section.add "api-version", valid_564130
  var valid_564131 = query.getOrDefault("ApplicationsHealthStateFilter")
  valid_564131 = validateParameter(valid_564131, JInt, required = false,
                                 default = newJInt(0))
  if valid_564131 != nil:
    section.add "ApplicationsHealthStateFilter", valid_564131
  var valid_564132 = query.getOrDefault("timeout")
  valid_564132 = validateParameter(valid_564132, JInt, required = false,
                                 default = newJInt(60))
  if valid_564132 != nil:
    section.add "timeout", valid_564132
  var valid_564133 = query.getOrDefault("EventsHealthStateFilter")
  valid_564133 = validateParameter(valid_564133, JInt, required = false,
                                 default = newJInt(0))
  if valid_564133 != nil:
    section.add "EventsHealthStateFilter", valid_564133
  var valid_564134 = query.getOrDefault("NodesHealthStateFilter")
  valid_564134 = validateParameter(valid_564134, JInt, required = false,
                                 default = newJInt(0))
  if valid_564134 != nil:
    section.add "NodesHealthStateFilter", valid_564134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ClusterHealthPolicies: JObject
  ##                        : Describes the health policies used to evaluate the cluster health.
  ## If not present, the health evaluation uses the cluster health policy defined in the cluster manifest or the default cluster health policy.
  ## By default, each application is evaluated using its specific application health policy, defined in the application manifest, or the default health policy, if no policy is defined in manifest.
  ## If the application health policy map is specified, and it has an entry for an application, the specified application health policy
  ## is used to evaluate the application health.
  ## 
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564136: Call_GetClusterHealthUsingPolicy_564110; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric cluster.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the cluster based on the health state.
  ## Similarly, use NodesHealthStateFilter and ApplicationsHealthStateFilter to filter the collection of nodes and applications returned based on their aggregated health state.
  ## Use ClusterHealthPolicies to override the health policies used to evaluate the health.
  ## 
  ## 
  let valid = call_564136.validator(path, query, header, formData, body)
  let scheme = call_564136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564136.url(scheme.get, call_564136.host, call_564136.base,
                         call_564136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564136, url, valid)

proc call*(call_564137: Call_GetClusterHealthUsingPolicy_564110;
          ClusterHealthPolicies: JsonNode = nil; apiVersion: string = "3.0";
          ApplicationsHealthStateFilter: int = 0; timeout: int = 60;
          EventsHealthStateFilter: int = 0; NodesHealthStateFilter: int = 0): Recallable =
  ## getClusterHealthUsingPolicy
  ## Gets the health of a Service Fabric cluster.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the cluster based on the health state.
  ## Similarly, use NodesHealthStateFilter and ApplicationsHealthStateFilter to filter the collection of nodes and applications returned based on their aggregated health state.
  ## Use ClusterHealthPolicies to override the health policies used to evaluate the health.
  ## 
  ##   ClusterHealthPolicies: JObject
  ##                        : Describes the health policies used to evaluate the cluster health.
  ## If not present, the health evaluation uses the cluster health policy defined in the cluster manifest or the default cluster health policy.
  ## By default, each application is evaluated using its specific application health policy, defined in the application manifest, or the default health policy, if no policy is defined in manifest.
  ## If the application health policy map is specified, and it has an entry for an application, the specified application health policy
  ## is used to evaluate the application health.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationsHealthStateFilter: int
  ##                                : Allows filtering of the application health state objects returned in the result of cluster health
  ## query based on their health state.
  ## The possible values for this parameter include integer value obtained from members or bitwise operations
  ## on members of HealthStateFilter enumeration. Only applications that match the filter are returned.
  ## All applications are used to evaluate the aggregated health state. If not specified, all entries are returned.
  ## The state values are flag based enumeration, so the value could be a combination of these values obtained using bitwise 'OR' operator.
  ## For example, if the provided value is 6 then health state of applications with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   EventsHealthStateFilter: int
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   NodesHealthStateFilter: int
  ##                         : Allows filtering of the node health state objects returned in the result of cluster health query
  ## based on their health state. The possible values for this parameter include integer value of one of the
  ## following health states. Only nodes that match the filter are returned. All nodes are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned.
  ## The state values are flag based enumeration, so the value could be a combination of these values obtained using bitwise 'OR' operator.
  ## For example, if the provided value is 6 then health state of nodes with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  var query_564138 = newJObject()
  var body_564139 = newJObject()
  if ClusterHealthPolicies != nil:
    body_564139 = ClusterHealthPolicies
  add(query_564138, "api-version", newJString(apiVersion))
  add(query_564138, "ApplicationsHealthStateFilter",
      newJInt(ApplicationsHealthStateFilter))
  add(query_564138, "timeout", newJInt(timeout))
  add(query_564138, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(query_564138, "NodesHealthStateFilter", newJInt(NodesHealthStateFilter))
  result = call_564137.call(nil, query_564138, nil, nil, body_564139)

var getClusterHealthUsingPolicy* = Call_GetClusterHealthUsingPolicy_564110(
    name: "getClusterHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/GetClusterHealth",
    validator: validate_GetClusterHealthUsingPolicy_564111, base: "",
    url: url_GetClusterHealthUsingPolicy_564112,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetClusterHealth_564099 = ref object of OpenApiRestCall_563564
proc url_GetClusterHealth_564101(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetClusterHealth_564100(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the health of a Service Fabric cluster.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the cluster based on the health state.
  ## Similarly, use NodesHealthStateFilter and ApplicationsHealthStateFilter to filter the collection of nodes and applications returned based on their aggregated health state.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationsHealthStateFilter: JInt
  ##                                : Allows filtering of the application health state objects returned in the result of cluster health
  ## query based on their health state.
  ## The possible values for this parameter include integer value obtained from members or bitwise operations
  ## on members of HealthStateFilter enumeration. Only applications that match the filter are returned.
  ## All applications are used to evaluate the aggregated health state. If not specified, all entries are returned.
  ## The state values are flag based enumeration, so the value could be a combination of these values obtained using bitwise 'OR' operator.
  ## For example, if the provided value is 6 then health state of applications with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   EventsHealthStateFilter: JInt
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   NodesHealthStateFilter: JInt
  ##                         : Allows filtering of the node health state objects returned in the result of cluster health query
  ## based on their health state. The possible values for this parameter include integer value of one of the
  ## following health states. Only nodes that match the filter are returned. All nodes are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned.
  ## The state values are flag based enumeration, so the value could be a combination of these values obtained using bitwise 'OR' operator.
  ## For example, if the provided value is 6 then health state of nodes with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564102 = query.getOrDefault("api-version")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564102 != nil:
    section.add "api-version", valid_564102
  var valid_564103 = query.getOrDefault("ApplicationsHealthStateFilter")
  valid_564103 = validateParameter(valid_564103, JInt, required = false,
                                 default = newJInt(0))
  if valid_564103 != nil:
    section.add "ApplicationsHealthStateFilter", valid_564103
  var valid_564104 = query.getOrDefault("timeout")
  valid_564104 = validateParameter(valid_564104, JInt, required = false,
                                 default = newJInt(60))
  if valid_564104 != nil:
    section.add "timeout", valid_564104
  var valid_564105 = query.getOrDefault("EventsHealthStateFilter")
  valid_564105 = validateParameter(valid_564105, JInt, required = false,
                                 default = newJInt(0))
  if valid_564105 != nil:
    section.add "EventsHealthStateFilter", valid_564105
  var valid_564106 = query.getOrDefault("NodesHealthStateFilter")
  valid_564106 = validateParameter(valid_564106, JInt, required = false,
                                 default = newJInt(0))
  if valid_564106 != nil:
    section.add "NodesHealthStateFilter", valid_564106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564107: Call_GetClusterHealth_564099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric cluster.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the cluster based on the health state.
  ## Similarly, use NodesHealthStateFilter and ApplicationsHealthStateFilter to filter the collection of nodes and applications returned based on their aggregated health state.
  ## 
  ## 
  let valid = call_564107.validator(path, query, header, formData, body)
  let scheme = call_564107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564107.url(scheme.get, call_564107.host, call_564107.base,
                         call_564107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564107, url, valid)

proc call*(call_564108: Call_GetClusterHealth_564099; apiVersion: string = "3.0";
          ApplicationsHealthStateFilter: int = 0; timeout: int = 60;
          EventsHealthStateFilter: int = 0; NodesHealthStateFilter: int = 0): Recallable =
  ## getClusterHealth
  ## Gets the health of a Service Fabric cluster.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the cluster based on the health state.
  ## Similarly, use NodesHealthStateFilter and ApplicationsHealthStateFilter to filter the collection of nodes and applications returned based on their aggregated health state.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationsHealthStateFilter: int
  ##                                : Allows filtering of the application health state objects returned in the result of cluster health
  ## query based on their health state.
  ## The possible values for this parameter include integer value obtained from members or bitwise operations
  ## on members of HealthStateFilter enumeration. Only applications that match the filter are returned.
  ## All applications are used to evaluate the aggregated health state. If not specified, all entries are returned.
  ## The state values are flag based enumeration, so the value could be a combination of these values obtained using bitwise 'OR' operator.
  ## For example, if the provided value is 6 then health state of applications with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   EventsHealthStateFilter: int
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   NodesHealthStateFilter: int
  ##                         : Allows filtering of the node health state objects returned in the result of cluster health query
  ## based on their health state. The possible values for this parameter include integer value of one of the
  ## following health states. Only nodes that match the filter are returned. All nodes are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned.
  ## The state values are flag based enumeration, so the value could be a combination of these values obtained using bitwise 'OR' operator.
  ## For example, if the provided value is 6 then health state of nodes with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  var query_564109 = newJObject()
  add(query_564109, "api-version", newJString(apiVersion))
  add(query_564109, "ApplicationsHealthStateFilter",
      newJInt(ApplicationsHealthStateFilter))
  add(query_564109, "timeout", newJInt(timeout))
  add(query_564109, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(query_564109, "NodesHealthStateFilter", newJInt(NodesHealthStateFilter))
  result = call_564108.call(nil, query_564109, nil, nil, nil)

var getClusterHealth* = Call_GetClusterHealth_564099(name: "getClusterHealth",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/$/GetClusterHealth", validator: validate_GetClusterHealth_564100,
    base: "", url: url_GetClusterHealth_564101, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_564148 = ref object of OpenApiRestCall_563564
proc url_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_564150(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_564149(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the health of a Service Fabric cluster using health chunks. The health evaluation is done based on the input cluster health chunk query description.
  ## The query description allows users to specify health policies for evaluating the cluster and its children.
  ## Users can specify very flexible filters to select which cluster entities to return. The selection can be done based on the entities health state and based on the hierarchy.
  ## The query can return multi-level children of the entities based on the specified filters. For example, it can return one application with a specified name, and for this application, return
  ## only services that are in Error or Warning, and all partitions and replicas for one of these services.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564151 = query.getOrDefault("api-version")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564151 != nil:
    section.add "api-version", valid_564151
  var valid_564152 = query.getOrDefault("timeout")
  valid_564152 = validateParameter(valid_564152, JInt, required = false,
                                 default = newJInt(60))
  if valid_564152 != nil:
    section.add "timeout", valid_564152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ClusterHealthChunkQueryDescription: JObject
  ##                                     : Describes the cluster and application health policies used to evaluate the cluster health and the filters to select which cluster entities to be returned.
  ## If the cluster health policy is present, it is used to evaluate the cluster events and the cluster nodes. If not present, the health evaluation uses the cluster health policy defined in the cluster manifest or the default cluster health policy.
  ## By default, each application is evaluated using its specific application health policy, defined in the application manifest, or the default health policy, if no policy is defined in manifest.
  ## If the application health policy map is specified, and it has an entry for an application, the specified application health policy
  ## is used to evaluate the application health.
  ## Users can specify very flexible filters to select which cluster entities to include in response. The selection can be done based on the entities health state and based on the hierarchy.
  ## The query can return multi-level children of the entities based on the specified filters. For example, it can return one application with a specified name, and for this application, return
  ## only services that are in Error or Warning, and all partitions and replicas for one of these services.
  ## 
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564154: Call_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_564148;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric cluster using health chunks. The health evaluation is done based on the input cluster health chunk query description.
  ## The query description allows users to specify health policies for evaluating the cluster and its children.
  ## Users can specify very flexible filters to select which cluster entities to return. The selection can be done based on the entities health state and based on the hierarchy.
  ## The query can return multi-level children of the entities based on the specified filters. For example, it can return one application with a specified name, and for this application, return
  ## only services that are in Error or Warning, and all partitions and replicas for one of these services.
  ## 
  ## 
  let valid = call_564154.validator(path, query, header, formData, body)
  let scheme = call_564154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564154.url(scheme.get, call_564154.host, call_564154.base,
                         call_564154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564154, url, valid)

proc call*(call_564155: Call_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_564148;
          apiVersion: string = "3.0";
          ClusterHealthChunkQueryDescription: JsonNode = nil; timeout: int = 60): Recallable =
  ## getClusterHealthChunkUsingPolicyAndAdvancedFilters
  ## Gets the health of a Service Fabric cluster using health chunks. The health evaluation is done based on the input cluster health chunk query description.
  ## The query description allows users to specify health policies for evaluating the cluster and its children.
  ## Users can specify very flexible filters to select which cluster entities to return. The selection can be done based on the entities health state and based on the hierarchy.
  ## The query can return multi-level children of the entities based on the specified filters. For example, it can return one application with a specified name, and for this application, return
  ## only services that are in Error or Warning, and all partitions and replicas for one of these services.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ClusterHealthChunkQueryDescription: JObject
  ##                                     : Describes the cluster and application health policies used to evaluate the cluster health and the filters to select which cluster entities to be returned.
  ## If the cluster health policy is present, it is used to evaluate the cluster events and the cluster nodes. If not present, the health evaluation uses the cluster health policy defined in the cluster manifest or the default cluster health policy.
  ## By default, each application is evaluated using its specific application health policy, defined in the application manifest, or the default health policy, if no policy is defined in manifest.
  ## If the application health policy map is specified, and it has an entry for an application, the specified application health policy
  ## is used to evaluate the application health.
  ## Users can specify very flexible filters to select which cluster entities to include in response. The selection can be done based on the entities health state and based on the hierarchy.
  ## The query can return multi-level children of the entities based on the specified filters. For example, it can return one application with a specified name, and for this application, return
  ## only services that are in Error or Warning, and all partitions and replicas for one of these services.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  var query_564156 = newJObject()
  var body_564157 = newJObject()
  add(query_564156, "api-version", newJString(apiVersion))
  if ClusterHealthChunkQueryDescription != nil:
    body_564157 = ClusterHealthChunkQueryDescription
  add(query_564156, "timeout", newJInt(timeout))
  result = call_564155.call(nil, query_564156, nil, nil, body_564157)

var getClusterHealthChunkUsingPolicyAndAdvancedFilters* = Call_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_564148(
    name: "getClusterHealthChunkUsingPolicyAndAdvancedFilters",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/$/GetClusterHealthChunk",
    validator: validate_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_564149,
    base: "", url: url_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_564150,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetClusterHealthChunk_564140 = ref object of OpenApiRestCall_563564
proc url_GetClusterHealthChunk_564142(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetClusterHealthChunk_564141(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the health of a Service Fabric cluster using health chunks. Includes the aggregated health state of the cluster, but none of the cluster entities.
  ## To expand the cluster health and get the health state of all or some of the entities, use the POST URI and specify the cluster health chunk query description.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564143 = query.getOrDefault("api-version")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564143 != nil:
    section.add "api-version", valid_564143
  var valid_564144 = query.getOrDefault("timeout")
  valid_564144 = validateParameter(valid_564144, JInt, required = false,
                                 default = newJInt(60))
  if valid_564144 != nil:
    section.add "timeout", valid_564144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564145: Call_GetClusterHealthChunk_564140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric cluster using health chunks. Includes the aggregated health state of the cluster, but none of the cluster entities.
  ## To expand the cluster health and get the health state of all or some of the entities, use the POST URI and specify the cluster health chunk query description.
  ## 
  ## 
  let valid = call_564145.validator(path, query, header, formData, body)
  let scheme = call_564145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564145.url(scheme.get, call_564145.host, call_564145.base,
                         call_564145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564145, url, valid)

proc call*(call_564146: Call_GetClusterHealthChunk_564140;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getClusterHealthChunk
  ## Gets the health of a Service Fabric cluster using health chunks. Includes the aggregated health state of the cluster, but none of the cluster entities.
  ## To expand the cluster health and get the health state of all or some of the entities, use the POST URI and specify the cluster health chunk query description.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  var query_564147 = newJObject()
  add(query_564147, "api-version", newJString(apiVersion))
  add(query_564147, "timeout", newJInt(timeout))
  result = call_564146.call(nil, query_564147, nil, nil, nil)

var getClusterHealthChunk* = Call_GetClusterHealthChunk_564140(
    name: "getClusterHealthChunk", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetClusterHealthChunk",
    validator: validate_GetClusterHealthChunk_564141, base: "",
    url: url_GetClusterHealthChunk_564142, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetClusterManifest_564158 = ref object of OpenApiRestCall_563564
proc url_GetClusterManifest_564160(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetClusterManifest_564159(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the Service Fabric cluster manifest. The cluster manifest contains properties of the cluster that include different node types on the cluster,
  ## security configurations, fault and upgrade domain topologies etc.
  ## 
  ## These properties are specified as part of the ClusterConfig.JSON file while deploying a stand alone cluster. However, most of the information in the cluster manifest
  ## is generated internally by service fabric during cluster deployment in other deployment scenarios (for e.g when using azuer portal).
  ## 
  ## The contents of the cluster manifest are for informational purposes only and users are not expected to take a dependency on the format of the file contents or its interpretation.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564161 = query.getOrDefault("api-version")
  valid_564161 = validateParameter(valid_564161, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564161 != nil:
    section.add "api-version", valid_564161
  var valid_564162 = query.getOrDefault("timeout")
  valid_564162 = validateParameter(valid_564162, JInt, required = false,
                                 default = newJInt(60))
  if valid_564162 != nil:
    section.add "timeout", valid_564162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564163: Call_GetClusterManifest_564158; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the Service Fabric cluster manifest. The cluster manifest contains properties of the cluster that include different node types on the cluster,
  ## security configurations, fault and upgrade domain topologies etc.
  ## 
  ## These properties are specified as part of the ClusterConfig.JSON file while deploying a stand alone cluster. However, most of the information in the cluster manifest
  ## is generated internally by service fabric during cluster deployment in other deployment scenarios (for e.g when using azuer portal).
  ## 
  ## The contents of the cluster manifest are for informational purposes only and users are not expected to take a dependency on the format of the file contents or its interpretation.
  ## 
  ## 
  let valid = call_564163.validator(path, query, header, formData, body)
  let scheme = call_564163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564163.url(scheme.get, call_564163.host, call_564163.base,
                         call_564163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564163, url, valid)

proc call*(call_564164: Call_GetClusterManifest_564158; apiVersion: string = "3.0";
          timeout: int = 60): Recallable =
  ## getClusterManifest
  ## Get the Service Fabric cluster manifest. The cluster manifest contains properties of the cluster that include different node types on the cluster,
  ## security configurations, fault and upgrade domain topologies etc.
  ## 
  ## These properties are specified as part of the ClusterConfig.JSON file while deploying a stand alone cluster. However, most of the information in the cluster manifest
  ## is generated internally by service fabric during cluster deployment in other deployment scenarios (for e.g when using azuer portal).
  ## 
  ## The contents of the cluster manifest are for informational purposes only and users are not expected to take a dependency on the format of the file contents or its interpretation.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  var query_564165 = newJObject()
  add(query_564165, "api-version", newJString(apiVersion))
  add(query_564165, "timeout", newJInt(timeout))
  result = call_564164.call(nil, query_564165, nil, nil, nil)

var getClusterManifest* = Call_GetClusterManifest_564158(
    name: "getClusterManifest", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/$/GetClusterManifest", validator: validate_GetClusterManifest_564159,
    base: "", url: url_GetClusterManifest_564160,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetProvisionedFabricCodeVersionInfoList_564166 = ref object of OpenApiRestCall_563564
proc url_GetProvisionedFabricCodeVersionInfoList_564168(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetProvisionedFabricCodeVersionInfoList_564167(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of information about fabric code versions that are provisioned in the cluster. The parameter CodeVersion can be used to optionally filter the output to only that particular version.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   CodeVersion: JString
  ##              : The product version of Service Fabric.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564169 = query.getOrDefault("api-version")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564169 != nil:
    section.add "api-version", valid_564169
  var valid_564170 = query.getOrDefault("timeout")
  valid_564170 = validateParameter(valid_564170, JInt, required = false,
                                 default = newJInt(60))
  if valid_564170 != nil:
    section.add "timeout", valid_564170
  var valid_564171 = query.getOrDefault("CodeVersion")
  valid_564171 = validateParameter(valid_564171, JString, required = false,
                                 default = nil)
  if valid_564171 != nil:
    section.add "CodeVersion", valid_564171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564172: Call_GetProvisionedFabricCodeVersionInfoList_564166;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of information about fabric code versions that are provisioned in the cluster. The parameter CodeVersion can be used to optionally filter the output to only that particular version.
  ## 
  let valid = call_564172.validator(path, query, header, formData, body)
  let scheme = call_564172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564172.url(scheme.get, call_564172.host, call_564172.base,
                         call_564172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564172, url, valid)

proc call*(call_564173: Call_GetProvisionedFabricCodeVersionInfoList_564166;
          apiVersion: string = "3.0"; timeout: int = 60; CodeVersion: string = ""): Recallable =
  ## getProvisionedFabricCodeVersionInfoList
  ## Gets a list of information about fabric code versions that are provisioned in the cluster. The parameter CodeVersion can be used to optionally filter the output to only that particular version.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   CodeVersion: string
  ##              : The product version of Service Fabric.
  var query_564174 = newJObject()
  add(query_564174, "api-version", newJString(apiVersion))
  add(query_564174, "timeout", newJInt(timeout))
  add(query_564174, "CodeVersion", newJString(CodeVersion))
  result = call_564173.call(nil, query_564174, nil, nil, nil)

var getProvisionedFabricCodeVersionInfoList* = Call_GetProvisionedFabricCodeVersionInfoList_564166(
    name: "getProvisionedFabricCodeVersionInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetProvisionedCodeVersions",
    validator: validate_GetProvisionedFabricCodeVersionInfoList_564167, base: "",
    url: url_GetProvisionedFabricCodeVersionInfoList_564168,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetProvisionedFabricConfigVersionInfoList_564175 = ref object of OpenApiRestCall_563564
proc url_GetProvisionedFabricConfigVersionInfoList_564177(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetProvisionedFabricConfigVersionInfoList_564176(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of information about fabric config versions that are provisioned in the cluster. The parameter ConfigVersion can be used to optionally filter the output to only that particular version.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ConfigVersion: JString
  ##                : The config version of Service Fabric.
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564178 = query.getOrDefault("api-version")
  valid_564178 = validateParameter(valid_564178, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564178 != nil:
    section.add "api-version", valid_564178
  var valid_564179 = query.getOrDefault("ConfigVersion")
  valid_564179 = validateParameter(valid_564179, JString, required = false,
                                 default = nil)
  if valid_564179 != nil:
    section.add "ConfigVersion", valid_564179
  var valid_564180 = query.getOrDefault("timeout")
  valid_564180 = validateParameter(valid_564180, JInt, required = false,
                                 default = newJInt(60))
  if valid_564180 != nil:
    section.add "timeout", valid_564180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564181: Call_GetProvisionedFabricConfigVersionInfoList_564175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of information about fabric config versions that are provisioned in the cluster. The parameter ConfigVersion can be used to optionally filter the output to only that particular version.
  ## 
  let valid = call_564181.validator(path, query, header, formData, body)
  let scheme = call_564181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564181.url(scheme.get, call_564181.host, call_564181.base,
                         call_564181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564181, url, valid)

proc call*(call_564182: Call_GetProvisionedFabricConfigVersionInfoList_564175;
          apiVersion: string = "3.0"; ConfigVersion: string = ""; timeout: int = 60): Recallable =
  ## getProvisionedFabricConfigVersionInfoList
  ## Gets a list of information about fabric config versions that are provisioned in the cluster. The parameter ConfigVersion can be used to optionally filter the output to only that particular version.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ConfigVersion: string
  ##                : The config version of Service Fabric.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  var query_564183 = newJObject()
  add(query_564183, "api-version", newJString(apiVersion))
  add(query_564183, "ConfigVersion", newJString(ConfigVersion))
  add(query_564183, "timeout", newJInt(timeout))
  result = call_564182.call(nil, query_564183, nil, nil, nil)

var getProvisionedFabricConfigVersionInfoList* = Call_GetProvisionedFabricConfigVersionInfoList_564175(
    name: "getProvisionedFabricConfigVersionInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetProvisionedConfigVersions",
    validator: validate_GetProvisionedFabricConfigVersionInfoList_564176,
    base: "", url: url_GetProvisionedFabricConfigVersionInfoList_564177,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetClusterUpgradeProgress_564184 = ref object of OpenApiRestCall_563564
proc url_GetClusterUpgradeProgress_564186(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetClusterUpgradeProgress_564185(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the current progress of the ongoing cluster upgrade. If no upgrade is currently in progress, gets the last state of the previous cluster upgrade.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564187 = query.getOrDefault("api-version")
  valid_564187 = validateParameter(valid_564187, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564187 != nil:
    section.add "api-version", valid_564187
  var valid_564188 = query.getOrDefault("timeout")
  valid_564188 = validateParameter(valid_564188, JInt, required = false,
                                 default = newJInt(60))
  if valid_564188 != nil:
    section.add "timeout", valid_564188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564189: Call_GetClusterUpgradeProgress_564184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current progress of the ongoing cluster upgrade. If no upgrade is currently in progress, gets the last state of the previous cluster upgrade.
  ## 
  let valid = call_564189.validator(path, query, header, formData, body)
  let scheme = call_564189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564189.url(scheme.get, call_564189.host, call_564189.base,
                         call_564189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564189, url, valid)

proc call*(call_564190: Call_GetClusterUpgradeProgress_564184;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getClusterUpgradeProgress
  ## Gets the current progress of the ongoing cluster upgrade. If no upgrade is currently in progress, gets the last state of the previous cluster upgrade.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  var query_564191 = newJObject()
  add(query_564191, "api-version", newJString(apiVersion))
  add(query_564191, "timeout", newJInt(timeout))
  result = call_564190.call(nil, query_564191, nil, nil, nil)

var getClusterUpgradeProgress* = Call_GetClusterUpgradeProgress_564184(
    name: "getClusterUpgradeProgress", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetUpgradeProgress",
    validator: validate_GetClusterUpgradeProgress_564185, base: "",
    url: url_GetClusterUpgradeProgress_564186,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_InvokeInfrastructureCommand_564192 = ref object of OpenApiRestCall_563564
proc url_InvokeInfrastructureCommand_564194(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_InvokeInfrastructureCommand_564193(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## For clusters that have one or more instances of the Infrastructure Service configured,
  ## this API provides a way to send infrastructure-specific commands to a particular
  ## instance of the Infrastructure Service.
  ## 
  ## Available commands and their corresponding response formats vary depending upon
  ## the infrastructure on which the cluster is running.
  ## 
  ## This API supports the Service Fabric platform; it is not meant to be used directly from your code.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ServiceId: JString
  ##            : The identity of the infrastructure service. This is  the full name of the infrastructure service without the 'fabric:' URI scheme. This parameter required only for the cluster that have more than one instance of infrastructure service running.
  ##   Command: JString (required)
  ##          : The text of the command to be invoked. The content of the command is infrastructure-specific.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564195 = query.getOrDefault("api-version")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564195 != nil:
    section.add "api-version", valid_564195
  var valid_564196 = query.getOrDefault("timeout")
  valid_564196 = validateParameter(valid_564196, JInt, required = false,
                                 default = newJInt(60))
  if valid_564196 != nil:
    section.add "timeout", valid_564196
  var valid_564197 = query.getOrDefault("ServiceId")
  valid_564197 = validateParameter(valid_564197, JString, required = false,
                                 default = nil)
  if valid_564197 != nil:
    section.add "ServiceId", valid_564197
  var valid_564198 = query.getOrDefault("Command")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "Command", valid_564198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564199: Call_InvokeInfrastructureCommand_564192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## For clusters that have one or more instances of the Infrastructure Service configured,
  ## this API provides a way to send infrastructure-specific commands to a particular
  ## instance of the Infrastructure Service.
  ## 
  ## Available commands and their corresponding response formats vary depending upon
  ## the infrastructure on which the cluster is running.
  ## 
  ## This API supports the Service Fabric platform; it is not meant to be used directly from your code.
  ## 
  ## 
  let valid = call_564199.validator(path, query, header, formData, body)
  let scheme = call_564199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564199.url(scheme.get, call_564199.host, call_564199.base,
                         call_564199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564199, url, valid)

proc call*(call_564200: Call_InvokeInfrastructureCommand_564192; Command: string;
          apiVersion: string = "3.0"; timeout: int = 60; ServiceId: string = ""): Recallable =
  ## invokeInfrastructureCommand
  ## For clusters that have one or more instances of the Infrastructure Service configured,
  ## this API provides a way to send infrastructure-specific commands to a particular
  ## instance of the Infrastructure Service.
  ## 
  ## Available commands and their corresponding response formats vary depending upon
  ## the infrastructure on which the cluster is running.
  ## 
  ## This API supports the Service Fabric platform; it is not meant to be used directly from your code.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ServiceId: string
  ##            : The identity of the infrastructure service. This is  the full name of the infrastructure service without the 'fabric:' URI scheme. This parameter required only for the cluster that have more than one instance of infrastructure service running.
  ##   Command: string (required)
  ##          : The text of the command to be invoked. The content of the command is infrastructure-specific.
  var query_564201 = newJObject()
  add(query_564201, "api-version", newJString(apiVersion))
  add(query_564201, "timeout", newJInt(timeout))
  add(query_564201, "ServiceId", newJString(ServiceId))
  add(query_564201, "Command", newJString(Command))
  result = call_564200.call(nil, query_564201, nil, nil, nil)

var invokeInfrastructureCommand* = Call_InvokeInfrastructureCommand_564192(
    name: "invokeInfrastructureCommand", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/InvokeInfrastructureCommand",
    validator: validate_InvokeInfrastructureCommand_564193, base: "",
    url: url_InvokeInfrastructureCommand_564194,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_InvokeInfrastructureQuery_564202 = ref object of OpenApiRestCall_563564
proc url_InvokeInfrastructureQuery_564204(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_InvokeInfrastructureQuery_564203(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## For clusters that have one or more instances of the Infrastructure Service configured,
  ## this API provides a way to send infrastructure-specific queries to a particular
  ## instance of the Infrastructure Service.
  ## 
  ## Available commands and their corresponding response formats vary depending upon
  ## the infrastructure on which the cluster is running.
  ## 
  ## This API supports the Service Fabric platform; it is not meant to be used directly from your code.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ServiceId: JString
  ##            : The identity of the infrastructure service. This is  the full name of the infrastructure service without the 'fabric:' URI scheme. This parameter required only for the cluster that have more than one instance of infrastructure service running.
  ##   Command: JString (required)
  ##          : The text of the command to be invoked. The content of the command is infrastructure-specific.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564205 = query.getOrDefault("api-version")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564205 != nil:
    section.add "api-version", valid_564205
  var valid_564206 = query.getOrDefault("timeout")
  valid_564206 = validateParameter(valid_564206, JInt, required = false,
                                 default = newJInt(60))
  if valid_564206 != nil:
    section.add "timeout", valid_564206
  var valid_564207 = query.getOrDefault("ServiceId")
  valid_564207 = validateParameter(valid_564207, JString, required = false,
                                 default = nil)
  if valid_564207 != nil:
    section.add "ServiceId", valid_564207
  var valid_564208 = query.getOrDefault("Command")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "Command", valid_564208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564209: Call_InvokeInfrastructureQuery_564202; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## For clusters that have one or more instances of the Infrastructure Service configured,
  ## this API provides a way to send infrastructure-specific queries to a particular
  ## instance of the Infrastructure Service.
  ## 
  ## Available commands and their corresponding response formats vary depending upon
  ## the infrastructure on which the cluster is running.
  ## 
  ## This API supports the Service Fabric platform; it is not meant to be used directly from your code.
  ## 
  ## 
  let valid = call_564209.validator(path, query, header, formData, body)
  let scheme = call_564209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564209.url(scheme.get, call_564209.host, call_564209.base,
                         call_564209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564209, url, valid)

proc call*(call_564210: Call_InvokeInfrastructureQuery_564202; Command: string;
          apiVersion: string = "3.0"; timeout: int = 60; ServiceId: string = ""): Recallable =
  ## invokeInfrastructureQuery
  ## For clusters that have one or more instances of the Infrastructure Service configured,
  ## this API provides a way to send infrastructure-specific queries to a particular
  ## instance of the Infrastructure Service.
  ## 
  ## Available commands and their corresponding response formats vary depending upon
  ## the infrastructure on which the cluster is running.
  ## 
  ## This API supports the Service Fabric platform; it is not meant to be used directly from your code.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ServiceId: string
  ##            : The identity of the infrastructure service. This is  the full name of the infrastructure service without the 'fabric:' URI scheme. This parameter required only for the cluster that have more than one instance of infrastructure service running.
  ##   Command: string (required)
  ##          : The text of the command to be invoked. The content of the command is infrastructure-specific.
  var query_564211 = newJObject()
  add(query_564211, "api-version", newJString(apiVersion))
  add(query_564211, "timeout", newJInt(timeout))
  add(query_564211, "ServiceId", newJString(ServiceId))
  add(query_564211, "Command", newJString(Command))
  result = call_564210.call(nil, query_564211, nil, nil, nil)

var invokeInfrastructureQuery* = Call_InvokeInfrastructureQuery_564202(
    name: "invokeInfrastructureQuery", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/InvokeInfrastructureQuery",
    validator: validate_InvokeInfrastructureQuery_564203, base: "",
    url: url_InvokeInfrastructureQuery_564204,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_RecoverAllPartitions_564212 = ref object of OpenApiRestCall_563564
proc url_RecoverAllPartitions_564214(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecoverAllPartitions_564213(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Indicates to the Service Fabric cluster that it should attempt to recover any services (including system services) which are currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564215 = query.getOrDefault("api-version")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564215 != nil:
    section.add "api-version", valid_564215
  var valid_564216 = query.getOrDefault("timeout")
  valid_564216 = validateParameter(valid_564216, JInt, required = false,
                                 default = newJInt(60))
  if valid_564216 != nil:
    section.add "timeout", valid_564216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564217: Call_RecoverAllPartitions_564212; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicates to the Service Fabric cluster that it should attempt to recover any services (including system services) which are currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ## 
  let valid = call_564217.validator(path, query, header, formData, body)
  let scheme = call_564217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564217.url(scheme.get, call_564217.host, call_564217.base,
                         call_564217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564217, url, valid)

proc call*(call_564218: Call_RecoverAllPartitions_564212;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## recoverAllPartitions
  ## Indicates to the Service Fabric cluster that it should attempt to recover any services (including system services) which are currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  var query_564219 = newJObject()
  add(query_564219, "api-version", newJString(apiVersion))
  add(query_564219, "timeout", newJInt(timeout))
  result = call_564218.call(nil, query_564219, nil, nil, nil)

var recoverAllPartitions* = Call_RecoverAllPartitions_564212(
    name: "recoverAllPartitions", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/RecoverAllPartitions",
    validator: validate_RecoverAllPartitions_564213, base: "",
    url: url_RecoverAllPartitions_564214, schemes: {Scheme.Https, Scheme.Http})
type
  Call_RecoverSystemPartitions_564220 = ref object of OpenApiRestCall_563564
proc url_RecoverSystemPartitions_564222(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecoverSystemPartitions_564221(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Indicates to the Service Fabric cluster that it should attempt to recover the system services which are currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564223 = query.getOrDefault("api-version")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564223 != nil:
    section.add "api-version", valid_564223
  var valid_564224 = query.getOrDefault("timeout")
  valid_564224 = validateParameter(valid_564224, JInt, required = false,
                                 default = newJInt(60))
  if valid_564224 != nil:
    section.add "timeout", valid_564224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564225: Call_RecoverSystemPartitions_564220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicates to the Service Fabric cluster that it should attempt to recover the system services which are currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ## 
  let valid = call_564225.validator(path, query, header, formData, body)
  let scheme = call_564225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564225.url(scheme.get, call_564225.host, call_564225.base,
                         call_564225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564225, url, valid)

proc call*(call_564226: Call_RecoverSystemPartitions_564220;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## recoverSystemPartitions
  ## Indicates to the Service Fabric cluster that it should attempt to recover the system services which are currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  var query_564227 = newJObject()
  add(query_564227, "api-version", newJString(apiVersion))
  add(query_564227, "timeout", newJInt(timeout))
  result = call_564226.call(nil, query_564227, nil, nil, nil)

var recoverSystemPartitions* = Call_RecoverSystemPartitions_564220(
    name: "recoverSystemPartitions", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/RecoverSystemPartitions",
    validator: validate_RecoverSystemPartitions_564221, base: "",
    url: url_RecoverSystemPartitions_564222, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportClusterHealth_564228 = ref object of OpenApiRestCall_563564
proc url_ReportClusterHealth_564230(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportClusterHealth_564229(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Sends a health report on a Service Fabric cluster. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway node, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetClusterHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564231 = query.getOrDefault("api-version")
  valid_564231 = validateParameter(valid_564231, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564231 != nil:
    section.add "api-version", valid_564231
  var valid_564232 = query.getOrDefault("timeout")
  valid_564232 = validateParameter(valid_564232, JInt, required = false,
                                 default = newJInt(60))
  if valid_564232 != nil:
    section.add "timeout", valid_564232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564234: Call_ReportClusterHealth_564228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a health report on a Service Fabric cluster. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway node, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetClusterHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_564234.validator(path, query, header, formData, body)
  let scheme = call_564234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564234.url(scheme.get, call_564234.host, call_564234.base,
                         call_564234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564234, url, valid)

proc call*(call_564235: Call_ReportClusterHealth_564228;
          HealthInformation: JsonNode; apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## reportClusterHealth
  ## Sends a health report on a Service Fabric cluster. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway node, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetClusterHealth and check that the report appears in the HealthEvents section.
  ## 
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  var query_564236 = newJObject()
  var body_564237 = newJObject()
  if HealthInformation != nil:
    body_564237 = HealthInformation
  add(query_564236, "api-version", newJString(apiVersion))
  add(query_564236, "timeout", newJInt(timeout))
  result = call_564235.call(nil, query_564236, nil, nil, body_564237)

var reportClusterHealth* = Call_ReportClusterHealth_564228(
    name: "reportClusterHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/ReportClusterHealth",
    validator: validate_ReportClusterHealth_564229, base: "",
    url: url_ReportClusterHealth_564230, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationTypeInfoList_564238 = ref object of OpenApiRestCall_563564
proc url_GetApplicationTypeInfoList_564240(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetApplicationTypeInfoList_564239(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the information about the application types that are provisioned or in the process of being provisioned in the Service Fabric cluster. Each version of an application type is returned as one application type. The response includes the name, version, status and other details about the application type. This is a paged query, meaning that if not all of the application types fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page. For example, if there are 10 application types but a page only fits the first 3 application types, or if max results is set to 3, then 3 is returned. To access the rest of the results, retrieve subsequent pages by using the returned continuation token in the next query. An empty continuation token is returned if there are no subsequent pages.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   MaxResults: JInt
  ##             : The maximum number of results to be returned as part of the paged queries. This parameter defines the upper bound on the number of results returned. The results returned can be less than the specified maximum results if they do not fit in the message as per the max message size restrictions defined in the configuration. If this parameter is zero or not specified, the paged queries includes as much results as possible that fit in the return message.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "4.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ExcludeApplicationParameters: JBool
  ##                               : The flag that specifies whether application parameters will be excluded from the result.
  section = newJObject()
  var valid_564241 = query.getOrDefault("ContinuationToken")
  valid_564241 = validateParameter(valid_564241, JString, required = false,
                                 default = nil)
  if valid_564241 != nil:
    section.add "ContinuationToken", valid_564241
  var valid_564242 = query.getOrDefault("MaxResults")
  valid_564242 = validateParameter(valid_564242, JInt, required = false,
                                 default = newJInt(0))
  if valid_564242 != nil:
    section.add "MaxResults", valid_564242
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564243 = query.getOrDefault("api-version")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = newJString("4.0"))
  if valid_564243 != nil:
    section.add "api-version", valid_564243
  var valid_564244 = query.getOrDefault("timeout")
  valid_564244 = validateParameter(valid_564244, JInt, required = false,
                                 default = newJInt(60))
  if valid_564244 != nil:
    section.add "timeout", valid_564244
  var valid_564245 = query.getOrDefault("ExcludeApplicationParameters")
  valid_564245 = validateParameter(valid_564245, JBool, required = false,
                                 default = newJBool(false))
  if valid_564245 != nil:
    section.add "ExcludeApplicationParameters", valid_564245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564246: Call_GetApplicationTypeInfoList_564238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the information about the application types that are provisioned or in the process of being provisioned in the Service Fabric cluster. Each version of an application type is returned as one application type. The response includes the name, version, status and other details about the application type. This is a paged query, meaning that if not all of the application types fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page. For example, if there are 10 application types but a page only fits the first 3 application types, or if max results is set to 3, then 3 is returned. To access the rest of the results, retrieve subsequent pages by using the returned continuation token in the next query. An empty continuation token is returned if there are no subsequent pages.
  ## 
  let valid = call_564246.validator(path, query, header, formData, body)
  let scheme = call_564246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564246.url(scheme.get, call_564246.host, call_564246.base,
                         call_564246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564246, url, valid)

proc call*(call_564247: Call_GetApplicationTypeInfoList_564238;
          ContinuationToken: string = ""; MaxResults: int = 0;
          apiVersion: string = "4.0"; timeout: int = 60;
          ExcludeApplicationParameters: bool = false): Recallable =
  ## getApplicationTypeInfoList
  ## Returns the information about the application types that are provisioned or in the process of being provisioned in the Service Fabric cluster. Each version of an application type is returned as one application type. The response includes the name, version, status and other details about the application type. This is a paged query, meaning that if not all of the application types fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page. For example, if there are 10 application types but a page only fits the first 3 application types, or if max results is set to 3, then 3 is returned. To access the rest of the results, retrieve subsequent pages by using the returned continuation token in the next query. An empty continuation token is returned if there are no subsequent pages.
  ##   ContinuationToken: string
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   MaxResults: int
  ##             : The maximum number of results to be returned as part of the paged queries. This parameter defines the upper bound on the number of results returned. The results returned can be less than the specified maximum results if they do not fit in the message as per the max message size restrictions defined in the configuration. If this parameter is zero or not specified, the paged queries includes as much results as possible that fit in the return message.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "4.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ExcludeApplicationParameters: bool
  ##                               : The flag that specifies whether application parameters will be excluded from the result.
  var query_564248 = newJObject()
  add(query_564248, "ContinuationToken", newJString(ContinuationToken))
  add(query_564248, "MaxResults", newJInt(MaxResults))
  add(query_564248, "api-version", newJString(apiVersion))
  add(query_564248, "timeout", newJInt(timeout))
  add(query_564248, "ExcludeApplicationParameters",
      newJBool(ExcludeApplicationParameters))
  result = call_564247.call(nil, query_564248, nil, nil, nil)

var getApplicationTypeInfoList* = Call_GetApplicationTypeInfoList_564238(
    name: "getApplicationTypeInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ApplicationTypes",
    validator: validate_GetApplicationTypeInfoList_564239, base: "",
    url: url_GetApplicationTypeInfoList_564240,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_ProvisionApplicationType_564249 = ref object of OpenApiRestCall_563564
proc url_ProvisionApplicationType_564251(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProvisionApplicationType_564250(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provisions or registers a Service Fabric application type with the cluster. This is required before any new applications can be instantiated.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564252 = query.getOrDefault("api-version")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564252 != nil:
    section.add "api-version", valid_564252
  var valid_564253 = query.getOrDefault("timeout")
  valid_564253 = validateParameter(valid_564253, JInt, required = false,
                                 default = newJInt(60))
  if valid_564253 != nil:
    section.add "timeout", valid_564253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ApplicationTypeImageStorePath: JObject (required)
  ##                                : The relative path for the application package in the image store specified during the prior copy operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564255: Call_ProvisionApplicationType_564249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provisions or registers a Service Fabric application type with the cluster. This is required before any new applications can be instantiated.
  ## 
  let valid = call_564255.validator(path, query, header, formData, body)
  let scheme = call_564255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564255.url(scheme.get, call_564255.host, call_564255.base,
                         call_564255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564255, url, valid)

proc call*(call_564256: Call_ProvisionApplicationType_564249;
          ApplicationTypeImageStorePath: JsonNode; apiVersion: string = "3.0";
          timeout: int = 60): Recallable =
  ## provisionApplicationType
  ## Provisions or registers a Service Fabric application type with the cluster. This is required before any new applications can be instantiated.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationTypeImageStorePath: JObject (required)
  ##                                : The relative path for the application package in the image store specified during the prior copy operation.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  var query_564257 = newJObject()
  var body_564258 = newJObject()
  add(query_564257, "api-version", newJString(apiVersion))
  if ApplicationTypeImageStorePath != nil:
    body_564258 = ApplicationTypeImageStorePath
  add(query_564257, "timeout", newJInt(timeout))
  result = call_564256.call(nil, query_564257, nil, nil, body_564258)

var provisionApplicationType* = Call_ProvisionApplicationType_564249(
    name: "provisionApplicationType", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/ApplicationTypes/$/Provision",
    validator: validate_ProvisionApplicationType_564250, base: "",
    url: url_ProvisionApplicationType_564251, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationTypeInfoListByName_564259 = ref object of OpenApiRestCall_563564
proc url_GetApplicationTypeInfoListByName_564261(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationTypeName" in path,
        "`applicationTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/ApplicationTypes/"),
               (kind: VariableSegment, value: "applicationTypeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetApplicationTypeInfoListByName_564260(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the information about the application types that are provisioned or in the process of being provisioned in the Service Fabric cluster. These results are of application types whose name match exactly the one specified as the parameter, and which comply with the given query parameters. All versions of the application type matching the application type name are returned, with each version returned as one application type. The response includes the name, version, status and other details about the application type. This is a paged query, meaning that if not all of the application types fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page. For example, if there are 10 application types but a page only fits the first 3 application types, or if max results is set to 3, then 3 is returned. To access the rest of the results, retrieve subsequent pages by using the returned continuation token in the next query. An empty continuation token is returned if there are no subsequent pages.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `applicationTypeName` field"
  var valid_564276 = path.getOrDefault("applicationTypeName")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "applicationTypeName", valid_564276
  result.add "path", section
  ## parameters in `query` object:
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   MaxResults: JInt
  ##             : The maximum number of results to be returned as part of the paged queries. This parameter defines the upper bound on the number of results returned. The results returned can be less than the specified maximum results if they do not fit in the message as per the max message size restrictions defined in the configuration. If this parameter is zero or not specified, the paged queries includes as much results as possible that fit in the return message.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "4.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ExcludeApplicationParameters: JBool
  ##                               : The flag that specifies whether application parameters will be excluded from the result.
  section = newJObject()
  var valid_564277 = query.getOrDefault("ContinuationToken")
  valid_564277 = validateParameter(valid_564277, JString, required = false,
                                 default = nil)
  if valid_564277 != nil:
    section.add "ContinuationToken", valid_564277
  var valid_564278 = query.getOrDefault("MaxResults")
  valid_564278 = validateParameter(valid_564278, JInt, required = false,
                                 default = newJInt(0))
  if valid_564278 != nil:
    section.add "MaxResults", valid_564278
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564279 = query.getOrDefault("api-version")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = newJString("4.0"))
  if valid_564279 != nil:
    section.add "api-version", valid_564279
  var valid_564280 = query.getOrDefault("timeout")
  valid_564280 = validateParameter(valid_564280, JInt, required = false,
                                 default = newJInt(60))
  if valid_564280 != nil:
    section.add "timeout", valid_564280
  var valid_564281 = query.getOrDefault("ExcludeApplicationParameters")
  valid_564281 = validateParameter(valid_564281, JBool, required = false,
                                 default = newJBool(false))
  if valid_564281 != nil:
    section.add "ExcludeApplicationParameters", valid_564281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564282: Call_GetApplicationTypeInfoListByName_564259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the information about the application types that are provisioned or in the process of being provisioned in the Service Fabric cluster. These results are of application types whose name match exactly the one specified as the parameter, and which comply with the given query parameters. All versions of the application type matching the application type name are returned, with each version returned as one application type. The response includes the name, version, status and other details about the application type. This is a paged query, meaning that if not all of the application types fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page. For example, if there are 10 application types but a page only fits the first 3 application types, or if max results is set to 3, then 3 is returned. To access the rest of the results, retrieve subsequent pages by using the returned continuation token in the next query. An empty continuation token is returned if there are no subsequent pages.
  ## 
  let valid = call_564282.validator(path, query, header, formData, body)
  let scheme = call_564282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564282.url(scheme.get, call_564282.host, call_564282.base,
                         call_564282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564282, url, valid)

proc call*(call_564283: Call_GetApplicationTypeInfoListByName_564259;
          applicationTypeName: string; ContinuationToken: string = "";
          MaxResults: int = 0; apiVersion: string = "4.0"; timeout: int = 60;
          ExcludeApplicationParameters: bool = false): Recallable =
  ## getApplicationTypeInfoListByName
  ## Returns the information about the application types that are provisioned or in the process of being provisioned in the Service Fabric cluster. These results are of application types whose name match exactly the one specified as the parameter, and which comply with the given query parameters. All versions of the application type matching the application type name are returned, with each version returned as one application type. The response includes the name, version, status and other details about the application type. This is a paged query, meaning that if not all of the application types fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page. For example, if there are 10 application types but a page only fits the first 3 application types, or if max results is set to 3, then 3 is returned. To access the rest of the results, retrieve subsequent pages by using the returned continuation token in the next query. An empty continuation token is returned if there are no subsequent pages.
  ##   ContinuationToken: string
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   MaxResults: int
  ##             : The maximum number of results to be returned as part of the paged queries. This parameter defines the upper bound on the number of results returned. The results returned can be less than the specified maximum results if they do not fit in the message as per the max message size restrictions defined in the configuration. If this parameter is zero or not specified, the paged queries includes as much results as possible that fit in the return message.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "4.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type.
  ##   ExcludeApplicationParameters: bool
  ##                               : The flag that specifies whether application parameters will be excluded from the result.
  var path_564284 = newJObject()
  var query_564285 = newJObject()
  add(query_564285, "ContinuationToken", newJString(ContinuationToken))
  add(query_564285, "MaxResults", newJInt(MaxResults))
  add(query_564285, "api-version", newJString(apiVersion))
  add(query_564285, "timeout", newJInt(timeout))
  add(path_564284, "applicationTypeName", newJString(applicationTypeName))
  add(query_564285, "ExcludeApplicationParameters",
      newJBool(ExcludeApplicationParameters))
  result = call_564283.call(path_564284, query_564285, nil, nil, nil)

var getApplicationTypeInfoListByName* = Call_GetApplicationTypeInfoListByName_564259(
    name: "getApplicationTypeInfoListByName", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ApplicationTypes/{applicationTypeName}",
    validator: validate_GetApplicationTypeInfoListByName_564260, base: "",
    url: url_GetApplicationTypeInfoListByName_564261,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationManifest_564286 = ref object of OpenApiRestCall_563564
proc url_GetApplicationManifest_564288(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationTypeName" in path,
        "`applicationTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/ApplicationTypes/"),
               (kind: VariableSegment, value: "applicationTypeName"),
               (kind: ConstantSegment, value: "/$/GetApplicationManifest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetApplicationManifest_564287(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the manifest describing an application type. The response contains the application manifest XML as a string.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `applicationTypeName` field"
  var valid_564289 = path.getOrDefault("applicationTypeName")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "applicationTypeName", valid_564289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationTypeVersion: JString (required)
  ##                         : The version of the application type.
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564290 = query.getOrDefault("api-version")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564290 != nil:
    section.add "api-version", valid_564290
  var valid_564291 = query.getOrDefault("ApplicationTypeVersion")
  valid_564291 = validateParameter(valid_564291, JString, required = true,
                                 default = nil)
  if valid_564291 != nil:
    section.add "ApplicationTypeVersion", valid_564291
  var valid_564292 = query.getOrDefault("timeout")
  valid_564292 = validateParameter(valid_564292, JInt, required = false,
                                 default = newJInt(60))
  if valid_564292 != nil:
    section.add "timeout", valid_564292
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564293: Call_GetApplicationManifest_564286; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the manifest describing an application type. The response contains the application manifest XML as a string.
  ## 
  let valid = call_564293.validator(path, query, header, formData, body)
  let scheme = call_564293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564293.url(scheme.get, call_564293.host, call_564293.base,
                         call_564293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564293, url, valid)

proc call*(call_564294: Call_GetApplicationManifest_564286;
          ApplicationTypeVersion: string; applicationTypeName: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getApplicationManifest
  ## Gets the manifest describing an application type. The response contains the application manifest XML as a string.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationTypeVersion: string (required)
  ##                         : The version of the application type.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type.
  var path_564295 = newJObject()
  var query_564296 = newJObject()
  add(query_564296, "api-version", newJString(apiVersion))
  add(query_564296, "ApplicationTypeVersion", newJString(ApplicationTypeVersion))
  add(query_564296, "timeout", newJInt(timeout))
  add(path_564295, "applicationTypeName", newJString(applicationTypeName))
  result = call_564294.call(path_564295, query_564296, nil, nil, nil)

var getApplicationManifest* = Call_GetApplicationManifest_564286(
    name: "getApplicationManifest", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/GetApplicationManifest",
    validator: validate_GetApplicationManifest_564287, base: "",
    url: url_GetApplicationManifest_564288, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceManifest_564297 = ref object of OpenApiRestCall_563564
proc url_GetServiceManifest_564299(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationTypeName" in path,
        "`applicationTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/ApplicationTypes/"),
               (kind: VariableSegment, value: "applicationTypeName"),
               (kind: ConstantSegment, value: "/$/GetServiceManifest")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetServiceManifest_564298(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the manifest describing a service type. The response contains the service manifest XML as a string.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `applicationTypeName` field"
  var valid_564300 = path.getOrDefault("applicationTypeName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "applicationTypeName", valid_564300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationTypeVersion: JString (required)
  ##                         : The version of the application type.
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ServiceManifestName: JString (required)
  ##                      : The name of a service manifest registered as part of an application type in a Service Fabric cluster.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564301 = query.getOrDefault("api-version")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564301 != nil:
    section.add "api-version", valid_564301
  var valid_564302 = query.getOrDefault("ApplicationTypeVersion")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "ApplicationTypeVersion", valid_564302
  var valid_564303 = query.getOrDefault("timeout")
  valid_564303 = validateParameter(valid_564303, JInt, required = false,
                                 default = newJInt(60))
  if valid_564303 != nil:
    section.add "timeout", valid_564303
  var valid_564304 = query.getOrDefault("ServiceManifestName")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "ServiceManifestName", valid_564304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564305: Call_GetServiceManifest_564297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the manifest describing a service type. The response contains the service manifest XML as a string.
  ## 
  let valid = call_564305.validator(path, query, header, formData, body)
  let scheme = call_564305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564305.url(scheme.get, call_564305.host, call_564305.base,
                         call_564305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564305, url, valid)

proc call*(call_564306: Call_GetServiceManifest_564297;
          ApplicationTypeVersion: string; applicationTypeName: string;
          ServiceManifestName: string; apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getServiceManifest
  ## Gets the manifest describing a service type. The response contains the service manifest XML as a string.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationTypeVersion: string (required)
  ##                         : The version of the application type.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type.
  ##   ServiceManifestName: string (required)
  ##                      : The name of a service manifest registered as part of an application type in a Service Fabric cluster.
  var path_564307 = newJObject()
  var query_564308 = newJObject()
  add(query_564308, "api-version", newJString(apiVersion))
  add(query_564308, "ApplicationTypeVersion", newJString(ApplicationTypeVersion))
  add(query_564308, "timeout", newJInt(timeout))
  add(path_564307, "applicationTypeName", newJString(applicationTypeName))
  add(query_564308, "ServiceManifestName", newJString(ServiceManifestName))
  result = call_564306.call(path_564307, query_564308, nil, nil, nil)

var getServiceManifest* = Call_GetServiceManifest_564297(
    name: "getServiceManifest", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/GetServiceManifest",
    validator: validate_GetServiceManifest_564298, base: "",
    url: url_GetServiceManifest_564299, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceTypeInfoList_564309 = ref object of OpenApiRestCall_563564
proc url_GetServiceTypeInfoList_564311(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationTypeName" in path,
        "`applicationTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/ApplicationTypes/"),
               (kind: VariableSegment, value: "applicationTypeName"),
               (kind: ConstantSegment, value: "/$/GetServiceTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetServiceTypeInfoList_564310(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list containing the information about service types that are supported by a provisioned application type in a Service Fabric cluster. The response includes the name of the service type, the name and version of the service manifest the type is defined in, kind (stateless or stateless) of the service type and other information about it.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `applicationTypeName` field"
  var valid_564312 = path.getOrDefault("applicationTypeName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "applicationTypeName", valid_564312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationTypeVersion: JString (required)
  ##                         : The version of the application type.
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564313 = query.getOrDefault("api-version")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564313 != nil:
    section.add "api-version", valid_564313
  var valid_564314 = query.getOrDefault("ApplicationTypeVersion")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "ApplicationTypeVersion", valid_564314
  var valid_564315 = query.getOrDefault("timeout")
  valid_564315 = validateParameter(valid_564315, JInt, required = false,
                                 default = newJInt(60))
  if valid_564315 != nil:
    section.add "timeout", valid_564315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564316: Call_GetServiceTypeInfoList_564309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list containing the information about service types that are supported by a provisioned application type in a Service Fabric cluster. The response includes the name of the service type, the name and version of the service manifest the type is defined in, kind (stateless or stateless) of the service type and other information about it.
  ## 
  let valid = call_564316.validator(path, query, header, formData, body)
  let scheme = call_564316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564316.url(scheme.get, call_564316.host, call_564316.base,
                         call_564316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564316, url, valid)

proc call*(call_564317: Call_GetServiceTypeInfoList_564309;
          ApplicationTypeVersion: string; applicationTypeName: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getServiceTypeInfoList
  ## Gets the list containing the information about service types that are supported by a provisioned application type in a Service Fabric cluster. The response includes the name of the service type, the name and version of the service manifest the type is defined in, kind (stateless or stateless) of the service type and other information about it.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationTypeVersion: string (required)
  ##                         : The version of the application type.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type.
  var path_564318 = newJObject()
  var query_564319 = newJObject()
  add(query_564319, "api-version", newJString(apiVersion))
  add(query_564319, "ApplicationTypeVersion", newJString(ApplicationTypeVersion))
  add(query_564319, "timeout", newJInt(timeout))
  add(path_564318, "applicationTypeName", newJString(applicationTypeName))
  result = call_564317.call(path_564318, query_564319, nil, nil, nil)

var getServiceTypeInfoList* = Call_GetServiceTypeInfoList_564309(
    name: "getServiceTypeInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/GetServiceTypes",
    validator: validate_GetServiceTypeInfoList_564310, base: "",
    url: url_GetServiceTypeInfoList_564311, schemes: {Scheme.Https, Scheme.Http})
type
  Call_UnprovisionApplicationType_564320 = ref object of OpenApiRestCall_563564
proc url_UnprovisionApplicationType_564322(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationTypeName" in path,
        "`applicationTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/ApplicationTypes/"),
               (kind: VariableSegment, value: "applicationTypeName"),
               (kind: ConstantSegment, value: "/$/Unprovision")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UnprovisionApplicationType_564321(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes or unregisters a Service Fabric application type from the cluster. This operation can only be performed if all application instance of the application type has been deleted. Once the application type is unregistered, no new application instance can be created for this particular application type.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationTypeName: JString (required)
  ##                      : The name of the application type.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `applicationTypeName` field"
  var valid_564323 = path.getOrDefault("applicationTypeName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "applicationTypeName", valid_564323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564324 = query.getOrDefault("api-version")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564324 != nil:
    section.add "api-version", valid_564324
  var valid_564325 = query.getOrDefault("timeout")
  valid_564325 = validateParameter(valid_564325, JInt, required = false,
                                 default = newJInt(60))
  if valid_564325 != nil:
    section.add "timeout", valid_564325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ApplicationTypeImageStoreVersion: JObject (required)
  ##                                   : The version of the application type in the image store.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564327: Call_UnprovisionApplicationType_564320; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes or unregisters a Service Fabric application type from the cluster. This operation can only be performed if all application instance of the application type has been deleted. Once the application type is unregistered, no new application instance can be created for this particular application type.
  ## 
  let valid = call_564327.validator(path, query, header, formData, body)
  let scheme = call_564327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564327.url(scheme.get, call_564327.host, call_564327.base,
                         call_564327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564327, url, valid)

proc call*(call_564328: Call_UnprovisionApplicationType_564320;
          applicationTypeName: string; ApplicationTypeImageStoreVersion: JsonNode;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## unprovisionApplicationType
  ## Removes or unregisters a Service Fabric application type from the cluster. This operation can only be performed if all application instance of the application type has been deleted. Once the application type is unregistered, no new application instance can be created for this particular application type.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type.
  ##   ApplicationTypeImageStoreVersion: JObject (required)
  ##                                   : The version of the application type in the image store.
  var path_564329 = newJObject()
  var query_564330 = newJObject()
  var body_564331 = newJObject()
  add(query_564330, "api-version", newJString(apiVersion))
  add(query_564330, "timeout", newJInt(timeout))
  add(path_564329, "applicationTypeName", newJString(applicationTypeName))
  if ApplicationTypeImageStoreVersion != nil:
    body_564331 = ApplicationTypeImageStoreVersion
  result = call_564328.call(path_564329, query_564330, nil, nil, body_564331)

var unprovisionApplicationType* = Call_UnprovisionApplicationType_564320(
    name: "unprovisionApplicationType", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/Unprovision",
    validator: validate_UnprovisionApplicationType_564321, base: "",
    url: url_UnprovisionApplicationType_564322,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationInfoList_564332 = ref object of OpenApiRestCall_563564
proc url_GetApplicationInfoList_564334(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetApplicationInfoList_564333(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the applications that were created or in the process of being created in the Service Fabric cluster and match filters specified as the parameter. The response includes the name, type, status, parameters and other details about the application. If the applications do not fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ApplicationTypeName: JString
  ##                      : The application type name used to filter the applications to query for. This value should not contain the application type version.
  ##   ExcludeApplicationParameters: JBool
  ##                               : The flag that specifies whether application parameters will be excluded from the result.
  section = newJObject()
  var valid_564335 = query.getOrDefault("ContinuationToken")
  valid_564335 = validateParameter(valid_564335, JString, required = false,
                                 default = nil)
  if valid_564335 != nil:
    section.add "ContinuationToken", valid_564335
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564336 = query.getOrDefault("api-version")
  valid_564336 = validateParameter(valid_564336, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564336 != nil:
    section.add "api-version", valid_564336
  var valid_564337 = query.getOrDefault("timeout")
  valid_564337 = validateParameter(valid_564337, JInt, required = false,
                                 default = newJInt(60))
  if valid_564337 != nil:
    section.add "timeout", valid_564337
  var valid_564338 = query.getOrDefault("ApplicationTypeName")
  valid_564338 = validateParameter(valid_564338, JString, required = false,
                                 default = nil)
  if valid_564338 != nil:
    section.add "ApplicationTypeName", valid_564338
  var valid_564339 = query.getOrDefault("ExcludeApplicationParameters")
  valid_564339 = validateParameter(valid_564339, JBool, required = false,
                                 default = newJBool(false))
  if valid_564339 != nil:
    section.add "ExcludeApplicationParameters", valid_564339
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564340: Call_GetApplicationInfoList_564332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the applications that were created or in the process of being created in the Service Fabric cluster and match filters specified as the parameter. The response includes the name, type, status, parameters and other details about the application. If the applications do not fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page.
  ## 
  let valid = call_564340.validator(path, query, header, formData, body)
  let scheme = call_564340.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564340.url(scheme.get, call_564340.host, call_564340.base,
                         call_564340.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564340, url, valid)

proc call*(call_564341: Call_GetApplicationInfoList_564332;
          ContinuationToken: string = ""; apiVersion: string = "3.0"; timeout: int = 60;
          ApplicationTypeName: string = "";
          ExcludeApplicationParameters: bool = false): Recallable =
  ## getApplicationInfoList
  ## Gets the information about the applications that were created or in the process of being created in the Service Fabric cluster and match filters specified as the parameter. The response includes the name, type, status, parameters and other details about the application. If the applications do not fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page.
  ##   ContinuationToken: string
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ApplicationTypeName: string
  ##                      : The application type name used to filter the applications to query for. This value should not contain the application type version.
  ##   ExcludeApplicationParameters: bool
  ##                               : The flag that specifies whether application parameters will be excluded from the result.
  var query_564342 = newJObject()
  add(query_564342, "ContinuationToken", newJString(ContinuationToken))
  add(query_564342, "api-version", newJString(apiVersion))
  add(query_564342, "timeout", newJInt(timeout))
  add(query_564342, "ApplicationTypeName", newJString(ApplicationTypeName))
  add(query_564342, "ExcludeApplicationParameters",
      newJBool(ExcludeApplicationParameters))
  result = call_564341.call(nil, query_564342, nil, nil, nil)

var getApplicationInfoList* = Call_GetApplicationInfoList_564332(
    name: "getApplicationInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Applications",
    validator: validate_GetApplicationInfoList_564333, base: "",
    url: url_GetApplicationInfoList_564334, schemes: {Scheme.Https, Scheme.Http})
type
  Call_CreateApplication_564343 = ref object of OpenApiRestCall_563564
proc url_CreateApplication_564345(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CreateApplication_564344(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a Service Fabric application using the specified description.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564346 = query.getOrDefault("api-version")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564346 != nil:
    section.add "api-version", valid_564346
  var valid_564347 = query.getOrDefault("timeout")
  valid_564347 = validateParameter(valid_564347, JInt, required = false,
                                 default = newJInt(60))
  if valid_564347 != nil:
    section.add "timeout", valid_564347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ApplicationDescription: JObject (required)
  ##                         : Describes the application to be created.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564349: Call_CreateApplication_564343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Service Fabric application using the specified description.
  ## 
  let valid = call_564349.validator(path, query, header, formData, body)
  let scheme = call_564349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564349.url(scheme.get, call_564349.host, call_564349.base,
                         call_564349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564349, url, valid)

proc call*(call_564350: Call_CreateApplication_564343;
          ApplicationDescription: JsonNode; apiVersion: string = "3.0";
          timeout: int = 60): Recallable =
  ## createApplication
  ## Creates a Service Fabric application using the specified description.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationDescription: JObject (required)
  ##                         : Describes the application to be created.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  var query_564351 = newJObject()
  var body_564352 = newJObject()
  add(query_564351, "api-version", newJString(apiVersion))
  if ApplicationDescription != nil:
    body_564352 = ApplicationDescription
  add(query_564351, "timeout", newJInt(timeout))
  result = call_564350.call(nil, query_564351, nil, nil, body_564352)

var createApplication* = Call_CreateApplication_564343(name: "createApplication",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Applications/$/Create", validator: validate_CreateApplication_564344,
    base: "", url: url_CreateApplication_564345,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationInfo_564353 = ref object of OpenApiRestCall_563564
proc url_GetApplicationInfo_564355(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetApplicationInfo_564354(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns the information about the application that was created or in the process of being created in the Service Fabric cluster and whose name matches the one specified as the parameter. The response includes the name, type, status, parameters and other details about the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_564356 = path.getOrDefault("applicationId")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "applicationId", valid_564356
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ExcludeApplicationParameters: JBool
  ##                               : The flag that specifies whether application parameters will be excluded from the result.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564357 = query.getOrDefault("api-version")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564357 != nil:
    section.add "api-version", valid_564357
  var valid_564358 = query.getOrDefault("timeout")
  valid_564358 = validateParameter(valid_564358, JInt, required = false,
                                 default = newJInt(60))
  if valid_564358 != nil:
    section.add "timeout", valid_564358
  var valid_564359 = query.getOrDefault("ExcludeApplicationParameters")
  valid_564359 = validateParameter(valid_564359, JBool, required = false,
                                 default = newJBool(false))
  if valid_564359 != nil:
    section.add "ExcludeApplicationParameters", valid_564359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564360: Call_GetApplicationInfo_564353; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the information about the application that was created or in the process of being created in the Service Fabric cluster and whose name matches the one specified as the parameter. The response includes the name, type, status, parameters and other details about the application.
  ## 
  let valid = call_564360.validator(path, query, header, formData, body)
  let scheme = call_564360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564360.url(scheme.get, call_564360.host, call_564360.base,
                         call_564360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564360, url, valid)

proc call*(call_564361: Call_GetApplicationInfo_564353; applicationId: string;
          apiVersion: string = "3.0"; timeout: int = 60;
          ExcludeApplicationParameters: bool = false): Recallable =
  ## getApplicationInfo
  ## Returns the information about the application that was created or in the process of being created in the Service Fabric cluster and whose name matches the one specified as the parameter. The response includes the name, type, status, parameters and other details about the application.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ExcludeApplicationParameters: bool
  ##                               : The flag that specifies whether application parameters will be excluded from the result.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564362 = newJObject()
  var query_564363 = newJObject()
  add(query_564363, "api-version", newJString(apiVersion))
  add(query_564363, "timeout", newJInt(timeout))
  add(query_564363, "ExcludeApplicationParameters",
      newJBool(ExcludeApplicationParameters))
  add(path_564362, "applicationId", newJString(applicationId))
  result = call_564361.call(path_564362, query_564363, nil, nil, nil)

var getApplicationInfo* = Call_GetApplicationInfo_564353(
    name: "getApplicationInfo", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Applications/{applicationId}",
    validator: validate_GetApplicationInfo_564354, base: "",
    url: url_GetApplicationInfo_564355, schemes: {Scheme.Https, Scheme.Http})
type
  Call_DeleteApplication_564364 = ref object of OpenApiRestCall_563564
proc url_DeleteApplication_564366(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/Delete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeleteApplication_564365(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes an existing Service Fabric application. An application must be created before it can be deleted. Deleting an application will delete all services that are part of that application. By default Service Fabric will try to close service replicas in a graceful manner and then delete the service. However if service is having issues closing the replica gracefully, the delete operation may take a long time or get stuck. Use the optional ForceRemove flag to skip the graceful close sequence and forcefully delete the application and all of the its services.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_564367 = path.getOrDefault("applicationId")
  valid_564367 = validateParameter(valid_564367, JString, required = true,
                                 default = nil)
  if valid_564367 != nil:
    section.add "applicationId", valid_564367
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ForceRemove: JBool
  ##              : Remove a Service Fabric application or service forcefully without going through the graceful shutdown sequence. This parameter can be used to forcefully delete an application or service for which delete is timing out due to issues in the service code that prevents graceful close of replicas.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564368 = query.getOrDefault("api-version")
  valid_564368 = validateParameter(valid_564368, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564368 != nil:
    section.add "api-version", valid_564368
  var valid_564369 = query.getOrDefault("timeout")
  valid_564369 = validateParameter(valid_564369, JInt, required = false,
                                 default = newJInt(60))
  if valid_564369 != nil:
    section.add "timeout", valid_564369
  var valid_564370 = query.getOrDefault("ForceRemove")
  valid_564370 = validateParameter(valid_564370, JBool, required = false, default = nil)
  if valid_564370 != nil:
    section.add "ForceRemove", valid_564370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564371: Call_DeleteApplication_564364; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Service Fabric application. An application must be created before it can be deleted. Deleting an application will delete all services that are part of that application. By default Service Fabric will try to close service replicas in a graceful manner and then delete the service. However if service is having issues closing the replica gracefully, the delete operation may take a long time or get stuck. Use the optional ForceRemove flag to skip the graceful close sequence and forcefully delete the application and all of the its services.
  ## 
  let valid = call_564371.validator(path, query, header, formData, body)
  let scheme = call_564371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564371.url(scheme.get, call_564371.host, call_564371.base,
                         call_564371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564371, url, valid)

proc call*(call_564372: Call_DeleteApplication_564364; applicationId: string;
          apiVersion: string = "3.0"; timeout: int = 60; ForceRemove: bool = false): Recallable =
  ## deleteApplication
  ## Deletes an existing Service Fabric application. An application must be created before it can be deleted. Deleting an application will delete all services that are part of that application. By default Service Fabric will try to close service replicas in a graceful manner and then delete the service. However if service is having issues closing the replica gracefully, the delete operation may take a long time or get stuck. Use the optional ForceRemove flag to skip the graceful close sequence and forcefully delete the application and all of the its services.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ForceRemove: bool
  ##              : Remove a Service Fabric application or service forcefully without going through the graceful shutdown sequence. This parameter can be used to forcefully delete an application or service for which delete is timing out due to issues in the service code that prevents graceful close of replicas.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564373 = newJObject()
  var query_564374 = newJObject()
  add(query_564374, "api-version", newJString(apiVersion))
  add(query_564374, "timeout", newJInt(timeout))
  add(query_564374, "ForceRemove", newJBool(ForceRemove))
  add(path_564373, "applicationId", newJString(applicationId))
  result = call_564372.call(path_564373, query_564374, nil, nil, nil)

var deleteApplication* = Call_DeleteApplication_564364(name: "deleteApplication",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/Delete",
    validator: validate_DeleteApplication_564365, base: "",
    url: url_DeleteApplication_564366, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationHealthUsingPolicy_564388 = ref object of OpenApiRestCall_563564
proc url_GetApplicationHealthUsingPolicy_564390(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetApplicationHealthUsingPolicy_564389(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the health of a Service Fabric application. Use EventsHealthStateFilter to filter the collection of health events reported on the node based on the health state. Use ClusterHealthPolicies to override the health policies used to evaluate the health.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_564391 = path.getOrDefault("applicationId")
  valid_564391 = validateParameter(valid_564391, JString, required = true,
                                 default = nil)
  if valid_564391 != nil:
    section.add "applicationId", valid_564391
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ServicesHealthStateFilter: JInt
  ##                            : Allows filtering of the services health state objects returned in the result of services health query based on their health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only services that match the filter are returned. All services are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value
  ## obtained using bitwise 'OR' operator. For example, if the provided value is 6 then health state of services with HealthState value of OK (2) and Warning (4) will be returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn�t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   EventsHealthStateFilter: JInt
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   DeployedApplicationsHealthStateFilter: JInt
  ##                                        : Allows filtering of the deployed applications health state objects returned in the result of application health query based on their health state.
  ## The possible values for this parameter include integer value of one of the following health states. Only deployed applications that match the filter will be returned.\
  ## All deployed applications are used to evaluate the aggregated health state. If not specified, all entries are returned.
  ## The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator.
  ## For example, if the provided value is 6 then health state of deployed applications with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn't match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564392 = query.getOrDefault("api-version")
  valid_564392 = validateParameter(valid_564392, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564392 != nil:
    section.add "api-version", valid_564392
  var valid_564393 = query.getOrDefault("timeout")
  valid_564393 = validateParameter(valid_564393, JInt, required = false,
                                 default = newJInt(60))
  if valid_564393 != nil:
    section.add "timeout", valid_564393
  var valid_564394 = query.getOrDefault("ServicesHealthStateFilter")
  valid_564394 = validateParameter(valid_564394, JInt, required = false,
                                 default = newJInt(0))
  if valid_564394 != nil:
    section.add "ServicesHealthStateFilter", valid_564394
  var valid_564395 = query.getOrDefault("EventsHealthStateFilter")
  valid_564395 = validateParameter(valid_564395, JInt, required = false,
                                 default = newJInt(0))
  if valid_564395 != nil:
    section.add "EventsHealthStateFilter", valid_564395
  var valid_564396 = query.getOrDefault("DeployedApplicationsHealthStateFilter")
  valid_564396 = validateParameter(valid_564396, JInt, required = false,
                                 default = newJInt(0))
  if valid_564396 != nil:
    section.add "DeployedApplicationsHealthStateFilter", valid_564396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ApplicationHealthPolicy: JObject
  ##                          : Describes the health policies used to evaluate the health of an application or one of its children.
  ## If not present, the health evaluation uses the health policy from application manifest or the default health policy.
  ## 
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564398: Call_GetApplicationHealthUsingPolicy_564388;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric application. Use EventsHealthStateFilter to filter the collection of health events reported on the node based on the health state. Use ClusterHealthPolicies to override the health policies used to evaluate the health.
  ## 
  let valid = call_564398.validator(path, query, header, formData, body)
  let scheme = call_564398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564398.url(scheme.get, call_564398.host, call_564398.base,
                         call_564398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564398, url, valid)

proc call*(call_564399: Call_GetApplicationHealthUsingPolicy_564388;
          applicationId: string; ApplicationHealthPolicy: JsonNode = nil;
          apiVersion: string = "3.0"; timeout: int = 60;
          ServicesHealthStateFilter: int = 0; EventsHealthStateFilter: int = 0;
          DeployedApplicationsHealthStateFilter: int = 0): Recallable =
  ## getApplicationHealthUsingPolicy
  ## Gets the health of a Service Fabric application. Use EventsHealthStateFilter to filter the collection of health events reported on the node based on the health state. Use ClusterHealthPolicies to override the health policies used to evaluate the health.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  ##   ApplicationHealthPolicy: JObject
  ##                          : Describes the health policies used to evaluate the health of an application or one of its children.
  ## If not present, the health evaluation uses the health policy from application manifest or the default health policy.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ServicesHealthStateFilter: int
  ##                            : Allows filtering of the services health state objects returned in the result of services health query based on their health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only services that match the filter are returned. All services are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value
  ## obtained using bitwise 'OR' operator. For example, if the provided value is 6 then health state of services with HealthState value of OK (2) and Warning (4) will be returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn�t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   EventsHealthStateFilter: int
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   DeployedApplicationsHealthStateFilter: int
  ##                                        : Allows filtering of the deployed applications health state objects returned in the result of application health query based on their health state.
  ## The possible values for this parameter include integer value of one of the following health states. Only deployed applications that match the filter will be returned.\
  ## All deployed applications are used to evaluate the aggregated health state. If not specified, all entries are returned.
  ## The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator.
  ## For example, if the provided value is 6 then health state of deployed applications with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn't match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  var path_564400 = newJObject()
  var query_564401 = newJObject()
  var body_564402 = newJObject()
  add(path_564400, "applicationId", newJString(applicationId))
  if ApplicationHealthPolicy != nil:
    body_564402 = ApplicationHealthPolicy
  add(query_564401, "api-version", newJString(apiVersion))
  add(query_564401, "timeout", newJInt(timeout))
  add(query_564401, "ServicesHealthStateFilter",
      newJInt(ServicesHealthStateFilter))
  add(query_564401, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(query_564401, "DeployedApplicationsHealthStateFilter",
      newJInt(DeployedApplicationsHealthStateFilter))
  result = call_564399.call(path_564400, query_564401, nil, nil, body_564402)

var getApplicationHealthUsingPolicy* = Call_GetApplicationHealthUsingPolicy_564388(
    name: "getApplicationHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationId}/$/GetHealth",
    validator: validate_GetApplicationHealthUsingPolicy_564389, base: "",
    url: url_GetApplicationHealthUsingPolicy_564390,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationHealth_564375 = ref object of OpenApiRestCall_563564
proc url_GetApplicationHealth_564377(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetApplicationHealth_564376(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the heath state of the service fabric application. The response reports either Ok, Error or Warning health state. If the entity is not found in the helath store, it will return Error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_564378 = path.getOrDefault("applicationId")
  valid_564378 = validateParameter(valid_564378, JString, required = true,
                                 default = nil)
  if valid_564378 != nil:
    section.add "applicationId", valid_564378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ServicesHealthStateFilter: JInt
  ##                            : Allows filtering of the services health state objects returned in the result of services health query based on their health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only services that match the filter are returned. All services are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value
  ## obtained using bitwise 'OR' operator. For example, if the provided value is 6 then health state of services with HealthState value of OK (2) and Warning (4) will be returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn�t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   EventsHealthStateFilter: JInt
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   DeployedApplicationsHealthStateFilter: JInt
  ##                                        : Allows filtering of the deployed applications health state objects returned in the result of application health query based on their health state.
  ## The possible values for this parameter include integer value of one of the following health states. Only deployed applications that match the filter will be returned.\
  ## All deployed applications are used to evaluate the aggregated health state. If not specified, all entries are returned.
  ## The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator.
  ## For example, if the provided value is 6 then health state of deployed applications with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn't match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564379 = query.getOrDefault("api-version")
  valid_564379 = validateParameter(valid_564379, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564379 != nil:
    section.add "api-version", valid_564379
  var valid_564380 = query.getOrDefault("timeout")
  valid_564380 = validateParameter(valid_564380, JInt, required = false,
                                 default = newJInt(60))
  if valid_564380 != nil:
    section.add "timeout", valid_564380
  var valid_564381 = query.getOrDefault("ServicesHealthStateFilter")
  valid_564381 = validateParameter(valid_564381, JInt, required = false,
                                 default = newJInt(0))
  if valid_564381 != nil:
    section.add "ServicesHealthStateFilter", valid_564381
  var valid_564382 = query.getOrDefault("EventsHealthStateFilter")
  valid_564382 = validateParameter(valid_564382, JInt, required = false,
                                 default = newJInt(0))
  if valid_564382 != nil:
    section.add "EventsHealthStateFilter", valid_564382
  var valid_564383 = query.getOrDefault("DeployedApplicationsHealthStateFilter")
  valid_564383 = validateParameter(valid_564383, JInt, required = false,
                                 default = newJInt(0))
  if valid_564383 != nil:
    section.add "DeployedApplicationsHealthStateFilter", valid_564383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564384: Call_GetApplicationHealth_564375; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the heath state of the service fabric application. The response reports either Ok, Error or Warning health state. If the entity is not found in the helath store, it will return Error.
  ## 
  let valid = call_564384.validator(path, query, header, formData, body)
  let scheme = call_564384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564384.url(scheme.get, call_564384.host, call_564384.base,
                         call_564384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564384, url, valid)

proc call*(call_564385: Call_GetApplicationHealth_564375; applicationId: string;
          apiVersion: string = "3.0"; timeout: int = 60;
          ServicesHealthStateFilter: int = 0; EventsHealthStateFilter: int = 0;
          DeployedApplicationsHealthStateFilter: int = 0): Recallable =
  ## getApplicationHealth
  ## Returns the heath state of the service fabric application. The response reports either Ok, Error or Warning health state. If the entity is not found in the helath store, it will return Error.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ServicesHealthStateFilter: int
  ##                            : Allows filtering of the services health state objects returned in the result of services health query based on their health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only services that match the filter are returned. All services are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value
  ## obtained using bitwise 'OR' operator. For example, if the provided value is 6 then health state of services with HealthState value of OK (2) and Warning (4) will be returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn�t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   EventsHealthStateFilter: int
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   DeployedApplicationsHealthStateFilter: int
  ##                                        : Allows filtering of the deployed applications health state objects returned in the result of application health query based on their health state.
  ## The possible values for this parameter include integer value of one of the following health states. Only deployed applications that match the filter will be returned.\
  ## All deployed applications are used to evaluate the aggregated health state. If not specified, all entries are returned.
  ## The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator.
  ## For example, if the provided value is 6 then health state of deployed applications with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn't match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  var path_564386 = newJObject()
  var query_564387 = newJObject()
  add(path_564386, "applicationId", newJString(applicationId))
  add(query_564387, "api-version", newJString(apiVersion))
  add(query_564387, "timeout", newJInt(timeout))
  add(query_564387, "ServicesHealthStateFilter",
      newJInt(ServicesHealthStateFilter))
  add(query_564387, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(query_564387, "DeployedApplicationsHealthStateFilter",
      newJInt(DeployedApplicationsHealthStateFilter))
  result = call_564385.call(path_564386, query_564387, nil, nil, nil)

var getApplicationHealth* = Call_GetApplicationHealth_564375(
    name: "getApplicationHealth", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Applications/{applicationId}/$/GetHealth",
    validator: validate_GetApplicationHealth_564376, base: "",
    url: url_GetApplicationHealth_564377, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceInfoList_564403 = ref object of OpenApiRestCall_563564
proc url_GetServiceInfoList_564405(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/GetServices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetServiceInfoList_564404(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns the information about all services belonging to the application specified by the application id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_564406 = path.getOrDefault("applicationId")
  valid_564406 = validateParameter(valid_564406, JString, required = true,
                                 default = nil)
  if valid_564406 != nil:
    section.add "applicationId", valid_564406
  result.add "path", section
  ## parameters in `query` object:
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   ServiceTypeName: JString
  ##                  : The service type name used to filter the services to query for.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  var valid_564407 = query.getOrDefault("ContinuationToken")
  valid_564407 = validateParameter(valid_564407, JString, required = false,
                                 default = nil)
  if valid_564407 != nil:
    section.add "ContinuationToken", valid_564407
  var valid_564408 = query.getOrDefault("ServiceTypeName")
  valid_564408 = validateParameter(valid_564408, JString, required = false,
                                 default = nil)
  if valid_564408 != nil:
    section.add "ServiceTypeName", valid_564408
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564409 = query.getOrDefault("api-version")
  valid_564409 = validateParameter(valid_564409, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564409 != nil:
    section.add "api-version", valid_564409
  var valid_564410 = query.getOrDefault("timeout")
  valid_564410 = validateParameter(valid_564410, JInt, required = false,
                                 default = newJInt(60))
  if valid_564410 != nil:
    section.add "timeout", valid_564410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564411: Call_GetServiceInfoList_564403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the information about all services belonging to the application specified by the application id.
  ## 
  let valid = call_564411.validator(path, query, header, formData, body)
  let scheme = call_564411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564411.url(scheme.get, call_564411.host, call_564411.base,
                         call_564411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564411, url, valid)

proc call*(call_564412: Call_GetServiceInfoList_564403; applicationId: string;
          ContinuationToken: string = ""; ServiceTypeName: string = "";
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getServiceInfoList
  ## Returns the information about all services belonging to the application specified by the application id.
  ##   ContinuationToken: string
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   ServiceTypeName: string
  ##                  : The service type name used to filter the services to query for.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564413 = newJObject()
  var query_564414 = newJObject()
  add(query_564414, "ContinuationToken", newJString(ContinuationToken))
  add(query_564414, "ServiceTypeName", newJString(ServiceTypeName))
  add(query_564414, "api-version", newJString(apiVersion))
  add(query_564414, "timeout", newJInt(timeout))
  add(path_564413, "applicationId", newJString(applicationId))
  result = call_564412.call(path_564413, query_564414, nil, nil, nil)

var getServiceInfoList* = Call_GetServiceInfoList_564403(
    name: "getServiceInfoList", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/GetServices",
    validator: validate_GetServiceInfoList_564404, base: "",
    url: url_GetServiceInfoList_564405, schemes: {Scheme.Https, Scheme.Http})
type
  Call_CreateService_564415 = ref object of OpenApiRestCall_563564
proc url_CreateService_564417(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/GetServices/$/Create")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CreateService_564416(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates the specified service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_564418 = path.getOrDefault("applicationId")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "applicationId", valid_564418
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564419 = query.getOrDefault("api-version")
  valid_564419 = validateParameter(valid_564419, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564419 != nil:
    section.add "api-version", valid_564419
  var valid_564420 = query.getOrDefault("timeout")
  valid_564420 = validateParameter(valid_564420, JInt, required = false,
                                 default = newJInt(60))
  if valid_564420 != nil:
    section.add "timeout", valid_564420
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ServiceDescription: JObject (required)
  ##                     : The configuration for the service.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564422: Call_CreateService_564415; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the specified service.
  ## 
  let valid = call_564422.validator(path, query, header, formData, body)
  let scheme = call_564422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564422.url(scheme.get, call_564422.host, call_564422.base,
                         call_564422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564422, url, valid)

proc call*(call_564423: Call_CreateService_564415; ServiceDescription: JsonNode;
          applicationId: string; apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## createService
  ## Creates the specified service.
  ##   ServiceDescription: JObject (required)
  ##                     : The configuration for the service.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564424 = newJObject()
  var query_564425 = newJObject()
  var body_564426 = newJObject()
  if ServiceDescription != nil:
    body_564426 = ServiceDescription
  add(query_564425, "api-version", newJString(apiVersion))
  add(query_564425, "timeout", newJInt(timeout))
  add(path_564424, "applicationId", newJString(applicationId))
  result = call_564423.call(path_564424, query_564425, nil, nil, body_564426)

var createService* = Call_CreateService_564415(name: "createService",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/GetServices/$/Create",
    validator: validate_CreateService_564416, base: "", url: url_CreateService_564417,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_CreateServiceFromTemplate_564427 = ref object of OpenApiRestCall_563564
proc url_CreateServiceFromTemplate_564429(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationId"), (
        kind: ConstantSegment, value: "/$/GetServices/$/CreateFromTemplate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CreateServiceFromTemplate_564428(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Service Fabric service from the service template defined in the application manifest.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_564430 = path.getOrDefault("applicationId")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "applicationId", valid_564430
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564431 = query.getOrDefault("api-version")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564431 != nil:
    section.add "api-version", valid_564431
  var valid_564432 = query.getOrDefault("timeout")
  valid_564432 = validateParameter(valid_564432, JInt, required = false,
                                 default = newJInt(60))
  if valid_564432 != nil:
    section.add "timeout", valid_564432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ServiceFromTemplateDescription: JObject (required)
  ##                                 : Describes the service that needs to be created from the template defined in the application manifest.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564434: Call_CreateServiceFromTemplate_564427; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Service Fabric service from the service template defined in the application manifest.
  ## 
  let valid = call_564434.validator(path, query, header, formData, body)
  let scheme = call_564434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564434.url(scheme.get, call_564434.host, call_564434.base,
                         call_564434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564434, url, valid)

proc call*(call_564435: Call_CreateServiceFromTemplate_564427;
          ServiceFromTemplateDescription: JsonNode; applicationId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## createServiceFromTemplate
  ## Creates a Service Fabric service from the service template defined in the application manifest.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ServiceFromTemplateDescription: JObject (required)
  ##                                 : Describes the service that needs to be created from the template defined in the application manifest.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564436 = newJObject()
  var query_564437 = newJObject()
  var body_564438 = newJObject()
  add(query_564437, "api-version", newJString(apiVersion))
  if ServiceFromTemplateDescription != nil:
    body_564438 = ServiceFromTemplateDescription
  add(query_564437, "timeout", newJInt(timeout))
  add(path_564436, "applicationId", newJString(applicationId))
  result = call_564435.call(path_564436, query_564437, nil, nil, body_564438)

var createServiceFromTemplate* = Call_CreateServiceFromTemplate_564427(
    name: "createServiceFromTemplate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/GetServices/$/CreateFromTemplate",
    validator: validate_CreateServiceFromTemplate_564428, base: "",
    url: url_CreateServiceFromTemplate_564429,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceInfo_564439 = ref object of OpenApiRestCall_563564
proc url_GetServiceInfo_564441(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  assert "serviceId" in path, "`serviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/GetServices/"),
               (kind: VariableSegment, value: "serviceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetServiceInfo_564440(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns the information about specified service belonging to the specified Service Fabric application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceId: JString (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `serviceId` field"
  var valid_564442 = path.getOrDefault("serviceId")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "serviceId", valid_564442
  var valid_564443 = path.getOrDefault("applicationId")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "applicationId", valid_564443
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564444 = query.getOrDefault("api-version")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564444 != nil:
    section.add "api-version", valid_564444
  var valid_564445 = query.getOrDefault("timeout")
  valid_564445 = validateParameter(valid_564445, JInt, required = false,
                                 default = newJInt(60))
  if valid_564445 != nil:
    section.add "timeout", valid_564445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564446: Call_GetServiceInfo_564439; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the information about specified service belonging to the specified Service Fabric application.
  ## 
  let valid = call_564446.validator(path, query, header, formData, body)
  let scheme = call_564446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564446.url(scheme.get, call_564446.host, call_564446.base,
                         call_564446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564446, url, valid)

proc call*(call_564447: Call_GetServiceInfo_564439; serviceId: string;
          applicationId: string; apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getServiceInfo
  ## Returns the information about specified service belonging to the specified Service Fabric application.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564448 = newJObject()
  var query_564449 = newJObject()
  add(query_564449, "api-version", newJString(apiVersion))
  add(query_564449, "timeout", newJInt(timeout))
  add(path_564448, "serviceId", newJString(serviceId))
  add(path_564448, "applicationId", newJString(applicationId))
  result = call_564447.call(path_564448, query_564449, nil, nil, nil)

var getServiceInfo* = Call_GetServiceInfo_564439(name: "getServiceInfo",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/GetServices/{serviceId}",
    validator: validate_GetServiceInfo_564440, base: "", url: url_GetServiceInfo_564441,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationUpgrade_564450 = ref object of OpenApiRestCall_563564
proc url_GetApplicationUpgrade_564452(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/GetUpgradeProgress")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetApplicationUpgrade_564451(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns information about the state of the latest application upgrade along with details to aid debugging application health issues.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_564453 = path.getOrDefault("applicationId")
  valid_564453 = validateParameter(valid_564453, JString, required = true,
                                 default = nil)
  if valid_564453 != nil:
    section.add "applicationId", valid_564453
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564454 = query.getOrDefault("api-version")
  valid_564454 = validateParameter(valid_564454, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564454 != nil:
    section.add "api-version", valid_564454
  var valid_564455 = query.getOrDefault("timeout")
  valid_564455 = validateParameter(valid_564455, JInt, required = false,
                                 default = newJInt(60))
  if valid_564455 != nil:
    section.add "timeout", valid_564455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564456: Call_GetApplicationUpgrade_564450; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the state of the latest application upgrade along with details to aid debugging application health issues.
  ## 
  let valid = call_564456.validator(path, query, header, formData, body)
  let scheme = call_564456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564456.url(scheme.get, call_564456.host, call_564456.base,
                         call_564456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564456, url, valid)

proc call*(call_564457: Call_GetApplicationUpgrade_564450; applicationId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getApplicationUpgrade
  ## Returns information about the state of the latest application upgrade along with details to aid debugging application health issues.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564458 = newJObject()
  var query_564459 = newJObject()
  add(query_564459, "api-version", newJString(apiVersion))
  add(query_564459, "timeout", newJInt(timeout))
  add(path_564458, "applicationId", newJString(applicationId))
  result = call_564457.call(path_564458, query_564459, nil, nil, nil)

var getApplicationUpgrade* = Call_GetApplicationUpgrade_564450(
    name: "getApplicationUpgrade", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/GetUpgradeProgress",
    validator: validate_GetApplicationUpgrade_564451, base: "",
    url: url_GetApplicationUpgrade_564452, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ResumeApplicationUpgrade_564460 = ref object of OpenApiRestCall_563564
proc url_ResumeApplicationUpgrade_564462(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/MoveToNextUpgradeDomain")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResumeApplicationUpgrade_564461(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Resumes an unmonitored manual Service Fabric application upgrade. Service Fabric upgrades one upgrade domain at a time. For unmonitored manual upgrades, after Service Fabric finishes an upgrade domain, it waits for you to call this API before proceeding to the next upgrade domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_564463 = path.getOrDefault("applicationId")
  valid_564463 = validateParameter(valid_564463, JString, required = true,
                                 default = nil)
  if valid_564463 != nil:
    section.add "applicationId", valid_564463
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564464 = query.getOrDefault("api-version")
  valid_564464 = validateParameter(valid_564464, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564464 != nil:
    section.add "api-version", valid_564464
  var valid_564465 = query.getOrDefault("timeout")
  valid_564465 = validateParameter(valid_564465, JInt, required = false,
                                 default = newJInt(60))
  if valid_564465 != nil:
    section.add "timeout", valid_564465
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ResumeApplicationUpgradeDescription: JObject (required)
  ##                                      : Describes the parameters for resuming an application upgrade.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564467: Call_ResumeApplicationUpgrade_564460; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resumes an unmonitored manual Service Fabric application upgrade. Service Fabric upgrades one upgrade domain at a time. For unmonitored manual upgrades, after Service Fabric finishes an upgrade domain, it waits for you to call this API before proceeding to the next upgrade domain.
  ## 
  let valid = call_564467.validator(path, query, header, formData, body)
  let scheme = call_564467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564467.url(scheme.get, call_564467.host, call_564467.base,
                         call_564467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564467, url, valid)

proc call*(call_564468: Call_ResumeApplicationUpgrade_564460;
          ResumeApplicationUpgradeDescription: JsonNode; applicationId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## resumeApplicationUpgrade
  ## Resumes an unmonitored manual Service Fabric application upgrade. Service Fabric upgrades one upgrade domain at a time. For unmonitored manual upgrades, after Service Fabric finishes an upgrade domain, it waits for you to call this API before proceeding to the next upgrade domain.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ResumeApplicationUpgradeDescription: JObject (required)
  ##                                      : Describes the parameters for resuming an application upgrade.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564469 = newJObject()
  var query_564470 = newJObject()
  var body_564471 = newJObject()
  add(query_564470, "api-version", newJString(apiVersion))
  if ResumeApplicationUpgradeDescription != nil:
    body_564471 = ResumeApplicationUpgradeDescription
  add(query_564470, "timeout", newJInt(timeout))
  add(path_564469, "applicationId", newJString(applicationId))
  result = call_564468.call(path_564469, query_564470, nil, nil, body_564471)

var resumeApplicationUpgrade* = Call_ResumeApplicationUpgrade_564460(
    name: "resumeApplicationUpgrade", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/MoveToNextUpgradeDomain",
    validator: validate_ResumeApplicationUpgrade_564461, base: "",
    url: url_ResumeApplicationUpgrade_564462, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportApplicationHealth_564472 = ref object of OpenApiRestCall_563564
proc url_ReportApplicationHealth_564474(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/ReportHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportApplicationHealth_564473(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reports health state of the specified Service Fabric application. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Application, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetApplicationHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_564475 = path.getOrDefault("applicationId")
  valid_564475 = validateParameter(valid_564475, JString, required = true,
                                 default = nil)
  if valid_564475 != nil:
    section.add "applicationId", valid_564475
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564476 = query.getOrDefault("api-version")
  valid_564476 = validateParameter(valid_564476, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564476 != nil:
    section.add "api-version", valid_564476
  var valid_564477 = query.getOrDefault("timeout")
  valid_564477 = validateParameter(valid_564477, JInt, required = false,
                                 default = newJInt(60))
  if valid_564477 != nil:
    section.add "timeout", valid_564477
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564479: Call_ReportApplicationHealth_564472; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reports health state of the specified Service Fabric application. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Application, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetApplicationHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_564479.validator(path, query, header, formData, body)
  let scheme = call_564479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564479.url(scheme.get, call_564479.host, call_564479.base,
                         call_564479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564479, url, valid)

proc call*(call_564480: Call_ReportApplicationHealth_564472;
          HealthInformation: JsonNode; applicationId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## reportApplicationHealth
  ## Reports health state of the specified Service Fabric application. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Application, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetApplicationHealth and check that the report appears in the HealthEvents section.
  ## 
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564481 = newJObject()
  var query_564482 = newJObject()
  var body_564483 = newJObject()
  if HealthInformation != nil:
    body_564483 = HealthInformation
  add(query_564482, "api-version", newJString(apiVersion))
  add(query_564482, "timeout", newJInt(timeout))
  add(path_564481, "applicationId", newJString(applicationId))
  result = call_564480.call(path_564481, query_564482, nil, nil, body_564483)

var reportApplicationHealth* = Call_ReportApplicationHealth_564472(
    name: "reportApplicationHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/ReportHealth",
    validator: validate_ReportApplicationHealth_564473, base: "",
    url: url_ReportApplicationHealth_564474, schemes: {Scheme.Https, Scheme.Http})
type
  Call_RollbackApplicationUpgrade_564484 = ref object of OpenApiRestCall_563564
proc url_RollbackApplicationUpgrade_564486(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/RollbackUpgrade")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RollbackApplicationUpgrade_564485(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts rolling back the current application upgrade to the previous version. This API can only be used to rollback the current in-progress upgrade that is rolling forward to new version. If the application is not currently being upgraded use StartApplicationUpgrade API to upgrade it to desired version including rolling back to a previous version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_564487 = path.getOrDefault("applicationId")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "applicationId", valid_564487
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564488 = query.getOrDefault("api-version")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564488 != nil:
    section.add "api-version", valid_564488
  var valid_564489 = query.getOrDefault("timeout")
  valid_564489 = validateParameter(valid_564489, JInt, required = false,
                                 default = newJInt(60))
  if valid_564489 != nil:
    section.add "timeout", valid_564489
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564490: Call_RollbackApplicationUpgrade_564484; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts rolling back the current application upgrade to the previous version. This API can only be used to rollback the current in-progress upgrade that is rolling forward to new version. If the application is not currently being upgraded use StartApplicationUpgrade API to upgrade it to desired version including rolling back to a previous version.
  ## 
  let valid = call_564490.validator(path, query, header, formData, body)
  let scheme = call_564490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564490.url(scheme.get, call_564490.host, call_564490.base,
                         call_564490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564490, url, valid)

proc call*(call_564491: Call_RollbackApplicationUpgrade_564484;
          applicationId: string; apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## rollbackApplicationUpgrade
  ## Starts rolling back the current application upgrade to the previous version. This API can only be used to rollback the current in-progress upgrade that is rolling forward to new version. If the application is not currently being upgraded use StartApplicationUpgrade API to upgrade it to desired version including rolling back to a previous version.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564492 = newJObject()
  var query_564493 = newJObject()
  add(query_564493, "api-version", newJString(apiVersion))
  add(query_564493, "timeout", newJInt(timeout))
  add(path_564492, "applicationId", newJString(applicationId))
  result = call_564491.call(path_564492, query_564493, nil, nil, nil)

var rollbackApplicationUpgrade* = Call_RollbackApplicationUpgrade_564484(
    name: "rollbackApplicationUpgrade", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/RollbackUpgrade",
    validator: validate_RollbackApplicationUpgrade_564485, base: "",
    url: url_RollbackApplicationUpgrade_564486,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_UpdateApplicationUpgrade_564494 = ref object of OpenApiRestCall_563564
proc url_UpdateApplicationUpgrade_564496(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/UpdateUpgrade")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateApplicationUpgrade_564495(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the parameters of an ongoing application upgrade from the ones specified at the time of starting the application upgrade. This may be required to mitigate stuck application upgrades due to incorrect parameters or issues in the application to make progress.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_564497 = path.getOrDefault("applicationId")
  valid_564497 = validateParameter(valid_564497, JString, required = true,
                                 default = nil)
  if valid_564497 != nil:
    section.add "applicationId", valid_564497
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564498 = query.getOrDefault("api-version")
  valid_564498 = validateParameter(valid_564498, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564498 != nil:
    section.add "api-version", valid_564498
  var valid_564499 = query.getOrDefault("timeout")
  valid_564499 = validateParameter(valid_564499, JInt, required = false,
                                 default = newJInt(60))
  if valid_564499 != nil:
    section.add "timeout", valid_564499
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ApplicationUpgradeUpdateDescription: JObject (required)
  ##                                      : Describes the parameters for updating an existing application upgrade.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564501: Call_UpdateApplicationUpgrade_564494; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the parameters of an ongoing application upgrade from the ones specified at the time of starting the application upgrade. This may be required to mitigate stuck application upgrades due to incorrect parameters or issues in the application to make progress.
  ## 
  let valid = call_564501.validator(path, query, header, formData, body)
  let scheme = call_564501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564501.url(scheme.get, call_564501.host, call_564501.base,
                         call_564501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564501, url, valid)

proc call*(call_564502: Call_UpdateApplicationUpgrade_564494;
          ApplicationUpgradeUpdateDescription: JsonNode; applicationId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## updateApplicationUpgrade
  ## Updates the parameters of an ongoing application upgrade from the ones specified at the time of starting the application upgrade. This may be required to mitigate stuck application upgrades due to incorrect parameters or issues in the application to make progress.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationUpgradeUpdateDescription: JObject (required)
  ##                                      : Describes the parameters for updating an existing application upgrade.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564503 = newJObject()
  var query_564504 = newJObject()
  var body_564505 = newJObject()
  add(query_564504, "api-version", newJString(apiVersion))
  if ApplicationUpgradeUpdateDescription != nil:
    body_564505 = ApplicationUpgradeUpdateDescription
  add(query_564504, "timeout", newJInt(timeout))
  add(path_564503, "applicationId", newJString(applicationId))
  result = call_564502.call(path_564503, query_564504, nil, nil, body_564505)

var updateApplicationUpgrade* = Call_UpdateApplicationUpgrade_564494(
    name: "updateApplicationUpgrade", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/UpdateUpgrade",
    validator: validate_UpdateApplicationUpgrade_564495, base: "",
    url: url_UpdateApplicationUpgrade_564496, schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartApplicationUpgrade_564506 = ref object of OpenApiRestCall_563564
proc url_StartApplicationUpgrade_564508(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Applications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/Upgrade")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StartApplicationUpgrade_564507(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates the supplied application upgrade parameters and starts upgrading the application if the parameters are valid.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_564509 = path.getOrDefault("applicationId")
  valid_564509 = validateParameter(valid_564509, JString, required = true,
                                 default = nil)
  if valid_564509 != nil:
    section.add "applicationId", valid_564509
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564510 = query.getOrDefault("api-version")
  valid_564510 = validateParameter(valid_564510, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564510 != nil:
    section.add "api-version", valid_564510
  var valid_564511 = query.getOrDefault("timeout")
  valid_564511 = validateParameter(valid_564511, JInt, required = false,
                                 default = newJInt(60))
  if valid_564511 != nil:
    section.add "timeout", valid_564511
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ApplicationUpgradeDescription: JObject (required)
  ##                                : Describes the parameters for an application upgrade.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564513: Call_StartApplicationUpgrade_564506; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the supplied application upgrade parameters and starts upgrading the application if the parameters are valid.
  ## 
  let valid = call_564513.validator(path, query, header, formData, body)
  let scheme = call_564513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564513.url(scheme.get, call_564513.host, call_564513.base,
                         call_564513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564513, url, valid)

proc call*(call_564514: Call_StartApplicationUpgrade_564506;
          ApplicationUpgradeDescription: JsonNode; applicationId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## startApplicationUpgrade
  ## Validates the supplied application upgrade parameters and starts upgrading the application if the parameters are valid.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ApplicationUpgradeDescription: JObject (required)
  ##                                : Describes the parameters for an application upgrade.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564515 = newJObject()
  var query_564516 = newJObject()
  var body_564517 = newJObject()
  add(query_564516, "api-version", newJString(apiVersion))
  add(query_564516, "timeout", newJInt(timeout))
  if ApplicationUpgradeDescription != nil:
    body_564517 = ApplicationUpgradeDescription
  add(path_564515, "applicationId", newJString(applicationId))
  result = call_564514.call(path_564515, query_564516, nil, nil, body_564517)

var startApplicationUpgrade* = Call_StartApplicationUpgrade_564506(
    name: "startApplicationUpgrade", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationId}/$/Upgrade",
    validator: validate_StartApplicationUpgrade_564507, base: "",
    url: url_StartApplicationUpgrade_564508, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetComposeApplicationStatusList_564518 = ref object of OpenApiRestCall_563564
proc url_GetComposeApplicationStatusList_564520(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetComposeApplicationStatusList_564519(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status about the compose applications that were created or in the process of being created in the Service Fabric cluster. The response includes the name, status and other details about the compose application. If the applications do not fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   MaxResults: JInt
  ##             : The maximum number of results to be returned as part of the paged queries. This parameter defines the upper bound on the number of results returned. The results returned can be less than the specified maximum results if they do not fit in the message as per the max message size restrictions defined in the configuration. If this parameter is zero or not specified, the paged queries includes as much results as possible that fit in the return message.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "4.0-preview".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  var valid_564521 = query.getOrDefault("ContinuationToken")
  valid_564521 = validateParameter(valid_564521, JString, required = false,
                                 default = nil)
  if valid_564521 != nil:
    section.add "ContinuationToken", valid_564521
  var valid_564522 = query.getOrDefault("MaxResults")
  valid_564522 = validateParameter(valid_564522, JInt, required = false,
                                 default = newJInt(0))
  if valid_564522 != nil:
    section.add "MaxResults", valid_564522
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564523 = query.getOrDefault("api-version")
  valid_564523 = validateParameter(valid_564523, JString, required = true,
                                 default = newJString("4.0-preview"))
  if valid_564523 != nil:
    section.add "api-version", valid_564523
  var valid_564524 = query.getOrDefault("timeout")
  valid_564524 = validateParameter(valid_564524, JInt, required = false,
                                 default = newJInt(60))
  if valid_564524 != nil:
    section.add "timeout", valid_564524
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564525: Call_GetComposeApplicationStatusList_564518;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status about the compose applications that were created or in the process of being created in the Service Fabric cluster. The response includes the name, status and other details about the compose application. If the applications do not fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page.
  ## 
  let valid = call_564525.validator(path, query, header, formData, body)
  let scheme = call_564525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564525.url(scheme.get, call_564525.host, call_564525.base,
                         call_564525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564525, url, valid)

proc call*(call_564526: Call_GetComposeApplicationStatusList_564518;
          ContinuationToken: string = ""; MaxResults: int = 0;
          apiVersion: string = "4.0-preview"; timeout: int = 60): Recallable =
  ## getComposeApplicationStatusList
  ## Gets the status about the compose applications that were created or in the process of being created in the Service Fabric cluster. The response includes the name, status and other details about the compose application. If the applications do not fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page.
  ##   ContinuationToken: string
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   MaxResults: int
  ##             : The maximum number of results to be returned as part of the paged queries. This parameter defines the upper bound on the number of results returned. The results returned can be less than the specified maximum results if they do not fit in the message as per the max message size restrictions defined in the configuration. If this parameter is zero or not specified, the paged queries includes as much results as possible that fit in the return message.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "4.0-preview".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  var query_564527 = newJObject()
  add(query_564527, "ContinuationToken", newJString(ContinuationToken))
  add(query_564527, "MaxResults", newJInt(MaxResults))
  add(query_564527, "api-version", newJString(apiVersion))
  add(query_564527, "timeout", newJInt(timeout))
  result = call_564526.call(nil, query_564527, nil, nil, nil)

var getComposeApplicationStatusList* = Call_GetComposeApplicationStatusList_564518(
    name: "getComposeApplicationStatusList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ComposeDeployments",
    validator: validate_GetComposeApplicationStatusList_564519, base: "",
    url: url_GetComposeApplicationStatusList_564520,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_CreateComposeApplication_564528 = ref object of OpenApiRestCall_563564
proc url_CreateComposeApplication_564530(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CreateComposeApplication_564529(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Service Fabric compose application.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "4.0-preview".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564531 = query.getOrDefault("api-version")
  valid_564531 = validateParameter(valid_564531, JString, required = true,
                                 default = newJString("4.0-preview"))
  if valid_564531 != nil:
    section.add "api-version", valid_564531
  var valid_564532 = query.getOrDefault("timeout")
  valid_564532 = validateParameter(valid_564532, JInt, required = false,
                                 default = newJInt(60))
  if valid_564532 != nil:
    section.add "timeout", valid_564532
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   CreateComposeApplicationDescription: JObject (required)
  ##                                      : Describes the compose application that needs to be created.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564534: Call_CreateComposeApplication_564528; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Service Fabric compose application.
  ## 
  let valid = call_564534.validator(path, query, header, formData, body)
  let scheme = call_564534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564534.url(scheme.get, call_564534.host, call_564534.base,
                         call_564534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564534, url, valid)

proc call*(call_564535: Call_CreateComposeApplication_564528;
          CreateComposeApplicationDescription: JsonNode;
          apiVersion: string = "4.0-preview"; timeout: int = 60): Recallable =
  ## createComposeApplication
  ## Creates a Service Fabric compose application.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "4.0-preview".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   CreateComposeApplicationDescription: JObject (required)
  ##                                      : Describes the compose application that needs to be created.
  var query_564536 = newJObject()
  var body_564537 = newJObject()
  add(query_564536, "api-version", newJString(apiVersion))
  add(query_564536, "timeout", newJInt(timeout))
  if CreateComposeApplicationDescription != nil:
    body_564537 = CreateComposeApplicationDescription
  result = call_564535.call(nil, query_564536, nil, nil, body_564537)

var createComposeApplication* = Call_CreateComposeApplication_564528(
    name: "createComposeApplication", meth: HttpMethod.HttpPut,
    host: "azure.local:19080", route: "/ComposeDeployments/$/Create",
    validator: validate_CreateComposeApplication_564529, base: "",
    url: url_CreateComposeApplication_564530, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetComposeApplicationStatus_564538 = ref object of OpenApiRestCall_563564
proc url_GetComposeApplicationStatus_564540(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/ComposeDeployments/"),
               (kind: VariableSegment, value: "applicationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetComposeApplicationStatus_564539(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the status of compose application that was created or in the process of being created in the Service Fabric cluster and whose name matches the one specified as the parameter. The response includes the name, status and other details about the application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_564541 = path.getOrDefault("applicationId")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "applicationId", valid_564541
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "4.0-preview".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564542 = query.getOrDefault("api-version")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = newJString("4.0-preview"))
  if valid_564542 != nil:
    section.add "api-version", valid_564542
  var valid_564543 = query.getOrDefault("timeout")
  valid_564543 = validateParameter(valid_564543, JInt, required = false,
                                 default = newJInt(60))
  if valid_564543 != nil:
    section.add "timeout", valid_564543
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564544: Call_GetComposeApplicationStatus_564538; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the status of compose application that was created or in the process of being created in the Service Fabric cluster and whose name matches the one specified as the parameter. The response includes the name, status and other details about the application.
  ## 
  let valid = call_564544.validator(path, query, header, formData, body)
  let scheme = call_564544.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564544.url(scheme.get, call_564544.host, call_564544.base,
                         call_564544.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564544, url, valid)

proc call*(call_564545: Call_GetComposeApplicationStatus_564538;
          applicationId: string; apiVersion: string = "4.0-preview"; timeout: int = 60): Recallable =
  ## getComposeApplicationStatus
  ## Returns the status of compose application that was created or in the process of being created in the Service Fabric cluster and whose name matches the one specified as the parameter. The response includes the name, status and other details about the application.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "4.0-preview".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564546 = newJObject()
  var query_564547 = newJObject()
  add(query_564547, "api-version", newJString(apiVersion))
  add(query_564547, "timeout", newJInt(timeout))
  add(path_564546, "applicationId", newJString(applicationId))
  result = call_564545.call(path_564546, query_564547, nil, nil, nil)

var getComposeApplicationStatus* = Call_GetComposeApplicationStatus_564538(
    name: "getComposeApplicationStatus", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ComposeDeployments/{applicationId}",
    validator: validate_GetComposeApplicationStatus_564539, base: "",
    url: url_GetComposeApplicationStatus_564540,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_RemoveComposeApplication_564548 = ref object of OpenApiRestCall_563564
proc url_RemoveComposeApplication_564550(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/ComposeDeployments/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/Delete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemoveComposeApplication_564549(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Service Fabric compose application. An application must be created before it can be deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_564551 = path.getOrDefault("applicationId")
  valid_564551 = validateParameter(valid_564551, JString, required = true,
                                 default = nil)
  if valid_564551 != nil:
    section.add "applicationId", valid_564551
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "4.0-preview".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564552 = query.getOrDefault("api-version")
  valid_564552 = validateParameter(valid_564552, JString, required = true,
                                 default = newJString("4.0-preview"))
  if valid_564552 != nil:
    section.add "api-version", valid_564552
  var valid_564553 = query.getOrDefault("timeout")
  valid_564553 = validateParameter(valid_564553, JInt, required = false,
                                 default = newJInt(60))
  if valid_564553 != nil:
    section.add "timeout", valid_564553
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564554: Call_RemoveComposeApplication_564548; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Service Fabric compose application. An application must be created before it can be deleted.
  ## 
  let valid = call_564554.validator(path, query, header, formData, body)
  let scheme = call_564554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564554.url(scheme.get, call_564554.host, call_564554.base,
                         call_564554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564554, url, valid)

proc call*(call_564555: Call_RemoveComposeApplication_564548;
          applicationId: string; apiVersion: string = "4.0-preview"; timeout: int = 60): Recallable =
  ## removeComposeApplication
  ## Deletes an existing Service Fabric compose application. An application must be created before it can be deleted.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "4.0-preview".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564556 = newJObject()
  var query_564557 = newJObject()
  add(query_564557, "api-version", newJString(apiVersion))
  add(query_564557, "timeout", newJInt(timeout))
  add(path_564556, "applicationId", newJString(applicationId))
  result = call_564555.call(path_564556, query_564557, nil, nil, nil)

var removeComposeApplication* = Call_RemoveComposeApplication_564548(
    name: "removeComposeApplication", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/ComposeDeployments/{applicationId}/$/Delete",
    validator: validate_RemoveComposeApplication_564549, base: "",
    url: url_RemoveComposeApplication_564550, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetFaultOperationList_564558 = ref object of OpenApiRestCall_563564
proc url_GetFaultOperationList_564560(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetFaultOperationList_564559(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the a list of user-induced fault operations filtered by provided input.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   TypeFilter: JInt (required)
  ##             : Used to filter on OperationType for user-induced operations.
  ## 65535 - select all
  ## 1     - select PartitionDataLoss.
  ## 2     - select PartitionQuorumLoss.
  ## 4     - select PartitionRestart.
  ## 8     - select NodeTransition.
  ## 
  ##   StateFilter: JInt (required)
  ##              : Used to filter on OperationState's for user-induced operations.
  ## 65535 - select All
  ## 1     - select Running
  ## 2     - select RollingBack
  ## 8     - select Completed
  ## 16    - select Faulted
  ## 32    - select Cancelled
  ## 64    - select ForceCancelled
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564561 = query.getOrDefault("api-version")
  valid_564561 = validateParameter(valid_564561, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564561 != nil:
    section.add "api-version", valid_564561
  var valid_564562 = query.getOrDefault("timeout")
  valid_564562 = validateParameter(valid_564562, JInt, required = false,
                                 default = newJInt(60))
  if valid_564562 != nil:
    section.add "timeout", valid_564562
  var valid_564563 = query.getOrDefault("TypeFilter")
  valid_564563 = validateParameter(valid_564563, JInt, required = true,
                                 default = newJInt(65535))
  if valid_564563 != nil:
    section.add "TypeFilter", valid_564563
  var valid_564564 = query.getOrDefault("StateFilter")
  valid_564564 = validateParameter(valid_564564, JInt, required = true,
                                 default = newJInt(65535))
  if valid_564564 != nil:
    section.add "StateFilter", valid_564564
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564565: Call_GetFaultOperationList_564558; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the a list of user-induced fault operations filtered by provided input.
  ## 
  let valid = call_564565.validator(path, query, header, formData, body)
  let scheme = call_564565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564565.url(scheme.get, call_564565.host, call_564565.base,
                         call_564565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564565, url, valid)

proc call*(call_564566: Call_GetFaultOperationList_564558;
          apiVersion: string = "3.0"; timeout: int = 60; TypeFilter: int = 65535;
          StateFilter: int = 65535): Recallable =
  ## getFaultOperationList
  ## Gets the a list of user-induced fault operations filtered by provided input.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   TypeFilter: int (required)
  ##             : Used to filter on OperationType for user-induced operations.
  ## 65535 - select all
  ## 1     - select PartitionDataLoss.
  ## 2     - select PartitionQuorumLoss.
  ## 4     - select PartitionRestart.
  ## 8     - select NodeTransition.
  ## 
  ##   StateFilter: int (required)
  ##              : Used to filter on OperationState's for user-induced operations.
  ## 65535 - select All
  ## 1     - select Running
  ## 2     - select RollingBack
  ## 8     - select Completed
  ## 16    - select Faulted
  ## 32    - select Cancelled
  ## 64    - select ForceCancelled
  ## 
  var query_564567 = newJObject()
  add(query_564567, "api-version", newJString(apiVersion))
  add(query_564567, "timeout", newJInt(timeout))
  add(query_564567, "TypeFilter", newJInt(TypeFilter))
  add(query_564567, "StateFilter", newJInt(StateFilter))
  result = call_564566.call(nil, query_564567, nil, nil, nil)

var getFaultOperationList* = Call_GetFaultOperationList_564558(
    name: "getFaultOperationList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Faults/",
    validator: validate_GetFaultOperationList_564559, base: "",
    url: url_GetFaultOperationList_564560, schemes: {Scheme.Https, Scheme.Http})
type
  Call_CancelOperation_564568 = ref object of OpenApiRestCall_563564
proc url_CancelOperation_564570(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CancelOperation_564569(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## The following is a list of APIs that start fault operations that may be cancelled using CancelOperation -
  ## - StartDataLoss
  ## - StartQuorumLoss
  ## - StartPartitionRestart
  ## - StartNodeTransition
  ## 
  ## If force is false, then the specified user-induced operation will be gracefully stopped and cleaned up.  If force is true, the command will be aborted, and some internal state
  ## may be left behind.  Specifying force as true should be used with care.  Calling this API with force set to true is not allowed until this API has already
  ## been called on the same test command with force set to false first, or unless the test command already has an OperationState of OperationState.RollingBack.
  ## Clarification: OperationState.RollingBack means that the system will/is be cleaning up internal system state caused by executing the command.  It will not restore data if the
  ## test command was to cause data loss.  For example, if you call StartDataLoss then call this API, the system will only clean up internal state from running the command.
  ## It will not restore the target partition's data, if the command progressed far enough to cause data loss.
  ## 
  ## Important note:  if this API is invoked with force==true, internal state may be left behind.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   Force: JBool (required)
  ##        : Indicates whether to gracefully rollback and clean up internal system state modified by executing the user-induced operation.
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `OperationId` field"
  var valid_564571 = query.getOrDefault("OperationId")
  valid_564571 = validateParameter(valid_564571, JString, required = true,
                                 default = nil)
  if valid_564571 != nil:
    section.add "OperationId", valid_564571
  var valid_564572 = query.getOrDefault("api-version")
  valid_564572 = validateParameter(valid_564572, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564572 != nil:
    section.add "api-version", valid_564572
  var valid_564573 = query.getOrDefault("Force")
  valid_564573 = validateParameter(valid_564573, JBool, required = true,
                                 default = newJBool(false))
  if valid_564573 != nil:
    section.add "Force", valid_564573
  var valid_564574 = query.getOrDefault("timeout")
  valid_564574 = validateParameter(valid_564574, JInt, required = false,
                                 default = newJInt(60))
  if valid_564574 != nil:
    section.add "timeout", valid_564574
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564575: Call_CancelOperation_564568; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The following is a list of APIs that start fault operations that may be cancelled using CancelOperation -
  ## - StartDataLoss
  ## - StartQuorumLoss
  ## - StartPartitionRestart
  ## - StartNodeTransition
  ## 
  ## If force is false, then the specified user-induced operation will be gracefully stopped and cleaned up.  If force is true, the command will be aborted, and some internal state
  ## may be left behind.  Specifying force as true should be used with care.  Calling this API with force set to true is not allowed until this API has already
  ## been called on the same test command with force set to false first, or unless the test command already has an OperationState of OperationState.RollingBack.
  ## Clarification: OperationState.RollingBack means that the system will/is be cleaning up internal system state caused by executing the command.  It will not restore data if the
  ## test command was to cause data loss.  For example, if you call StartDataLoss then call this API, the system will only clean up internal state from running the command.
  ## It will not restore the target partition's data, if the command progressed far enough to cause data loss.
  ## 
  ## Important note:  if this API is invoked with force==true, internal state may be left behind.
  ## 
  ## 
  let valid = call_564575.validator(path, query, header, formData, body)
  let scheme = call_564575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564575.url(scheme.get, call_564575.host, call_564575.base,
                         call_564575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564575, url, valid)

proc call*(call_564576: Call_CancelOperation_564568; OperationId: string;
          apiVersion: string = "3.0"; Force: bool = false; timeout: int = 60): Recallable =
  ## cancelOperation
  ## The following is a list of APIs that start fault operations that may be cancelled using CancelOperation -
  ## - StartDataLoss
  ## - StartQuorumLoss
  ## - StartPartitionRestart
  ## - StartNodeTransition
  ## 
  ## If force is false, then the specified user-induced operation will be gracefully stopped and cleaned up.  If force is true, the command will be aborted, and some internal state
  ## may be left behind.  Specifying force as true should be used with care.  Calling this API with force set to true is not allowed until this API has already
  ## been called on the same test command with force set to false first, or unless the test command already has an OperationState of OperationState.RollingBack.
  ## Clarification: OperationState.RollingBack means that the system will/is be cleaning up internal system state caused by executing the command.  It will not restore data if the
  ## test command was to cause data loss.  For example, if you call StartDataLoss then call this API, the system will only clean up internal state from running the command.
  ## It will not restore the target partition's data, if the command progressed far enough to cause data loss.
  ## 
  ## Important note:  if this API is invoked with force==true, internal state may be left behind.
  ## 
  ##   OperationId: string (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   Force: bool (required)
  ##        : Indicates whether to gracefully rollback and clean up internal system state modified by executing the user-induced operation.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  var query_564577 = newJObject()
  add(query_564577, "OperationId", newJString(OperationId))
  add(query_564577, "api-version", newJString(apiVersion))
  add(query_564577, "Force", newJBool(Force))
  add(query_564577, "timeout", newJInt(timeout))
  result = call_564576.call(nil, query_564577, nil, nil, nil)

var cancelOperation* = Call_CancelOperation_564568(name: "cancelOperation",
    meth: HttpMethod.HttpPost, host: "azure.local:19080", route: "/Faults/$/Cancel",
    validator: validate_CancelOperation_564569, base: "", url: url_CancelOperation_564570,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetNodeTransitionProgress_564578 = ref object of OpenApiRestCall_563564
proc url_GetNodeTransitionProgress_564580(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Faults/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetTransitionProgress")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetNodeTransitionProgress_564579(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the progress of an operation started with StartNodeTransition using the provided OperationId.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_564581 = path.getOrDefault("nodeName")
  valid_564581 = validateParameter(valid_564581, JString, required = true,
                                 default = nil)
  if valid_564581 != nil:
    section.add "nodeName", valid_564581
  result.add "path", section
  ## parameters in `query` object:
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `OperationId` field"
  var valid_564582 = query.getOrDefault("OperationId")
  valid_564582 = validateParameter(valid_564582, JString, required = true,
                                 default = nil)
  if valid_564582 != nil:
    section.add "OperationId", valid_564582
  var valid_564583 = query.getOrDefault("api-version")
  valid_564583 = validateParameter(valid_564583, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564583 != nil:
    section.add "api-version", valid_564583
  var valid_564584 = query.getOrDefault("timeout")
  valid_564584 = validateParameter(valid_564584, JInt, required = false,
                                 default = newJInt(60))
  if valid_564584 != nil:
    section.add "timeout", valid_564584
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564585: Call_GetNodeTransitionProgress_564578; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the progress of an operation started with StartNodeTransition using the provided OperationId.
  ## 
  ## 
  let valid = call_564585.validator(path, query, header, formData, body)
  let scheme = call_564585.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564585.url(scheme.get, call_564585.host, call_564585.base,
                         call_564585.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564585, url, valid)

proc call*(call_564586: Call_GetNodeTransitionProgress_564578; OperationId: string;
          nodeName: string; apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getNodeTransitionProgress
  ## Gets the progress of an operation started with StartNodeTransition using the provided OperationId.
  ## 
  ##   OperationId: string (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_564587 = newJObject()
  var query_564588 = newJObject()
  add(query_564588, "OperationId", newJString(OperationId))
  add(query_564588, "api-version", newJString(apiVersion))
  add(query_564588, "timeout", newJInt(timeout))
  add(path_564587, "nodeName", newJString(nodeName))
  result = call_564586.call(path_564587, query_564588, nil, nil, nil)

var getNodeTransitionProgress* = Call_GetNodeTransitionProgress_564578(
    name: "getNodeTransitionProgress", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Faults/Nodes/{nodeName}/$/GetTransitionProgress",
    validator: validate_GetNodeTransitionProgress_564579, base: "",
    url: url_GetNodeTransitionProgress_564580,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartNodeTransition_564589 = ref object of OpenApiRestCall_563564
proc url_StartNodeTransition_564591(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Faults/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/StartTransition/")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StartNodeTransition_564590(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Starts or stops a cluster node.  A cluster node is a process, not the OS instance itself.  To start a node, pass in "Start" for the NodeTransitionType parameter.
  ## To stop a node, pass in "Stop" for the NodeTransitionType parameter.  This API starts the operation - when the API returns the node may not have finished transitioning yet.
  ## Call GetNodeTransitionProgress with the same OperationId to get the progress of the operation.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_564592 = path.getOrDefault("nodeName")
  valid_564592 = validateParameter(valid_564592, JString, required = true,
                                 default = nil)
  if valid_564592 != nil:
    section.add "nodeName", valid_564592
  result.add "path", section
  ## parameters in `query` object:
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  ##   NodeInstanceId: JString (required)
  ##                 : The node instance ID of the target node.  This can be determined through GetNodeInfo API.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   StopDurationInSeconds: JInt (required)
  ##                        : The duration, in seconds, to keep the node stopped.  The minimum value is 600, the maximum is 14400.  After this time expires, the node will automatically come back up.
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   NodeTransitionType: JString (required)
  ##                     : Indicates the type of transition to perform.  NodeTransitionType.Start will start a stopped node.  NodeTransitionType.Stop will stop a node that is up.
  ##   - Invalid - Reserved.  Do not pass into API.
  ##   - Start - Transition a stopped node to up.
  ##   - Stop - Transition an up node to stopped.
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `OperationId` field"
  var valid_564593 = query.getOrDefault("OperationId")
  valid_564593 = validateParameter(valid_564593, JString, required = true,
                                 default = nil)
  if valid_564593 != nil:
    section.add "OperationId", valid_564593
  var valid_564594 = query.getOrDefault("NodeInstanceId")
  valid_564594 = validateParameter(valid_564594, JString, required = true,
                                 default = nil)
  if valid_564594 != nil:
    section.add "NodeInstanceId", valid_564594
  var valid_564595 = query.getOrDefault("api-version")
  valid_564595 = validateParameter(valid_564595, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564595 != nil:
    section.add "api-version", valid_564595
  var valid_564596 = query.getOrDefault("StopDurationInSeconds")
  valid_564596 = validateParameter(valid_564596, JInt, required = true, default = nil)
  if valid_564596 != nil:
    section.add "StopDurationInSeconds", valid_564596
  var valid_564597 = query.getOrDefault("timeout")
  valid_564597 = validateParameter(valid_564597, JInt, required = false,
                                 default = newJInt(60))
  if valid_564597 != nil:
    section.add "timeout", valid_564597
  var valid_564598 = query.getOrDefault("NodeTransitionType")
  valid_564598 = validateParameter(valid_564598, JString, required = true,
                                 default = newJString("Invalid"))
  if valid_564598 != nil:
    section.add "NodeTransitionType", valid_564598
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564599: Call_StartNodeTransition_564589; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts or stops a cluster node.  A cluster node is a process, not the OS instance itself.  To start a node, pass in "Start" for the NodeTransitionType parameter.
  ## To stop a node, pass in "Stop" for the NodeTransitionType parameter.  This API starts the operation - when the API returns the node may not have finished transitioning yet.
  ## Call GetNodeTransitionProgress with the same OperationId to get the progress of the operation.
  ## 
  ## 
  let valid = call_564599.validator(path, query, header, formData, body)
  let scheme = call_564599.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564599.url(scheme.get, call_564599.host, call_564599.base,
                         call_564599.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564599, url, valid)

proc call*(call_564600: Call_StartNodeTransition_564589; OperationId: string;
          NodeInstanceId: string; StopDurationInSeconds: int; nodeName: string;
          apiVersion: string = "3.0"; timeout: int = 60;
          NodeTransitionType: string = "Invalid"): Recallable =
  ## startNodeTransition
  ## Starts or stops a cluster node.  A cluster node is a process, not the OS instance itself.  To start a node, pass in "Start" for the NodeTransitionType parameter.
  ## To stop a node, pass in "Stop" for the NodeTransitionType parameter.  This API starts the operation - when the API returns the node may not have finished transitioning yet.
  ## Call GetNodeTransitionProgress with the same OperationId to get the progress of the operation.
  ## 
  ##   OperationId: string (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  ##   NodeInstanceId: string (required)
  ##                 : The node instance ID of the target node.  This can be determined through GetNodeInfo API.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   StopDurationInSeconds: int (required)
  ##                        : The duration, in seconds, to keep the node stopped.  The minimum value is 600, the maximum is 14400.  After this time expires, the node will automatically come back up.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   NodeTransitionType: string (required)
  ##                     : Indicates the type of transition to perform.  NodeTransitionType.Start will start a stopped node.  NodeTransitionType.Stop will stop a node that is up.
  ##   - Invalid - Reserved.  Do not pass into API.
  ##   - Start - Transition a stopped node to up.
  ##   - Stop - Transition an up node to stopped.
  ## 
  var path_564601 = newJObject()
  var query_564602 = newJObject()
  add(query_564602, "OperationId", newJString(OperationId))
  add(query_564602, "NodeInstanceId", newJString(NodeInstanceId))
  add(query_564602, "api-version", newJString(apiVersion))
  add(query_564602, "StopDurationInSeconds", newJInt(StopDurationInSeconds))
  add(query_564602, "timeout", newJInt(timeout))
  add(path_564601, "nodeName", newJString(nodeName))
  add(query_564602, "NodeTransitionType", newJString(NodeTransitionType))
  result = call_564600.call(path_564601, query_564602, nil, nil, nil)

var startNodeTransition* = Call_StartNodeTransition_564589(
    name: "startNodeTransition", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Faults/Nodes/{nodeName}/$/StartTransition/",
    validator: validate_StartNodeTransition_564590, base: "",
    url: url_StartNodeTransition_564591, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDataLossProgress_564603 = ref object of OpenApiRestCall_563564
proc url_GetDataLossProgress_564605(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceId" in path, "`serviceId` is a required path parameter"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Faults/Services/"),
               (kind: VariableSegment, value: "serviceId"),
               (kind: ConstantSegment, value: "/$/GetPartitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetDataLossProgress")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDataLossProgress_564604(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets the progress of a data loss operation started with StartDataLoss, using the OperationId.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  ##   serviceId: JString (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_564606 = path.getOrDefault("partitionId")
  valid_564606 = validateParameter(valid_564606, JString, required = true,
                                 default = nil)
  if valid_564606 != nil:
    section.add "partitionId", valid_564606
  var valid_564607 = path.getOrDefault("serviceId")
  valid_564607 = validateParameter(valid_564607, JString, required = true,
                                 default = nil)
  if valid_564607 != nil:
    section.add "serviceId", valid_564607
  result.add "path", section
  ## parameters in `query` object:
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `OperationId` field"
  var valid_564608 = query.getOrDefault("OperationId")
  valid_564608 = validateParameter(valid_564608, JString, required = true,
                                 default = nil)
  if valid_564608 != nil:
    section.add "OperationId", valid_564608
  var valid_564609 = query.getOrDefault("api-version")
  valid_564609 = validateParameter(valid_564609, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564609 != nil:
    section.add "api-version", valid_564609
  var valid_564610 = query.getOrDefault("timeout")
  valid_564610 = validateParameter(valid_564610, JInt, required = false,
                                 default = newJInt(60))
  if valid_564610 != nil:
    section.add "timeout", valid_564610
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564611: Call_GetDataLossProgress_564603; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the progress of a data loss operation started with StartDataLoss, using the OperationId.
  ## 
  ## 
  let valid = call_564611.validator(path, query, header, formData, body)
  let scheme = call_564611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564611.url(scheme.get, call_564611.host, call_564611.base,
                         call_564611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564611, url, valid)

proc call*(call_564612: Call_GetDataLossProgress_564603; OperationId: string;
          partitionId: string; serviceId: string; apiVersion: string = "3.0";
          timeout: int = 60): Recallable =
  ## getDataLossProgress
  ## Gets the progress of a data loss operation started with StartDataLoss, using the OperationId.
  ## 
  ##   OperationId: string (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_564613 = newJObject()
  var query_564614 = newJObject()
  add(query_564614, "OperationId", newJString(OperationId))
  add(query_564614, "api-version", newJString(apiVersion))
  add(query_564614, "timeout", newJInt(timeout))
  add(path_564613, "partitionId", newJString(partitionId))
  add(path_564613, "serviceId", newJString(serviceId))
  result = call_564612.call(path_564613, query_564614, nil, nil, nil)

var getDataLossProgress* = Call_GetDataLossProgress_564603(
    name: "getDataLossProgress", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Faults/Services/{serviceId}/$/GetPartitions/{partitionId}/$/GetDataLossProgress",
    validator: validate_GetDataLossProgress_564604, base: "",
    url: url_GetDataLossProgress_564605, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetQuorumLossProgress_564615 = ref object of OpenApiRestCall_563564
proc url_GetQuorumLossProgress_564617(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceId" in path, "`serviceId` is a required path parameter"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Faults/Services/"),
               (kind: VariableSegment, value: "serviceId"),
               (kind: ConstantSegment, value: "/$/GetPartitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetQuorumLossProgress")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetQuorumLossProgress_564616(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the progress of a quorum loss operation started with StartQuorumLoss, using the provided OperationId.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  ##   serviceId: JString (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_564618 = path.getOrDefault("partitionId")
  valid_564618 = validateParameter(valid_564618, JString, required = true,
                                 default = nil)
  if valid_564618 != nil:
    section.add "partitionId", valid_564618
  var valid_564619 = path.getOrDefault("serviceId")
  valid_564619 = validateParameter(valid_564619, JString, required = true,
                                 default = nil)
  if valid_564619 != nil:
    section.add "serviceId", valid_564619
  result.add "path", section
  ## parameters in `query` object:
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `OperationId` field"
  var valid_564620 = query.getOrDefault("OperationId")
  valid_564620 = validateParameter(valid_564620, JString, required = true,
                                 default = nil)
  if valid_564620 != nil:
    section.add "OperationId", valid_564620
  var valid_564621 = query.getOrDefault("api-version")
  valid_564621 = validateParameter(valid_564621, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564621 != nil:
    section.add "api-version", valid_564621
  var valid_564622 = query.getOrDefault("timeout")
  valid_564622 = validateParameter(valid_564622, JInt, required = false,
                                 default = newJInt(60))
  if valid_564622 != nil:
    section.add "timeout", valid_564622
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564623: Call_GetQuorumLossProgress_564615; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the progress of a quorum loss operation started with StartQuorumLoss, using the provided OperationId.
  ## 
  ## 
  let valid = call_564623.validator(path, query, header, formData, body)
  let scheme = call_564623.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564623.url(scheme.get, call_564623.host, call_564623.base,
                         call_564623.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564623, url, valid)

proc call*(call_564624: Call_GetQuorumLossProgress_564615; OperationId: string;
          partitionId: string; serviceId: string; apiVersion: string = "3.0";
          timeout: int = 60): Recallable =
  ## getQuorumLossProgress
  ## Gets the progress of a quorum loss operation started with StartQuorumLoss, using the provided OperationId.
  ## 
  ##   OperationId: string (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_564625 = newJObject()
  var query_564626 = newJObject()
  add(query_564626, "OperationId", newJString(OperationId))
  add(query_564626, "api-version", newJString(apiVersion))
  add(query_564626, "timeout", newJInt(timeout))
  add(path_564625, "partitionId", newJString(partitionId))
  add(path_564625, "serviceId", newJString(serviceId))
  result = call_564624.call(path_564625, query_564626, nil, nil, nil)

var getQuorumLossProgress* = Call_GetQuorumLossProgress_564615(
    name: "getQuorumLossProgress", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Faults/Services/{serviceId}/$/GetPartitions/{partitionId}/$/GetQuorumLossProgress",
    validator: validate_GetQuorumLossProgress_564616, base: "",
    url: url_GetQuorumLossProgress_564617, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetPartitionRestartProgress_564627 = ref object of OpenApiRestCall_563564
proc url_GetPartitionRestartProgress_564629(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceId" in path, "`serviceId` is a required path parameter"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Faults/Services/"),
               (kind: VariableSegment, value: "serviceId"),
               (kind: ConstantSegment, value: "/$/GetPartitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetRestartProgress")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetPartitionRestartProgress_564628(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the progress of a PartitionRestart started with StartPartitionRestart using the provided OperationId.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  ##   serviceId: JString (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_564630 = path.getOrDefault("partitionId")
  valid_564630 = validateParameter(valid_564630, JString, required = true,
                                 default = nil)
  if valid_564630 != nil:
    section.add "partitionId", valid_564630
  var valid_564631 = path.getOrDefault("serviceId")
  valid_564631 = validateParameter(valid_564631, JString, required = true,
                                 default = nil)
  if valid_564631 != nil:
    section.add "serviceId", valid_564631
  result.add "path", section
  ## parameters in `query` object:
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `OperationId` field"
  var valid_564632 = query.getOrDefault("OperationId")
  valid_564632 = validateParameter(valid_564632, JString, required = true,
                                 default = nil)
  if valid_564632 != nil:
    section.add "OperationId", valid_564632
  var valid_564633 = query.getOrDefault("api-version")
  valid_564633 = validateParameter(valid_564633, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564633 != nil:
    section.add "api-version", valid_564633
  var valid_564634 = query.getOrDefault("timeout")
  valid_564634 = validateParameter(valid_564634, JInt, required = false,
                                 default = newJInt(60))
  if valid_564634 != nil:
    section.add "timeout", valid_564634
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564635: Call_GetPartitionRestartProgress_564627; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the progress of a PartitionRestart started with StartPartitionRestart using the provided OperationId.
  ## 
  ## 
  let valid = call_564635.validator(path, query, header, formData, body)
  let scheme = call_564635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564635.url(scheme.get, call_564635.host, call_564635.base,
                         call_564635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564635, url, valid)

proc call*(call_564636: Call_GetPartitionRestartProgress_564627;
          OperationId: string; partitionId: string; serviceId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getPartitionRestartProgress
  ## Gets the progress of a PartitionRestart started with StartPartitionRestart using the provided OperationId.
  ## 
  ##   OperationId: string (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_564637 = newJObject()
  var query_564638 = newJObject()
  add(query_564638, "OperationId", newJString(OperationId))
  add(query_564638, "api-version", newJString(apiVersion))
  add(query_564638, "timeout", newJInt(timeout))
  add(path_564637, "partitionId", newJString(partitionId))
  add(path_564637, "serviceId", newJString(serviceId))
  result = call_564636.call(path_564637, query_564638, nil, nil, nil)

var getPartitionRestartProgress* = Call_GetPartitionRestartProgress_564627(
    name: "getPartitionRestartProgress", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Faults/Services/{serviceId}/$/GetPartitions/{partitionId}/$/GetRestartProgress",
    validator: validate_GetPartitionRestartProgress_564628, base: "",
    url: url_GetPartitionRestartProgress_564629,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartDataLoss_564639 = ref object of OpenApiRestCall_563564
proc url_StartDataLoss_564641(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceId" in path, "`serviceId` is a required path parameter"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Faults/Services/"),
               (kind: VariableSegment, value: "serviceId"),
               (kind: ConstantSegment, value: "/$/GetPartitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/StartDataLoss")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StartDataLoss_564640(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## This API will induce data loss for the specified partition. It will trigger a call to the OnDataLoss API of the partition.
  ## Actual data loss will depend on the specified DataLossMode
  ## PartialDataLoss - Only a quorum of replicas are removed and OnDataLoss is triggered for the partition but actual data loss depends on the presence of in-flight replication.
  ## FullDataLoss - All replicas are removed hence all data is lost and OnDataLoss is triggered.
  ## 
  ## This API should only be called with a stateful service as the target.
  ## 
  ## Calling this API with a system service as the target is not advised.
  ## 
  ## Note:  Once this API has been called, it cannot be reversed. Calling CancelOperation will only stop execution and clean up internal system state.
  ## It will not restore data if the command has progressed far enough to cause data loss.
  ## 
  ## Call the GetDataLossProgress API with the same OperationId to return information on the operation started with this API.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  ##   serviceId: JString (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_564642 = path.getOrDefault("partitionId")
  valid_564642 = validateParameter(valid_564642, JString, required = true,
                                 default = nil)
  if valid_564642 != nil:
    section.add "partitionId", valid_564642
  var valid_564643 = path.getOrDefault("serviceId")
  valid_564643 = validateParameter(valid_564643, JString, required = true,
                                 default = nil)
  if valid_564643 != nil:
    section.add "serviceId", valid_564643
  result.add "path", section
  ## parameters in `query` object:
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  ##   DataLossMode: JString (required)
  ##               : This enum is passed to the StartDataLoss API to indicate what type of data loss to induce.
  ## - Invalid - Reserved.  Do not pass into API.
  ## - PartialDataLoss - PartialDataLoss option will cause a quorum of replicas to go down, triggering an OnDataLoss event in the system for the given partition.
  ## - FullDataLoss - FullDataLoss option will drop all the replicas which means that all the data will be lost.
  ## 
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `OperationId` field"
  var valid_564644 = query.getOrDefault("OperationId")
  valid_564644 = validateParameter(valid_564644, JString, required = true,
                                 default = nil)
  if valid_564644 != nil:
    section.add "OperationId", valid_564644
  var valid_564645 = query.getOrDefault("DataLossMode")
  valid_564645 = validateParameter(valid_564645, JString, required = true,
                                 default = newJString("Invalid"))
  if valid_564645 != nil:
    section.add "DataLossMode", valid_564645
  var valid_564646 = query.getOrDefault("api-version")
  valid_564646 = validateParameter(valid_564646, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564646 != nil:
    section.add "api-version", valid_564646
  var valid_564647 = query.getOrDefault("timeout")
  valid_564647 = validateParameter(valid_564647, JInt, required = false,
                                 default = newJInt(60))
  if valid_564647 != nil:
    section.add "timeout", valid_564647
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564648: Call_StartDataLoss_564639; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This API will induce data loss for the specified partition. It will trigger a call to the OnDataLoss API of the partition.
  ## Actual data loss will depend on the specified DataLossMode
  ## PartialDataLoss - Only a quorum of replicas are removed and OnDataLoss is triggered for the partition but actual data loss depends on the presence of in-flight replication.
  ## FullDataLoss - All replicas are removed hence all data is lost and OnDataLoss is triggered.
  ## 
  ## This API should only be called with a stateful service as the target.
  ## 
  ## Calling this API with a system service as the target is not advised.
  ## 
  ## Note:  Once this API has been called, it cannot be reversed. Calling CancelOperation will only stop execution and clean up internal system state.
  ## It will not restore data if the command has progressed far enough to cause data loss.
  ## 
  ## Call the GetDataLossProgress API with the same OperationId to return information on the operation started with this API.
  ## 
  ## 
  let valid = call_564648.validator(path, query, header, formData, body)
  let scheme = call_564648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564648.url(scheme.get, call_564648.host, call_564648.base,
                         call_564648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564648, url, valid)

proc call*(call_564649: Call_StartDataLoss_564639; OperationId: string;
          partitionId: string; serviceId: string; DataLossMode: string = "Invalid";
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## startDataLoss
  ## This API will induce data loss for the specified partition. It will trigger a call to the OnDataLoss API of the partition.
  ## Actual data loss will depend on the specified DataLossMode
  ## PartialDataLoss - Only a quorum of replicas are removed and OnDataLoss is triggered for the partition but actual data loss depends on the presence of in-flight replication.
  ## FullDataLoss - All replicas are removed hence all data is lost and OnDataLoss is triggered.
  ## 
  ## This API should only be called with a stateful service as the target.
  ## 
  ## Calling this API with a system service as the target is not advised.
  ## 
  ## Note:  Once this API has been called, it cannot be reversed. Calling CancelOperation will only stop execution and clean up internal system state.
  ## It will not restore data if the command has progressed far enough to cause data loss.
  ## 
  ## Call the GetDataLossProgress API with the same OperationId to return information on the operation started with this API.
  ## 
  ##   OperationId: string (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  ##   DataLossMode: string (required)
  ##               : This enum is passed to the StartDataLoss API to indicate what type of data loss to induce.
  ## - Invalid - Reserved.  Do not pass into API.
  ## - PartialDataLoss - PartialDataLoss option will cause a quorum of replicas to go down, triggering an OnDataLoss event in the system for the given partition.
  ## - FullDataLoss - FullDataLoss option will drop all the replicas which means that all the data will be lost.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_564650 = newJObject()
  var query_564651 = newJObject()
  add(query_564651, "OperationId", newJString(OperationId))
  add(query_564651, "DataLossMode", newJString(DataLossMode))
  add(query_564651, "api-version", newJString(apiVersion))
  add(query_564651, "timeout", newJInt(timeout))
  add(path_564650, "partitionId", newJString(partitionId))
  add(path_564650, "serviceId", newJString(serviceId))
  result = call_564649.call(path_564650, query_564651, nil, nil, nil)

var startDataLoss* = Call_StartDataLoss_564639(name: "startDataLoss",
    meth: HttpMethod.HttpPost, host: "azure.local:19080", route: "/Faults/Services/{serviceId}/$/GetPartitions/{partitionId}/$/StartDataLoss",
    validator: validate_StartDataLoss_564640, base: "", url: url_StartDataLoss_564641,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartQuorumLoss_564652 = ref object of OpenApiRestCall_563564
proc url_StartQuorumLoss_564654(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceId" in path, "`serviceId` is a required path parameter"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Faults/Services/"),
               (kind: VariableSegment, value: "serviceId"),
               (kind: ConstantSegment, value: "/$/GetPartitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/StartQuorumLoss")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StartQuorumLoss_564653(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Induces quorum loss for a given stateful service partition.  This API is useful for a temporary quorum loss situation on your service.
  ## 
  ## Call the GetQuorumLossProgress API with the same OperationId to return information on the operation started with this API.
  ## 
  ## This can only be called on stateful persisted (HasPersistedState==true) services.  Do not use this API on stateless services or stateful in-memory only services.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  ##   serviceId: JString (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_564655 = path.getOrDefault("partitionId")
  valid_564655 = validateParameter(valid_564655, JString, required = true,
                                 default = nil)
  if valid_564655 != nil:
    section.add "partitionId", valid_564655
  var valid_564656 = path.getOrDefault("serviceId")
  valid_564656 = validateParameter(valid_564656, JString, required = true,
                                 default = nil)
  if valid_564656 != nil:
    section.add "serviceId", valid_564656
  result.add "path", section
  ## parameters in `query` object:
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   QuorumLossDuration: JInt (required)
  ##                     : The amount of time for which the partition will be kept in quorum loss.  This must be specified in seconds.
  ##   QuorumLossMode: JString (required)
  ##                 : This enum is passed to the StartQuorumLoss API to indicate what type of quorum loss to induce.
  ##   - Invalid - Reserved.  Do not pass into API.
  ##   - QuorumReplicas - Partial Quorum loss mode : Minimum number of replicas for a partition will be down that will cause a quorum loss.
  ##   - AllReplicas- Full Quorum loss mode : All replicas for a partition will be down that will cause a quorum loss.
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `OperationId` field"
  var valid_564657 = query.getOrDefault("OperationId")
  valid_564657 = validateParameter(valid_564657, JString, required = true,
                                 default = nil)
  if valid_564657 != nil:
    section.add "OperationId", valid_564657
  var valid_564658 = query.getOrDefault("api-version")
  valid_564658 = validateParameter(valid_564658, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564658 != nil:
    section.add "api-version", valid_564658
  var valid_564659 = query.getOrDefault("timeout")
  valid_564659 = validateParameter(valid_564659, JInt, required = false,
                                 default = newJInt(60))
  if valid_564659 != nil:
    section.add "timeout", valid_564659
  var valid_564660 = query.getOrDefault("QuorumLossDuration")
  valid_564660 = validateParameter(valid_564660, JInt, required = true, default = nil)
  if valid_564660 != nil:
    section.add "QuorumLossDuration", valid_564660
  var valid_564661 = query.getOrDefault("QuorumLossMode")
  valid_564661 = validateParameter(valid_564661, JString, required = true,
                                 default = newJString("Invalid"))
  if valid_564661 != nil:
    section.add "QuorumLossMode", valid_564661
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564662: Call_StartQuorumLoss_564652; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Induces quorum loss for a given stateful service partition.  This API is useful for a temporary quorum loss situation on your service.
  ## 
  ## Call the GetQuorumLossProgress API with the same OperationId to return information on the operation started with this API.
  ## 
  ## This can only be called on stateful persisted (HasPersistedState==true) services.  Do not use this API on stateless services or stateful in-memory only services.
  ## 
  ## 
  let valid = call_564662.validator(path, query, header, formData, body)
  let scheme = call_564662.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564662.url(scheme.get, call_564662.host, call_564662.base,
                         call_564662.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564662, url, valid)

proc call*(call_564663: Call_StartQuorumLoss_564652; OperationId: string;
          partitionId: string; QuorumLossDuration: int; serviceId: string;
          apiVersion: string = "3.0"; timeout: int = 60;
          QuorumLossMode: string = "Invalid"): Recallable =
  ## startQuorumLoss
  ## Induces quorum loss for a given stateful service partition.  This API is useful for a temporary quorum loss situation on your service.
  ## 
  ## Call the GetQuorumLossProgress API with the same OperationId to return information on the operation started with this API.
  ## 
  ## This can only be called on stateful persisted (HasPersistedState==true) services.  Do not use this API on stateless services or stateful in-memory only services.
  ## 
  ##   OperationId: string (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  ##   QuorumLossDuration: int (required)
  ##                     : The amount of time for which the partition will be kept in quorum loss.  This must be specified in seconds.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  ##   QuorumLossMode: string (required)
  ##                 : This enum is passed to the StartQuorumLoss API to indicate what type of quorum loss to induce.
  ##   - Invalid - Reserved.  Do not pass into API.
  ##   - QuorumReplicas - Partial Quorum loss mode : Minimum number of replicas for a partition will be down that will cause a quorum loss.
  ##   - AllReplicas- Full Quorum loss mode : All replicas for a partition will be down that will cause a quorum loss.
  ## 
  var path_564664 = newJObject()
  var query_564665 = newJObject()
  add(query_564665, "OperationId", newJString(OperationId))
  add(query_564665, "api-version", newJString(apiVersion))
  add(query_564665, "timeout", newJInt(timeout))
  add(path_564664, "partitionId", newJString(partitionId))
  add(query_564665, "QuorumLossDuration", newJInt(QuorumLossDuration))
  add(path_564664, "serviceId", newJString(serviceId))
  add(query_564665, "QuorumLossMode", newJString(QuorumLossMode))
  result = call_564663.call(path_564664, query_564665, nil, nil, nil)

var startQuorumLoss* = Call_StartQuorumLoss_564652(name: "startQuorumLoss",
    meth: HttpMethod.HttpPost, host: "azure.local:19080", route: "/Faults/Services/{serviceId}/$/GetPartitions/{partitionId}/$/StartQuorumLoss",
    validator: validate_StartQuorumLoss_564653, base: "", url: url_StartQuorumLoss_564654,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartPartitionRestart_564666 = ref object of OpenApiRestCall_563564
proc url_StartPartitionRestart_564668(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceId" in path, "`serviceId` is a required path parameter"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Faults/Services/"),
               (kind: VariableSegment, value: "serviceId"),
               (kind: ConstantSegment, value: "/$/GetPartitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/StartRestart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StartPartitionRestart_564667(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## This API is useful for testing failover.
  ## 
  ## If used to target a stateless service partition, RestartPartitionMode must be AllReplicasOrInstances.
  ## 
  ## Call the GetPartitionRestartProgress API using the same OperationId to get the progress.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  ##   serviceId: JString (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_564669 = path.getOrDefault("partitionId")
  valid_564669 = validateParameter(valid_564669, JString, required = true,
                                 default = nil)
  if valid_564669 != nil:
    section.add "partitionId", valid_564669
  var valid_564670 = path.getOrDefault("serviceId")
  valid_564670 = validateParameter(valid_564670, JString, required = true,
                                 default = nil)
  if valid_564670 != nil:
    section.add "serviceId", valid_564670
  result.add "path", section
  ## parameters in `query` object:
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   RestartPartitionMode: JString (required)
  ##                       : - Invalid - Reserved.  Do not pass into API.
  ## - AllReplicasOrInstances - All replicas or instances in the partition are restarted at once.
  ## - OnlyActiveSecondaries - Only the secondary replicas are restarted.
  ## 
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `OperationId` field"
  var valid_564671 = query.getOrDefault("OperationId")
  valid_564671 = validateParameter(valid_564671, JString, required = true,
                                 default = nil)
  if valid_564671 != nil:
    section.add "OperationId", valid_564671
  var valid_564672 = query.getOrDefault("api-version")
  valid_564672 = validateParameter(valid_564672, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564672 != nil:
    section.add "api-version", valid_564672
  var valid_564673 = query.getOrDefault("RestartPartitionMode")
  valid_564673 = validateParameter(valid_564673, JString, required = true,
                                 default = newJString("Invalid"))
  if valid_564673 != nil:
    section.add "RestartPartitionMode", valid_564673
  var valid_564674 = query.getOrDefault("timeout")
  valid_564674 = validateParameter(valid_564674, JInt, required = false,
                                 default = newJInt(60))
  if valid_564674 != nil:
    section.add "timeout", valid_564674
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564675: Call_StartPartitionRestart_564666; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This API is useful for testing failover.
  ## 
  ## If used to target a stateless service partition, RestartPartitionMode must be AllReplicasOrInstances.
  ## 
  ## Call the GetPartitionRestartProgress API using the same OperationId to get the progress.
  ## 
  ## 
  let valid = call_564675.validator(path, query, header, formData, body)
  let scheme = call_564675.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564675.url(scheme.get, call_564675.host, call_564675.base,
                         call_564675.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564675, url, valid)

proc call*(call_564676: Call_StartPartitionRestart_564666; OperationId: string;
          partitionId: string; serviceId: string; apiVersion: string = "3.0";
          RestartPartitionMode: string = "Invalid"; timeout: int = 60): Recallable =
  ## startPartitionRestart
  ## This API is useful for testing failover.
  ## 
  ## If used to target a stateless service partition, RestartPartitionMode must be AllReplicasOrInstances.
  ## 
  ## Call the GetPartitionRestartProgress API using the same OperationId to get the progress.
  ## 
  ##   OperationId: string (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   RestartPartitionMode: string (required)
  ##                       : - Invalid - Reserved.  Do not pass into API.
  ## - AllReplicasOrInstances - All replicas or instances in the partition are restarted at once.
  ## - OnlyActiveSecondaries - Only the secondary replicas are restarted.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_564677 = newJObject()
  var query_564678 = newJObject()
  add(query_564678, "OperationId", newJString(OperationId))
  add(query_564678, "api-version", newJString(apiVersion))
  add(query_564678, "RestartPartitionMode", newJString(RestartPartitionMode))
  add(query_564678, "timeout", newJInt(timeout))
  add(path_564677, "partitionId", newJString(partitionId))
  add(path_564677, "serviceId", newJString(serviceId))
  result = call_564676.call(path_564677, query_564678, nil, nil, nil)

var startPartitionRestart* = Call_StartPartitionRestart_564666(
    name: "startPartitionRestart", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Faults/Services/{serviceId}/$/GetPartitions/{partitionId}/$/StartRestart",
    validator: validate_StartPartitionRestart_564667, base: "",
    url: url_StartPartitionRestart_564668, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetImageStoreRootContent_564679 = ref object of OpenApiRestCall_563564
proc url_GetImageStoreRootContent_564681(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetImageStoreRootContent_564680(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the information about the image store content at the root of the image store.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564682 = query.getOrDefault("api-version")
  valid_564682 = validateParameter(valid_564682, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564682 != nil:
    section.add "api-version", valid_564682
  var valid_564683 = query.getOrDefault("timeout")
  valid_564683 = validateParameter(valid_564683, JInt, required = false,
                                 default = newJInt(60))
  if valid_564683 != nil:
    section.add "timeout", valid_564683
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564684: Call_GetImageStoreRootContent_564679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the information about the image store content at the root of the image store.
  ## 
  let valid = call_564684.validator(path, query, header, formData, body)
  let scheme = call_564684.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564684.url(scheme.get, call_564684.host, call_564684.base,
                         call_564684.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564684, url, valid)

proc call*(call_564685: Call_GetImageStoreRootContent_564679;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getImageStoreRootContent
  ## Returns the information about the image store content at the root of the image store.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  var query_564686 = newJObject()
  add(query_564686, "api-version", newJString(apiVersion))
  add(query_564686, "timeout", newJInt(timeout))
  result = call_564685.call(nil, query_564686, nil, nil, nil)

var getImageStoreRootContent* = Call_GetImageStoreRootContent_564679(
    name: "getImageStoreRootContent", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ImageStore",
    validator: validate_GetImageStoreRootContent_564680, base: "",
    url: url_GetImageStoreRootContent_564681, schemes: {Scheme.Https, Scheme.Http})
type
  Call_CopyImageStoreContent_564687 = ref object of OpenApiRestCall_563564
proc url_CopyImageStoreContent_564689(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CopyImageStoreContent_564688(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Copies the image store content from the source image store relative path to the destination image store relative path.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564690 = query.getOrDefault("api-version")
  valid_564690 = validateParameter(valid_564690, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564690 != nil:
    section.add "api-version", valid_564690
  var valid_564691 = query.getOrDefault("timeout")
  valid_564691 = validateParameter(valid_564691, JInt, required = false,
                                 default = newJInt(60))
  if valid_564691 != nil:
    section.add "timeout", valid_564691
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ImageStoreCopyDescription: JObject (required)
  ##                            : Describes the copy description for the image store.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564693: Call_CopyImageStoreContent_564687; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies the image store content from the source image store relative path to the destination image store relative path.
  ## 
  let valid = call_564693.validator(path, query, header, formData, body)
  let scheme = call_564693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564693.url(scheme.get, call_564693.host, call_564693.base,
                         call_564693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564693, url, valid)

proc call*(call_564694: Call_CopyImageStoreContent_564687;
          ImageStoreCopyDescription: JsonNode; apiVersion: string = "3.0";
          timeout: int = 60): Recallable =
  ## copyImageStoreContent
  ## Copies the image store content from the source image store relative path to the destination image store relative path.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ImageStoreCopyDescription: JObject (required)
  ##                            : Describes the copy description for the image store.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  var query_564695 = newJObject()
  var body_564696 = newJObject()
  add(query_564695, "api-version", newJString(apiVersion))
  if ImageStoreCopyDescription != nil:
    body_564696 = ImageStoreCopyDescription
  add(query_564695, "timeout", newJInt(timeout))
  result = call_564694.call(nil, query_564695, nil, nil, body_564696)

var copyImageStoreContent* = Call_CopyImageStoreContent_564687(
    name: "copyImageStoreContent", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/ImageStore/$/Copy",
    validator: validate_CopyImageStoreContent_564688, base: "",
    url: url_CopyImageStoreContent_564689, schemes: {Scheme.Https, Scheme.Http})
type
  Call_UploadFile_564707 = ref object of OpenApiRestCall_563564
proc url_UploadFile_564709(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "contentPath" in path, "`contentPath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/ImageStore/"),
               (kind: VariableSegment, value: "contentPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UploadFile_564708(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads contents of the file to the image store. Use this API if the file is small enough to upload again if the connection fails. The file's data needs to be added to the request body. The contents will be uploaded to the specified path.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   contentPath: JString (required)
  ##              : Relative path to file or folder in the image store from its root.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `contentPath` field"
  var valid_564710 = path.getOrDefault("contentPath")
  valid_564710 = validateParameter(valid_564710, JString, required = true,
                                 default = nil)
  if valid_564710 != nil:
    section.add "contentPath", valid_564710
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564711 = query.getOrDefault("api-version")
  valid_564711 = validateParameter(valid_564711, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564711 != nil:
    section.add "api-version", valid_564711
  var valid_564712 = query.getOrDefault("timeout")
  valid_564712 = validateParameter(valid_564712, JInt, required = false,
                                 default = newJInt(60))
  if valid_564712 != nil:
    section.add "timeout", valid_564712
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564713: Call_UploadFile_564707; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads contents of the file to the image store. Use this API if the file is small enough to upload again if the connection fails. The file's data needs to be added to the request body. The contents will be uploaded to the specified path.
  ## 
  let valid = call_564713.validator(path, query, header, formData, body)
  let scheme = call_564713.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564713.url(scheme.get, call_564713.host, call_564713.base,
                         call_564713.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564713, url, valid)

proc call*(call_564714: Call_UploadFile_564707; contentPath: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## uploadFile
  ## Uploads contents of the file to the image store. Use this API if the file is small enough to upload again if the connection fails. The file's data needs to be added to the request body. The contents will be uploaded to the specified path.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   contentPath: string (required)
  ##              : Relative path to file or folder in the image store from its root.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  var path_564715 = newJObject()
  var query_564716 = newJObject()
  add(query_564716, "api-version", newJString(apiVersion))
  add(path_564715, "contentPath", newJString(contentPath))
  add(query_564716, "timeout", newJInt(timeout))
  result = call_564714.call(path_564715, query_564716, nil, nil, nil)

var uploadFile* = Call_UploadFile_564707(name: "uploadFile",
                                      meth: HttpMethod.HttpPut,
                                      host: "azure.local:19080",
                                      route: "/ImageStore/{contentPath}",
                                      validator: validate_UploadFile_564708,
                                      base: "", url: url_UploadFile_564709,
                                      schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetImageStoreContent_564697 = ref object of OpenApiRestCall_563564
proc url_GetImageStoreContent_564699(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "contentPath" in path, "`contentPath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/ImageStore/"),
               (kind: VariableSegment, value: "contentPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetImageStoreContent_564698(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the information about the image store content at the specified contentPath relative to the root of the image store.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   contentPath: JString (required)
  ##              : Relative path to file or folder in the image store from its root.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `contentPath` field"
  var valid_564700 = path.getOrDefault("contentPath")
  valid_564700 = validateParameter(valid_564700, JString, required = true,
                                 default = nil)
  if valid_564700 != nil:
    section.add "contentPath", valid_564700
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564701 = query.getOrDefault("api-version")
  valid_564701 = validateParameter(valid_564701, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564701 != nil:
    section.add "api-version", valid_564701
  var valid_564702 = query.getOrDefault("timeout")
  valid_564702 = validateParameter(valid_564702, JInt, required = false,
                                 default = newJInt(60))
  if valid_564702 != nil:
    section.add "timeout", valid_564702
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564703: Call_GetImageStoreContent_564697; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the information about the image store content at the specified contentPath relative to the root of the image store.
  ## 
  let valid = call_564703.validator(path, query, header, formData, body)
  let scheme = call_564703.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564703.url(scheme.get, call_564703.host, call_564703.base,
                         call_564703.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564703, url, valid)

proc call*(call_564704: Call_GetImageStoreContent_564697; contentPath: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getImageStoreContent
  ## Returns the information about the image store content at the specified contentPath relative to the root of the image store.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   contentPath: string (required)
  ##              : Relative path to file or folder in the image store from its root.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  var path_564705 = newJObject()
  var query_564706 = newJObject()
  add(query_564706, "api-version", newJString(apiVersion))
  add(path_564705, "contentPath", newJString(contentPath))
  add(query_564706, "timeout", newJInt(timeout))
  result = call_564704.call(path_564705, query_564706, nil, nil, nil)

var getImageStoreContent* = Call_GetImageStoreContent_564697(
    name: "getImageStoreContent", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ImageStore/{contentPath}",
    validator: validate_GetImageStoreContent_564698, base: "",
    url: url_GetImageStoreContent_564699, schemes: {Scheme.Https, Scheme.Http})
type
  Call_DeleteImageStoreContent_564717 = ref object of OpenApiRestCall_563564
proc url_DeleteImageStoreContent_564719(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "contentPath" in path, "`contentPath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/ImageStore/"),
               (kind: VariableSegment, value: "contentPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeleteImageStoreContent_564718(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes existing image store content being found within the given image store relative path. This can be used to delete uploaded application packages once they are provisioned.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   contentPath: JString (required)
  ##              : Relative path to file or folder in the image store from its root.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `contentPath` field"
  var valid_564720 = path.getOrDefault("contentPath")
  valid_564720 = validateParameter(valid_564720, JString, required = true,
                                 default = nil)
  if valid_564720 != nil:
    section.add "contentPath", valid_564720
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564721 = query.getOrDefault("api-version")
  valid_564721 = validateParameter(valid_564721, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564721 != nil:
    section.add "api-version", valid_564721
  var valid_564722 = query.getOrDefault("timeout")
  valid_564722 = validateParameter(valid_564722, JInt, required = false,
                                 default = newJInt(60))
  if valid_564722 != nil:
    section.add "timeout", valid_564722
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564723: Call_DeleteImageStoreContent_564717; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes existing image store content being found within the given image store relative path. This can be used to delete uploaded application packages once they are provisioned.
  ## 
  let valid = call_564723.validator(path, query, header, formData, body)
  let scheme = call_564723.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564723.url(scheme.get, call_564723.host, call_564723.base,
                         call_564723.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564723, url, valid)

proc call*(call_564724: Call_DeleteImageStoreContent_564717; contentPath: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## deleteImageStoreContent
  ## Deletes existing image store content being found within the given image store relative path. This can be used to delete uploaded application packages once they are provisioned.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   contentPath: string (required)
  ##              : Relative path to file or folder in the image store from its root.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  var path_564725 = newJObject()
  var query_564726 = newJObject()
  add(query_564726, "api-version", newJString(apiVersion))
  add(path_564725, "contentPath", newJString(contentPath))
  add(query_564726, "timeout", newJInt(timeout))
  result = call_564724.call(path_564725, query_564726, nil, nil, nil)

var deleteImageStoreContent* = Call_DeleteImageStoreContent_564717(
    name: "deleteImageStoreContent", meth: HttpMethod.HttpDelete,
    host: "azure.local:19080", route: "/ImageStore/{contentPath}",
    validator: validate_DeleteImageStoreContent_564718, base: "",
    url: url_DeleteImageStoreContent_564719, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetNodeInfoList_564727 = ref object of OpenApiRestCall_563564
proc url_GetNodeInfoList_564729(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetNodeInfoList_564728(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## The Nodes endpoint returns information about the nodes in the Service Fabric Cluster. The respons include the name, status, id, health, uptime and other details about the node.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   NodeStatusFilter: JString
  ##                   : Allows filtering the nodes based on the NodeStatus. Only the nodes that are matching the specified filter value will be returned. The filter value can be one of the following.
  ## 
  ##   - default - This filter value will match all of the nodes excepts the ones with with status as Unknown or Removed.
  ##   - all - This filter value will match all of the nodes.
  ##   - up - This filter value will match nodes that are Up.
  ##   - down - This filter value will match nodes that are Down.
  ##   - enabling - This filter value will match nodes that are in the process of being enabled with status as Enabling.
  ##   - disabling - This filter value will match nodes that are in the process of being disabled with status as Disabling.
  ##   - disabled - This filter value will match nodes that are Disabled.
  ##   - unknown - This filter value will match nodes whose status is Unknown. A node would be in Unknown state if Service Fabric does not have authoritative information about that node. This can happen if the system learns about a node at runtime.
  ##   - removed - This filter value will match nodes whose status is Removed. These are the nodes that are removed from the cluster using the RemoveNodeState API.
  ## 
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  var valid_564730 = query.getOrDefault("ContinuationToken")
  valid_564730 = validateParameter(valid_564730, JString, required = false,
                                 default = nil)
  if valid_564730 != nil:
    section.add "ContinuationToken", valid_564730
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564731 = query.getOrDefault("api-version")
  valid_564731 = validateParameter(valid_564731, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564731 != nil:
    section.add "api-version", valid_564731
  var valid_564732 = query.getOrDefault("NodeStatusFilter")
  valid_564732 = validateParameter(valid_564732, JString, required = false,
                                 default = newJString("default"))
  if valid_564732 != nil:
    section.add "NodeStatusFilter", valid_564732
  var valid_564733 = query.getOrDefault("timeout")
  valid_564733 = validateParameter(valid_564733, JInt, required = false,
                                 default = newJInt(60))
  if valid_564733 != nil:
    section.add "timeout", valid_564733
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564734: Call_GetNodeInfoList_564727; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Nodes endpoint returns information about the nodes in the Service Fabric Cluster. The respons include the name, status, id, health, uptime and other details about the node.
  ## 
  let valid = call_564734.validator(path, query, header, formData, body)
  let scheme = call_564734.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564734.url(scheme.get, call_564734.host, call_564734.base,
                         call_564734.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564734, url, valid)

proc call*(call_564735: Call_GetNodeInfoList_564727;
          ContinuationToken: string = ""; apiVersion: string = "3.0";
          NodeStatusFilter: string = "default"; timeout: int = 60): Recallable =
  ## getNodeInfoList
  ## The Nodes endpoint returns information about the nodes in the Service Fabric Cluster. The respons include the name, status, id, health, uptime and other details about the node.
  ##   ContinuationToken: string
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   NodeStatusFilter: string
  ##                   : Allows filtering the nodes based on the NodeStatus. Only the nodes that are matching the specified filter value will be returned. The filter value can be one of the following.
  ## 
  ##   - default - This filter value will match all of the nodes excepts the ones with with status as Unknown or Removed.
  ##   - all - This filter value will match all of the nodes.
  ##   - up - This filter value will match nodes that are Up.
  ##   - down - This filter value will match nodes that are Down.
  ##   - enabling - This filter value will match nodes that are in the process of being enabled with status as Enabling.
  ##   - disabling - This filter value will match nodes that are in the process of being disabled with status as Disabling.
  ##   - disabled - This filter value will match nodes that are Disabled.
  ##   - unknown - This filter value will match nodes whose status is Unknown. A node would be in Unknown state if Service Fabric does not have authoritative information about that node. This can happen if the system learns about a node at runtime.
  ##   - removed - This filter value will match nodes whose status is Removed. These are the nodes that are removed from the cluster using the RemoveNodeState API.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  var query_564736 = newJObject()
  add(query_564736, "ContinuationToken", newJString(ContinuationToken))
  add(query_564736, "api-version", newJString(apiVersion))
  add(query_564736, "NodeStatusFilter", newJString(NodeStatusFilter))
  add(query_564736, "timeout", newJInt(timeout))
  result = call_564735.call(nil, query_564736, nil, nil, nil)

var getNodeInfoList* = Call_GetNodeInfoList_564727(name: "getNodeInfoList",
    meth: HttpMethod.HttpGet, host: "azure.local:19080", route: "/Nodes",
    validator: validate_GetNodeInfoList_564728, base: "", url: url_GetNodeInfoList_564729,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetNodeInfo_564737 = ref object of OpenApiRestCall_563564
proc url_GetNodeInfo_564739(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetNodeInfo_564738(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about a specific node in the Service Fabric Cluster.The respons include the name, status, id, health, uptime and other details about the node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_564740 = path.getOrDefault("nodeName")
  valid_564740 = validateParameter(valid_564740, JString, required = true,
                                 default = nil)
  if valid_564740 != nil:
    section.add "nodeName", valid_564740
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564741 = query.getOrDefault("api-version")
  valid_564741 = validateParameter(valid_564741, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564741 != nil:
    section.add "api-version", valid_564741
  var valid_564742 = query.getOrDefault("timeout")
  valid_564742 = validateParameter(valid_564742, JInt, required = false,
                                 default = newJInt(60))
  if valid_564742 != nil:
    section.add "timeout", valid_564742
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564743: Call_GetNodeInfo_564737; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about a specific node in the Service Fabric Cluster.The respons include the name, status, id, health, uptime and other details about the node.
  ## 
  let valid = call_564743.validator(path, query, header, formData, body)
  let scheme = call_564743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564743.url(scheme.get, call_564743.host, call_564743.base,
                         call_564743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564743, url, valid)

proc call*(call_564744: Call_GetNodeInfo_564737; nodeName: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getNodeInfo
  ## Gets the information about a specific node in the Service Fabric Cluster.The respons include the name, status, id, health, uptime and other details about the node.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_564745 = newJObject()
  var query_564746 = newJObject()
  add(query_564746, "api-version", newJString(apiVersion))
  add(query_564746, "timeout", newJInt(timeout))
  add(path_564745, "nodeName", newJString(nodeName))
  result = call_564744.call(path_564745, query_564746, nil, nil, nil)

var getNodeInfo* = Call_GetNodeInfo_564737(name: "getNodeInfo",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local:19080",
                                        route: "/Nodes/{nodeName}",
                                        validator: validate_GetNodeInfo_564738,
                                        base: "", url: url_GetNodeInfo_564739,
                                        schemes: {Scheme.Https, Scheme.Http})
type
  Call_EnableNode_564747 = ref object of OpenApiRestCall_563564
proc url_EnableNode_564749(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/Activate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EnableNode_564748(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Activates a Service Fabric cluster node which is currently deactivated. Once activated, the node will again become a viable target for placing new replicas, and any deactivated replicas remaining on the node will be reactivated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_564750 = path.getOrDefault("nodeName")
  valid_564750 = validateParameter(valid_564750, JString, required = true,
                                 default = nil)
  if valid_564750 != nil:
    section.add "nodeName", valid_564750
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564751 = query.getOrDefault("api-version")
  valid_564751 = validateParameter(valid_564751, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564751 != nil:
    section.add "api-version", valid_564751
  var valid_564752 = query.getOrDefault("timeout")
  valid_564752 = validateParameter(valid_564752, JInt, required = false,
                                 default = newJInt(60))
  if valid_564752 != nil:
    section.add "timeout", valid_564752
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564753: Call_EnableNode_564747; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activates a Service Fabric cluster node which is currently deactivated. Once activated, the node will again become a viable target for placing new replicas, and any deactivated replicas remaining on the node will be reactivated.
  ## 
  let valid = call_564753.validator(path, query, header, formData, body)
  let scheme = call_564753.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564753.url(scheme.get, call_564753.host, call_564753.base,
                         call_564753.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564753, url, valid)

proc call*(call_564754: Call_EnableNode_564747; nodeName: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## enableNode
  ## Activates a Service Fabric cluster node which is currently deactivated. Once activated, the node will again become a viable target for placing new replicas, and any deactivated replicas remaining on the node will be reactivated.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_564755 = newJObject()
  var query_564756 = newJObject()
  add(query_564756, "api-version", newJString(apiVersion))
  add(query_564756, "timeout", newJInt(timeout))
  add(path_564755, "nodeName", newJString(nodeName))
  result = call_564754.call(path_564755, query_564756, nil, nil, nil)

var enableNode* = Call_EnableNode_564747(name: "enableNode",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local:19080",
                                      route: "/Nodes/{nodeName}/$/Activate",
                                      validator: validate_EnableNode_564748,
                                      base: "", url: url_EnableNode_564749,
                                      schemes: {Scheme.Https, Scheme.Http})
type
  Call_DisableNode_564757 = ref object of OpenApiRestCall_563564
proc url_DisableNode_564759(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/Deactivate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DisableNode_564758(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Deactivate a Service Fabric cluster node with the specified deactivation intent. Once the deactivation is in progress, the deactivation intent can be increased, but not decreased (for example, a node which is was deactivated with the Pause intent can be deactivated further with Restart, but not the other way around. Nodes may be reactivated using the Activate a node operation any time after they are deactivated. If the deactivation is not complete this will cancel the deactivation. A node which goes down and comes back up while deactivated will still need to be reactivated before services will be placed on that node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_564760 = path.getOrDefault("nodeName")
  valid_564760 = validateParameter(valid_564760, JString, required = true,
                                 default = nil)
  if valid_564760 != nil:
    section.add "nodeName", valid_564760
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564761 = query.getOrDefault("api-version")
  valid_564761 = validateParameter(valid_564761, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564761 != nil:
    section.add "api-version", valid_564761
  var valid_564762 = query.getOrDefault("timeout")
  valid_564762 = validateParameter(valid_564762, JInt, required = false,
                                 default = newJInt(60))
  if valid_564762 != nil:
    section.add "timeout", valid_564762
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   DeactivationIntentDescription: JObject (required)
  ##                                : Describes the intent or reason for deactivating the node.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564764: Call_DisableNode_564757; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deactivate a Service Fabric cluster node with the specified deactivation intent. Once the deactivation is in progress, the deactivation intent can be increased, but not decreased (for example, a node which is was deactivated with the Pause intent can be deactivated further with Restart, but not the other way around. Nodes may be reactivated using the Activate a node operation any time after they are deactivated. If the deactivation is not complete this will cancel the deactivation. A node which goes down and comes back up while deactivated will still need to be reactivated before services will be placed on that node.
  ## 
  let valid = call_564764.validator(path, query, header, formData, body)
  let scheme = call_564764.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564764.url(scheme.get, call_564764.host, call_564764.base,
                         call_564764.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564764, url, valid)

proc call*(call_564765: Call_DisableNode_564757;
          DeactivationIntentDescription: JsonNode; nodeName: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## disableNode
  ## Deactivate a Service Fabric cluster node with the specified deactivation intent. Once the deactivation is in progress, the deactivation intent can be increased, but not decreased (for example, a node which is was deactivated with the Pause intent can be deactivated further with Restart, but not the other way around. Nodes may be reactivated using the Activate a node operation any time after they are deactivated. If the deactivation is not complete this will cancel the deactivation. A node which goes down and comes back up while deactivated will still need to be reactivated before services will be placed on that node.
  ##   DeactivationIntentDescription: JObject (required)
  ##                                : Describes the intent or reason for deactivating the node.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_564766 = newJObject()
  var query_564767 = newJObject()
  var body_564768 = newJObject()
  if DeactivationIntentDescription != nil:
    body_564768 = DeactivationIntentDescription
  add(query_564767, "api-version", newJString(apiVersion))
  add(query_564767, "timeout", newJInt(timeout))
  add(path_564766, "nodeName", newJString(nodeName))
  result = call_564765.call(path_564766, query_564767, nil, nil, body_564768)

var disableNode* = Call_DisableNode_564757(name: "disableNode",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local:19080", route: "/Nodes/{nodeName}/$/Deactivate",
                                        validator: validate_DisableNode_564758,
                                        base: "", url: url_DisableNode_564759,
                                        schemes: {Scheme.Https, Scheme.Http})
type
  Call_DeployedServicePackageToNode_564769 = ref object of OpenApiRestCall_563564
proc url_DeployedServicePackageToNode_564771(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/DeployServicePackage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeployedServicePackageToNode_564770(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Downloads packages associated with specified service manifest to image cache on specified node.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_564772 = path.getOrDefault("nodeName")
  valid_564772 = validateParameter(valid_564772, JString, required = true,
                                 default = nil)
  if valid_564772 != nil:
    section.add "nodeName", valid_564772
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564773 = query.getOrDefault("api-version")
  valid_564773 = validateParameter(valid_564773, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564773 != nil:
    section.add "api-version", valid_564773
  var valid_564774 = query.getOrDefault("timeout")
  valid_564774 = validateParameter(valid_564774, JInt, required = false,
                                 default = newJInt(60))
  if valid_564774 != nil:
    section.add "timeout", valid_564774
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   DeployServicePackageToNodeDescription: JObject (required)
  ##                                        : Describes information for deploying a service package to a Service Fabric node.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564776: Call_DeployedServicePackageToNode_564769; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Downloads packages associated with specified service manifest to image cache on specified node.
  ## 
  ## 
  let valid = call_564776.validator(path, query, header, formData, body)
  let scheme = call_564776.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564776.url(scheme.get, call_564776.host, call_564776.base,
                         call_564776.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564776, url, valid)

proc call*(call_564777: Call_DeployedServicePackageToNode_564769;
          DeployServicePackageToNodeDescription: JsonNode; nodeName: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## deployedServicePackageToNode
  ## Downloads packages associated with specified service manifest to image cache on specified node.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   DeployServicePackageToNodeDescription: JObject (required)
  ##                                        : Describes information for deploying a service package to a Service Fabric node.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_564778 = newJObject()
  var query_564779 = newJObject()
  var body_564780 = newJObject()
  add(query_564779, "api-version", newJString(apiVersion))
  if DeployServicePackageToNodeDescription != nil:
    body_564780 = DeployServicePackageToNodeDescription
  add(query_564779, "timeout", newJInt(timeout))
  add(path_564778, "nodeName", newJString(nodeName))
  result = call_564777.call(path_564778, query_564779, nil, nil, body_564780)

var deployedServicePackageToNode* = Call_DeployedServicePackageToNode_564769(
    name: "deployedServicePackageToNode", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/DeployServicePackage",
    validator: validate_DeployedServicePackageToNode_564770, base: "",
    url: url_DeployedServicePackageToNode_564771,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedApplicationInfoList_564781 = ref object of OpenApiRestCall_563564
proc url_GetDeployedApplicationInfoList_564783(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDeployedApplicationInfoList_564782(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of applications deployed on a Service Fabric node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_564784 = path.getOrDefault("nodeName")
  valid_564784 = validateParameter(valid_564784, JString, required = true,
                                 default = nil)
  if valid_564784 != nil:
    section.add "nodeName", valid_564784
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564785 = query.getOrDefault("api-version")
  valid_564785 = validateParameter(valid_564785, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564785 != nil:
    section.add "api-version", valid_564785
  var valid_564786 = query.getOrDefault("timeout")
  valid_564786 = validateParameter(valid_564786, JInt, required = false,
                                 default = newJInt(60))
  if valid_564786 != nil:
    section.add "timeout", valid_564786
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564787: Call_GetDeployedApplicationInfoList_564781; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of applications deployed on a Service Fabric node.
  ## 
  let valid = call_564787.validator(path, query, header, formData, body)
  let scheme = call_564787.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564787.url(scheme.get, call_564787.host, call_564787.base,
                         call_564787.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564787, url, valid)

proc call*(call_564788: Call_GetDeployedApplicationInfoList_564781;
          nodeName: string; apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getDeployedApplicationInfoList
  ## Gets the list of applications deployed on a Service Fabric node.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_564789 = newJObject()
  var query_564790 = newJObject()
  add(query_564790, "api-version", newJString(apiVersion))
  add(query_564790, "timeout", newJInt(timeout))
  add(path_564789, "nodeName", newJString(nodeName))
  result = call_564788.call(path_564789, query_564790, nil, nil, nil)

var getDeployedApplicationInfoList* = Call_GetDeployedApplicationInfoList_564781(
    name: "getDeployedApplicationInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications",
    validator: validate_GetDeployedApplicationInfoList_564782, base: "",
    url: url_GetDeployedApplicationInfoList_564783,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedApplicationInfo_564791 = ref object of OpenApiRestCall_563564
proc url_GetDeployedApplicationInfo_564793(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDeployedApplicationInfo_564792(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about an application deployed on a Service Fabric node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_564794 = path.getOrDefault("nodeName")
  valid_564794 = validateParameter(valid_564794, JString, required = true,
                                 default = nil)
  if valid_564794 != nil:
    section.add "nodeName", valid_564794
  var valid_564795 = path.getOrDefault("applicationId")
  valid_564795 = validateParameter(valid_564795, JString, required = true,
                                 default = nil)
  if valid_564795 != nil:
    section.add "applicationId", valid_564795
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564796 = query.getOrDefault("api-version")
  valid_564796 = validateParameter(valid_564796, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564796 != nil:
    section.add "api-version", valid_564796
  var valid_564797 = query.getOrDefault("timeout")
  valid_564797 = validateParameter(valid_564797, JInt, required = false,
                                 default = newJInt(60))
  if valid_564797 != nil:
    section.add "timeout", valid_564797
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564798: Call_GetDeployedApplicationInfo_564791; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about an application deployed on a Service Fabric node.
  ## 
  let valid = call_564798.validator(path, query, header, formData, body)
  let scheme = call_564798.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564798.url(scheme.get, call_564798.host, call_564798.base,
                         call_564798.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564798, url, valid)

proc call*(call_564799: Call_GetDeployedApplicationInfo_564791; nodeName: string;
          applicationId: string; apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getDeployedApplicationInfo
  ## Gets the information about an application deployed on a Service Fabric node.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564800 = newJObject()
  var query_564801 = newJObject()
  add(query_564801, "api-version", newJString(apiVersion))
  add(query_564801, "timeout", newJInt(timeout))
  add(path_564800, "nodeName", newJString(nodeName))
  add(path_564800, "applicationId", newJString(applicationId))
  result = call_564799.call(path_564800, query_564801, nil, nil, nil)

var getDeployedApplicationInfo* = Call_GetDeployedApplicationInfo_564791(
    name: "getDeployedApplicationInfo", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}",
    validator: validate_GetDeployedApplicationInfo_564792, base: "",
    url: url_GetDeployedApplicationInfo_564793,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedCodePackageInfoList_564802 = ref object of OpenApiRestCall_563564
proc url_GetDeployedCodePackageInfoList_564804(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/GetCodePackages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDeployedCodePackageInfoList_564803(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of code packages deployed on a Service Fabric node for the given application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_564805 = path.getOrDefault("nodeName")
  valid_564805 = validateParameter(valid_564805, JString, required = true,
                                 default = nil)
  if valid_564805 != nil:
    section.add "nodeName", valid_564805
  var valid_564806 = path.getOrDefault("applicationId")
  valid_564806 = validateParameter(valid_564806, JString, required = true,
                                 default = nil)
  if valid_564806 != nil:
    section.add "applicationId", valid_564806
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   CodePackageName: JString
  ##                  : The name of code package specified in service manifest registered as part of an application type in a Service Fabric cluster.
  ##   ServiceManifestName: JString
  ##                      : The name of a service manifest registered as part of an application type in a Service Fabric cluster.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564807 = query.getOrDefault("api-version")
  valid_564807 = validateParameter(valid_564807, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564807 != nil:
    section.add "api-version", valid_564807
  var valid_564808 = query.getOrDefault("timeout")
  valid_564808 = validateParameter(valid_564808, JInt, required = false,
                                 default = newJInt(60))
  if valid_564808 != nil:
    section.add "timeout", valid_564808
  var valid_564809 = query.getOrDefault("CodePackageName")
  valid_564809 = validateParameter(valid_564809, JString, required = false,
                                 default = nil)
  if valid_564809 != nil:
    section.add "CodePackageName", valid_564809
  var valid_564810 = query.getOrDefault("ServiceManifestName")
  valid_564810 = validateParameter(valid_564810, JString, required = false,
                                 default = nil)
  if valid_564810 != nil:
    section.add "ServiceManifestName", valid_564810
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564811: Call_GetDeployedCodePackageInfoList_564802; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of code packages deployed on a Service Fabric node for the given application.
  ## 
  let valid = call_564811.validator(path, query, header, formData, body)
  let scheme = call_564811.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564811.url(scheme.get, call_564811.host, call_564811.base,
                         call_564811.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564811, url, valid)

proc call*(call_564812: Call_GetDeployedCodePackageInfoList_564802;
          nodeName: string; applicationId: string; apiVersion: string = "3.0";
          timeout: int = 60; CodePackageName: string = "";
          ServiceManifestName: string = ""): Recallable =
  ## getDeployedCodePackageInfoList
  ## Gets the list of code packages deployed on a Service Fabric node for the given application.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   CodePackageName: string
  ##                  : The name of code package specified in service manifest registered as part of an application type in a Service Fabric cluster.
  ##   ServiceManifestName: string
  ##                      : The name of a service manifest registered as part of an application type in a Service Fabric cluster.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564813 = newJObject()
  var query_564814 = newJObject()
  add(query_564814, "api-version", newJString(apiVersion))
  add(query_564814, "timeout", newJInt(timeout))
  add(path_564813, "nodeName", newJString(nodeName))
  add(query_564814, "CodePackageName", newJString(CodePackageName))
  add(query_564814, "ServiceManifestName", newJString(ServiceManifestName))
  add(path_564813, "applicationId", newJString(applicationId))
  result = call_564812.call(path_564813, query_564814, nil, nil, nil)

var getDeployedCodePackageInfoList* = Call_GetDeployedCodePackageInfoList_564802(
    name: "getDeployedCodePackageInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetCodePackages",
    validator: validate_GetDeployedCodePackageInfoList_564803, base: "",
    url: url_GetDeployedCodePackageInfoList_564804,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_RestartDeployedCodePackage_564815 = ref object of OpenApiRestCall_563564
proc url_RestartDeployedCodePackage_564817(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/GetCodePackages/$/Restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RestartDeployedCodePackage_564816(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Restarts a code package deployed on a Service Fabric node in a cluster. This aborts the code package process, which will restart all the user service replicas hosted in that process.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_564818 = path.getOrDefault("nodeName")
  valid_564818 = validateParameter(valid_564818, JString, required = true,
                                 default = nil)
  if valid_564818 != nil:
    section.add "nodeName", valid_564818
  var valid_564819 = path.getOrDefault("applicationId")
  valid_564819 = validateParameter(valid_564819, JString, required = true,
                                 default = nil)
  if valid_564819 != nil:
    section.add "applicationId", valid_564819
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564820 = query.getOrDefault("api-version")
  valid_564820 = validateParameter(valid_564820, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564820 != nil:
    section.add "api-version", valid_564820
  var valid_564821 = query.getOrDefault("timeout")
  valid_564821 = validateParameter(valid_564821, JInt, required = false,
                                 default = newJInt(60))
  if valid_564821 != nil:
    section.add "timeout", valid_564821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   RestartDeployedCodePackageDescription: JObject (required)
  ##                                        : Describes the deployed code package on Service Fabric node to restart.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564823: Call_RestartDeployedCodePackage_564815; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a code package deployed on a Service Fabric node in a cluster. This aborts the code package process, which will restart all the user service replicas hosted in that process.
  ## 
  let valid = call_564823.validator(path, query, header, formData, body)
  let scheme = call_564823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564823.url(scheme.get, call_564823.host, call_564823.base,
                         call_564823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564823, url, valid)

proc call*(call_564824: Call_RestartDeployedCodePackage_564815; nodeName: string;
          RestartDeployedCodePackageDescription: JsonNode; applicationId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## restartDeployedCodePackage
  ## Restarts a code package deployed on a Service Fabric node in a cluster. This aborts the code package process, which will restart all the user service replicas hosted in that process.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   RestartDeployedCodePackageDescription: JObject (required)
  ##                                        : Describes the deployed code package on Service Fabric node to restart.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564825 = newJObject()
  var query_564826 = newJObject()
  var body_564827 = newJObject()
  add(query_564826, "api-version", newJString(apiVersion))
  add(query_564826, "timeout", newJInt(timeout))
  add(path_564825, "nodeName", newJString(nodeName))
  if RestartDeployedCodePackageDescription != nil:
    body_564827 = RestartDeployedCodePackageDescription
  add(path_564825, "applicationId", newJString(applicationId))
  result = call_564824.call(path_564825, query_564826, nil, nil, body_564827)

var restartDeployedCodePackage* = Call_RestartDeployedCodePackage_564815(
    name: "restartDeployedCodePackage", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetCodePackages/$/Restart",
    validator: validate_RestartDeployedCodePackage_564816, base: "",
    url: url_RestartDeployedCodePackage_564817,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedApplicationHealthUsingPolicy_564841 = ref object of OpenApiRestCall_563564
proc url_GetDeployedApplicationHealthUsingPolicy_564843(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDeployedApplicationHealthUsingPolicy_564842(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about health of an application deployed on a Service Fabric node using the specified policy. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed application based on health state. Use DeployedServicePackagesHealthStateFilter to optionally filter for DeployedServicePackageHealth children based on health state. Use ApplicationHealthPolicy to optionally override the health policies used to evaluate the health. This API only uses 'ConsiderWarningAsError' field of the ApplicationHealthPolicy. The rest of the fields are ignored while evaluating the health of the deployed application.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_564844 = path.getOrDefault("nodeName")
  valid_564844 = validateParameter(valid_564844, JString, required = true,
                                 default = nil)
  if valid_564844 != nil:
    section.add "nodeName", valid_564844
  var valid_564845 = path.getOrDefault("applicationId")
  valid_564845 = validateParameter(valid_564845, JString, required = true,
                                 default = nil)
  if valid_564845 != nil:
    section.add "applicationId", valid_564845
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   DeployedServicePackagesHealthStateFilter: JInt
  ##                                           : Allows filtering of the deployed service package health state objects returned in the result of deployed application health query based on their health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only deployed service packages that match the filter are returned. All deployed service packages are used to evaluate the aggregated health state of the deployed application.
  ## If not specified, all entries are returned.
  ## The state values are flag based enumeration, so the value can be a combination of these value obtained using bitwise 'OR' operator.
  ## For example, if the provided value is 6 then health state of service packages with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   EventsHealthStateFilter: JInt
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564846 = query.getOrDefault("api-version")
  valid_564846 = validateParameter(valid_564846, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564846 != nil:
    section.add "api-version", valid_564846
  var valid_564847 = query.getOrDefault("DeployedServicePackagesHealthStateFilter")
  valid_564847 = validateParameter(valid_564847, JInt, required = false,
                                 default = newJInt(0))
  if valid_564847 != nil:
    section.add "DeployedServicePackagesHealthStateFilter", valid_564847
  var valid_564848 = query.getOrDefault("timeout")
  valid_564848 = validateParameter(valid_564848, JInt, required = false,
                                 default = newJInt(60))
  if valid_564848 != nil:
    section.add "timeout", valid_564848
  var valid_564849 = query.getOrDefault("EventsHealthStateFilter")
  valid_564849 = validateParameter(valid_564849, JInt, required = false,
                                 default = newJInt(0))
  if valid_564849 != nil:
    section.add "EventsHealthStateFilter", valid_564849
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ApplicationHealthPolicy: JObject
  ##                          : Describes the health policies used to evaluate the health of an application or one of its children.
  ## If not present, the health evaluation uses the health policy from application manifest or the default health policy.
  ## 
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564851: Call_GetDeployedApplicationHealthUsingPolicy_564841;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the information about health of an application deployed on a Service Fabric node using the specified policy. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed application based on health state. Use DeployedServicePackagesHealthStateFilter to optionally filter for DeployedServicePackageHealth children based on health state. Use ApplicationHealthPolicy to optionally override the health policies used to evaluate the health. This API only uses 'ConsiderWarningAsError' field of the ApplicationHealthPolicy. The rest of the fields are ignored while evaluating the health of the deployed application.
  ## 
  ## 
  let valid = call_564851.validator(path, query, header, formData, body)
  let scheme = call_564851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564851.url(scheme.get, call_564851.host, call_564851.base,
                         call_564851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564851, url, valid)

proc call*(call_564852: Call_GetDeployedApplicationHealthUsingPolicy_564841;
          nodeName: string; applicationId: string;
          ApplicationHealthPolicy: JsonNode = nil; apiVersion: string = "3.0";
          DeployedServicePackagesHealthStateFilter: int = 0; timeout: int = 60;
          EventsHealthStateFilter: int = 0): Recallable =
  ## getDeployedApplicationHealthUsingPolicy
  ## Gets the information about health of an application deployed on a Service Fabric node using the specified policy. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed application based on health state. Use DeployedServicePackagesHealthStateFilter to optionally filter for DeployedServicePackageHealth children based on health state. Use ApplicationHealthPolicy to optionally override the health policies used to evaluate the health. This API only uses 'ConsiderWarningAsError' field of the ApplicationHealthPolicy. The rest of the fields are ignored while evaluating the health of the deployed application.
  ## 
  ##   ApplicationHealthPolicy: JObject
  ##                          : Describes the health policies used to evaluate the health of an application or one of its children.
  ## If not present, the health evaluation uses the health policy from application manifest or the default health policy.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   DeployedServicePackagesHealthStateFilter: int
  ##                                           : Allows filtering of the deployed service package health state objects returned in the result of deployed application health query based on their health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only deployed service packages that match the filter are returned. All deployed service packages are used to evaluate the aggregated health state of the deployed application.
  ## If not specified, all entries are returned.
  ## The state values are flag based enumeration, so the value can be a combination of these value obtained using bitwise 'OR' operator.
  ## For example, if the provided value is 6 then health state of service packages with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   EventsHealthStateFilter: int
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564853 = newJObject()
  var query_564854 = newJObject()
  var body_564855 = newJObject()
  if ApplicationHealthPolicy != nil:
    body_564855 = ApplicationHealthPolicy
  add(query_564854, "api-version", newJString(apiVersion))
  add(query_564854, "DeployedServicePackagesHealthStateFilter",
      newJInt(DeployedServicePackagesHealthStateFilter))
  add(query_564854, "timeout", newJInt(timeout))
  add(path_564853, "nodeName", newJString(nodeName))
  add(query_564854, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_564853, "applicationId", newJString(applicationId))
  result = call_564852.call(path_564853, query_564854, nil, nil, body_564855)

var getDeployedApplicationHealthUsingPolicy* = Call_GetDeployedApplicationHealthUsingPolicy_564841(
    name: "getDeployedApplicationHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetHealth",
    validator: validate_GetDeployedApplicationHealthUsingPolicy_564842, base: "",
    url: url_GetDeployedApplicationHealthUsingPolicy_564843,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedApplicationHealth_564828 = ref object of OpenApiRestCall_563564
proc url_GetDeployedApplicationHealth_564830(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDeployedApplicationHealth_564829(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about health of an application deployed on a Service Fabric node. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed application based on health state. Use DeployedServicePackagesHealthStateFilter to optionally filter for DeployedServicePackageHealth children based on health state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_564831 = path.getOrDefault("nodeName")
  valid_564831 = validateParameter(valid_564831, JString, required = true,
                                 default = nil)
  if valid_564831 != nil:
    section.add "nodeName", valid_564831
  var valid_564832 = path.getOrDefault("applicationId")
  valid_564832 = validateParameter(valid_564832, JString, required = true,
                                 default = nil)
  if valid_564832 != nil:
    section.add "applicationId", valid_564832
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   DeployedServicePackagesHealthStateFilter: JInt
  ##                                           : Allows filtering of the deployed service package health state objects returned in the result of deployed application health query based on their health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only deployed service packages that match the filter are returned. All deployed service packages are used to evaluate the aggregated health state of the deployed application.
  ## If not specified, all entries are returned.
  ## The state values are flag based enumeration, so the value can be a combination of these value obtained using bitwise 'OR' operator.
  ## For example, if the provided value is 6 then health state of service packages with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   EventsHealthStateFilter: JInt
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564833 = query.getOrDefault("api-version")
  valid_564833 = validateParameter(valid_564833, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564833 != nil:
    section.add "api-version", valid_564833
  var valid_564834 = query.getOrDefault("DeployedServicePackagesHealthStateFilter")
  valid_564834 = validateParameter(valid_564834, JInt, required = false,
                                 default = newJInt(0))
  if valid_564834 != nil:
    section.add "DeployedServicePackagesHealthStateFilter", valid_564834
  var valid_564835 = query.getOrDefault("timeout")
  valid_564835 = validateParameter(valid_564835, JInt, required = false,
                                 default = newJInt(60))
  if valid_564835 != nil:
    section.add "timeout", valid_564835
  var valid_564836 = query.getOrDefault("EventsHealthStateFilter")
  valid_564836 = validateParameter(valid_564836, JInt, required = false,
                                 default = newJInt(0))
  if valid_564836 != nil:
    section.add "EventsHealthStateFilter", valid_564836
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564837: Call_GetDeployedApplicationHealth_564828; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about health of an application deployed on a Service Fabric node. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed application based on health state. Use DeployedServicePackagesHealthStateFilter to optionally filter for DeployedServicePackageHealth children based on health state.
  ## 
  let valid = call_564837.validator(path, query, header, formData, body)
  let scheme = call_564837.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564837.url(scheme.get, call_564837.host, call_564837.base,
                         call_564837.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564837, url, valid)

proc call*(call_564838: Call_GetDeployedApplicationHealth_564828; nodeName: string;
          applicationId: string; apiVersion: string = "3.0";
          DeployedServicePackagesHealthStateFilter: int = 0; timeout: int = 60;
          EventsHealthStateFilter: int = 0): Recallable =
  ## getDeployedApplicationHealth
  ## Gets the information about health of an application deployed on a Service Fabric node. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed application based on health state. Use DeployedServicePackagesHealthStateFilter to optionally filter for DeployedServicePackageHealth children based on health state.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   DeployedServicePackagesHealthStateFilter: int
  ##                                           : Allows filtering of the deployed service package health state objects returned in the result of deployed application health query based on their health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only deployed service packages that match the filter are returned. All deployed service packages are used to evaluate the aggregated health state of the deployed application.
  ## If not specified, all entries are returned.
  ## The state values are flag based enumeration, so the value can be a combination of these value obtained using bitwise 'OR' operator.
  ## For example, if the provided value is 6 then health state of service packages with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   EventsHealthStateFilter: int
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564839 = newJObject()
  var query_564840 = newJObject()
  add(query_564840, "api-version", newJString(apiVersion))
  add(query_564840, "DeployedServicePackagesHealthStateFilter",
      newJInt(DeployedServicePackagesHealthStateFilter))
  add(query_564840, "timeout", newJInt(timeout))
  add(path_564839, "nodeName", newJString(nodeName))
  add(query_564840, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_564839, "applicationId", newJString(applicationId))
  result = call_564838.call(path_564839, query_564840, nil, nil, nil)

var getDeployedApplicationHealth* = Call_GetDeployedApplicationHealth_564828(
    name: "getDeployedApplicationHealth", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetHealth",
    validator: validate_GetDeployedApplicationHealth_564829, base: "",
    url: url_GetDeployedApplicationHealth_564830,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServiceReplicaInfoList_564856 = ref object of OpenApiRestCall_563564
proc url_GetDeployedServiceReplicaInfoList_564858(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/GetReplicas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDeployedServiceReplicaInfoList_564857(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list containing the information about replicas deployed on a Service Fabric node. The information include partition id, replica id, status of the replica, name of the service, name of the service type and other information. Use PartitionId or ServiceManifestName query parameters to return information about the deployed replicas matching the specified values for those parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_564859 = path.getOrDefault("nodeName")
  valid_564859 = validateParameter(valid_564859, JString, required = true,
                                 default = nil)
  if valid_564859 != nil:
    section.add "nodeName", valid_564859
  var valid_564860 = path.getOrDefault("applicationId")
  valid_564860 = validateParameter(valid_564860, JString, required = true,
                                 default = nil)
  if valid_564860 != nil:
    section.add "applicationId", valid_564860
  result.add "path", section
  ## parameters in `query` object:
  ##   PartitionId: JString
  ##              : The identity of the partition.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ServiceManifestName: JString
  ##                      : The name of a service manifest registered as part of an application type in a Service Fabric cluster.
  section = newJObject()
  var valid_564861 = query.getOrDefault("PartitionId")
  valid_564861 = validateParameter(valid_564861, JString, required = false,
                                 default = nil)
  if valid_564861 != nil:
    section.add "PartitionId", valid_564861
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564862 = query.getOrDefault("api-version")
  valid_564862 = validateParameter(valid_564862, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564862 != nil:
    section.add "api-version", valid_564862
  var valid_564863 = query.getOrDefault("timeout")
  valid_564863 = validateParameter(valid_564863, JInt, required = false,
                                 default = newJInt(60))
  if valid_564863 != nil:
    section.add "timeout", valid_564863
  var valid_564864 = query.getOrDefault("ServiceManifestName")
  valid_564864 = validateParameter(valid_564864, JString, required = false,
                                 default = nil)
  if valid_564864 != nil:
    section.add "ServiceManifestName", valid_564864
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564865: Call_GetDeployedServiceReplicaInfoList_564856;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list containing the information about replicas deployed on a Service Fabric node. The information include partition id, replica id, status of the replica, name of the service, name of the service type and other information. Use PartitionId or ServiceManifestName query parameters to return information about the deployed replicas matching the specified values for those parameters.
  ## 
  let valid = call_564865.validator(path, query, header, formData, body)
  let scheme = call_564865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564865.url(scheme.get, call_564865.host, call_564865.base,
                         call_564865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564865, url, valid)

proc call*(call_564866: Call_GetDeployedServiceReplicaInfoList_564856;
          nodeName: string; applicationId: string; PartitionId: string = "";
          apiVersion: string = "3.0"; timeout: int = 60;
          ServiceManifestName: string = ""): Recallable =
  ## getDeployedServiceReplicaInfoList
  ## Gets the list containing the information about replicas deployed on a Service Fabric node. The information include partition id, replica id, status of the replica, name of the service, name of the service type and other information. Use PartitionId or ServiceManifestName query parameters to return information about the deployed replicas matching the specified values for those parameters.
  ##   PartitionId: string
  ##              : The identity of the partition.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   ServiceManifestName: string
  ##                      : The name of a service manifest registered as part of an application type in a Service Fabric cluster.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564867 = newJObject()
  var query_564868 = newJObject()
  add(query_564868, "PartitionId", newJString(PartitionId))
  add(query_564868, "api-version", newJString(apiVersion))
  add(query_564868, "timeout", newJInt(timeout))
  add(path_564867, "nodeName", newJString(nodeName))
  add(query_564868, "ServiceManifestName", newJString(ServiceManifestName))
  add(path_564867, "applicationId", newJString(applicationId))
  result = call_564866.call(path_564867, query_564868, nil, nil, nil)

var getDeployedServiceReplicaInfoList* = Call_GetDeployedServiceReplicaInfoList_564856(
    name: "getDeployedServiceReplicaInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetReplicas",
    validator: validate_GetDeployedServiceReplicaInfoList_564857, base: "",
    url: url_GetDeployedServiceReplicaInfoList_564858,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServicePackageInfoList_564869 = ref object of OpenApiRestCall_563564
proc url_GetDeployedServicePackageInfoList_564871(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/GetServicePackages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDeployedServicePackageInfoList_564870(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the information about the service packages deployed on a Service Fabric node for the given application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_564872 = path.getOrDefault("nodeName")
  valid_564872 = validateParameter(valid_564872, JString, required = true,
                                 default = nil)
  if valid_564872 != nil:
    section.add "nodeName", valid_564872
  var valid_564873 = path.getOrDefault("applicationId")
  valid_564873 = validateParameter(valid_564873, JString, required = true,
                                 default = nil)
  if valid_564873 != nil:
    section.add "applicationId", valid_564873
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564874 = query.getOrDefault("api-version")
  valid_564874 = validateParameter(valid_564874, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564874 != nil:
    section.add "api-version", valid_564874
  var valid_564875 = query.getOrDefault("timeout")
  valid_564875 = validateParameter(valid_564875, JInt, required = false,
                                 default = newJInt(60))
  if valid_564875 != nil:
    section.add "timeout", valid_564875
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564876: Call_GetDeployedServicePackageInfoList_564869;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the information about the service packages deployed on a Service Fabric node for the given application.
  ## 
  let valid = call_564876.validator(path, query, header, formData, body)
  let scheme = call_564876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564876.url(scheme.get, call_564876.host, call_564876.base,
                         call_564876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564876, url, valid)

proc call*(call_564877: Call_GetDeployedServicePackageInfoList_564869;
          nodeName: string; applicationId: string; apiVersion: string = "3.0";
          timeout: int = 60): Recallable =
  ## getDeployedServicePackageInfoList
  ## Returns the information about the service packages deployed on a Service Fabric node for the given application.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564878 = newJObject()
  var query_564879 = newJObject()
  add(query_564879, "api-version", newJString(apiVersion))
  add(query_564879, "timeout", newJInt(timeout))
  add(path_564878, "nodeName", newJString(nodeName))
  add(path_564878, "applicationId", newJString(applicationId))
  result = call_564877.call(path_564878, query_564879, nil, nil, nil)

var getDeployedServicePackageInfoList* = Call_GetDeployedServicePackageInfoList_564869(
    name: "getDeployedServicePackageInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServicePackages",
    validator: validate_GetDeployedServicePackageInfoList_564870, base: "",
    url: url_GetDeployedServicePackageInfoList_564871,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServicePackageInfoListByName_564880 = ref object of OpenApiRestCall_563564
proc url_GetDeployedServicePackageInfoListByName_564882(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  assert "servicePackageName" in path,
        "`servicePackageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/GetServicePackages/"),
               (kind: VariableSegment, value: "servicePackageName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDeployedServicePackageInfoListByName_564881(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the information about the service packages deployed on a Service Fabric node for the given application. These results are of service packages whose name match exactly the service package name specified as the parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   servicePackageName: JString (required)
  ##                     : The name of the service package.
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `servicePackageName` field"
  var valid_564883 = path.getOrDefault("servicePackageName")
  valid_564883 = validateParameter(valid_564883, JString, required = true,
                                 default = nil)
  if valid_564883 != nil:
    section.add "servicePackageName", valid_564883
  var valid_564884 = path.getOrDefault("nodeName")
  valid_564884 = validateParameter(valid_564884, JString, required = true,
                                 default = nil)
  if valid_564884 != nil:
    section.add "nodeName", valid_564884
  var valid_564885 = path.getOrDefault("applicationId")
  valid_564885 = validateParameter(valid_564885, JString, required = true,
                                 default = nil)
  if valid_564885 != nil:
    section.add "applicationId", valid_564885
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564886 = query.getOrDefault("api-version")
  valid_564886 = validateParameter(valid_564886, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564886 != nil:
    section.add "api-version", valid_564886
  var valid_564887 = query.getOrDefault("timeout")
  valid_564887 = validateParameter(valid_564887, JInt, required = false,
                                 default = newJInt(60))
  if valid_564887 != nil:
    section.add "timeout", valid_564887
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564888: Call_GetDeployedServicePackageInfoListByName_564880;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the information about the service packages deployed on a Service Fabric node for the given application. These results are of service packages whose name match exactly the service package name specified as the parameter.
  ## 
  let valid = call_564888.validator(path, query, header, formData, body)
  let scheme = call_564888.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564888.url(scheme.get, call_564888.host, call_564888.base,
                         call_564888.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564888, url, valid)

proc call*(call_564889: Call_GetDeployedServicePackageInfoListByName_564880;
          servicePackageName: string; nodeName: string; applicationId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getDeployedServicePackageInfoListByName
  ## Returns the information about the service packages deployed on a Service Fabric node for the given application. These results are of service packages whose name match exactly the service package name specified as the parameter.
  ##   servicePackageName: string (required)
  ##                     : The name of the service package.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564890 = newJObject()
  var query_564891 = newJObject()
  add(path_564890, "servicePackageName", newJString(servicePackageName))
  add(query_564891, "api-version", newJString(apiVersion))
  add(query_564891, "timeout", newJInt(timeout))
  add(path_564890, "nodeName", newJString(nodeName))
  add(path_564890, "applicationId", newJString(applicationId))
  result = call_564889.call(path_564890, query_564891, nil, nil, nil)

var getDeployedServicePackageInfoListByName* = Call_GetDeployedServicePackageInfoListByName_564880(
    name: "getDeployedServicePackageInfoListByName", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServicePackages/{servicePackageName}",
    validator: validate_GetDeployedServicePackageInfoListByName_564881, base: "",
    url: url_GetDeployedServicePackageInfoListByName_564882,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServicePackageHealthUsingPolicy_564905 = ref object of OpenApiRestCall_563564
proc url_GetDeployedServicePackageHealthUsingPolicy_564907(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  assert "servicePackageName" in path,
        "`servicePackageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/GetServicePackages/"),
               (kind: VariableSegment, value: "servicePackageName"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDeployedServicePackageHealthUsingPolicy_564906(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about health of an service package for a specific application deployed on a Service Fabric node. using the specified policy. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed service package based on health state. Use ApplicationHealthPolicy to optionally override the health policies used to evaluate the health. This API only uses 'ConsiderWarningAsError' field of the ApplicationHealthPolicy. The rest of the fields are ignored while evaluating the health of the deployed service package.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   servicePackageName: JString (required)
  ##                     : The name of the service package.
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `servicePackageName` field"
  var valid_564908 = path.getOrDefault("servicePackageName")
  valid_564908 = validateParameter(valid_564908, JString, required = true,
                                 default = nil)
  if valid_564908 != nil:
    section.add "servicePackageName", valid_564908
  var valid_564909 = path.getOrDefault("nodeName")
  valid_564909 = validateParameter(valid_564909, JString, required = true,
                                 default = nil)
  if valid_564909 != nil:
    section.add "nodeName", valid_564909
  var valid_564910 = path.getOrDefault("applicationId")
  valid_564910 = validateParameter(valid_564910, JString, required = true,
                                 default = nil)
  if valid_564910 != nil:
    section.add "applicationId", valid_564910
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   EventsHealthStateFilter: JInt
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564911 = query.getOrDefault("api-version")
  valid_564911 = validateParameter(valid_564911, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564911 != nil:
    section.add "api-version", valid_564911
  var valid_564912 = query.getOrDefault("timeout")
  valid_564912 = validateParameter(valid_564912, JInt, required = false,
                                 default = newJInt(60))
  if valid_564912 != nil:
    section.add "timeout", valid_564912
  var valid_564913 = query.getOrDefault("EventsHealthStateFilter")
  valid_564913 = validateParameter(valid_564913, JInt, required = false,
                                 default = newJInt(0))
  if valid_564913 != nil:
    section.add "EventsHealthStateFilter", valid_564913
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ApplicationHealthPolicy: JObject
  ##                          : Describes the health policies used to evaluate the health of an application or one of its children.
  ## If not present, the health evaluation uses the health policy from application manifest or the default health policy.
  ## 
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564915: Call_GetDeployedServicePackageHealthUsingPolicy_564905;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the information about health of an service package for a specific application deployed on a Service Fabric node. using the specified policy. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed service package based on health state. Use ApplicationHealthPolicy to optionally override the health policies used to evaluate the health. This API only uses 'ConsiderWarningAsError' field of the ApplicationHealthPolicy. The rest of the fields are ignored while evaluating the health of the deployed service package.
  ## 
  ## 
  let valid = call_564915.validator(path, query, header, formData, body)
  let scheme = call_564915.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564915.url(scheme.get, call_564915.host, call_564915.base,
                         call_564915.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564915, url, valid)

proc call*(call_564916: Call_GetDeployedServicePackageHealthUsingPolicy_564905;
          servicePackageName: string; nodeName: string; applicationId: string;
          ApplicationHealthPolicy: JsonNode = nil; apiVersion: string = "3.0";
          timeout: int = 60; EventsHealthStateFilter: int = 0): Recallable =
  ## getDeployedServicePackageHealthUsingPolicy
  ## Gets the information about health of an service package for a specific application deployed on a Service Fabric node. using the specified policy. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed service package based on health state. Use ApplicationHealthPolicy to optionally override the health policies used to evaluate the health. This API only uses 'ConsiderWarningAsError' field of the ApplicationHealthPolicy. The rest of the fields are ignored while evaluating the health of the deployed service package.
  ## 
  ##   ApplicationHealthPolicy: JObject
  ##                          : Describes the health policies used to evaluate the health of an application or one of its children.
  ## If not present, the health evaluation uses the health policy from application manifest or the default health policy.
  ## 
  ##   servicePackageName: string (required)
  ##                     : The name of the service package.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   EventsHealthStateFilter: int
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564917 = newJObject()
  var query_564918 = newJObject()
  var body_564919 = newJObject()
  if ApplicationHealthPolicy != nil:
    body_564919 = ApplicationHealthPolicy
  add(path_564917, "servicePackageName", newJString(servicePackageName))
  add(query_564918, "api-version", newJString(apiVersion))
  add(query_564918, "timeout", newJInt(timeout))
  add(path_564917, "nodeName", newJString(nodeName))
  add(query_564918, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_564917, "applicationId", newJString(applicationId))
  result = call_564916.call(path_564917, query_564918, nil, nil, body_564919)

var getDeployedServicePackageHealthUsingPolicy* = Call_GetDeployedServicePackageHealthUsingPolicy_564905(
    name: "getDeployedServicePackageHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServicePackages/{servicePackageName}/$/GetHealth",
    validator: validate_GetDeployedServicePackageHealthUsingPolicy_564906,
    base: "", url: url_GetDeployedServicePackageHealthUsingPolicy_564907,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServicePackageHealth_564892 = ref object of OpenApiRestCall_563564
proc url_GetDeployedServicePackageHealth_564894(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  assert "servicePackageName" in path,
        "`servicePackageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/GetServicePackages/"),
               (kind: VariableSegment, value: "servicePackageName"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDeployedServicePackageHealth_564893(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about health of service package for a specific application deployed on a Service Fabric node. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed service package based on health state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   servicePackageName: JString (required)
  ##                     : The name of the service package.
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `servicePackageName` field"
  var valid_564895 = path.getOrDefault("servicePackageName")
  valid_564895 = validateParameter(valid_564895, JString, required = true,
                                 default = nil)
  if valid_564895 != nil:
    section.add "servicePackageName", valid_564895
  var valid_564896 = path.getOrDefault("nodeName")
  valid_564896 = validateParameter(valid_564896, JString, required = true,
                                 default = nil)
  if valid_564896 != nil:
    section.add "nodeName", valid_564896
  var valid_564897 = path.getOrDefault("applicationId")
  valid_564897 = validateParameter(valid_564897, JString, required = true,
                                 default = nil)
  if valid_564897 != nil:
    section.add "applicationId", valid_564897
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   EventsHealthStateFilter: JInt
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564898 = query.getOrDefault("api-version")
  valid_564898 = validateParameter(valid_564898, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564898 != nil:
    section.add "api-version", valid_564898
  var valid_564899 = query.getOrDefault("timeout")
  valid_564899 = validateParameter(valid_564899, JInt, required = false,
                                 default = newJInt(60))
  if valid_564899 != nil:
    section.add "timeout", valid_564899
  var valid_564900 = query.getOrDefault("EventsHealthStateFilter")
  valid_564900 = validateParameter(valid_564900, JInt, required = false,
                                 default = newJInt(0))
  if valid_564900 != nil:
    section.add "EventsHealthStateFilter", valid_564900
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564901: Call_GetDeployedServicePackageHealth_564892;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the information about health of service package for a specific application deployed on a Service Fabric node. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed service package based on health state.
  ## 
  let valid = call_564901.validator(path, query, header, formData, body)
  let scheme = call_564901.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564901.url(scheme.get, call_564901.host, call_564901.base,
                         call_564901.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564901, url, valid)

proc call*(call_564902: Call_GetDeployedServicePackageHealth_564892;
          servicePackageName: string; nodeName: string; applicationId: string;
          apiVersion: string = "3.0"; timeout: int = 60;
          EventsHealthStateFilter: int = 0): Recallable =
  ## getDeployedServicePackageHealth
  ## Gets the information about health of service package for a specific application deployed on a Service Fabric node. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed service package based on health state.
  ##   servicePackageName: string (required)
  ##                     : The name of the service package.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   EventsHealthStateFilter: int
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564903 = newJObject()
  var query_564904 = newJObject()
  add(path_564903, "servicePackageName", newJString(servicePackageName))
  add(query_564904, "api-version", newJString(apiVersion))
  add(query_564904, "timeout", newJInt(timeout))
  add(path_564903, "nodeName", newJString(nodeName))
  add(query_564904, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_564903, "applicationId", newJString(applicationId))
  result = call_564902.call(path_564903, query_564904, nil, nil, nil)

var getDeployedServicePackageHealth* = Call_GetDeployedServicePackageHealth_564892(
    name: "getDeployedServicePackageHealth", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServicePackages/{servicePackageName}/$/GetHealth",
    validator: validate_GetDeployedServicePackageHealth_564893, base: "",
    url: url_GetDeployedServicePackageHealth_564894,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportDeployedServicePackageHealth_564920 = ref object of OpenApiRestCall_563564
proc url_ReportDeployedServicePackageHealth_564922(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  assert "servicePackageName" in path,
        "`servicePackageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/GetServicePackages/"),
               (kind: VariableSegment, value: "servicePackageName"),
               (kind: ConstantSegment, value: "/$/ReportHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportDeployedServicePackageHealth_564921(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reports health state of the service package of the application deployed on a Service Fabric node. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Service, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, get deployed service package health and check that the report appears in the HealthEvents section.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   servicePackageName: JString (required)
  ##                     : The name of the service package.
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `servicePackageName` field"
  var valid_564923 = path.getOrDefault("servicePackageName")
  valid_564923 = validateParameter(valid_564923, JString, required = true,
                                 default = nil)
  if valid_564923 != nil:
    section.add "servicePackageName", valid_564923
  var valid_564924 = path.getOrDefault("nodeName")
  valid_564924 = validateParameter(valid_564924, JString, required = true,
                                 default = nil)
  if valid_564924 != nil:
    section.add "nodeName", valid_564924
  var valid_564925 = path.getOrDefault("applicationId")
  valid_564925 = validateParameter(valid_564925, JString, required = true,
                                 default = nil)
  if valid_564925 != nil:
    section.add "applicationId", valid_564925
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564926 = query.getOrDefault("api-version")
  valid_564926 = validateParameter(valid_564926, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564926 != nil:
    section.add "api-version", valid_564926
  var valid_564927 = query.getOrDefault("timeout")
  valid_564927 = validateParameter(valid_564927, JInt, required = false,
                                 default = newJInt(60))
  if valid_564927 != nil:
    section.add "timeout", valid_564927
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564929: Call_ReportDeployedServicePackageHealth_564920;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reports health state of the service package of the application deployed on a Service Fabric node. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Service, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, get deployed service package health and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_564929.validator(path, query, header, formData, body)
  let scheme = call_564929.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564929.url(scheme.get, call_564929.host, call_564929.base,
                         call_564929.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564929, url, valid)

proc call*(call_564930: Call_ReportDeployedServicePackageHealth_564920;
          servicePackageName: string; HealthInformation: JsonNode; nodeName: string;
          applicationId: string; apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## reportDeployedServicePackageHealth
  ## Reports health state of the service package of the application deployed on a Service Fabric node. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Service, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, get deployed service package health and check that the report appears in the HealthEvents section.
  ## 
  ##   servicePackageName: string (required)
  ##                     : The name of the service package.
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564931 = newJObject()
  var query_564932 = newJObject()
  var body_564933 = newJObject()
  add(path_564931, "servicePackageName", newJString(servicePackageName))
  if HealthInformation != nil:
    body_564933 = HealthInformation
  add(query_564932, "api-version", newJString(apiVersion))
  add(query_564932, "timeout", newJInt(timeout))
  add(path_564931, "nodeName", newJString(nodeName))
  add(path_564931, "applicationId", newJString(applicationId))
  result = call_564930.call(path_564931, query_564932, nil, nil, body_564933)

var reportDeployedServicePackageHealth* = Call_ReportDeployedServicePackageHealth_564920(
    name: "reportDeployedServicePackageHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServicePackages/{servicePackageName}/$/ReportHealth",
    validator: validate_ReportDeployedServicePackageHealth_564921, base: "",
    url: url_ReportDeployedServicePackageHealth_564922,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServiceTypeInfoList_564934 = ref object of OpenApiRestCall_563564
proc url_GetDeployedServiceTypeInfoList_564936(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/GetServiceTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDeployedServiceTypeInfoList_564935(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list containing the information about service types from the applications deployed on a node in a Service Fabric cluster. The response includes the name of the service type, its registration status, the code package that registered it and activation id of the service package.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_564937 = path.getOrDefault("nodeName")
  valid_564937 = validateParameter(valid_564937, JString, required = true,
                                 default = nil)
  if valid_564937 != nil:
    section.add "nodeName", valid_564937
  var valid_564938 = path.getOrDefault("applicationId")
  valid_564938 = validateParameter(valid_564938, JString, required = true,
                                 default = nil)
  if valid_564938 != nil:
    section.add "applicationId", valid_564938
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ServiceManifestName: JString
  ##                      : The name of the service manifest to filter the list of deployed service type information. If specified, the response will only contain the information about service types that are defined in this service manifest.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564939 = query.getOrDefault("api-version")
  valid_564939 = validateParameter(valid_564939, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564939 != nil:
    section.add "api-version", valid_564939
  var valid_564940 = query.getOrDefault("timeout")
  valid_564940 = validateParameter(valid_564940, JInt, required = false,
                                 default = newJInt(60))
  if valid_564940 != nil:
    section.add "timeout", valid_564940
  var valid_564941 = query.getOrDefault("ServiceManifestName")
  valid_564941 = validateParameter(valid_564941, JString, required = false,
                                 default = nil)
  if valid_564941 != nil:
    section.add "ServiceManifestName", valid_564941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564942: Call_GetDeployedServiceTypeInfoList_564934; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list containing the information about service types from the applications deployed on a node in a Service Fabric cluster. The response includes the name of the service type, its registration status, the code package that registered it and activation id of the service package.
  ## 
  let valid = call_564942.validator(path, query, header, formData, body)
  let scheme = call_564942.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564942.url(scheme.get, call_564942.host, call_564942.base,
                         call_564942.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564942, url, valid)

proc call*(call_564943: Call_GetDeployedServiceTypeInfoList_564934;
          nodeName: string; applicationId: string; apiVersion: string = "3.0";
          timeout: int = 60; ServiceManifestName: string = ""): Recallable =
  ## getDeployedServiceTypeInfoList
  ## Gets the list containing the information about service types from the applications deployed on a node in a Service Fabric cluster. The response includes the name of the service type, its registration status, the code package that registered it and activation id of the service package.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   ServiceManifestName: string
  ##                      : The name of the service manifest to filter the list of deployed service type information. If specified, the response will only contain the information about service types that are defined in this service manifest.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564944 = newJObject()
  var query_564945 = newJObject()
  add(query_564945, "api-version", newJString(apiVersion))
  add(query_564945, "timeout", newJInt(timeout))
  add(path_564944, "nodeName", newJString(nodeName))
  add(query_564945, "ServiceManifestName", newJString(ServiceManifestName))
  add(path_564944, "applicationId", newJString(applicationId))
  result = call_564943.call(path_564944, query_564945, nil, nil, nil)

var getDeployedServiceTypeInfoList* = Call_GetDeployedServiceTypeInfoList_564934(
    name: "getDeployedServiceTypeInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServiceTypes",
    validator: validate_GetDeployedServiceTypeInfoList_564935, base: "",
    url: url_GetDeployedServiceTypeInfoList_564936,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServiceTypeInfoByName_564946 = ref object of OpenApiRestCall_563564
proc url_GetDeployedServiceTypeInfoByName_564948(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  assert "serviceTypeName" in path, "`serviceTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/GetServiceTypes/"),
               (kind: VariableSegment, value: "serviceTypeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDeployedServiceTypeInfoByName_564947(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about a specified service type of the application deployed on a node in a Service Fabric cluster. The response includes the name of the service type, its registration status, the code package that registered it and activation id of the service package.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceTypeName: JString (required)
  ##                  : Specifies the name of a Service Fabric service type.
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceTypeName` field"
  var valid_564949 = path.getOrDefault("serviceTypeName")
  valid_564949 = validateParameter(valid_564949, JString, required = true,
                                 default = nil)
  if valid_564949 != nil:
    section.add "serviceTypeName", valid_564949
  var valid_564950 = path.getOrDefault("nodeName")
  valid_564950 = validateParameter(valid_564950, JString, required = true,
                                 default = nil)
  if valid_564950 != nil:
    section.add "nodeName", valid_564950
  var valid_564951 = path.getOrDefault("applicationId")
  valid_564951 = validateParameter(valid_564951, JString, required = true,
                                 default = nil)
  if valid_564951 != nil:
    section.add "applicationId", valid_564951
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ServiceManifestName: JString
  ##                      : The name of the service manifest to filter the list of deployed service type information. If specified, the response will only contain the information about service types that are defined in this service manifest.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564952 = query.getOrDefault("api-version")
  valid_564952 = validateParameter(valid_564952, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564952 != nil:
    section.add "api-version", valid_564952
  var valid_564953 = query.getOrDefault("timeout")
  valid_564953 = validateParameter(valid_564953, JInt, required = false,
                                 default = newJInt(60))
  if valid_564953 != nil:
    section.add "timeout", valid_564953
  var valid_564954 = query.getOrDefault("ServiceManifestName")
  valid_564954 = validateParameter(valid_564954, JString, required = false,
                                 default = nil)
  if valid_564954 != nil:
    section.add "ServiceManifestName", valid_564954
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564955: Call_GetDeployedServiceTypeInfoByName_564946;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the information about a specified service type of the application deployed on a node in a Service Fabric cluster. The response includes the name of the service type, its registration status, the code package that registered it and activation id of the service package.
  ## 
  let valid = call_564955.validator(path, query, header, formData, body)
  let scheme = call_564955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564955.url(scheme.get, call_564955.host, call_564955.base,
                         call_564955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564955, url, valid)

proc call*(call_564956: Call_GetDeployedServiceTypeInfoByName_564946;
          serviceTypeName: string; nodeName: string; applicationId: string;
          apiVersion: string = "3.0"; timeout: int = 60;
          ServiceManifestName: string = ""): Recallable =
  ## getDeployedServiceTypeInfoByName
  ## Gets the information about a specified service type of the application deployed on a node in a Service Fabric cluster. The response includes the name of the service type, its registration status, the code package that registered it and activation id of the service package.
  ##   serviceTypeName: string (required)
  ##                  : Specifies the name of a Service Fabric service type.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   ServiceManifestName: string
  ##                      : The name of the service manifest to filter the list of deployed service type information. If specified, the response will only contain the information about service types that are defined in this service manifest.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564957 = newJObject()
  var query_564958 = newJObject()
  add(path_564957, "serviceTypeName", newJString(serviceTypeName))
  add(query_564958, "api-version", newJString(apiVersion))
  add(query_564958, "timeout", newJInt(timeout))
  add(path_564957, "nodeName", newJString(nodeName))
  add(query_564958, "ServiceManifestName", newJString(ServiceManifestName))
  add(path_564957, "applicationId", newJString(applicationId))
  result = call_564956.call(path_564957, query_564958, nil, nil, nil)

var getDeployedServiceTypeInfoByName* = Call_GetDeployedServiceTypeInfoByName_564946(
    name: "getDeployedServiceTypeInfoByName", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServiceTypes/{serviceTypeName}",
    validator: validate_GetDeployedServiceTypeInfoByName_564947, base: "",
    url: url_GetDeployedServiceTypeInfoByName_564948,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportDeployedApplicationHealth_564959 = ref object of OpenApiRestCall_563564
proc url_ReportDeployedApplicationHealth_564961(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "applicationId" in path, "`applicationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetApplications/"),
               (kind: VariableSegment, value: "applicationId"),
               (kind: ConstantSegment, value: "/$/ReportHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportDeployedApplicationHealth_564960(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reports health state of the application deployed on a Service Fabric node. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Service, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, get deployed application health and check that the report appears in the HealthEvents section.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_564962 = path.getOrDefault("nodeName")
  valid_564962 = validateParameter(valid_564962, JString, required = true,
                                 default = nil)
  if valid_564962 != nil:
    section.add "nodeName", valid_564962
  var valid_564963 = path.getOrDefault("applicationId")
  valid_564963 = validateParameter(valid_564963, JString, required = true,
                                 default = nil)
  if valid_564963 != nil:
    section.add "applicationId", valid_564963
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564964 = query.getOrDefault("api-version")
  valid_564964 = validateParameter(valid_564964, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564964 != nil:
    section.add "api-version", valid_564964
  var valid_564965 = query.getOrDefault("timeout")
  valid_564965 = validateParameter(valid_564965, JInt, required = false,
                                 default = newJInt(60))
  if valid_564965 != nil:
    section.add "timeout", valid_564965
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564967: Call_ReportDeployedApplicationHealth_564959;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reports health state of the application deployed on a Service Fabric node. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Service, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, get deployed application health and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_564967.validator(path, query, header, formData, body)
  let scheme = call_564967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564967.url(scheme.get, call_564967.host, call_564967.base,
                         call_564967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564967, url, valid)

proc call*(call_564968: Call_ReportDeployedApplicationHealth_564959;
          HealthInformation: JsonNode; nodeName: string; applicationId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## reportDeployedApplicationHealth
  ## Reports health state of the application deployed on a Service Fabric node. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Service, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, get deployed application health and check that the report appears in the HealthEvents section.
  ## 
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_564969 = newJObject()
  var query_564970 = newJObject()
  var body_564971 = newJObject()
  if HealthInformation != nil:
    body_564971 = HealthInformation
  add(query_564970, "api-version", newJString(apiVersion))
  add(query_564970, "timeout", newJInt(timeout))
  add(path_564969, "nodeName", newJString(nodeName))
  add(path_564969, "applicationId", newJString(applicationId))
  result = call_564968.call(path_564969, query_564970, nil, nil, body_564971)

var reportDeployedApplicationHealth* = Call_ReportDeployedApplicationHealth_564959(
    name: "reportDeployedApplicationHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/ReportHealth",
    validator: validate_ReportDeployedApplicationHealth_564960, base: "",
    url: url_ReportDeployedApplicationHealth_564961,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetNodeHealthUsingPolicy_564983 = ref object of OpenApiRestCall_563564
proc url_GetNodeHealthUsingPolicy_564985(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetNodeHealthUsingPolicy_564984(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the health of a Service Fabric node. Use EventsHealthStateFilter to filter the collection of health events reported on the node based on the health state. Use ClusterHealthPolicy in the POST body to override the health policies used to evaluate the health. If the node that you specify by name does not exist in the health store, this returns an error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_564986 = path.getOrDefault("nodeName")
  valid_564986 = validateParameter(valid_564986, JString, required = true,
                                 default = nil)
  if valid_564986 != nil:
    section.add "nodeName", valid_564986
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   EventsHealthStateFilter: JInt
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564987 = query.getOrDefault("api-version")
  valid_564987 = validateParameter(valid_564987, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564987 != nil:
    section.add "api-version", valid_564987
  var valid_564988 = query.getOrDefault("timeout")
  valid_564988 = validateParameter(valid_564988, JInt, required = false,
                                 default = newJInt(60))
  if valid_564988 != nil:
    section.add "timeout", valid_564988
  var valid_564989 = query.getOrDefault("EventsHealthStateFilter")
  valid_564989 = validateParameter(valid_564989, JInt, required = false,
                                 default = newJInt(0))
  if valid_564989 != nil:
    section.add "EventsHealthStateFilter", valid_564989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ClusterHealthPolicy: JObject
  ##                      : Describes the health policies used to evaluate the health of a cluster or node. If not present, the health evaluation uses the health policy from cluster manifest or the default health policy.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564991: Call_GetNodeHealthUsingPolicy_564983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric node. Use EventsHealthStateFilter to filter the collection of health events reported on the node based on the health state. Use ClusterHealthPolicy in the POST body to override the health policies used to evaluate the health. If the node that you specify by name does not exist in the health store, this returns an error.
  ## 
  let valid = call_564991.validator(path, query, header, formData, body)
  let scheme = call_564991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564991.url(scheme.get, call_564991.host, call_564991.base,
                         call_564991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564991, url, valid)

proc call*(call_564992: Call_GetNodeHealthUsingPolicy_564983; nodeName: string;
          apiVersion: string = "3.0"; ClusterHealthPolicy: JsonNode = nil;
          timeout: int = 60; EventsHealthStateFilter: int = 0): Recallable =
  ## getNodeHealthUsingPolicy
  ## Gets the health of a Service Fabric node. Use EventsHealthStateFilter to filter the collection of health events reported on the node based on the health state. Use ClusterHealthPolicy in the POST body to override the health policies used to evaluate the health. If the node that you specify by name does not exist in the health store, this returns an error.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ClusterHealthPolicy: JObject
  ##                      : Describes the health policies used to evaluate the health of a cluster or node. If not present, the health evaluation uses the health policy from cluster manifest or the default health policy.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   EventsHealthStateFilter: int
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  var path_564993 = newJObject()
  var query_564994 = newJObject()
  var body_564995 = newJObject()
  add(query_564994, "api-version", newJString(apiVersion))
  if ClusterHealthPolicy != nil:
    body_564995 = ClusterHealthPolicy
  add(query_564994, "timeout", newJInt(timeout))
  add(path_564993, "nodeName", newJString(nodeName))
  add(query_564994, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  result = call_564992.call(path_564993, query_564994, nil, nil, body_564995)

var getNodeHealthUsingPolicy* = Call_GetNodeHealthUsingPolicy_564983(
    name: "getNodeHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetHealth",
    validator: validate_GetNodeHealthUsingPolicy_564984, base: "",
    url: url_GetNodeHealthUsingPolicy_564985, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetNodeHealth_564972 = ref object of OpenApiRestCall_563564
proc url_GetNodeHealth_564974(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetNodeHealth_564973(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the health of a Service Fabric node. Use EventsHealthStateFilter to filter the collection of health events reported on the node based on the health state. If the node that you specify by name does not exist in the health store, this returns an error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_564975 = path.getOrDefault("nodeName")
  valid_564975 = validateParameter(valid_564975, JString, required = true,
                                 default = nil)
  if valid_564975 != nil:
    section.add "nodeName", valid_564975
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   EventsHealthStateFilter: JInt
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564976 = query.getOrDefault("api-version")
  valid_564976 = validateParameter(valid_564976, JString, required = true,
                                 default = newJString("3.0"))
  if valid_564976 != nil:
    section.add "api-version", valid_564976
  var valid_564977 = query.getOrDefault("timeout")
  valid_564977 = validateParameter(valid_564977, JInt, required = false,
                                 default = newJInt(60))
  if valid_564977 != nil:
    section.add "timeout", valid_564977
  var valid_564978 = query.getOrDefault("EventsHealthStateFilter")
  valid_564978 = validateParameter(valid_564978, JInt, required = false,
                                 default = newJInt(0))
  if valid_564978 != nil:
    section.add "EventsHealthStateFilter", valid_564978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564979: Call_GetNodeHealth_564972; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric node. Use EventsHealthStateFilter to filter the collection of health events reported on the node based on the health state. If the node that you specify by name does not exist in the health store, this returns an error.
  ## 
  let valid = call_564979.validator(path, query, header, formData, body)
  let scheme = call_564979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564979.url(scheme.get, call_564979.host, call_564979.base,
                         call_564979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564979, url, valid)

proc call*(call_564980: Call_GetNodeHealth_564972; nodeName: string;
          apiVersion: string = "3.0"; timeout: int = 60;
          EventsHealthStateFilter: int = 0): Recallable =
  ## getNodeHealth
  ## Gets the health of a Service Fabric node. Use EventsHealthStateFilter to filter the collection of health events reported on the node based on the health state. If the node that you specify by name does not exist in the health store, this returns an error.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   EventsHealthStateFilter: int
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  var path_564981 = newJObject()
  var query_564982 = newJObject()
  add(query_564982, "api-version", newJString(apiVersion))
  add(query_564982, "timeout", newJInt(timeout))
  add(path_564981, "nodeName", newJString(nodeName))
  add(query_564982, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  result = call_564980.call(path_564981, query_564982, nil, nil, nil)

var getNodeHealth* = Call_GetNodeHealth_564972(name: "getNodeHealth",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetHealth", validator: validate_GetNodeHealth_564973,
    base: "", url: url_GetNodeHealth_564974, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetNodeLoadInfo_564996 = ref object of OpenApiRestCall_563564
proc url_GetNodeLoadInfo_564998(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetLoadInformation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetNodeLoadInfo_564997(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the load information of a Service Fabric node.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_564999 = path.getOrDefault("nodeName")
  valid_564999 = validateParameter(valid_564999, JString, required = true,
                                 default = nil)
  if valid_564999 != nil:
    section.add "nodeName", valid_564999
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565000 = query.getOrDefault("api-version")
  valid_565000 = validateParameter(valid_565000, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565000 != nil:
    section.add "api-version", valid_565000
  var valid_565001 = query.getOrDefault("timeout")
  valid_565001 = validateParameter(valid_565001, JInt, required = false,
                                 default = newJInt(60))
  if valid_565001 != nil:
    section.add "timeout", valid_565001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565002: Call_GetNodeLoadInfo_564996; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the load information of a Service Fabric node.
  ## 
  let valid = call_565002.validator(path, query, header, formData, body)
  let scheme = call_565002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565002.url(scheme.get, call_565002.host, call_565002.base,
                         call_565002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565002, url, valid)

proc call*(call_565003: Call_GetNodeLoadInfo_564996; nodeName: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getNodeLoadInfo
  ## Gets the load information of a Service Fabric node.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_565004 = newJObject()
  var query_565005 = newJObject()
  add(query_565005, "api-version", newJString(apiVersion))
  add(query_565005, "timeout", newJInt(timeout))
  add(path_565004, "nodeName", newJString(nodeName))
  result = call_565003.call(path_565004, query_565005, nil, nil, nil)

var getNodeLoadInfo* = Call_GetNodeLoadInfo_564996(name: "getNodeLoadInfo",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetLoadInformation",
    validator: validate_GetNodeLoadInfo_564997, base: "", url: url_GetNodeLoadInfo_564998,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_RemoveReplica_565006 = ref object of OpenApiRestCall_563564
proc url_RemoveReplica_565008(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  assert "replicaId" in path, "`replicaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetPartitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetReplicas/"),
               (kind: VariableSegment, value: "replicaId"),
               (kind: ConstantSegment, value: "/$/Delete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemoveReplica_565007(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## This API simulates a Service Fabric replica failure by removing a replica from a Service Fabric cluster. The removal closes the replica, transitions the replica to the role None, and then removes all of the state information of the replica from the cluster. This API tests the replica state removal path, and simulates the report fault permanent path through client APIs. Warning - There are no safety checks performed when this API is used. Incorrect use of this API can lead to data loss for stateful services.In addition, the forceRemove flag impacts all other replicas hosted in the same process.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   replicaId: JString (required)
  ##            : The identifier of the replica.
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `replicaId` field"
  var valid_565009 = path.getOrDefault("replicaId")
  valid_565009 = validateParameter(valid_565009, JString, required = true,
                                 default = nil)
  if valid_565009 != nil:
    section.add "replicaId", valid_565009
  var valid_565010 = path.getOrDefault("nodeName")
  valid_565010 = validateParameter(valid_565010, JString, required = true,
                                 default = nil)
  if valid_565010 != nil:
    section.add "nodeName", valid_565010
  var valid_565011 = path.getOrDefault("partitionId")
  valid_565011 = validateParameter(valid_565011, JString, required = true,
                                 default = nil)
  if valid_565011 != nil:
    section.add "partitionId", valid_565011
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ForceRemove: JBool
  ##              : Remove a Service Fabric application or service forcefully without going through the graceful shutdown sequence. This parameter can be used to forcefully delete an application or service for which delete is timing out due to issues in the service code that prevents graceful close of replicas.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565012 = query.getOrDefault("api-version")
  valid_565012 = validateParameter(valid_565012, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565012 != nil:
    section.add "api-version", valid_565012
  var valid_565013 = query.getOrDefault("timeout")
  valid_565013 = validateParameter(valid_565013, JInt, required = false,
                                 default = newJInt(60))
  if valid_565013 != nil:
    section.add "timeout", valid_565013
  var valid_565014 = query.getOrDefault("ForceRemove")
  valid_565014 = validateParameter(valid_565014, JBool, required = false, default = nil)
  if valid_565014 != nil:
    section.add "ForceRemove", valid_565014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565015: Call_RemoveReplica_565006; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This API simulates a Service Fabric replica failure by removing a replica from a Service Fabric cluster. The removal closes the replica, transitions the replica to the role None, and then removes all of the state information of the replica from the cluster. This API tests the replica state removal path, and simulates the report fault permanent path through client APIs. Warning - There are no safety checks performed when this API is used. Incorrect use of this API can lead to data loss for stateful services.In addition, the forceRemove flag impacts all other replicas hosted in the same process.
  ## 
  let valid = call_565015.validator(path, query, header, formData, body)
  let scheme = call_565015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565015.url(scheme.get, call_565015.host, call_565015.base,
                         call_565015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565015, url, valid)

proc call*(call_565016: Call_RemoveReplica_565006; replicaId: string;
          nodeName: string; partitionId: string; apiVersion: string = "3.0";
          timeout: int = 60; ForceRemove: bool = false): Recallable =
  ## removeReplica
  ## This API simulates a Service Fabric replica failure by removing a replica from a Service Fabric cluster. The removal closes the replica, transitions the replica to the role None, and then removes all of the state information of the replica from the cluster. This API tests the replica state removal path, and simulates the report fault permanent path through client APIs. Warning - There are no safety checks performed when this API is used. Incorrect use of this API can lead to data loss for stateful services.In addition, the forceRemove flag impacts all other replicas hosted in the same process.
  ##   replicaId: string (required)
  ##            : The identifier of the replica.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  ##   ForceRemove: bool
  ##              : Remove a Service Fabric application or service forcefully without going through the graceful shutdown sequence. This parameter can be used to forcefully delete an application or service for which delete is timing out due to issues in the service code that prevents graceful close of replicas.
  var path_565017 = newJObject()
  var query_565018 = newJObject()
  add(path_565017, "replicaId", newJString(replicaId))
  add(query_565018, "api-version", newJString(apiVersion))
  add(query_565018, "timeout", newJInt(timeout))
  add(path_565017, "nodeName", newJString(nodeName))
  add(path_565017, "partitionId", newJString(partitionId))
  add(query_565018, "ForceRemove", newJBool(ForceRemove))
  result = call_565016.call(path_565017, query_565018, nil, nil, nil)

var removeReplica* = Call_RemoveReplica_565006(name: "removeReplica",
    meth: HttpMethod.HttpPost, host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetPartitions/{partitionId}/$/GetReplicas/{replicaId}/$/Delete",
    validator: validate_RemoveReplica_565007, base: "", url: url_RemoveReplica_565008,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServiceReplicaDetailInfo_565019 = ref object of OpenApiRestCall_563564
proc url_GetDeployedServiceReplicaDetailInfo_565021(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  assert "replicaId" in path, "`replicaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetPartitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetReplicas/"),
               (kind: VariableSegment, value: "replicaId"),
               (kind: ConstantSegment, value: "/$/GetDetail")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetDeployedServiceReplicaDetailInfo_565020(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of the replica deployed on a Service Fabric node. The information include service kind, service name, current service operation, current service operation start date time, partition id, replica/instance id, reported load and other information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   replicaId: JString (required)
  ##            : The identifier of the replica.
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `replicaId` field"
  var valid_565022 = path.getOrDefault("replicaId")
  valid_565022 = validateParameter(valid_565022, JString, required = true,
                                 default = nil)
  if valid_565022 != nil:
    section.add "replicaId", valid_565022
  var valid_565023 = path.getOrDefault("nodeName")
  valid_565023 = validateParameter(valid_565023, JString, required = true,
                                 default = nil)
  if valid_565023 != nil:
    section.add "nodeName", valid_565023
  var valid_565024 = path.getOrDefault("partitionId")
  valid_565024 = validateParameter(valid_565024, JString, required = true,
                                 default = nil)
  if valid_565024 != nil:
    section.add "partitionId", valid_565024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565025 = query.getOrDefault("api-version")
  valid_565025 = validateParameter(valid_565025, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565025 != nil:
    section.add "api-version", valid_565025
  var valid_565026 = query.getOrDefault("timeout")
  valid_565026 = validateParameter(valid_565026, JInt, required = false,
                                 default = newJInt(60))
  if valid_565026 != nil:
    section.add "timeout", valid_565026
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565027: Call_GetDeployedServiceReplicaDetailInfo_565019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the replica deployed on a Service Fabric node. The information include service kind, service name, current service operation, current service operation start date time, partition id, replica/instance id, reported load and other information.
  ## 
  let valid = call_565027.validator(path, query, header, formData, body)
  let scheme = call_565027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565027.url(scheme.get, call_565027.host, call_565027.base,
                         call_565027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565027, url, valid)

proc call*(call_565028: Call_GetDeployedServiceReplicaDetailInfo_565019;
          replicaId: string; nodeName: string; partitionId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getDeployedServiceReplicaDetailInfo
  ## Gets the details of the replica deployed on a Service Fabric node. The information include service kind, service name, current service operation, current service operation start date time, partition id, replica/instance id, reported load and other information.
  ##   replicaId: string (required)
  ##            : The identifier of the replica.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_565029 = newJObject()
  var query_565030 = newJObject()
  add(path_565029, "replicaId", newJString(replicaId))
  add(query_565030, "api-version", newJString(apiVersion))
  add(query_565030, "timeout", newJInt(timeout))
  add(path_565029, "nodeName", newJString(nodeName))
  add(path_565029, "partitionId", newJString(partitionId))
  result = call_565028.call(path_565029, query_565030, nil, nil, nil)

var getDeployedServiceReplicaDetailInfo* = Call_GetDeployedServiceReplicaDetailInfo_565019(
    name: "getDeployedServiceReplicaDetailInfo", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetPartitions/{partitionId}/$/GetReplicas/{replicaId}/$/GetDetail",
    validator: validate_GetDeployedServiceReplicaDetailInfo_565020, base: "",
    url: url_GetDeployedServiceReplicaDetailInfo_565021,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_RestartReplica_565031 = ref object of OpenApiRestCall_563564
proc url_RestartReplica_565033(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  assert "replicaId" in path, "`replicaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/GetPartitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetReplicas/"),
               (kind: VariableSegment, value: "replicaId"),
               (kind: ConstantSegment, value: "/$/Restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RestartReplica_565032(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Restarts a service replica of a persisted service running on a node. Warning - There are no safety checks performed when this API is used. Incorrect use of this API can lead to availability loss for stateful services.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   replicaId: JString (required)
  ##            : The identifier of the replica.
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `replicaId` field"
  var valid_565034 = path.getOrDefault("replicaId")
  valid_565034 = validateParameter(valid_565034, JString, required = true,
                                 default = nil)
  if valid_565034 != nil:
    section.add "replicaId", valid_565034
  var valid_565035 = path.getOrDefault("nodeName")
  valid_565035 = validateParameter(valid_565035, JString, required = true,
                                 default = nil)
  if valid_565035 != nil:
    section.add "nodeName", valid_565035
  var valid_565036 = path.getOrDefault("partitionId")
  valid_565036 = validateParameter(valid_565036, JString, required = true,
                                 default = nil)
  if valid_565036 != nil:
    section.add "partitionId", valid_565036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565037 = query.getOrDefault("api-version")
  valid_565037 = validateParameter(valid_565037, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565037 != nil:
    section.add "api-version", valid_565037
  var valid_565038 = query.getOrDefault("timeout")
  valid_565038 = validateParameter(valid_565038, JInt, required = false,
                                 default = newJInt(60))
  if valid_565038 != nil:
    section.add "timeout", valid_565038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565039: Call_RestartReplica_565031; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a service replica of a persisted service running on a node. Warning - There are no safety checks performed when this API is used. Incorrect use of this API can lead to availability loss for stateful services.
  ## 
  let valid = call_565039.validator(path, query, header, formData, body)
  let scheme = call_565039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565039.url(scheme.get, call_565039.host, call_565039.base,
                         call_565039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565039, url, valid)

proc call*(call_565040: Call_RestartReplica_565031; replicaId: string;
          nodeName: string; partitionId: string; apiVersion: string = "3.0";
          timeout: int = 60): Recallable =
  ## restartReplica
  ## Restarts a service replica of a persisted service running on a node. Warning - There are no safety checks performed when this API is used. Incorrect use of this API can lead to availability loss for stateful services.
  ##   replicaId: string (required)
  ##            : The identifier of the replica.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_565041 = newJObject()
  var query_565042 = newJObject()
  add(path_565041, "replicaId", newJString(replicaId))
  add(query_565042, "api-version", newJString(apiVersion))
  add(query_565042, "timeout", newJInt(timeout))
  add(path_565041, "nodeName", newJString(nodeName))
  add(path_565041, "partitionId", newJString(partitionId))
  result = call_565040.call(path_565041, query_565042, nil, nil, nil)

var restartReplica* = Call_RestartReplica_565031(name: "restartReplica",
    meth: HttpMethod.HttpPost, host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetPartitions/{partitionId}/$/GetReplicas/{replicaId}/$/Restart",
    validator: validate_RestartReplica_565032, base: "", url: url_RestartReplica_565033,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_RemoveNodeState_565043 = ref object of OpenApiRestCall_563564
proc url_RemoveNodeState_565045(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/RemoveNodeState")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RemoveNodeState_565044(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Notifies Service Fabric that the persisted state on a node has been permanently removed or lost.  This implies that it is not possible to recover the persisted state of that node. This generally happens if a hard disk has been wiped clean, or if a hard disk crashes. The node has to be down for this operation to be successful. This operation lets Service Fabric know that the replicas on that node no longer exist, and that Service Fabric should stop waiting for those replicas to come back up. Do not run this cmdlet if the state on the node has not been removed and the node can comes back up with its state intact.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_565046 = path.getOrDefault("nodeName")
  valid_565046 = validateParameter(valid_565046, JString, required = true,
                                 default = nil)
  if valid_565046 != nil:
    section.add "nodeName", valid_565046
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565047 = query.getOrDefault("api-version")
  valid_565047 = validateParameter(valid_565047, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565047 != nil:
    section.add "api-version", valid_565047
  var valid_565048 = query.getOrDefault("timeout")
  valid_565048 = validateParameter(valid_565048, JInt, required = false,
                                 default = newJInt(60))
  if valid_565048 != nil:
    section.add "timeout", valid_565048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565049: Call_RemoveNodeState_565043; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Notifies Service Fabric that the persisted state on a node has been permanently removed or lost.  This implies that it is not possible to recover the persisted state of that node. This generally happens if a hard disk has been wiped clean, or if a hard disk crashes. The node has to be down for this operation to be successful. This operation lets Service Fabric know that the replicas on that node no longer exist, and that Service Fabric should stop waiting for those replicas to come back up. Do not run this cmdlet if the state on the node has not been removed and the node can comes back up with its state intact.
  ## 
  let valid = call_565049.validator(path, query, header, formData, body)
  let scheme = call_565049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565049.url(scheme.get, call_565049.host, call_565049.base,
                         call_565049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565049, url, valid)

proc call*(call_565050: Call_RemoveNodeState_565043; nodeName: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## removeNodeState
  ## Notifies Service Fabric that the persisted state on a node has been permanently removed or lost.  This implies that it is not possible to recover the persisted state of that node. This generally happens if a hard disk has been wiped clean, or if a hard disk crashes. The node has to be down for this operation to be successful. This operation lets Service Fabric know that the replicas on that node no longer exist, and that Service Fabric should stop waiting for those replicas to come back up. Do not run this cmdlet if the state on the node has not been removed and the node can comes back up with its state intact.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_565051 = newJObject()
  var query_565052 = newJObject()
  add(query_565052, "api-version", newJString(apiVersion))
  add(query_565052, "timeout", newJInt(timeout))
  add(path_565051, "nodeName", newJString(nodeName))
  result = call_565050.call(path_565051, query_565052, nil, nil, nil)

var removeNodeState* = Call_RemoveNodeState_565043(name: "removeNodeState",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/RemoveNodeState",
    validator: validate_RemoveNodeState_565044, base: "", url: url_RemoveNodeState_565045,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportNodeHealth_565053 = ref object of OpenApiRestCall_563564
proc url_ReportNodeHealth_565055(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/ReportHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportNodeHealth_565054(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Reports health state of the specified Service Fabric node. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway node, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetNodeHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_565056 = path.getOrDefault("nodeName")
  valid_565056 = validateParameter(valid_565056, JString, required = true,
                                 default = nil)
  if valid_565056 != nil:
    section.add "nodeName", valid_565056
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565057 = query.getOrDefault("api-version")
  valid_565057 = validateParameter(valid_565057, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565057 != nil:
    section.add "api-version", valid_565057
  var valid_565058 = query.getOrDefault("timeout")
  valid_565058 = validateParameter(valid_565058, JInt, required = false,
                                 default = newJInt(60))
  if valid_565058 != nil:
    section.add "timeout", valid_565058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565060: Call_ReportNodeHealth_565053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reports health state of the specified Service Fabric node. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway node, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetNodeHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_565060.validator(path, query, header, formData, body)
  let scheme = call_565060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565060.url(scheme.get, call_565060.host, call_565060.base,
                         call_565060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565060, url, valid)

proc call*(call_565061: Call_ReportNodeHealth_565053; HealthInformation: JsonNode;
          nodeName: string; apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## reportNodeHealth
  ## Reports health state of the specified Service Fabric node. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway node, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetNodeHealth and check that the report appears in the HealthEvents section.
  ## 
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_565062 = newJObject()
  var query_565063 = newJObject()
  var body_565064 = newJObject()
  if HealthInformation != nil:
    body_565064 = HealthInformation
  add(query_565063, "api-version", newJString(apiVersion))
  add(query_565063, "timeout", newJInt(timeout))
  add(path_565062, "nodeName", newJString(nodeName))
  result = call_565061.call(path_565062, query_565063, nil, nil, body_565064)

var reportNodeHealth* = Call_ReportNodeHealth_565053(name: "reportNodeHealth",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/ReportHealth",
    validator: validate_ReportNodeHealth_565054, base: "",
    url: url_ReportNodeHealth_565055, schemes: {Scheme.Https, Scheme.Http})
type
  Call_RestartNode_565065 = ref object of OpenApiRestCall_563564
proc url_RestartNode_565067(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/Restart")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RestartNode_565066(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Restarts a Service Fabric cluster node that is already started.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_565068 = path.getOrDefault("nodeName")
  valid_565068 = validateParameter(valid_565068, JString, required = true,
                                 default = nil)
  if valid_565068 != nil:
    section.add "nodeName", valid_565068
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565069 = query.getOrDefault("api-version")
  valid_565069 = validateParameter(valid_565069, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565069 != nil:
    section.add "api-version", valid_565069
  var valid_565070 = query.getOrDefault("timeout")
  valid_565070 = validateParameter(valid_565070, JInt, required = false,
                                 default = newJInt(60))
  if valid_565070 != nil:
    section.add "timeout", valid_565070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   RestartNodeDescription: JObject (required)
  ##                         : The instance of the node to be restarted and a flag indicating the need to take dump of the fabric process.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565072: Call_RestartNode_565065; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a Service Fabric cluster node that is already started.
  ## 
  let valid = call_565072.validator(path, query, header, formData, body)
  let scheme = call_565072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565072.url(scheme.get, call_565072.host, call_565072.base,
                         call_565072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565072, url, valid)

proc call*(call_565073: Call_RestartNode_565065; nodeName: string;
          RestartNodeDescription: JsonNode; apiVersion: string = "3.0";
          timeout: int = 60): Recallable =
  ## restartNode
  ## Restarts a Service Fabric cluster node that is already started.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   RestartNodeDescription: JObject (required)
  ##                         : The instance of the node to be restarted and a flag indicating the need to take dump of the fabric process.
  var path_565074 = newJObject()
  var query_565075 = newJObject()
  var body_565076 = newJObject()
  add(query_565075, "api-version", newJString(apiVersion))
  add(query_565075, "timeout", newJInt(timeout))
  add(path_565074, "nodeName", newJString(nodeName))
  if RestartNodeDescription != nil:
    body_565076 = RestartNodeDescription
  result = call_565073.call(path_565074, query_565075, nil, nil, body_565076)

var restartNode* = Call_RestartNode_565065(name: "restartNode",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local:19080",
                                        route: "/Nodes/{nodeName}/$/Restart",
                                        validator: validate_RestartNode_565066,
                                        base: "", url: url_RestartNode_565067,
                                        schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartNode_565077 = ref object of OpenApiRestCall_563564
proc url_StartNode_565079(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/Start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StartNode_565078(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts a Service Fabric cluster node that is already stopped.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_565080 = path.getOrDefault("nodeName")
  valid_565080 = validateParameter(valid_565080, JString, required = true,
                                 default = nil)
  if valid_565080 != nil:
    section.add "nodeName", valid_565080
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565081 = query.getOrDefault("api-version")
  valid_565081 = validateParameter(valid_565081, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565081 != nil:
    section.add "api-version", valid_565081
  var valid_565082 = query.getOrDefault("timeout")
  valid_565082 = validateParameter(valid_565082, JInt, required = false,
                                 default = newJInt(60))
  if valid_565082 != nil:
    section.add "timeout", valid_565082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   StartNodeDescription: JObject (required)
  ##                       : The instance id of the stopped node that needs to be started.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565084: Call_StartNode_565077; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a Service Fabric cluster node that is already stopped.
  ## 
  let valid = call_565084.validator(path, query, header, formData, body)
  let scheme = call_565084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565084.url(scheme.get, call_565084.host, call_565084.base,
                         call_565084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565084, url, valid)

proc call*(call_565085: Call_StartNode_565077; StartNodeDescription: JsonNode;
          nodeName: string; apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## startNode
  ## Starts a Service Fabric cluster node that is already stopped.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   StartNodeDescription: JObject (required)
  ##                       : The instance id of the stopped node that needs to be started.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_565086 = newJObject()
  var query_565087 = newJObject()
  var body_565088 = newJObject()
  add(query_565087, "api-version", newJString(apiVersion))
  if StartNodeDescription != nil:
    body_565088 = StartNodeDescription
  add(query_565087, "timeout", newJInt(timeout))
  add(path_565086, "nodeName", newJString(nodeName))
  result = call_565085.call(path_565086, query_565087, nil, nil, body_565088)

var startNode* = Call_StartNode_565077(name: "startNode", meth: HttpMethod.HttpPost,
                                    host: "azure.local:19080",
                                    route: "/Nodes/{nodeName}/$/Start",
                                    validator: validate_StartNode_565078,
                                    base: "", url: url_StartNode_565079,
                                    schemes: {Scheme.Https, Scheme.Http})
type
  Call_StopNode_565089 = ref object of OpenApiRestCall_563564
proc url_StopNode_565091(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "nodeName" in path, "`nodeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Nodes/"),
               (kind: VariableSegment, value: "nodeName"),
               (kind: ConstantSegment, value: "/$/Stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StopNode_565090(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops a Service Fabric cluster node that is in a started state. The node will stay down until start node is called.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_565092 = path.getOrDefault("nodeName")
  valid_565092 = validateParameter(valid_565092, JString, required = true,
                                 default = nil)
  if valid_565092 != nil:
    section.add "nodeName", valid_565092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565093 = query.getOrDefault("api-version")
  valid_565093 = validateParameter(valid_565093, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565093 != nil:
    section.add "api-version", valid_565093
  var valid_565094 = query.getOrDefault("timeout")
  valid_565094 = validateParameter(valid_565094, JInt, required = false,
                                 default = newJInt(60))
  if valid_565094 != nil:
    section.add "timeout", valid_565094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   StopNodeDescription: JObject (required)
  ##                      : The instance id of the stopped node that needs to be stopped.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565096: Call_StopNode_565089; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a Service Fabric cluster node that is in a started state. The node will stay down until start node is called.
  ## 
  let valid = call_565096.validator(path, query, header, formData, body)
  let scheme = call_565096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565096.url(scheme.get, call_565096.host, call_565096.base,
                         call_565096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565096, url, valid)

proc call*(call_565097: Call_StopNode_565089; StopNodeDescription: JsonNode;
          nodeName: string; apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## stopNode
  ## Stops a Service Fabric cluster node that is in a started state. The node will stay down until start node is called.
  ##   StopNodeDescription: JObject (required)
  ##                      : The instance id of the stopped node that needs to be stopped.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_565098 = newJObject()
  var query_565099 = newJObject()
  var body_565100 = newJObject()
  if StopNodeDescription != nil:
    body_565100 = StopNodeDescription
  add(query_565099, "api-version", newJString(apiVersion))
  add(query_565099, "timeout", newJInt(timeout))
  add(path_565098, "nodeName", newJString(nodeName))
  result = call_565097.call(path_565098, query_565099, nil, nil, body_565100)

var stopNode* = Call_StopNode_565089(name: "stopNode", meth: HttpMethod.HttpPost,
                                  host: "azure.local:19080",
                                  route: "/Nodes/{nodeName}/$/Stop",
                                  validator: validate_StopNode_565090, base: "",
                                  url: url_StopNode_565091,
                                  schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetPartitionInfo_565101 = ref object of OpenApiRestCall_563564
proc url_GetPartitionInfo_565103(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetPartitionInfo_565102(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## The Partitions endpoint returns information about the specified partition. The response include the partition id, partitioning scheme information, keys supported by the partition, status, health and other details about the partition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_565104 = path.getOrDefault("partitionId")
  valid_565104 = validateParameter(valid_565104, JString, required = true,
                                 default = nil)
  if valid_565104 != nil:
    section.add "partitionId", valid_565104
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565105 = query.getOrDefault("api-version")
  valid_565105 = validateParameter(valid_565105, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565105 != nil:
    section.add "api-version", valid_565105
  var valid_565106 = query.getOrDefault("timeout")
  valid_565106 = validateParameter(valid_565106, JInt, required = false,
                                 default = newJInt(60))
  if valid_565106 != nil:
    section.add "timeout", valid_565106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565107: Call_GetPartitionInfo_565101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Partitions endpoint returns information about the specified partition. The response include the partition id, partitioning scheme information, keys supported by the partition, status, health and other details about the partition.
  ## 
  let valid = call_565107.validator(path, query, header, formData, body)
  let scheme = call_565107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565107.url(scheme.get, call_565107.host, call_565107.base,
                         call_565107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565107, url, valid)

proc call*(call_565108: Call_GetPartitionInfo_565101; partitionId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getPartitionInfo
  ## The Partitions endpoint returns information about the specified partition. The response include the partition id, partitioning scheme information, keys supported by the partition, status, health and other details about the partition.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_565109 = newJObject()
  var query_565110 = newJObject()
  add(query_565110, "api-version", newJString(apiVersion))
  add(query_565110, "timeout", newJInt(timeout))
  add(path_565109, "partitionId", newJString(partitionId))
  result = call_565108.call(path_565109, query_565110, nil, nil, nil)

var getPartitionInfo* = Call_GetPartitionInfo_565101(name: "getPartitionInfo",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}", validator: validate_GetPartitionInfo_565102,
    base: "", url: url_GetPartitionInfo_565103, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetPartitionHealthUsingPolicy_565123 = ref object of OpenApiRestCall_563564
proc url_GetPartitionHealthUsingPolicy_565125(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetPartitionHealthUsingPolicy_565124(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the health information of the specified partition.
  ## If the application health policy is specified, the health evaluation uses it to get the aggregated health state.
  ## If the policy is not specified, the health evaluation uses the application health policy defined in the application manifest, or the default health policy, if no policy is defined in the manifest.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the partition based on the health state.
  ## Use ReplicasHealthStateFilter to filter the collection of ReplicaHealthState objects on the partition. Use ApplicationHealthPolicy in the POST body to override the health policies used to evaluate the health.
  ## If you specify a partition that does not exist in the health store, this cmdlet returns an error.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_565126 = path.getOrDefault("partitionId")
  valid_565126 = validateParameter(valid_565126, JString, required = true,
                                 default = nil)
  if valid_565126 != nil:
    section.add "partitionId", valid_565126
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   EventsHealthStateFilter: JInt
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   ReplicasHealthStateFilter: JInt
  ##                            : Allows filtering the collection of ReplicaHealthState objects on the partition. The value can be obtained from members or bitwise operations on members of HealthStateFilter. Only replicas that match the filter will be returned. All replicas will be used to evaluate the aggregated health state. If not specified, all entries will be returned.The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) will be returned. The possible values for this parameter include integer value of one of the following health states.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565127 = query.getOrDefault("api-version")
  valid_565127 = validateParameter(valid_565127, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565127 != nil:
    section.add "api-version", valid_565127
  var valid_565128 = query.getOrDefault("timeout")
  valid_565128 = validateParameter(valid_565128, JInt, required = false,
                                 default = newJInt(60))
  if valid_565128 != nil:
    section.add "timeout", valid_565128
  var valid_565129 = query.getOrDefault("EventsHealthStateFilter")
  valid_565129 = validateParameter(valid_565129, JInt, required = false,
                                 default = newJInt(0))
  if valid_565129 != nil:
    section.add "EventsHealthStateFilter", valid_565129
  var valid_565130 = query.getOrDefault("ReplicasHealthStateFilter")
  valid_565130 = validateParameter(valid_565130, JInt, required = false,
                                 default = newJInt(0))
  if valid_565130 != nil:
    section.add "ReplicasHealthStateFilter", valid_565130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ApplicationHealthPolicy: JObject
  ##                          : Describes the health policies used to evaluate the health of an application or one of its children.
  ## If not present, the health evaluation uses the health policy from application manifest or the default health policy.
  ## 
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565132: Call_GetPartitionHealthUsingPolicy_565123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health information of the specified partition.
  ## If the application health policy is specified, the health evaluation uses it to get the aggregated health state.
  ## If the policy is not specified, the health evaluation uses the application health policy defined in the application manifest, or the default health policy, if no policy is defined in the manifest.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the partition based on the health state.
  ## Use ReplicasHealthStateFilter to filter the collection of ReplicaHealthState objects on the partition. Use ApplicationHealthPolicy in the POST body to override the health policies used to evaluate the health.
  ## If you specify a partition that does not exist in the health store, this cmdlet returns an error.
  ## 
  ## 
  let valid = call_565132.validator(path, query, header, formData, body)
  let scheme = call_565132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565132.url(scheme.get, call_565132.host, call_565132.base,
                         call_565132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565132, url, valid)

proc call*(call_565133: Call_GetPartitionHealthUsingPolicy_565123;
          partitionId: string; ApplicationHealthPolicy: JsonNode = nil;
          apiVersion: string = "3.0"; timeout: int = 60;
          EventsHealthStateFilter: int = 0; ReplicasHealthStateFilter: int = 0): Recallable =
  ## getPartitionHealthUsingPolicy
  ## Gets the health information of the specified partition.
  ## If the application health policy is specified, the health evaluation uses it to get the aggregated health state.
  ## If the policy is not specified, the health evaluation uses the application health policy defined in the application manifest, or the default health policy, if no policy is defined in the manifest.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the partition based on the health state.
  ## Use ReplicasHealthStateFilter to filter the collection of ReplicaHealthState objects on the partition. Use ApplicationHealthPolicy in the POST body to override the health policies used to evaluate the health.
  ## If you specify a partition that does not exist in the health store, this cmdlet returns an error.
  ## 
  ##   ApplicationHealthPolicy: JObject
  ##                          : Describes the health policies used to evaluate the health of an application or one of its children.
  ## If not present, the health evaluation uses the health policy from application manifest or the default health policy.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  ##   EventsHealthStateFilter: int
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   ReplicasHealthStateFilter: int
  ##                            : Allows filtering the collection of ReplicaHealthState objects on the partition. The value can be obtained from members or bitwise operations on members of HealthStateFilter. Only replicas that match the filter will be returned. All replicas will be used to evaluate the aggregated health state. If not specified, all entries will be returned.The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) will be returned. The possible values for this parameter include integer value of one of the following health states.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  var path_565134 = newJObject()
  var query_565135 = newJObject()
  var body_565136 = newJObject()
  if ApplicationHealthPolicy != nil:
    body_565136 = ApplicationHealthPolicy
  add(query_565135, "api-version", newJString(apiVersion))
  add(query_565135, "timeout", newJInt(timeout))
  add(path_565134, "partitionId", newJString(partitionId))
  add(query_565135, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(query_565135, "ReplicasHealthStateFilter",
      newJInt(ReplicasHealthStateFilter))
  result = call_565133.call(path_565134, query_565135, nil, nil, body_565136)

var getPartitionHealthUsingPolicy* = Call_GetPartitionHealthUsingPolicy_565123(
    name: "getPartitionHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/GetHealth",
    validator: validate_GetPartitionHealthUsingPolicy_565124, base: "",
    url: url_GetPartitionHealthUsingPolicy_565125,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetPartitionHealth_565111 = ref object of OpenApiRestCall_563564
proc url_GetPartitionHealth_565113(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetPartitionHealth_565112(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets the health information of the specified partition.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the service based on the health state.
  ## Use ReplicasHealthStateFilter to filter the collection of ReplicaHealthState objects on the partition.
  ## If you specify a partition that does not exist in the health store, this cmdlet returns an error.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_565114 = path.getOrDefault("partitionId")
  valid_565114 = validateParameter(valid_565114, JString, required = true,
                                 default = nil)
  if valid_565114 != nil:
    section.add "partitionId", valid_565114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   EventsHealthStateFilter: JInt
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   ReplicasHealthStateFilter: JInt
  ##                            : Allows filtering the collection of ReplicaHealthState objects on the partition. The value can be obtained from members or bitwise operations on members of HealthStateFilter. Only replicas that match the filter will be returned. All replicas will be used to evaluate the aggregated health state. If not specified, all entries will be returned.The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) will be returned. The possible values for this parameter include integer value of one of the following health states.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565115 = query.getOrDefault("api-version")
  valid_565115 = validateParameter(valid_565115, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565115 != nil:
    section.add "api-version", valid_565115
  var valid_565116 = query.getOrDefault("timeout")
  valid_565116 = validateParameter(valid_565116, JInt, required = false,
                                 default = newJInt(60))
  if valid_565116 != nil:
    section.add "timeout", valid_565116
  var valid_565117 = query.getOrDefault("EventsHealthStateFilter")
  valid_565117 = validateParameter(valid_565117, JInt, required = false,
                                 default = newJInt(0))
  if valid_565117 != nil:
    section.add "EventsHealthStateFilter", valid_565117
  var valid_565118 = query.getOrDefault("ReplicasHealthStateFilter")
  valid_565118 = validateParameter(valid_565118, JInt, required = false,
                                 default = newJInt(0))
  if valid_565118 != nil:
    section.add "ReplicasHealthStateFilter", valid_565118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565119: Call_GetPartitionHealth_565111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health information of the specified partition.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the service based on the health state.
  ## Use ReplicasHealthStateFilter to filter the collection of ReplicaHealthState objects on the partition.
  ## If you specify a partition that does not exist in the health store, this cmdlet returns an error.
  ## 
  ## 
  let valid = call_565119.validator(path, query, header, formData, body)
  let scheme = call_565119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565119.url(scheme.get, call_565119.host, call_565119.base,
                         call_565119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565119, url, valid)

proc call*(call_565120: Call_GetPartitionHealth_565111; partitionId: string;
          apiVersion: string = "3.0"; timeout: int = 60;
          EventsHealthStateFilter: int = 0; ReplicasHealthStateFilter: int = 0): Recallable =
  ## getPartitionHealth
  ## Gets the health information of the specified partition.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the service based on the health state.
  ## Use ReplicasHealthStateFilter to filter the collection of ReplicaHealthState objects on the partition.
  ## If you specify a partition that does not exist in the health store, this cmdlet returns an error.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  ##   EventsHealthStateFilter: int
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   ReplicasHealthStateFilter: int
  ##                            : Allows filtering the collection of ReplicaHealthState objects on the partition. The value can be obtained from members or bitwise operations on members of HealthStateFilter. Only replicas that match the filter will be returned. All replicas will be used to evaluate the aggregated health state. If not specified, all entries will be returned.The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) will be returned. The possible values for this parameter include integer value of one of the following health states.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  var path_565121 = newJObject()
  var query_565122 = newJObject()
  add(query_565122, "api-version", newJString(apiVersion))
  add(query_565122, "timeout", newJInt(timeout))
  add(path_565121, "partitionId", newJString(partitionId))
  add(query_565122, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(query_565122, "ReplicasHealthStateFilter",
      newJInt(ReplicasHealthStateFilter))
  result = call_565120.call(path_565121, query_565122, nil, nil, nil)

var getPartitionHealth* = Call_GetPartitionHealth_565111(
    name: "getPartitionHealth", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetHealth",
    validator: validate_GetPartitionHealth_565112, base: "",
    url: url_GetPartitionHealth_565113, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetPartitionLoadInformation_565137 = ref object of OpenApiRestCall_563564
proc url_GetPartitionLoadInformation_565139(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetLoadInformation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetPartitionLoadInformation_565138(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns information about the specified partition.
  ## The response includes a list of load information.
  ## Each information includes load metric name, value and last reported time in UTC.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_565140 = path.getOrDefault("partitionId")
  valid_565140 = validateParameter(valid_565140, JString, required = true,
                                 default = nil)
  if valid_565140 != nil:
    section.add "partitionId", valid_565140
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565141 = query.getOrDefault("api-version")
  valid_565141 = validateParameter(valid_565141, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565141 != nil:
    section.add "api-version", valid_565141
  var valid_565142 = query.getOrDefault("timeout")
  valid_565142 = validateParameter(valid_565142, JInt, required = false,
                                 default = newJInt(60))
  if valid_565142 != nil:
    section.add "timeout", valid_565142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565143: Call_GetPartitionLoadInformation_565137; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the specified partition.
  ## The response includes a list of load information.
  ## Each information includes load metric name, value and last reported time in UTC.
  ## 
  ## 
  let valid = call_565143.validator(path, query, header, formData, body)
  let scheme = call_565143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565143.url(scheme.get, call_565143.host, call_565143.base,
                         call_565143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565143, url, valid)

proc call*(call_565144: Call_GetPartitionLoadInformation_565137;
          partitionId: string; apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getPartitionLoadInformation
  ## Returns information about the specified partition.
  ## The response includes a list of load information.
  ## Each information includes load metric name, value and last reported time in UTC.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_565145 = newJObject()
  var query_565146 = newJObject()
  add(query_565146, "api-version", newJString(apiVersion))
  add(query_565146, "timeout", newJInt(timeout))
  add(path_565145, "partitionId", newJString(partitionId))
  result = call_565144.call(path_565145, query_565146, nil, nil, nil)

var getPartitionLoadInformation* = Call_GetPartitionLoadInformation_565137(
    name: "getPartitionLoadInformation", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetLoadInformation",
    validator: validate_GetPartitionLoadInformation_565138, base: "",
    url: url_GetPartitionLoadInformation_565139,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetReplicaInfoList_565147 = ref object of OpenApiRestCall_563564
proc url_GetReplicaInfoList_565149(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetReplicas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetReplicaInfoList_565148(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## The GetReplicas endpoint returns information about the replicas of the specified partition. The respons include the id, role, status, health, node name, uptime, and other details about the replica.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_565150 = path.getOrDefault("partitionId")
  valid_565150 = validateParameter(valid_565150, JString, required = true,
                                 default = nil)
  if valid_565150 != nil:
    section.add "partitionId", valid_565150
  result.add "path", section
  ## parameters in `query` object:
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  var valid_565151 = query.getOrDefault("ContinuationToken")
  valid_565151 = validateParameter(valid_565151, JString, required = false,
                                 default = nil)
  if valid_565151 != nil:
    section.add "ContinuationToken", valid_565151
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565152 = query.getOrDefault("api-version")
  valid_565152 = validateParameter(valid_565152, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565152 != nil:
    section.add "api-version", valid_565152
  var valid_565153 = query.getOrDefault("timeout")
  valid_565153 = validateParameter(valid_565153, JInt, required = false,
                                 default = newJInt(60))
  if valid_565153 != nil:
    section.add "timeout", valid_565153
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565154: Call_GetReplicaInfoList_565147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetReplicas endpoint returns information about the replicas of the specified partition. The respons include the id, role, status, health, node name, uptime, and other details about the replica.
  ## 
  let valid = call_565154.validator(path, query, header, formData, body)
  let scheme = call_565154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565154.url(scheme.get, call_565154.host, call_565154.base,
                         call_565154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565154, url, valid)

proc call*(call_565155: Call_GetReplicaInfoList_565147; partitionId: string;
          ContinuationToken: string = ""; apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getReplicaInfoList
  ## The GetReplicas endpoint returns information about the replicas of the specified partition. The respons include the id, role, status, health, node name, uptime, and other details about the replica.
  ##   ContinuationToken: string
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_565156 = newJObject()
  var query_565157 = newJObject()
  add(query_565157, "ContinuationToken", newJString(ContinuationToken))
  add(query_565157, "api-version", newJString(apiVersion))
  add(query_565157, "timeout", newJInt(timeout))
  add(path_565156, "partitionId", newJString(partitionId))
  result = call_565155.call(path_565156, query_565157, nil, nil, nil)

var getReplicaInfoList* = Call_GetReplicaInfoList_565147(
    name: "getReplicaInfoList", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetReplicas",
    validator: validate_GetReplicaInfoList_565148, base: "",
    url: url_GetReplicaInfoList_565149, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetReplicaInfo_565158 = ref object of OpenApiRestCall_563564
proc url_GetReplicaInfo_565160(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  assert "replicaId" in path, "`replicaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetReplicas/"),
               (kind: VariableSegment, value: "replicaId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetReplicaInfo_565159(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The respons include the id, role, status, health, node name, uptime, and other details about the replica.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   replicaId: JString (required)
  ##            : The identifier of the replica.
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `replicaId` field"
  var valid_565161 = path.getOrDefault("replicaId")
  valid_565161 = validateParameter(valid_565161, JString, required = true,
                                 default = nil)
  if valid_565161 != nil:
    section.add "replicaId", valid_565161
  var valid_565162 = path.getOrDefault("partitionId")
  valid_565162 = validateParameter(valid_565162, JString, required = true,
                                 default = nil)
  if valid_565162 != nil:
    section.add "partitionId", valid_565162
  result.add "path", section
  ## parameters in `query` object:
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  var valid_565163 = query.getOrDefault("ContinuationToken")
  valid_565163 = validateParameter(valid_565163, JString, required = false,
                                 default = nil)
  if valid_565163 != nil:
    section.add "ContinuationToken", valid_565163
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565164 = query.getOrDefault("api-version")
  valid_565164 = validateParameter(valid_565164, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565164 != nil:
    section.add "api-version", valid_565164
  var valid_565165 = query.getOrDefault("timeout")
  valid_565165 = validateParameter(valid_565165, JInt, required = false,
                                 default = newJInt(60))
  if valid_565165 != nil:
    section.add "timeout", valid_565165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565166: Call_GetReplicaInfo_565158; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The respons include the id, role, status, health, node name, uptime, and other details about the replica.
  ## 
  let valid = call_565166.validator(path, query, header, formData, body)
  let scheme = call_565166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565166.url(scheme.get, call_565166.host, call_565166.base,
                         call_565166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565166, url, valid)

proc call*(call_565167: Call_GetReplicaInfo_565158; replicaId: string;
          partitionId: string; ContinuationToken: string = "";
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getReplicaInfo
  ## The respons include the id, role, status, health, node name, uptime, and other details about the replica.
  ##   replicaId: string (required)
  ##            : The identifier of the replica.
  ##   ContinuationToken: string
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_565168 = newJObject()
  var query_565169 = newJObject()
  add(path_565168, "replicaId", newJString(replicaId))
  add(query_565169, "ContinuationToken", newJString(ContinuationToken))
  add(query_565169, "api-version", newJString(apiVersion))
  add(query_565169, "timeout", newJInt(timeout))
  add(path_565168, "partitionId", newJString(partitionId))
  result = call_565167.call(path_565168, query_565169, nil, nil, nil)

var getReplicaInfo* = Call_GetReplicaInfo_565158(name: "getReplicaInfo",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}",
    validator: validate_GetReplicaInfo_565159, base: "", url: url_GetReplicaInfo_565160,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetReplicaHealthUsingPolicy_565182 = ref object of OpenApiRestCall_563564
proc url_GetReplicaHealthUsingPolicy_565184(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  assert "replicaId" in path, "`replicaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetReplicas/"),
               (kind: VariableSegment, value: "replicaId"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetReplicaHealthUsingPolicy_565183(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the health of a Service Fabric stateful service replica or stateless service instance.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the cluster based on the health state.
  ## Use ApplicationHealthPolicy to optionally override the health policies used to evaluate the health. This API only uses 'ConsiderWarningAsError' field of the ApplicationHealthPolicy. The rest of the fields are ignored while evaluating the health of the replica.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   replicaId: JString (required)
  ##            : The identifier of the replica.
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `replicaId` field"
  var valid_565185 = path.getOrDefault("replicaId")
  valid_565185 = validateParameter(valid_565185, JString, required = true,
                                 default = nil)
  if valid_565185 != nil:
    section.add "replicaId", valid_565185
  var valid_565186 = path.getOrDefault("partitionId")
  valid_565186 = validateParameter(valid_565186, JString, required = true,
                                 default = nil)
  if valid_565186 != nil:
    section.add "partitionId", valid_565186
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   EventsHealthStateFilter: JInt
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565187 = query.getOrDefault("api-version")
  valid_565187 = validateParameter(valid_565187, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565187 != nil:
    section.add "api-version", valid_565187
  var valid_565188 = query.getOrDefault("timeout")
  valid_565188 = validateParameter(valid_565188, JInt, required = false,
                                 default = newJInt(60))
  if valid_565188 != nil:
    section.add "timeout", valid_565188
  var valid_565189 = query.getOrDefault("EventsHealthStateFilter")
  valid_565189 = validateParameter(valid_565189, JInt, required = false,
                                 default = newJInt(0))
  if valid_565189 != nil:
    section.add "EventsHealthStateFilter", valid_565189
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ApplicationHealthPolicy: JObject
  ##                          : Describes the health policies used to evaluate the health of an application or one of its children.
  ## If not present, the health evaluation uses the health policy from application manifest or the default health policy.
  ## 
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565191: Call_GetReplicaHealthUsingPolicy_565182; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric stateful service replica or stateless service instance.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the cluster based on the health state.
  ## Use ApplicationHealthPolicy to optionally override the health policies used to evaluate the health. This API only uses 'ConsiderWarningAsError' field of the ApplicationHealthPolicy. The rest of the fields are ignored while evaluating the health of the replica.
  ## 
  ## 
  let valid = call_565191.validator(path, query, header, formData, body)
  let scheme = call_565191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565191.url(scheme.get, call_565191.host, call_565191.base,
                         call_565191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565191, url, valid)

proc call*(call_565192: Call_GetReplicaHealthUsingPolicy_565182; replicaId: string;
          partitionId: string; ApplicationHealthPolicy: JsonNode = nil;
          apiVersion: string = "3.0"; timeout: int = 60;
          EventsHealthStateFilter: int = 0): Recallable =
  ## getReplicaHealthUsingPolicy
  ## Gets the health of a Service Fabric stateful service replica or stateless service instance.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the cluster based on the health state.
  ## Use ApplicationHealthPolicy to optionally override the health policies used to evaluate the health. This API only uses 'ConsiderWarningAsError' field of the ApplicationHealthPolicy. The rest of the fields are ignored while evaluating the health of the replica.
  ## 
  ##   replicaId: string (required)
  ##            : The identifier of the replica.
  ##   ApplicationHealthPolicy: JObject
  ##                          : Describes the health policies used to evaluate the health of an application or one of its children.
  ## If not present, the health evaluation uses the health policy from application manifest or the default health policy.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  ##   EventsHealthStateFilter: int
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  var path_565193 = newJObject()
  var query_565194 = newJObject()
  var body_565195 = newJObject()
  add(path_565193, "replicaId", newJString(replicaId))
  if ApplicationHealthPolicy != nil:
    body_565195 = ApplicationHealthPolicy
  add(query_565194, "api-version", newJString(apiVersion))
  add(query_565194, "timeout", newJInt(timeout))
  add(path_565193, "partitionId", newJString(partitionId))
  add(query_565194, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  result = call_565192.call(path_565193, query_565194, nil, nil, body_565195)

var getReplicaHealthUsingPolicy* = Call_GetReplicaHealthUsingPolicy_565182(
    name: "getReplicaHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}/$/GetHealth",
    validator: validate_GetReplicaHealthUsingPolicy_565183, base: "",
    url: url_GetReplicaHealthUsingPolicy_565184,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetReplicaHealth_565170 = ref object of OpenApiRestCall_563564
proc url_GetReplicaHealth_565172(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  assert "replicaId" in path, "`replicaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetReplicas/"),
               (kind: VariableSegment, value: "replicaId"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetReplicaHealth_565171(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the health of a Service Fabric replica.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the replica based on the health state.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   replicaId: JString (required)
  ##            : The identifier of the replica.
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `replicaId` field"
  var valid_565173 = path.getOrDefault("replicaId")
  valid_565173 = validateParameter(valid_565173, JString, required = true,
                                 default = nil)
  if valid_565173 != nil:
    section.add "replicaId", valid_565173
  var valid_565174 = path.getOrDefault("partitionId")
  valid_565174 = validateParameter(valid_565174, JString, required = true,
                                 default = nil)
  if valid_565174 != nil:
    section.add "partitionId", valid_565174
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   EventsHealthStateFilter: JInt
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565175 = query.getOrDefault("api-version")
  valid_565175 = validateParameter(valid_565175, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565175 != nil:
    section.add "api-version", valid_565175
  var valid_565176 = query.getOrDefault("timeout")
  valid_565176 = validateParameter(valid_565176, JInt, required = false,
                                 default = newJInt(60))
  if valid_565176 != nil:
    section.add "timeout", valid_565176
  var valid_565177 = query.getOrDefault("EventsHealthStateFilter")
  valid_565177 = validateParameter(valid_565177, JInt, required = false,
                                 default = newJInt(0))
  if valid_565177 != nil:
    section.add "EventsHealthStateFilter", valid_565177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565178: Call_GetReplicaHealth_565170; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric replica.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the replica based on the health state.
  ## 
  ## 
  let valid = call_565178.validator(path, query, header, formData, body)
  let scheme = call_565178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565178.url(scheme.get, call_565178.host, call_565178.base,
                         call_565178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565178, url, valid)

proc call*(call_565179: Call_GetReplicaHealth_565170; replicaId: string;
          partitionId: string; apiVersion: string = "3.0"; timeout: int = 60;
          EventsHealthStateFilter: int = 0): Recallable =
  ## getReplicaHealth
  ## Gets the health of a Service Fabric replica.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the replica based on the health state.
  ## 
  ##   replicaId: string (required)
  ##            : The identifier of the replica.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  ##   EventsHealthStateFilter: int
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  var path_565180 = newJObject()
  var query_565181 = newJObject()
  add(path_565180, "replicaId", newJString(replicaId))
  add(query_565181, "api-version", newJString(apiVersion))
  add(query_565181, "timeout", newJInt(timeout))
  add(path_565180, "partitionId", newJString(partitionId))
  add(query_565181, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  result = call_565179.call(path_565180, query_565181, nil, nil, nil)

var getReplicaHealth* = Call_GetReplicaHealth_565170(name: "getReplicaHealth",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}/$/GetHealth",
    validator: validate_GetReplicaHealth_565171, base: "",
    url: url_GetReplicaHealth_565172, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportReplicaHealth_565196 = ref object of OpenApiRestCall_563564
proc url_ReportReplicaHealth_565198(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  assert "replicaId" in path, "`replicaId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetReplicas/"),
               (kind: VariableSegment, value: "replicaId"),
               (kind: ConstantSegment, value: "/$/ReportHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportReplicaHealth_565197(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Reports health state of the specified Service Fabric replica. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Replica, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetReplicaHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   replicaId: JString (required)
  ##            : The identifier of the replica.
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `replicaId` field"
  var valid_565199 = path.getOrDefault("replicaId")
  valid_565199 = validateParameter(valid_565199, JString, required = true,
                                 default = nil)
  if valid_565199 != nil:
    section.add "replicaId", valid_565199
  var valid_565200 = path.getOrDefault("partitionId")
  valid_565200 = validateParameter(valid_565200, JString, required = true,
                                 default = nil)
  if valid_565200 != nil:
    section.add "partitionId", valid_565200
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ServiceKind: JString (required)
  ##              : The kind of service replica (Stateless or Stateful) for which the health is being reported. Following are the possible values.
  ## - Stateless - Does not use Service Fabric to make its state highly available or reliable. The value is 1
  ## - Stateful - Uses Service Fabric to make its state or part of its state highly available and reliable. The value is 2.
  ## 
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565201 = query.getOrDefault("api-version")
  valid_565201 = validateParameter(valid_565201, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565201 != nil:
    section.add "api-version", valid_565201
  var valid_565202 = query.getOrDefault("ServiceKind")
  valid_565202 = validateParameter(valid_565202, JString, required = true,
                                 default = newJString("Stateful"))
  if valid_565202 != nil:
    section.add "ServiceKind", valid_565202
  var valid_565203 = query.getOrDefault("timeout")
  valid_565203 = validateParameter(valid_565203, JInt, required = false,
                                 default = newJInt(60))
  if valid_565203 != nil:
    section.add "timeout", valid_565203
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565205: Call_ReportReplicaHealth_565196; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reports health state of the specified Service Fabric replica. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Replica, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetReplicaHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_565205.validator(path, query, header, formData, body)
  let scheme = call_565205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565205.url(scheme.get, call_565205.host, call_565205.base,
                         call_565205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565205, url, valid)

proc call*(call_565206: Call_ReportReplicaHealth_565196; replicaId: string;
          HealthInformation: JsonNode; partitionId: string;
          apiVersion: string = "3.0"; ServiceKind: string = "Stateful";
          timeout: int = 60): Recallable =
  ## reportReplicaHealth
  ## Reports health state of the specified Service Fabric replica. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Replica, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetReplicaHealth and check that the report appears in the HealthEvents section.
  ## 
  ##   replicaId: string (required)
  ##            : The identifier of the replica.
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ServiceKind: string (required)
  ##              : The kind of service replica (Stateless or Stateful) for which the health is being reported. Following are the possible values.
  ## - Stateless - Does not use Service Fabric to make its state highly available or reliable. The value is 1
  ## - Stateful - Uses Service Fabric to make its state or part of its state highly available and reliable. The value is 2.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_565207 = newJObject()
  var query_565208 = newJObject()
  var body_565209 = newJObject()
  add(path_565207, "replicaId", newJString(replicaId))
  if HealthInformation != nil:
    body_565209 = HealthInformation
  add(query_565208, "api-version", newJString(apiVersion))
  add(query_565208, "ServiceKind", newJString(ServiceKind))
  add(query_565208, "timeout", newJInt(timeout))
  add(path_565207, "partitionId", newJString(partitionId))
  result = call_565206.call(path_565207, query_565208, nil, nil, body_565209)

var reportReplicaHealth* = Call_ReportReplicaHealth_565196(
    name: "reportReplicaHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}/$/ReportHealth",
    validator: validate_ReportReplicaHealth_565197, base: "",
    url: url_ReportReplicaHealth_565198, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceNameInfo_565210 = ref object of OpenApiRestCall_563564
proc url_GetServiceNameInfo_565212(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/GetServiceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetServiceNameInfo_565211(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## The GetServiceName endpoint returns the name of the service for the specified partition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_565213 = path.getOrDefault("partitionId")
  valid_565213 = validateParameter(valid_565213, JString, required = true,
                                 default = nil)
  if valid_565213 != nil:
    section.add "partitionId", valid_565213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565214 = query.getOrDefault("api-version")
  valid_565214 = validateParameter(valid_565214, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565214 != nil:
    section.add "api-version", valid_565214
  var valid_565215 = query.getOrDefault("timeout")
  valid_565215 = validateParameter(valid_565215, JInt, required = false,
                                 default = newJInt(60))
  if valid_565215 != nil:
    section.add "timeout", valid_565215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565216: Call_GetServiceNameInfo_565210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetServiceName endpoint returns the name of the service for the specified partition.
  ## 
  let valid = call_565216.validator(path, query, header, formData, body)
  let scheme = call_565216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565216.url(scheme.get, call_565216.host, call_565216.base,
                         call_565216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565216, url, valid)

proc call*(call_565217: Call_GetServiceNameInfo_565210; partitionId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getServiceNameInfo
  ## The GetServiceName endpoint returns the name of the service for the specified partition.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_565218 = newJObject()
  var query_565219 = newJObject()
  add(query_565219, "api-version", newJString(apiVersion))
  add(query_565219, "timeout", newJInt(timeout))
  add(path_565218, "partitionId", newJString(partitionId))
  result = call_565217.call(path_565218, query_565219, nil, nil, nil)

var getServiceNameInfo* = Call_GetServiceNameInfo_565210(
    name: "getServiceNameInfo", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetServiceName",
    validator: validate_GetServiceNameInfo_565211, base: "",
    url: url_GetServiceNameInfo_565212, schemes: {Scheme.Https, Scheme.Http})
type
  Call_RecoverPartition_565220 = ref object of OpenApiRestCall_563564
proc url_RecoverPartition_565222(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/Recover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecoverPartition_565221(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Indicates to the Service Fabric cluster that it should attempt to recover a specific partition which is currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_565223 = path.getOrDefault("partitionId")
  valid_565223 = validateParameter(valid_565223, JString, required = true,
                                 default = nil)
  if valid_565223 != nil:
    section.add "partitionId", valid_565223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565224 = query.getOrDefault("api-version")
  valid_565224 = validateParameter(valid_565224, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565224 != nil:
    section.add "api-version", valid_565224
  var valid_565225 = query.getOrDefault("timeout")
  valid_565225 = validateParameter(valid_565225, JInt, required = false,
                                 default = newJInt(60))
  if valid_565225 != nil:
    section.add "timeout", valid_565225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565226: Call_RecoverPartition_565220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicates to the Service Fabric cluster that it should attempt to recover a specific partition which is currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ## 
  let valid = call_565226.validator(path, query, header, formData, body)
  let scheme = call_565226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565226.url(scheme.get, call_565226.host, call_565226.base,
                         call_565226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565226, url, valid)

proc call*(call_565227: Call_RecoverPartition_565220; partitionId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## recoverPartition
  ## Indicates to the Service Fabric cluster that it should attempt to recover a specific partition which is currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_565228 = newJObject()
  var query_565229 = newJObject()
  add(query_565229, "api-version", newJString(apiVersion))
  add(query_565229, "timeout", newJInt(timeout))
  add(path_565228, "partitionId", newJString(partitionId))
  result = call_565227.call(path_565228, query_565229, nil, nil, nil)

var recoverPartition* = Call_RecoverPartition_565220(name: "recoverPartition",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/Recover",
    validator: validate_RecoverPartition_565221, base: "",
    url: url_RecoverPartition_565222, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportPartitionHealth_565230 = ref object of OpenApiRestCall_563564
proc url_ReportPartitionHealth_565232(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/ReportHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportPartitionHealth_565231(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Reports health state of the specified Service Fabric partition. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Partition, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetPartitionHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_565233 = path.getOrDefault("partitionId")
  valid_565233 = validateParameter(valid_565233, JString, required = true,
                                 default = nil)
  if valid_565233 != nil:
    section.add "partitionId", valid_565233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565234 = query.getOrDefault("api-version")
  valid_565234 = validateParameter(valid_565234, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565234 != nil:
    section.add "api-version", valid_565234
  var valid_565235 = query.getOrDefault("timeout")
  valid_565235 = validateParameter(valid_565235, JInt, required = false,
                                 default = newJInt(60))
  if valid_565235 != nil:
    section.add "timeout", valid_565235
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565237: Call_ReportPartitionHealth_565230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reports health state of the specified Service Fabric partition. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Partition, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetPartitionHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_565237.validator(path, query, header, formData, body)
  let scheme = call_565237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565237.url(scheme.get, call_565237.host, call_565237.base,
                         call_565237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565237, url, valid)

proc call*(call_565238: Call_ReportPartitionHealth_565230;
          HealthInformation: JsonNode; partitionId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## reportPartitionHealth
  ## Reports health state of the specified Service Fabric partition. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Partition, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetPartitionHealth and check that the report appears in the HealthEvents section.
  ## 
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_565239 = newJObject()
  var query_565240 = newJObject()
  var body_565241 = newJObject()
  if HealthInformation != nil:
    body_565241 = HealthInformation
  add(query_565240, "api-version", newJString(apiVersion))
  add(query_565240, "timeout", newJInt(timeout))
  add(path_565239, "partitionId", newJString(partitionId))
  result = call_565238.call(path_565239, query_565240, nil, nil, body_565241)

var reportPartitionHealth* = Call_ReportPartitionHealth_565230(
    name: "reportPartitionHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/ReportHealth",
    validator: validate_ReportPartitionHealth_565231, base: "",
    url: url_ReportPartitionHealth_565232, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ResetPartitionLoad_565242 = ref object of OpenApiRestCall_563564
proc url_ResetPartitionLoad_565244(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "partitionId" in path, "`partitionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Partitions/"),
               (kind: VariableSegment, value: "partitionId"),
               (kind: ConstantSegment, value: "/$/ResetLoad")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResetPartitionLoad_565243(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Resets the current load of a Service Fabric partition to the default load for the service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   partitionId: JString (required)
  ##              : The identity of the partition.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `partitionId` field"
  var valid_565245 = path.getOrDefault("partitionId")
  valid_565245 = validateParameter(valid_565245, JString, required = true,
                                 default = nil)
  if valid_565245 != nil:
    section.add "partitionId", valid_565245
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565246 = query.getOrDefault("api-version")
  valid_565246 = validateParameter(valid_565246, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565246 != nil:
    section.add "api-version", valid_565246
  var valid_565247 = query.getOrDefault("timeout")
  valid_565247 = validateParameter(valid_565247, JInt, required = false,
                                 default = newJInt(60))
  if valid_565247 != nil:
    section.add "timeout", valid_565247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565248: Call_ResetPartitionLoad_565242; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the current load of a Service Fabric partition to the default load for the service.
  ## 
  let valid = call_565248.validator(path, query, header, formData, body)
  let scheme = call_565248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565248.url(scheme.get, call_565248.host, call_565248.base,
                         call_565248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565248, url, valid)

proc call*(call_565249: Call_ResetPartitionLoad_565242; partitionId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## resetPartitionLoad
  ## Resets the current load of a Service Fabric partition to the default load for the service.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_565250 = newJObject()
  var query_565251 = newJObject()
  add(query_565251, "api-version", newJString(apiVersion))
  add(query_565251, "timeout", newJInt(timeout))
  add(path_565250, "partitionId", newJString(partitionId))
  result = call_565249.call(path_565250, query_565251, nil, nil, nil)

var resetPartitionLoad* = Call_ResetPartitionLoad_565242(
    name: "resetPartitionLoad", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/ResetLoad",
    validator: validate_ResetPartitionLoad_565243, base: "",
    url: url_ResetPartitionLoad_565244, schemes: {Scheme.Https, Scheme.Http})
type
  Call_RecoverServicePartitions_565252 = ref object of OpenApiRestCall_563564
proc url_RecoverServicePartitions_565254(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceId" in path, "`serviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Services/$/"),
               (kind: VariableSegment, value: "serviceId"),
               (kind: ConstantSegment, value: "/$/GetPartitions/$/Recover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RecoverServicePartitions_565253(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Indicates to the Service Fabric cluster that it should attempt to recover the specified service which is currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceId: JString (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `serviceId` field"
  var valid_565255 = path.getOrDefault("serviceId")
  valid_565255 = validateParameter(valid_565255, JString, required = true,
                                 default = nil)
  if valid_565255 != nil:
    section.add "serviceId", valid_565255
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565256 = query.getOrDefault("api-version")
  valid_565256 = validateParameter(valid_565256, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565256 != nil:
    section.add "api-version", valid_565256
  var valid_565257 = query.getOrDefault("timeout")
  valid_565257 = validateParameter(valid_565257, JInt, required = false,
                                 default = newJInt(60))
  if valid_565257 != nil:
    section.add "timeout", valid_565257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565258: Call_RecoverServicePartitions_565252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicates to the Service Fabric cluster that it should attempt to recover the specified service which is currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ## 
  let valid = call_565258.validator(path, query, header, formData, body)
  let scheme = call_565258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565258.url(scheme.get, call_565258.host, call_565258.base,
                         call_565258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565258, url, valid)

proc call*(call_565259: Call_RecoverServicePartitions_565252; serviceId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## recoverServicePartitions
  ## Indicates to the Service Fabric cluster that it should attempt to recover the specified service which is currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_565260 = newJObject()
  var query_565261 = newJObject()
  add(query_565261, "api-version", newJString(apiVersion))
  add(query_565261, "timeout", newJInt(timeout))
  add(path_565260, "serviceId", newJString(serviceId))
  result = call_565259.call(path_565260, query_565261, nil, nil, nil)

var recoverServicePartitions* = Call_RecoverServicePartitions_565252(
    name: "recoverServicePartitions", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Services/$/{serviceId}/$/GetPartitions/$/Recover",
    validator: validate_RecoverServicePartitions_565253, base: "",
    url: url_RecoverServicePartitions_565254, schemes: {Scheme.Https, Scheme.Http})
type
  Call_DeleteService_565262 = ref object of OpenApiRestCall_563564
proc url_DeleteService_565264(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceId" in path, "`serviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Services/"),
               (kind: VariableSegment, value: "serviceId"),
               (kind: ConstantSegment, value: "/$/Delete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DeleteService_565263(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing Service Fabric service. A service must be created before it can be deleted. By default Service Fabric will try to close service replicas in a graceful manner and then delete the service. However if service is having issues closing the replica gracefully, the delete operation may take a long time or get stuck. Use the optional ForceRemove flag to skip the graceful close sequence and forcefully delete the service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceId: JString (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `serviceId` field"
  var valid_565265 = path.getOrDefault("serviceId")
  valid_565265 = validateParameter(valid_565265, JString, required = true,
                                 default = nil)
  if valid_565265 != nil:
    section.add "serviceId", valid_565265
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ForceRemove: JBool
  ##              : Remove a Service Fabric application or service forcefully without going through the graceful shutdown sequence. This parameter can be used to forcefully delete an application or service for which delete is timing out due to issues in the service code that prevents graceful close of replicas.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565266 = query.getOrDefault("api-version")
  valid_565266 = validateParameter(valid_565266, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565266 != nil:
    section.add "api-version", valid_565266
  var valid_565267 = query.getOrDefault("timeout")
  valid_565267 = validateParameter(valid_565267, JInt, required = false,
                                 default = newJInt(60))
  if valid_565267 != nil:
    section.add "timeout", valid_565267
  var valid_565268 = query.getOrDefault("ForceRemove")
  valid_565268 = validateParameter(valid_565268, JBool, required = false, default = nil)
  if valid_565268 != nil:
    section.add "ForceRemove", valid_565268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565269: Call_DeleteService_565262; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Service Fabric service. A service must be created before it can be deleted. By default Service Fabric will try to close service replicas in a graceful manner and then delete the service. However if service is having issues closing the replica gracefully, the delete operation may take a long time or get stuck. Use the optional ForceRemove flag to skip the graceful close sequence and forcefully delete the service.
  ## 
  let valid = call_565269.validator(path, query, header, formData, body)
  let scheme = call_565269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565269.url(scheme.get, call_565269.host, call_565269.base,
                         call_565269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565269, url, valid)

proc call*(call_565270: Call_DeleteService_565262; serviceId: string;
          apiVersion: string = "3.0"; timeout: int = 60; ForceRemove: bool = false): Recallable =
  ## deleteService
  ## Deletes an existing Service Fabric service. A service must be created before it can be deleted. By default Service Fabric will try to close service replicas in a graceful manner and then delete the service. However if service is having issues closing the replica gracefully, the delete operation may take a long time or get stuck. Use the optional ForceRemove flag to skip the graceful close sequence and forcefully delete the service.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ForceRemove: bool
  ##              : Remove a Service Fabric application or service forcefully without going through the graceful shutdown sequence. This parameter can be used to forcefully delete an application or service for which delete is timing out due to issues in the service code that prevents graceful close of replicas.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_565271 = newJObject()
  var query_565272 = newJObject()
  add(query_565272, "api-version", newJString(apiVersion))
  add(query_565272, "timeout", newJInt(timeout))
  add(query_565272, "ForceRemove", newJBool(ForceRemove))
  add(path_565271, "serviceId", newJString(serviceId))
  result = call_565270.call(path_565271, query_565272, nil, nil, nil)

var deleteService* = Call_DeleteService_565262(name: "deleteService",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Services/{serviceId}/$/Delete", validator: validate_DeleteService_565263,
    base: "", url: url_DeleteService_565264, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationNameInfo_565273 = ref object of OpenApiRestCall_563564
proc url_GetApplicationNameInfo_565275(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceId" in path, "`serviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Services/"),
               (kind: VariableSegment, value: "serviceId"),
               (kind: ConstantSegment, value: "/$/GetApplicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetApplicationNameInfo_565274(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The GetApplicationName endpoint returns the name of the application for the specified service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceId: JString (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `serviceId` field"
  var valid_565276 = path.getOrDefault("serviceId")
  valid_565276 = validateParameter(valid_565276, JString, required = true,
                                 default = nil)
  if valid_565276 != nil:
    section.add "serviceId", valid_565276
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565277 = query.getOrDefault("api-version")
  valid_565277 = validateParameter(valid_565277, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565277 != nil:
    section.add "api-version", valid_565277
  var valid_565278 = query.getOrDefault("timeout")
  valid_565278 = validateParameter(valid_565278, JInt, required = false,
                                 default = newJInt(60))
  if valid_565278 != nil:
    section.add "timeout", valid_565278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565279: Call_GetApplicationNameInfo_565273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetApplicationName endpoint returns the name of the application for the specified service.
  ## 
  let valid = call_565279.validator(path, query, header, formData, body)
  let scheme = call_565279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565279.url(scheme.get, call_565279.host, call_565279.base,
                         call_565279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565279, url, valid)

proc call*(call_565280: Call_GetApplicationNameInfo_565273; serviceId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getApplicationNameInfo
  ## The GetApplicationName endpoint returns the name of the application for the specified service.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_565281 = newJObject()
  var query_565282 = newJObject()
  add(query_565282, "api-version", newJString(apiVersion))
  add(query_565282, "timeout", newJInt(timeout))
  add(path_565281, "serviceId", newJString(serviceId))
  result = call_565280.call(path_565281, query_565282, nil, nil, nil)

var getApplicationNameInfo* = Call_GetApplicationNameInfo_565273(
    name: "getApplicationNameInfo", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Services/{serviceId}/$/GetApplicationName",
    validator: validate_GetApplicationNameInfo_565274, base: "",
    url: url_GetApplicationNameInfo_565275, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceDescription_565283 = ref object of OpenApiRestCall_563564
proc url_GetServiceDescription_565285(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceId" in path, "`serviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Services/"),
               (kind: VariableSegment, value: "serviceId"),
               (kind: ConstantSegment, value: "/$/GetDescription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetServiceDescription_565284(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the description of an existing Service Fabric service. A service must be created before its description can be obtained.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceId: JString (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `serviceId` field"
  var valid_565286 = path.getOrDefault("serviceId")
  valid_565286 = validateParameter(valid_565286, JString, required = true,
                                 default = nil)
  if valid_565286 != nil:
    section.add "serviceId", valid_565286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565287 = query.getOrDefault("api-version")
  valid_565287 = validateParameter(valid_565287, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565287 != nil:
    section.add "api-version", valid_565287
  var valid_565288 = query.getOrDefault("timeout")
  valid_565288 = validateParameter(valid_565288, JInt, required = false,
                                 default = newJInt(60))
  if valid_565288 != nil:
    section.add "timeout", valid_565288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565289: Call_GetServiceDescription_565283; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the description of an existing Service Fabric service. A service must be created before its description can be obtained.
  ## 
  let valid = call_565289.validator(path, query, header, formData, body)
  let scheme = call_565289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565289.url(scheme.get, call_565289.host, call_565289.base,
                         call_565289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565289, url, valid)

proc call*(call_565290: Call_GetServiceDescription_565283; serviceId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getServiceDescription
  ## Gets the description of an existing Service Fabric service. A service must be created before its description can be obtained.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_565291 = newJObject()
  var query_565292 = newJObject()
  add(query_565292, "api-version", newJString(apiVersion))
  add(query_565292, "timeout", newJInt(timeout))
  add(path_565291, "serviceId", newJString(serviceId))
  result = call_565290.call(path_565291, query_565292, nil, nil, nil)

var getServiceDescription* = Call_GetServiceDescription_565283(
    name: "getServiceDescription", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Services/{serviceId}/$/GetDescription",
    validator: validate_GetServiceDescription_565284, base: "",
    url: url_GetServiceDescription_565285, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceHealthUsingPolicy_565305 = ref object of OpenApiRestCall_563564
proc url_GetServiceHealthUsingPolicy_565307(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceId" in path, "`serviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Services/"),
               (kind: VariableSegment, value: "serviceId"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetServiceHealthUsingPolicy_565306(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the health information of the specified service.
  ## If the application health policy is specified, the health evaluation uses it to get the aggregated health state.
  ## If the policy is not specified, the health evaluation uses the application health policy defined in the application manifest, or the default health policy, if no policy is defined in the manifest.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the service based on the health state.
  ## Use PartitionsHealthStateFilter to filter the collection of partitions returned.
  ## If you specify a service that does not exist in the health store, this cmdlet returns an error.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceId: JString (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `serviceId` field"
  var valid_565308 = path.getOrDefault("serviceId")
  valid_565308 = validateParameter(valid_565308, JString, required = true,
                                 default = nil)
  if valid_565308 != nil:
    section.add "serviceId", valid_565308
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   PartitionsHealthStateFilter: JInt
  ##                              : Allows filtering of the partitions health state objects returned in the result of service health query based on their health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only partitions that match the filter are returned. All partitions are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value
  ## obtained using bitwise 'OR' operator. For example, if the provided value is 6 then health state of partitions with HealthState value of OK (2) and Warning (4) will be returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn't match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   EventsHealthStateFilter: JInt
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565309 = query.getOrDefault("api-version")
  valid_565309 = validateParameter(valid_565309, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565309 != nil:
    section.add "api-version", valid_565309
  var valid_565310 = query.getOrDefault("PartitionsHealthStateFilter")
  valid_565310 = validateParameter(valid_565310, JInt, required = false,
                                 default = newJInt(0))
  if valid_565310 != nil:
    section.add "PartitionsHealthStateFilter", valid_565310
  var valid_565311 = query.getOrDefault("timeout")
  valid_565311 = validateParameter(valid_565311, JInt, required = false,
                                 default = newJInt(60))
  if valid_565311 != nil:
    section.add "timeout", valid_565311
  var valid_565312 = query.getOrDefault("EventsHealthStateFilter")
  valid_565312 = validateParameter(valid_565312, JInt, required = false,
                                 default = newJInt(0))
  if valid_565312 != nil:
    section.add "EventsHealthStateFilter", valid_565312
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ApplicationHealthPolicy: JObject
  ##                          : Describes the health policies used to evaluate the health of an application or one of its children.
  ## If not present, the health evaluation uses the health policy from application manifest or the default health policy.
  ## 
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565314: Call_GetServiceHealthUsingPolicy_565305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health information of the specified service.
  ## If the application health policy is specified, the health evaluation uses it to get the aggregated health state.
  ## If the policy is not specified, the health evaluation uses the application health policy defined in the application manifest, or the default health policy, if no policy is defined in the manifest.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the service based on the health state.
  ## Use PartitionsHealthStateFilter to filter the collection of partitions returned.
  ## If you specify a service that does not exist in the health store, this cmdlet returns an error.
  ## 
  ## 
  let valid = call_565314.validator(path, query, header, formData, body)
  let scheme = call_565314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565314.url(scheme.get, call_565314.host, call_565314.base,
                         call_565314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565314, url, valid)

proc call*(call_565315: Call_GetServiceHealthUsingPolicy_565305; serviceId: string;
          ApplicationHealthPolicy: JsonNode = nil; apiVersion: string = "3.0";
          PartitionsHealthStateFilter: int = 0; timeout: int = 60;
          EventsHealthStateFilter: int = 0): Recallable =
  ## getServiceHealthUsingPolicy
  ## Gets the health information of the specified service.
  ## If the application health policy is specified, the health evaluation uses it to get the aggregated health state.
  ## If the policy is not specified, the health evaluation uses the application health policy defined in the application manifest, or the default health policy, if no policy is defined in the manifest.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the service based on the health state.
  ## Use PartitionsHealthStateFilter to filter the collection of partitions returned.
  ## If you specify a service that does not exist in the health store, this cmdlet returns an error.
  ## 
  ##   ApplicationHealthPolicy: JObject
  ##                          : Describes the health policies used to evaluate the health of an application or one of its children.
  ## If not present, the health evaluation uses the health policy from application manifest or the default health policy.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   PartitionsHealthStateFilter: int
  ##                              : Allows filtering of the partitions health state objects returned in the result of service health query based on their health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only partitions that match the filter are returned. All partitions are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value
  ## obtained using bitwise 'OR' operator. For example, if the provided value is 6 then health state of partitions with HealthState value of OK (2) and Warning (4) will be returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn't match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   EventsHealthStateFilter: int
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_565316 = newJObject()
  var query_565317 = newJObject()
  var body_565318 = newJObject()
  if ApplicationHealthPolicy != nil:
    body_565318 = ApplicationHealthPolicy
  add(query_565317, "api-version", newJString(apiVersion))
  add(query_565317, "PartitionsHealthStateFilter",
      newJInt(PartitionsHealthStateFilter))
  add(query_565317, "timeout", newJInt(timeout))
  add(query_565317, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_565316, "serviceId", newJString(serviceId))
  result = call_565315.call(path_565316, query_565317, nil, nil, body_565318)

var getServiceHealthUsingPolicy* = Call_GetServiceHealthUsingPolicy_565305(
    name: "getServiceHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Services/{serviceId}/$/GetHealth",
    validator: validate_GetServiceHealthUsingPolicy_565306, base: "",
    url: url_GetServiceHealthUsingPolicy_565307,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceHealth_565293 = ref object of OpenApiRestCall_563564
proc url_GetServiceHealth_565295(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceId" in path, "`serviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Services/"),
               (kind: VariableSegment, value: "serviceId"),
               (kind: ConstantSegment, value: "/$/GetHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetServiceHealth_565294(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets the health information of the specified service.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the service based on the health state.
  ## Use PartitionsHealthStateFilter to filter the collection of partitions returned.
  ## If you specify a service that does not exist in the health store, this cmdlet returns an error.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceId: JString (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `serviceId` field"
  var valid_565296 = path.getOrDefault("serviceId")
  valid_565296 = validateParameter(valid_565296, JString, required = true,
                                 default = nil)
  if valid_565296 != nil:
    section.add "serviceId", valid_565296
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   PartitionsHealthStateFilter: JInt
  ##                              : Allows filtering of the partitions health state objects returned in the result of service health query based on their health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only partitions that match the filter are returned. All partitions are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value
  ## obtained using bitwise 'OR' operator. For example, if the provided value is 6 then health state of partitions with HealthState value of OK (2) and Warning (4) will be returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn't match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   EventsHealthStateFilter: JInt
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565297 = query.getOrDefault("api-version")
  valid_565297 = validateParameter(valid_565297, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565297 != nil:
    section.add "api-version", valid_565297
  var valid_565298 = query.getOrDefault("PartitionsHealthStateFilter")
  valid_565298 = validateParameter(valid_565298, JInt, required = false,
                                 default = newJInt(0))
  if valid_565298 != nil:
    section.add "PartitionsHealthStateFilter", valid_565298
  var valid_565299 = query.getOrDefault("timeout")
  valid_565299 = validateParameter(valid_565299, JInt, required = false,
                                 default = newJInt(60))
  if valid_565299 != nil:
    section.add "timeout", valid_565299
  var valid_565300 = query.getOrDefault("EventsHealthStateFilter")
  valid_565300 = validateParameter(valid_565300, JInt, required = false,
                                 default = newJInt(0))
  if valid_565300 != nil:
    section.add "EventsHealthStateFilter", valid_565300
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565301: Call_GetServiceHealth_565293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health information of the specified service.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the service based on the health state.
  ## Use PartitionsHealthStateFilter to filter the collection of partitions returned.
  ## If you specify a service that does not exist in the health store, this cmdlet returns an error.
  ## 
  ## 
  let valid = call_565301.validator(path, query, header, formData, body)
  let scheme = call_565301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565301.url(scheme.get, call_565301.host, call_565301.base,
                         call_565301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565301, url, valid)

proc call*(call_565302: Call_GetServiceHealth_565293; serviceId: string;
          apiVersion: string = "3.0"; PartitionsHealthStateFilter: int = 0;
          timeout: int = 60; EventsHealthStateFilter: int = 0): Recallable =
  ## getServiceHealth
  ## Gets the health information of the specified service.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the service based on the health state.
  ## Use PartitionsHealthStateFilter to filter the collection of partitions returned.
  ## If you specify a service that does not exist in the health store, this cmdlet returns an error.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   PartitionsHealthStateFilter: int
  ##                              : Allows filtering of the partitions health state objects returned in the result of service health query based on their health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only partitions that match the filter are returned. All partitions are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value
  ## obtained using bitwise 'OR' operator. For example, if the provided value is 6 then health state of partitions with HealthState value of OK (2) and Warning (4) will be returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn't match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   EventsHealthStateFilter: int
  ##                          : Allows filtering the collection of HealthEvent objects returned based on health state.
  ## The possible values for this parameter include integer value of one of the following health states.
  ## Only events that match the filter are returned. All events are used to evaluate the aggregated health state.
  ## If not specified, all entries are returned. The state values are flag based enumeration, so the value could be a combination of these value obtained using bitwise 'OR' operator. For example, If the provided value is 6 then all of the events with HealthState value of OK (2) and Warning (4) are returned.
  ## 
  ## - Default - Default value. Matches any HealthState. The value is zero.
  ## - None - Filter that doesn’t match any HealthState value. Used in order to return no results on a given collection of states. The value is 1.
  ## - Ok - Filter that matches input with HealthState value Ok. The value is 2.
  ## - Warning - Filter that matches input with HealthState value Warning. The value is 4.
  ## - Error - Filter that matches input with HealthState value Error. The value is 8.
  ## - All - Filter that matches input with any HealthState value. The value is 65535.
  ## 
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_565303 = newJObject()
  var query_565304 = newJObject()
  add(query_565304, "api-version", newJString(apiVersion))
  add(query_565304, "PartitionsHealthStateFilter",
      newJInt(PartitionsHealthStateFilter))
  add(query_565304, "timeout", newJInt(timeout))
  add(query_565304, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_565303, "serviceId", newJString(serviceId))
  result = call_565302.call(path_565303, query_565304, nil, nil, nil)

var getServiceHealth* = Call_GetServiceHealth_565293(name: "getServiceHealth",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Services/{serviceId}/$/GetHealth",
    validator: validate_GetServiceHealth_565294, base: "",
    url: url_GetServiceHealth_565295, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetPartitionInfoList_565319 = ref object of OpenApiRestCall_563564
proc url_GetPartitionInfoList_565321(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceId" in path, "`serviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Services/"),
               (kind: VariableSegment, value: "serviceId"),
               (kind: ConstantSegment, value: "/$/GetPartitions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GetPartitionInfoList_565320(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the list of partitions of a Service Fabric service. The response include the partition id, partitioning scheme information, keys supported by the partition, status, health and other details about the partition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceId: JString (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `serviceId` field"
  var valid_565322 = path.getOrDefault("serviceId")
  valid_565322 = validateParameter(valid_565322, JString, required = true,
                                 default = nil)
  if valid_565322 != nil:
    section.add "serviceId", valid_565322
  result.add "path", section
  ## parameters in `query` object:
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  var valid_565323 = query.getOrDefault("ContinuationToken")
  valid_565323 = validateParameter(valid_565323, JString, required = false,
                                 default = nil)
  if valid_565323 != nil:
    section.add "ContinuationToken", valid_565323
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565324 = query.getOrDefault("api-version")
  valid_565324 = validateParameter(valid_565324, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565324 != nil:
    section.add "api-version", valid_565324
  var valid_565325 = query.getOrDefault("timeout")
  valid_565325 = validateParameter(valid_565325, JInt, required = false,
                                 default = newJInt(60))
  if valid_565325 != nil:
    section.add "timeout", valid_565325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565326: Call_GetPartitionInfoList_565319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of partitions of a Service Fabric service. The response include the partition id, partitioning scheme information, keys supported by the partition, status, health and other details about the partition.
  ## 
  let valid = call_565326.validator(path, query, header, formData, body)
  let scheme = call_565326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565326.url(scheme.get, call_565326.host, call_565326.base,
                         call_565326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565326, url, valid)

proc call*(call_565327: Call_GetPartitionInfoList_565319; serviceId: string;
          ContinuationToken: string = ""; apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## getPartitionInfoList
  ## Gets the list of partitions of a Service Fabric service. The response include the partition id, partitioning scheme information, keys supported by the partition, status, health and other details about the partition.
  ##   ContinuationToken: string
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_565328 = newJObject()
  var query_565329 = newJObject()
  add(query_565329, "ContinuationToken", newJString(ContinuationToken))
  add(query_565329, "api-version", newJString(apiVersion))
  add(query_565329, "timeout", newJInt(timeout))
  add(path_565328, "serviceId", newJString(serviceId))
  result = call_565327.call(path_565328, query_565329, nil, nil, nil)

var getPartitionInfoList* = Call_GetPartitionInfoList_565319(
    name: "getPartitionInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Services/{serviceId}/$/GetPartitions",
    validator: validate_GetPartitionInfoList_565320, base: "",
    url: url_GetPartitionInfoList_565321, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportServiceHealth_565330 = ref object of OpenApiRestCall_563564
proc url_ReportServiceHealth_565332(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceId" in path, "`serviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Services/"),
               (kind: VariableSegment, value: "serviceId"),
               (kind: ConstantSegment, value: "/$/ReportHealth")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReportServiceHealth_565331(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Reports health state of the specified Service Fabric service. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Service, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetServiceHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceId: JString (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `serviceId` field"
  var valid_565333 = path.getOrDefault("serviceId")
  valid_565333 = validateParameter(valid_565333, JString, required = true,
                                 default = nil)
  if valid_565333 != nil:
    section.add "serviceId", valid_565333
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565334 = query.getOrDefault("api-version")
  valid_565334 = validateParameter(valid_565334, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565334 != nil:
    section.add "api-version", valid_565334
  var valid_565335 = query.getOrDefault("timeout")
  valid_565335 = validateParameter(valid_565335, JInt, required = false,
                                 default = newJInt(60))
  if valid_565335 != nil:
    section.add "timeout", valid_565335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565337: Call_ReportServiceHealth_565330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reports health state of the specified Service Fabric service. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Service, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetServiceHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_565337.validator(path, query, header, formData, body)
  let scheme = call_565337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565337.url(scheme.get, call_565337.host, call_565337.base,
                         call_565337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565337, url, valid)

proc call*(call_565338: Call_ReportServiceHealth_565330;
          HealthInformation: JsonNode; serviceId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## reportServiceHealth
  ## Reports health state of the specified Service Fabric service. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Service, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetServiceHealth and check that the report appears in the HealthEvents section.
  ## 
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_565339 = newJObject()
  var query_565340 = newJObject()
  var body_565341 = newJObject()
  if HealthInformation != nil:
    body_565341 = HealthInformation
  add(query_565340, "api-version", newJString(apiVersion))
  add(query_565340, "timeout", newJInt(timeout))
  add(path_565339, "serviceId", newJString(serviceId))
  result = call_565338.call(path_565339, query_565340, nil, nil, body_565341)

var reportServiceHealth* = Call_ReportServiceHealth_565330(
    name: "reportServiceHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Services/{serviceId}/$/ReportHealth",
    validator: validate_ReportServiceHealth_565331, base: "",
    url: url_ReportServiceHealth_565332, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ResolveService_565342 = ref object of OpenApiRestCall_563564
proc url_ResolveService_565344(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceId" in path, "`serviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Services/"),
               (kind: VariableSegment, value: "serviceId"),
               (kind: ConstantSegment, value: "/$/ResolvePartition")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResolveService_565343(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Resolve a Service Fabric service partition, to get the endpoints of the service replicas.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceId: JString (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `serviceId` field"
  var valid_565345 = path.getOrDefault("serviceId")
  valid_565345 = validateParameter(valid_565345, JString, required = true,
                                 default = nil)
  if valid_565345 != nil:
    section.add "serviceId", valid_565345
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   PartitionKeyValue: JString
  ##                    : Partition key. This is required if the partition scheme for the service is Int64Range or Named.
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   PartitionKeyType: JInt
  ##                   : Key type for the partition. This parameter is required if the partition scheme for the service is Int64Range or Named. The possible values are following.
  ## - None (1) - Indicates that the the PartitionKeyValue parameter is not specified. This is valid for the partitions with partitioning scheme as Singleton. This is the default value. The value is 1.
  ## - Int64Range (2) - Indicates that the the PartitionKeyValue parameter is an int64 partition key. This is valid for the partitions with partitioning scheme as Int64Range. The value is 2.
  ## - Named (3) - Indicates that the the PartitionKeyValue parameter is a name of the partition. This is valid for the partitions with partitioning scheme as Named. The value is 3.
  ## 
  ##   PreviousRspVersion: JString
  ##                     : The value in the Version field of the response that was received previously. This is required if the user knows that the result that was got previously is stale.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565346 = query.getOrDefault("api-version")
  valid_565346 = validateParameter(valid_565346, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565346 != nil:
    section.add "api-version", valid_565346
  var valid_565347 = query.getOrDefault("PartitionKeyValue")
  valid_565347 = validateParameter(valid_565347, JString, required = false,
                                 default = nil)
  if valid_565347 != nil:
    section.add "PartitionKeyValue", valid_565347
  var valid_565348 = query.getOrDefault("timeout")
  valid_565348 = validateParameter(valid_565348, JInt, required = false,
                                 default = newJInt(60))
  if valid_565348 != nil:
    section.add "timeout", valid_565348
  var valid_565349 = query.getOrDefault("PartitionKeyType")
  valid_565349 = validateParameter(valid_565349, JInt, required = false, default = nil)
  if valid_565349 != nil:
    section.add "PartitionKeyType", valid_565349
  var valid_565350 = query.getOrDefault("PreviousRspVersion")
  valid_565350 = validateParameter(valid_565350, JString, required = false,
                                 default = nil)
  if valid_565350 != nil:
    section.add "PreviousRspVersion", valid_565350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565351: Call_ResolveService_565342; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resolve a Service Fabric service partition, to get the endpoints of the service replicas.
  ## 
  let valid = call_565351.validator(path, query, header, formData, body)
  let scheme = call_565351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565351.url(scheme.get, call_565351.host, call_565351.base,
                         call_565351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565351, url, valid)

proc call*(call_565352: Call_ResolveService_565342; serviceId: string;
          apiVersion: string = "3.0"; PartitionKeyValue: string = ""; timeout: int = 60;
          PartitionKeyType: int = 0; PreviousRspVersion: string = ""): Recallable =
  ## resolveService
  ## Resolve a Service Fabric service partition, to get the endpoints of the service replicas.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   PartitionKeyValue: string
  ##                    : Partition key. This is required if the partition scheme for the service is Int64Range or Named.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   PartitionKeyType: int
  ##                   : Key type for the partition. This parameter is required if the partition scheme for the service is Int64Range or Named. The possible values are following.
  ## - None (1) - Indicates that the the PartitionKeyValue parameter is not specified. This is valid for the partitions with partitioning scheme as Singleton. This is the default value. The value is 1.
  ## - Int64Range (2) - Indicates that the the PartitionKeyValue parameter is an int64 partition key. This is valid for the partitions with partitioning scheme as Int64Range. The value is 2.
  ## - Named (3) - Indicates that the the PartitionKeyValue parameter is a name of the partition. This is valid for the partitions with partitioning scheme as Named. The value is 3.
  ## 
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  ##   PreviousRspVersion: string
  ##                     : The value in the Version field of the response that was received previously. This is required if the user knows that the result that was got previously is stale.
  var path_565353 = newJObject()
  var query_565354 = newJObject()
  add(query_565354, "api-version", newJString(apiVersion))
  add(query_565354, "PartitionKeyValue", newJString(PartitionKeyValue))
  add(query_565354, "timeout", newJInt(timeout))
  add(query_565354, "PartitionKeyType", newJInt(PartitionKeyType))
  add(path_565353, "serviceId", newJString(serviceId))
  add(query_565354, "PreviousRspVersion", newJString(PreviousRspVersion))
  result = call_565352.call(path_565353, query_565354, nil, nil, nil)

var resolveService* = Call_ResolveService_565342(name: "resolveService",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Services/{serviceId}/$/ResolvePartition",
    validator: validate_ResolveService_565343, base: "", url: url_ResolveService_565344,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_UpdateService_565355 = ref object of OpenApiRestCall_563564
proc url_UpdateService_565357(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "serviceId" in path, "`serviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/Services/"),
               (kind: VariableSegment, value: "serviceId"),
               (kind: ConstantSegment, value: "/$/Update")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_UpdateService_565356(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified service using the given update description.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceId: JString (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `serviceId` field"
  var valid_565358 = path.getOrDefault("serviceId")
  valid_565358 = validateParameter(valid_565358, JString, required = true,
                                 default = nil)
  if valid_565358 != nil:
    section.add "serviceId", valid_565358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565359 = query.getOrDefault("api-version")
  valid_565359 = validateParameter(valid_565359, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565359 != nil:
    section.add "api-version", valid_565359
  var valid_565360 = query.getOrDefault("timeout")
  valid_565360 = validateParameter(valid_565360, JInt, required = false,
                                 default = newJInt(60))
  if valid_565360 != nil:
    section.add "timeout", valid_565360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ServiceUpdateDescription: JObject (required)
  ##                           : The updated configuration for the service.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565362: Call_UpdateService_565355; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified service using the given update description.
  ## 
  let valid = call_565362.validator(path, query, header, formData, body)
  let scheme = call_565362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565362.url(scheme.get, call_565362.host, call_565362.base,
                         call_565362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565362, url, valid)

proc call*(call_565363: Call_UpdateService_565355;
          ServiceUpdateDescription: JsonNode; serviceId: string;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## updateService
  ## Updates the specified service using the given update description.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ServiceUpdateDescription: JObject (required)
  ##                           : The updated configuration for the service.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_565364 = newJObject()
  var query_565365 = newJObject()
  var body_565366 = newJObject()
  add(query_565365, "api-version", newJString(apiVersion))
  if ServiceUpdateDescription != nil:
    body_565366 = ServiceUpdateDescription
  add(query_565365, "timeout", newJInt(timeout))
  add(path_565364, "serviceId", newJString(serviceId))
  result = call_565363.call(path_565364, query_565365, nil, nil, body_565366)

var updateService* = Call_UpdateService_565355(name: "updateService",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Services/{serviceId}/$/Update", validator: validate_UpdateService_565356,
    base: "", url: url_UpdateService_565357, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetChaosReport_565367 = ref object of OpenApiRestCall_563564
proc url_GetChaosReport_565369(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetChaosReport_565368(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## You can either specify the ContinuationToken to get the next segment of the Chaos report or you can specify the time-range
  ## through StartTimeUtc and EndTimeUtc, but you cannot specify both the ContinuationToken and the time-range in the same call.
  ## When there are more than 100 Chaos events, the Chaos report is returned in segments where a segment contains no more than 100 Chaos events.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   EndTimeUtc: JString
  ##             : The count of ticks representing the end time of the time range for which a Chaos report is to be generated. Please consult [DateTime.Ticks 
  ## Property](https://msdn.microsoft.com/en-us/library/system.datetime.ticks%28v=vs.110%29) for details about tick.
  ##   StartTimeUtc: JString
  ##               : The count of ticks representing the start time of the time range for which a Chaos report is to be generated. Please consult [DateTime.Ticks 
  ## Property](https://msdn.microsoft.com/en-us/library/system.datetime.ticks%28v=vs.110%29) for details about tick.
  section = newJObject()
  var valid_565370 = query.getOrDefault("ContinuationToken")
  valid_565370 = validateParameter(valid_565370, JString, required = false,
                                 default = nil)
  if valid_565370 != nil:
    section.add "ContinuationToken", valid_565370
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565371 = query.getOrDefault("api-version")
  valid_565371 = validateParameter(valid_565371, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565371 != nil:
    section.add "api-version", valid_565371
  var valid_565372 = query.getOrDefault("timeout")
  valid_565372 = validateParameter(valid_565372, JInt, required = false,
                                 default = newJInt(60))
  if valid_565372 != nil:
    section.add "timeout", valid_565372
  var valid_565373 = query.getOrDefault("EndTimeUtc")
  valid_565373 = validateParameter(valid_565373, JString, required = false,
                                 default = nil)
  if valid_565373 != nil:
    section.add "EndTimeUtc", valid_565373
  var valid_565374 = query.getOrDefault("StartTimeUtc")
  valid_565374 = validateParameter(valid_565374, JString, required = false,
                                 default = nil)
  if valid_565374 != nil:
    section.add "StartTimeUtc", valid_565374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565375: Call_GetChaosReport_565367; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can either specify the ContinuationToken to get the next segment of the Chaos report or you can specify the time-range
  ## through StartTimeUtc and EndTimeUtc, but you cannot specify both the ContinuationToken and the time-range in the same call.
  ## When there are more than 100 Chaos events, the Chaos report is returned in segments where a segment contains no more than 100 Chaos events.
  ## 
  ## 
  let valid = call_565375.validator(path, query, header, formData, body)
  let scheme = call_565375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565375.url(scheme.get, call_565375.host, call_565375.base,
                         call_565375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565375, url, valid)

proc call*(call_565376: Call_GetChaosReport_565367; ContinuationToken: string = "";
          apiVersion: string = "3.0"; timeout: int = 60; EndTimeUtc: string = "";
          StartTimeUtc: string = ""): Recallable =
  ## getChaosReport
  ## You can either specify the ContinuationToken to get the next segment of the Chaos report or you can specify the time-range
  ## through StartTimeUtc and EndTimeUtc, but you cannot specify both the ContinuationToken and the time-range in the same call.
  ## When there are more than 100 Chaos events, the Chaos report is returned in segments where a segment contains no more than 100 Chaos events.
  ## 
  ##   ContinuationToken: string
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   EndTimeUtc: string
  ##             : The count of ticks representing the end time of the time range for which a Chaos report is to be generated. Please consult [DateTime.Ticks 
  ## Property](https://msdn.microsoft.com/en-us/library/system.datetime.ticks%28v=vs.110%29) for details about tick.
  ##   StartTimeUtc: string
  ##               : The count of ticks representing the start time of the time range for which a Chaos report is to be generated. Please consult [DateTime.Ticks 
  ## Property](https://msdn.microsoft.com/en-us/library/system.datetime.ticks%28v=vs.110%29) for details about tick.
  var query_565377 = newJObject()
  add(query_565377, "ContinuationToken", newJString(ContinuationToken))
  add(query_565377, "api-version", newJString(apiVersion))
  add(query_565377, "timeout", newJInt(timeout))
  add(query_565377, "EndTimeUtc", newJString(EndTimeUtc))
  add(query_565377, "StartTimeUtc", newJString(StartTimeUtc))
  result = call_565376.call(nil, query_565377, nil, nil, nil)

var getChaosReport* = Call_GetChaosReport_565367(name: "getChaosReport",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Tools/Chaos/$/Report", validator: validate_GetChaosReport_565368,
    base: "", url: url_GetChaosReport_565369, schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartChaos_565378 = ref object of OpenApiRestCall_563564
proc url_StartChaos_565380(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StartChaos_565379(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## If Chaos is not already running in the cluster, it starts Chaos with the passed in Chaos parameters.
  ## If Chaos is already running when this call is made, the call fails with the error code FABRIC_E_CHAOS_ALREADY_RUNNING.
  ## Please refer to the article [Induce controlled Chaos in Service Fabric clusters](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-controlled-chaos) for more details.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565381 = query.getOrDefault("api-version")
  valid_565381 = validateParameter(valid_565381, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565381 != nil:
    section.add "api-version", valid_565381
  var valid_565382 = query.getOrDefault("timeout")
  valid_565382 = validateParameter(valid_565382, JInt, required = false,
                                 default = newJInt(60))
  if valid_565382 != nil:
    section.add "timeout", valid_565382
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   ChaosParameters: JObject (required)
  ##                  : Describes all the parameters to configure a Chaos run.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_565384: Call_StartChaos_565378; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If Chaos is not already running in the cluster, it starts Chaos with the passed in Chaos parameters.
  ## If Chaos is already running when this call is made, the call fails with the error code FABRIC_E_CHAOS_ALREADY_RUNNING.
  ## Please refer to the article [Induce controlled Chaos in Service Fabric clusters](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-controlled-chaos) for more details.
  ## 
  ## 
  let valid = call_565384.validator(path, query, header, formData, body)
  let scheme = call_565384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565384.url(scheme.get, call_565384.host, call_565384.base,
                         call_565384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565384, url, valid)

proc call*(call_565385: Call_StartChaos_565378; ChaosParameters: JsonNode;
          apiVersion: string = "3.0"; timeout: int = 60): Recallable =
  ## startChaos
  ## If Chaos is not already running in the cluster, it starts Chaos with the passed in Chaos parameters.
  ## If Chaos is already running when this call is made, the call fails with the error code FABRIC_E_CHAOS_ALREADY_RUNNING.
  ## Please refer to the article [Induce controlled Chaos in Service Fabric clusters](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-controlled-chaos) for more details.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ChaosParameters: JObject (required)
  ##                  : Describes all the parameters to configure a Chaos run.
  var query_565386 = newJObject()
  var body_565387 = newJObject()
  add(query_565386, "api-version", newJString(apiVersion))
  add(query_565386, "timeout", newJInt(timeout))
  if ChaosParameters != nil:
    body_565387 = ChaosParameters
  result = call_565385.call(nil, query_565386, nil, nil, body_565387)

var startChaos* = Call_StartChaos_565378(name: "startChaos",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local:19080",
                                      route: "/Tools/Chaos/$/Start",
                                      validator: validate_StartChaos_565379,
                                      base: "", url: url_StartChaos_565380,
                                      schemes: {Scheme.Https, Scheme.Http})
type
  Call_StopChaos_565388 = ref object of OpenApiRestCall_563564
proc url_StopChaos_565390(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StopChaos_565389(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops Chaos from scheduling further faults; but, the in-flight faults are not affected.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_565391 = query.getOrDefault("api-version")
  valid_565391 = validateParameter(valid_565391, JString, required = true,
                                 default = newJString("3.0"))
  if valid_565391 != nil:
    section.add "api-version", valid_565391
  var valid_565392 = query.getOrDefault("timeout")
  valid_565392 = validateParameter(valid_565392, JInt, required = false,
                                 default = newJInt(60))
  if valid_565392 != nil:
    section.add "timeout", valid_565392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_565393: Call_StopChaos_565388; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops Chaos from scheduling further faults; but, the in-flight faults are not affected.
  ## 
  let valid = call_565393.validator(path, query, header, formData, body)
  let scheme = call_565393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_565393.url(scheme.get, call_565393.host, call_565393.base,
                         call_565393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_565393, url, valid)

proc call*(call_565394: Call_StopChaos_565388; apiVersion: string = "3.0";
          timeout: int = 60): Recallable =
  ## stopChaos
  ## Stops Chaos from scheduling further faults; but, the in-flight faults are not affected.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  var query_565395 = newJObject()
  add(query_565395, "api-version", newJString(apiVersion))
  add(query_565395, "timeout", newJInt(timeout))
  result = call_565394.call(nil, query_565395, nil, nil, nil)

var stopChaos* = Call_StopChaos_565388(name: "stopChaos", meth: HttpMethod.HttpPost,
                                    host: "azure.local:19080",
                                    route: "/Tools/Chaos/$/Stop",
                                    validator: validate_StopChaos_565389,
                                    base: "", url: url_StopChaos_565390,
                                    schemes: {Scheme.Https, Scheme.Http})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
