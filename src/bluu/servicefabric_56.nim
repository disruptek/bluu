
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_567666 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567666](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567666): Option[Scheme] {.used.} =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "servicefabric"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GetAadMetadata_567888 = ref object of OpenApiRestCall_567666
proc url_GetAadMetadata_567890(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetAadMetadata_567889(path: JsonNode; query: JsonNode;
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
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "1.0".
  section = newJObject()
  var valid_568063 = query.getOrDefault("timeout")
  valid_568063 = validateParameter(valid_568063, JInt, required = false,
                                 default = newJInt(60))
  if valid_568063 != nil:
    section.add "timeout", valid_568063
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568064 = query.getOrDefault("api-version")
  valid_568064 = validateParameter(valid_568064, JString, required = true,
                                 default = newJString("1.0"))
  if valid_568064 != nil:
    section.add "api-version", valid_568064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568087: Call_GetAadMetadata_567888; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Azure Active Directory metadata used for secured connection to cluster.
  ## This API is not supposed to be called separately. It provides information needed to set up an Azure Active Directory secured connection with a Service Fabric cluster.
  ## 
  ## 
  let valid = call_568087.validator(path, query, header, formData, body)
  let scheme = call_568087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568087.url(scheme.get, call_568087.host, call_568087.base,
                         call_568087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568087, url, valid)

proc call*(call_568158: Call_GetAadMetadata_567888; timeout: int = 60;
          apiVersion: string = "1.0"): Recallable =
  ## getAadMetadata
  ## Gets the Azure Active Directory metadata used for secured connection to cluster.
  ## This API is not supposed to be called separately. It provides information needed to set up an Azure Active Directory secured connection with a Service Fabric cluster.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "1.0".
  var query_568159 = newJObject()
  add(query_568159, "timeout", newJInt(timeout))
  add(query_568159, "api-version", newJString(apiVersion))
  result = call_568158.call(nil, query_568159, nil, nil, nil)

var getAadMetadata* = Call_GetAadMetadata_567888(name: "getAadMetadata",
    meth: HttpMethod.HttpGet, host: "azure.local:19080", route: "/$/GetAadMetadata",
    validator: validate_GetAadMetadata_567889, base: "", url: url_GetAadMetadata_567890,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetClusterHealthUsingPolicy_568210 = ref object of OpenApiRestCall_567666
proc url_GetClusterHealthUsingPolicy_568212(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetClusterHealthUsingPolicy_568211(path: JsonNode; query: JsonNode;
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
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
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
  var valid_568230 = query.getOrDefault("timeout")
  valid_568230 = validateParameter(valid_568230, JInt, required = false,
                                 default = newJInt(60))
  if valid_568230 != nil:
    section.add "timeout", valid_568230
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568231 = query.getOrDefault("api-version")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568231 != nil:
    section.add "api-version", valid_568231
  var valid_568232 = query.getOrDefault("ApplicationsHealthStateFilter")
  valid_568232 = validateParameter(valid_568232, JInt, required = false,
                                 default = newJInt(0))
  if valid_568232 != nil:
    section.add "ApplicationsHealthStateFilter", valid_568232
  var valid_568233 = query.getOrDefault("EventsHealthStateFilter")
  valid_568233 = validateParameter(valid_568233, JInt, required = false,
                                 default = newJInt(0))
  if valid_568233 != nil:
    section.add "EventsHealthStateFilter", valid_568233
  var valid_568234 = query.getOrDefault("NodesHealthStateFilter")
  valid_568234 = validateParameter(valid_568234, JInt, required = false,
                                 default = newJInt(0))
  if valid_568234 != nil:
    section.add "NodesHealthStateFilter", valid_568234
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

proc call*(call_568236: Call_GetClusterHealthUsingPolicy_568210; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric cluster.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the cluster based on the health state.
  ## Similarly, use NodesHealthStateFilter and ApplicationsHealthStateFilter to filter the collection of nodes and applications returned based on their aggregated health state.
  ## Use ClusterHealthPolicies to override the health policies used to evaluate the health.
  ## 
  ## 
  let valid = call_568236.validator(path, query, header, formData, body)
  let scheme = call_568236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568236.url(scheme.get, call_568236.host, call_568236.base,
                         call_568236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568236, url, valid)

proc call*(call_568237: Call_GetClusterHealthUsingPolicy_568210; timeout: int = 60;
          apiVersion: string = "3.0"; ApplicationsHealthStateFilter: int = 0;
          ClusterHealthPolicies: JsonNode = nil; EventsHealthStateFilter: int = 0;
          NodesHealthStateFilter: int = 0): Recallable =
  ## getClusterHealthUsingPolicy
  ## Gets the health of a Service Fabric cluster.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the cluster based on the health state.
  ## Similarly, use NodesHealthStateFilter and ApplicationsHealthStateFilter to filter the collection of nodes and applications returned based on their aggregated health state.
  ## Use ClusterHealthPolicies to override the health policies used to evaluate the health.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
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
  ##   ClusterHealthPolicies: JObject
  ##                        : Describes the health policies used to evaluate the cluster health.
  ## If not present, the health evaluation uses the cluster health policy defined in the cluster manifest or the default cluster health policy.
  ## By default, each application is evaluated using its specific application health policy, defined in the application manifest, or the default health policy, if no policy is defined in manifest.
  ## If the application health policy map is specified, and it has an entry for an application, the specified application health policy
  ## is used to evaluate the application health.
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
  var query_568238 = newJObject()
  var body_568239 = newJObject()
  add(query_568238, "timeout", newJInt(timeout))
  add(query_568238, "api-version", newJString(apiVersion))
  add(query_568238, "ApplicationsHealthStateFilter",
      newJInt(ApplicationsHealthStateFilter))
  if ClusterHealthPolicies != nil:
    body_568239 = ClusterHealthPolicies
  add(query_568238, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(query_568238, "NodesHealthStateFilter", newJInt(NodesHealthStateFilter))
  result = call_568237.call(nil, query_568238, nil, nil, body_568239)

var getClusterHealthUsingPolicy* = Call_GetClusterHealthUsingPolicy_568210(
    name: "getClusterHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/GetClusterHealth",
    validator: validate_GetClusterHealthUsingPolicy_568211, base: "",
    url: url_GetClusterHealthUsingPolicy_568212,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetClusterHealth_568199 = ref object of OpenApiRestCall_567666
proc url_GetClusterHealth_568201(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetClusterHealth_568200(path: JsonNode; query: JsonNode;
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
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
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
  var valid_568202 = query.getOrDefault("timeout")
  valid_568202 = validateParameter(valid_568202, JInt, required = false,
                                 default = newJInt(60))
  if valid_568202 != nil:
    section.add "timeout", valid_568202
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568203 = query.getOrDefault("api-version")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568203 != nil:
    section.add "api-version", valid_568203
  var valid_568204 = query.getOrDefault("ApplicationsHealthStateFilter")
  valid_568204 = validateParameter(valid_568204, JInt, required = false,
                                 default = newJInt(0))
  if valid_568204 != nil:
    section.add "ApplicationsHealthStateFilter", valid_568204
  var valid_568205 = query.getOrDefault("EventsHealthStateFilter")
  valid_568205 = validateParameter(valid_568205, JInt, required = false,
                                 default = newJInt(0))
  if valid_568205 != nil:
    section.add "EventsHealthStateFilter", valid_568205
  var valid_568206 = query.getOrDefault("NodesHealthStateFilter")
  valid_568206 = validateParameter(valid_568206, JInt, required = false,
                                 default = newJInt(0))
  if valid_568206 != nil:
    section.add "NodesHealthStateFilter", valid_568206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568207: Call_GetClusterHealth_568199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric cluster.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the cluster based on the health state.
  ## Similarly, use NodesHealthStateFilter and ApplicationsHealthStateFilter to filter the collection of nodes and applications returned based on their aggregated health state.
  ## 
  ## 
  let valid = call_568207.validator(path, query, header, formData, body)
  let scheme = call_568207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568207.url(scheme.get, call_568207.host, call_568207.base,
                         call_568207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568207, url, valid)

proc call*(call_568208: Call_GetClusterHealth_568199; timeout: int = 60;
          apiVersion: string = "3.0"; ApplicationsHealthStateFilter: int = 0;
          EventsHealthStateFilter: int = 0; NodesHealthStateFilter: int = 0): Recallable =
  ## getClusterHealth
  ## Gets the health of a Service Fabric cluster.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the cluster based on the health state.
  ## Similarly, use NodesHealthStateFilter and ApplicationsHealthStateFilter to filter the collection of nodes and applications returned based on their aggregated health state.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
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
  var query_568209 = newJObject()
  add(query_568209, "timeout", newJInt(timeout))
  add(query_568209, "api-version", newJString(apiVersion))
  add(query_568209, "ApplicationsHealthStateFilter",
      newJInt(ApplicationsHealthStateFilter))
  add(query_568209, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(query_568209, "NodesHealthStateFilter", newJInt(NodesHealthStateFilter))
  result = call_568208.call(nil, query_568209, nil, nil, nil)

var getClusterHealth* = Call_GetClusterHealth_568199(name: "getClusterHealth",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/$/GetClusterHealth", validator: validate_GetClusterHealth_568200,
    base: "", url: url_GetClusterHealth_568201, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_568248 = ref object of OpenApiRestCall_567666
proc url_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_568250(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_568249(
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
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568251 = query.getOrDefault("timeout")
  valid_568251 = validateParameter(valid_568251, JInt, required = false,
                                 default = newJInt(60))
  if valid_568251 != nil:
    section.add "timeout", valid_568251
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568252 = query.getOrDefault("api-version")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568252 != nil:
    section.add "api-version", valid_568252
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

proc call*(call_568254: Call_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_568248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric cluster using health chunks. The health evaluation is done based on the input cluster health chunk query description.
  ## The query description allows users to specify health policies for evaluating the cluster and its children.
  ## Users can specify very flexible filters to select which cluster entities to return. The selection can be done based on the entities health state and based on the hierarchy.
  ## The query can return multi-level children of the entities based on the specified filters. For example, it can return one application with a specified name, and for this application, return
  ## only services that are in Error or Warning, and all partitions and replicas for one of these services.
  ## 
  ## 
  let valid = call_568254.validator(path, query, header, formData, body)
  let scheme = call_568254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568254.url(scheme.get, call_568254.host, call_568254.base,
                         call_568254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568254, url, valid)

proc call*(call_568255: Call_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_568248;
          timeout: int = 60; apiVersion: string = "3.0";
          ClusterHealthChunkQueryDescription: JsonNode = nil): Recallable =
  ## getClusterHealthChunkUsingPolicyAndAdvancedFilters
  ## Gets the health of a Service Fabric cluster using health chunks. The health evaluation is done based on the input cluster health chunk query description.
  ## The query description allows users to specify health policies for evaluating the cluster and its children.
  ## Users can specify very flexible filters to select which cluster entities to return. The selection can be done based on the entities health state and based on the hierarchy.
  ## The query can return multi-level children of the entities based on the specified filters. For example, it can return one application with a specified name, and for this application, return
  ## only services that are in Error or Warning, and all partitions and replicas for one of these services.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
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
  var query_568256 = newJObject()
  var body_568257 = newJObject()
  add(query_568256, "timeout", newJInt(timeout))
  add(query_568256, "api-version", newJString(apiVersion))
  if ClusterHealthChunkQueryDescription != nil:
    body_568257 = ClusterHealthChunkQueryDescription
  result = call_568255.call(nil, query_568256, nil, nil, body_568257)

var getClusterHealthChunkUsingPolicyAndAdvancedFilters* = Call_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_568248(
    name: "getClusterHealthChunkUsingPolicyAndAdvancedFilters",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/$/GetClusterHealthChunk",
    validator: validate_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_568249,
    base: "", url: url_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_568250,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetClusterHealthChunk_568240 = ref object of OpenApiRestCall_567666
proc url_GetClusterHealthChunk_568242(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetClusterHealthChunk_568241(path: JsonNode; query: JsonNode;
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
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568243 = query.getOrDefault("timeout")
  valid_568243 = validateParameter(valid_568243, JInt, required = false,
                                 default = newJInt(60))
  if valid_568243 != nil:
    section.add "timeout", valid_568243
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568244 = query.getOrDefault("api-version")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568244 != nil:
    section.add "api-version", valid_568244
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568245: Call_GetClusterHealthChunk_568240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric cluster using health chunks. Includes the aggregated health state of the cluster, but none of the cluster entities.
  ## To expand the cluster health and get the health state of all or some of the entities, use the POST URI and specify the cluster health chunk query description.
  ## 
  ## 
  let valid = call_568245.validator(path, query, header, formData, body)
  let scheme = call_568245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568245.url(scheme.get, call_568245.host, call_568245.base,
                         call_568245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568245, url, valid)

proc call*(call_568246: Call_GetClusterHealthChunk_568240; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## getClusterHealthChunk
  ## Gets the health of a Service Fabric cluster using health chunks. Includes the aggregated health state of the cluster, but none of the cluster entities.
  ## To expand the cluster health and get the health state of all or some of the entities, use the POST URI and specify the cluster health chunk query description.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  var query_568247 = newJObject()
  add(query_568247, "timeout", newJInt(timeout))
  add(query_568247, "api-version", newJString(apiVersion))
  result = call_568246.call(nil, query_568247, nil, nil, nil)

var getClusterHealthChunk* = Call_GetClusterHealthChunk_568240(
    name: "getClusterHealthChunk", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetClusterHealthChunk",
    validator: validate_GetClusterHealthChunk_568241, base: "",
    url: url_GetClusterHealthChunk_568242, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetClusterManifest_568258 = ref object of OpenApiRestCall_567666
proc url_GetClusterManifest_568260(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetClusterManifest_568259(path: JsonNode; query: JsonNode;
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
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568261 = query.getOrDefault("timeout")
  valid_568261 = validateParameter(valid_568261, JInt, required = false,
                                 default = newJInt(60))
  if valid_568261 != nil:
    section.add "timeout", valid_568261
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568262 = query.getOrDefault("api-version")
  valid_568262 = validateParameter(valid_568262, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568262 != nil:
    section.add "api-version", valid_568262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568263: Call_GetClusterManifest_568258; path: JsonNode;
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
  let valid = call_568263.validator(path, query, header, formData, body)
  let scheme = call_568263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568263.url(scheme.get, call_568263.host, call_568263.base,
                         call_568263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568263, url, valid)

proc call*(call_568264: Call_GetClusterManifest_568258; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## getClusterManifest
  ## Get the Service Fabric cluster manifest. The cluster manifest contains properties of the cluster that include different node types on the cluster,
  ## security configurations, fault and upgrade domain topologies etc.
  ## 
  ## These properties are specified as part of the ClusterConfig.JSON file while deploying a stand alone cluster. However, most of the information in the cluster manifest
  ## is generated internally by service fabric during cluster deployment in other deployment scenarios (for e.g when using azuer portal).
  ## 
  ## The contents of the cluster manifest are for informational purposes only and users are not expected to take a dependency on the format of the file contents or its interpretation.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  var query_568265 = newJObject()
  add(query_568265, "timeout", newJInt(timeout))
  add(query_568265, "api-version", newJString(apiVersion))
  result = call_568264.call(nil, query_568265, nil, nil, nil)

var getClusterManifest* = Call_GetClusterManifest_568258(
    name: "getClusterManifest", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/$/GetClusterManifest", validator: validate_GetClusterManifest_568259,
    base: "", url: url_GetClusterManifest_568260,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetProvisionedFabricCodeVersionInfoList_568266 = ref object of OpenApiRestCall_567666
proc url_GetProvisionedFabricCodeVersionInfoList_568268(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetProvisionedFabricCodeVersionInfoList_568267(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of information about fabric code versions that are provisioned in the cluster. The parameter CodeVersion can be used to optionally filter the output to only that particular version.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   CodeVersion: JString
  ##              : The product version of Service Fabric.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568269 = query.getOrDefault("timeout")
  valid_568269 = validateParameter(valid_568269, JInt, required = false,
                                 default = newJInt(60))
  if valid_568269 != nil:
    section.add "timeout", valid_568269
  var valid_568270 = query.getOrDefault("CodeVersion")
  valid_568270 = validateParameter(valid_568270, JString, required = false,
                                 default = nil)
  if valid_568270 != nil:
    section.add "CodeVersion", valid_568270
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568271 = query.getOrDefault("api-version")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568271 != nil:
    section.add "api-version", valid_568271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568272: Call_GetProvisionedFabricCodeVersionInfoList_568266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of information about fabric code versions that are provisioned in the cluster. The parameter CodeVersion can be used to optionally filter the output to only that particular version.
  ## 
  let valid = call_568272.validator(path, query, header, formData, body)
  let scheme = call_568272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568272.url(scheme.get, call_568272.host, call_568272.base,
                         call_568272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568272, url, valid)

proc call*(call_568273: Call_GetProvisionedFabricCodeVersionInfoList_568266;
          timeout: int = 60; CodeVersion: string = ""; apiVersion: string = "3.0"): Recallable =
  ## getProvisionedFabricCodeVersionInfoList
  ## Gets a list of information about fabric code versions that are provisioned in the cluster. The parameter CodeVersion can be used to optionally filter the output to only that particular version.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   CodeVersion: string
  ##              : The product version of Service Fabric.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  var query_568274 = newJObject()
  add(query_568274, "timeout", newJInt(timeout))
  add(query_568274, "CodeVersion", newJString(CodeVersion))
  add(query_568274, "api-version", newJString(apiVersion))
  result = call_568273.call(nil, query_568274, nil, nil, nil)

var getProvisionedFabricCodeVersionInfoList* = Call_GetProvisionedFabricCodeVersionInfoList_568266(
    name: "getProvisionedFabricCodeVersionInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetProvisionedCodeVersions",
    validator: validate_GetProvisionedFabricCodeVersionInfoList_568267, base: "",
    url: url_GetProvisionedFabricCodeVersionInfoList_568268,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetProvisionedFabricConfigVersionInfoList_568275 = ref object of OpenApiRestCall_567666
proc url_GetProvisionedFabricConfigVersionInfoList_568277(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetProvisionedFabricConfigVersionInfoList_568276(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of information about fabric config versions that are provisioned in the cluster. The parameter ConfigVersion can be used to optionally filter the output to only that particular version.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ConfigVersion: JString
  ##                : The config version of Service Fabric.
  section = newJObject()
  var valid_568278 = query.getOrDefault("timeout")
  valid_568278 = validateParameter(valid_568278, JInt, required = false,
                                 default = newJInt(60))
  if valid_568278 != nil:
    section.add "timeout", valid_568278
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568279 = query.getOrDefault("api-version")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568279 != nil:
    section.add "api-version", valid_568279
  var valid_568280 = query.getOrDefault("ConfigVersion")
  valid_568280 = validateParameter(valid_568280, JString, required = false,
                                 default = nil)
  if valid_568280 != nil:
    section.add "ConfigVersion", valid_568280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568281: Call_GetProvisionedFabricConfigVersionInfoList_568275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of information about fabric config versions that are provisioned in the cluster. The parameter ConfigVersion can be used to optionally filter the output to only that particular version.
  ## 
  let valid = call_568281.validator(path, query, header, formData, body)
  let scheme = call_568281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568281.url(scheme.get, call_568281.host, call_568281.base,
                         call_568281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568281, url, valid)

proc call*(call_568282: Call_GetProvisionedFabricConfigVersionInfoList_568275;
          timeout: int = 60; apiVersion: string = "3.0"; ConfigVersion: string = ""): Recallable =
  ## getProvisionedFabricConfigVersionInfoList
  ## Gets a list of information about fabric config versions that are provisioned in the cluster. The parameter ConfigVersion can be used to optionally filter the output to only that particular version.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ConfigVersion: string
  ##                : The config version of Service Fabric.
  var query_568283 = newJObject()
  add(query_568283, "timeout", newJInt(timeout))
  add(query_568283, "api-version", newJString(apiVersion))
  add(query_568283, "ConfigVersion", newJString(ConfigVersion))
  result = call_568282.call(nil, query_568283, nil, nil, nil)

var getProvisionedFabricConfigVersionInfoList* = Call_GetProvisionedFabricConfigVersionInfoList_568275(
    name: "getProvisionedFabricConfigVersionInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetProvisionedConfigVersions",
    validator: validate_GetProvisionedFabricConfigVersionInfoList_568276,
    base: "", url: url_GetProvisionedFabricConfigVersionInfoList_568277,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetClusterUpgradeProgress_568284 = ref object of OpenApiRestCall_567666
proc url_GetClusterUpgradeProgress_568286(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetClusterUpgradeProgress_568285(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the current progress of the ongoing cluster upgrade. If no upgrade is currently in progress, gets the last state of the previous cluster upgrade.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568287 = query.getOrDefault("timeout")
  valid_568287 = validateParameter(valid_568287, JInt, required = false,
                                 default = newJInt(60))
  if valid_568287 != nil:
    section.add "timeout", valid_568287
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568288 = query.getOrDefault("api-version")
  valid_568288 = validateParameter(valid_568288, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568288 != nil:
    section.add "api-version", valid_568288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568289: Call_GetClusterUpgradeProgress_568284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current progress of the ongoing cluster upgrade. If no upgrade is currently in progress, gets the last state of the previous cluster upgrade.
  ## 
  let valid = call_568289.validator(path, query, header, formData, body)
  let scheme = call_568289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568289.url(scheme.get, call_568289.host, call_568289.base,
                         call_568289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568289, url, valid)

proc call*(call_568290: Call_GetClusterUpgradeProgress_568284; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## getClusterUpgradeProgress
  ## Gets the current progress of the ongoing cluster upgrade. If no upgrade is currently in progress, gets the last state of the previous cluster upgrade.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  var query_568291 = newJObject()
  add(query_568291, "timeout", newJInt(timeout))
  add(query_568291, "api-version", newJString(apiVersion))
  result = call_568290.call(nil, query_568291, nil, nil, nil)

var getClusterUpgradeProgress* = Call_GetClusterUpgradeProgress_568284(
    name: "getClusterUpgradeProgress", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetUpgradeProgress",
    validator: validate_GetClusterUpgradeProgress_568285, base: "",
    url: url_GetClusterUpgradeProgress_568286,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_InvokeInfrastructureCommand_568292 = ref object of OpenApiRestCall_567666
proc url_InvokeInfrastructureCommand_568294(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_InvokeInfrastructureCommand_568293(path: JsonNode; query: JsonNode;
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
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ServiceId: JString
  ##            : The identity of the infrastructure service. This is  the full name of the infrastructure service without the 'fabric:' URI scheme. This parameter required only for the cluster that have more than one instance of infrastructure service running.
  ##   Command: JString (required)
  ##          : The text of the command to be invoked. The content of the command is infrastructure-specific.
  section = newJObject()
  var valid_568295 = query.getOrDefault("timeout")
  valid_568295 = validateParameter(valid_568295, JInt, required = false,
                                 default = newJInt(60))
  if valid_568295 != nil:
    section.add "timeout", valid_568295
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568296 = query.getOrDefault("api-version")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568296 != nil:
    section.add "api-version", valid_568296
  var valid_568297 = query.getOrDefault("ServiceId")
  valid_568297 = validateParameter(valid_568297, JString, required = false,
                                 default = nil)
  if valid_568297 != nil:
    section.add "ServiceId", valid_568297
  var valid_568298 = query.getOrDefault("Command")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "Command", valid_568298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568299: Call_InvokeInfrastructureCommand_568292; path: JsonNode;
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
  let valid = call_568299.validator(path, query, header, formData, body)
  let scheme = call_568299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568299.url(scheme.get, call_568299.host, call_568299.base,
                         call_568299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568299, url, valid)

proc call*(call_568300: Call_InvokeInfrastructureCommand_568292; Command: string;
          timeout: int = 60; apiVersion: string = "3.0"; ServiceId: string = ""): Recallable =
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
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ServiceId: string
  ##            : The identity of the infrastructure service. This is  the full name of the infrastructure service without the 'fabric:' URI scheme. This parameter required only for the cluster that have more than one instance of infrastructure service running.
  ##   Command: string (required)
  ##          : The text of the command to be invoked. The content of the command is infrastructure-specific.
  var query_568301 = newJObject()
  add(query_568301, "timeout", newJInt(timeout))
  add(query_568301, "api-version", newJString(apiVersion))
  add(query_568301, "ServiceId", newJString(ServiceId))
  add(query_568301, "Command", newJString(Command))
  result = call_568300.call(nil, query_568301, nil, nil, nil)

var invokeInfrastructureCommand* = Call_InvokeInfrastructureCommand_568292(
    name: "invokeInfrastructureCommand", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/InvokeInfrastructureCommand",
    validator: validate_InvokeInfrastructureCommand_568293, base: "",
    url: url_InvokeInfrastructureCommand_568294,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_InvokeInfrastructureQuery_568302 = ref object of OpenApiRestCall_567666
proc url_InvokeInfrastructureQuery_568304(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_InvokeInfrastructureQuery_568303(path: JsonNode; query: JsonNode;
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
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ServiceId: JString
  ##            : The identity of the infrastructure service. This is  the full name of the infrastructure service without the 'fabric:' URI scheme. This parameter required only for the cluster that have more than one instance of infrastructure service running.
  ##   Command: JString (required)
  ##          : The text of the command to be invoked. The content of the command is infrastructure-specific.
  section = newJObject()
  var valid_568305 = query.getOrDefault("timeout")
  valid_568305 = validateParameter(valid_568305, JInt, required = false,
                                 default = newJInt(60))
  if valid_568305 != nil:
    section.add "timeout", valid_568305
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568306 = query.getOrDefault("api-version")
  valid_568306 = validateParameter(valid_568306, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568306 != nil:
    section.add "api-version", valid_568306
  var valid_568307 = query.getOrDefault("ServiceId")
  valid_568307 = validateParameter(valid_568307, JString, required = false,
                                 default = nil)
  if valid_568307 != nil:
    section.add "ServiceId", valid_568307
  var valid_568308 = query.getOrDefault("Command")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "Command", valid_568308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568309: Call_InvokeInfrastructureQuery_568302; path: JsonNode;
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
  let valid = call_568309.validator(path, query, header, formData, body)
  let scheme = call_568309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568309.url(scheme.get, call_568309.host, call_568309.base,
                         call_568309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568309, url, valid)

proc call*(call_568310: Call_InvokeInfrastructureQuery_568302; Command: string;
          timeout: int = 60; apiVersion: string = "3.0"; ServiceId: string = ""): Recallable =
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
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ServiceId: string
  ##            : The identity of the infrastructure service. This is  the full name of the infrastructure service without the 'fabric:' URI scheme. This parameter required only for the cluster that have more than one instance of infrastructure service running.
  ##   Command: string (required)
  ##          : The text of the command to be invoked. The content of the command is infrastructure-specific.
  var query_568311 = newJObject()
  add(query_568311, "timeout", newJInt(timeout))
  add(query_568311, "api-version", newJString(apiVersion))
  add(query_568311, "ServiceId", newJString(ServiceId))
  add(query_568311, "Command", newJString(Command))
  result = call_568310.call(nil, query_568311, nil, nil, nil)

var invokeInfrastructureQuery* = Call_InvokeInfrastructureQuery_568302(
    name: "invokeInfrastructureQuery", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/InvokeInfrastructureQuery",
    validator: validate_InvokeInfrastructureQuery_568303, base: "",
    url: url_InvokeInfrastructureQuery_568304,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_RecoverAllPartitions_568312 = ref object of OpenApiRestCall_567666
proc url_RecoverAllPartitions_568314(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecoverAllPartitions_568313(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Indicates to the Service Fabric cluster that it should attempt to recover any services (including system services) which are currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568315 = query.getOrDefault("timeout")
  valid_568315 = validateParameter(valid_568315, JInt, required = false,
                                 default = newJInt(60))
  if valid_568315 != nil:
    section.add "timeout", valid_568315
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568316 = query.getOrDefault("api-version")
  valid_568316 = validateParameter(valid_568316, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568316 != nil:
    section.add "api-version", valid_568316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568317: Call_RecoverAllPartitions_568312; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicates to the Service Fabric cluster that it should attempt to recover any services (including system services) which are currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ## 
  let valid = call_568317.validator(path, query, header, formData, body)
  let scheme = call_568317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568317.url(scheme.get, call_568317.host, call_568317.base,
                         call_568317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568317, url, valid)

proc call*(call_568318: Call_RecoverAllPartitions_568312; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## recoverAllPartitions
  ## Indicates to the Service Fabric cluster that it should attempt to recover any services (including system services) which are currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  var query_568319 = newJObject()
  add(query_568319, "timeout", newJInt(timeout))
  add(query_568319, "api-version", newJString(apiVersion))
  result = call_568318.call(nil, query_568319, nil, nil, nil)

var recoverAllPartitions* = Call_RecoverAllPartitions_568312(
    name: "recoverAllPartitions", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/RecoverAllPartitions",
    validator: validate_RecoverAllPartitions_568313, base: "",
    url: url_RecoverAllPartitions_568314, schemes: {Scheme.Https, Scheme.Http})
type
  Call_RecoverSystemPartitions_568320 = ref object of OpenApiRestCall_567666
proc url_RecoverSystemPartitions_568322(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecoverSystemPartitions_568321(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Indicates to the Service Fabric cluster that it should attempt to recover the system services which are currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568323 = query.getOrDefault("timeout")
  valid_568323 = validateParameter(valid_568323, JInt, required = false,
                                 default = newJInt(60))
  if valid_568323 != nil:
    section.add "timeout", valid_568323
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568324 = query.getOrDefault("api-version")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568324 != nil:
    section.add "api-version", valid_568324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568325: Call_RecoverSystemPartitions_568320; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicates to the Service Fabric cluster that it should attempt to recover the system services which are currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ## 
  let valid = call_568325.validator(path, query, header, formData, body)
  let scheme = call_568325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568325.url(scheme.get, call_568325.host, call_568325.base,
                         call_568325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568325, url, valid)

proc call*(call_568326: Call_RecoverSystemPartitions_568320; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## recoverSystemPartitions
  ## Indicates to the Service Fabric cluster that it should attempt to recover the system services which are currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  var query_568327 = newJObject()
  add(query_568327, "timeout", newJInt(timeout))
  add(query_568327, "api-version", newJString(apiVersion))
  result = call_568326.call(nil, query_568327, nil, nil, nil)

var recoverSystemPartitions* = Call_RecoverSystemPartitions_568320(
    name: "recoverSystemPartitions", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/RecoverSystemPartitions",
    validator: validate_RecoverSystemPartitions_568321, base: "",
    url: url_RecoverSystemPartitions_568322, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportClusterHealth_568328 = ref object of OpenApiRestCall_567666
proc url_ReportClusterHealth_568330(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportClusterHealth_568329(path: JsonNode; query: JsonNode;
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
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568331 = query.getOrDefault("timeout")
  valid_568331 = validateParameter(valid_568331, JInt, required = false,
                                 default = newJInt(60))
  if valid_568331 != nil:
    section.add "timeout", valid_568331
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568332 = query.getOrDefault("api-version")
  valid_568332 = validateParameter(valid_568332, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568332 != nil:
    section.add "api-version", valid_568332
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

proc call*(call_568334: Call_ReportClusterHealth_568328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a health report on a Service Fabric cluster. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway node, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetClusterHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_568334.validator(path, query, header, formData, body)
  let scheme = call_568334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568334.url(scheme.get, call_568334.host, call_568334.base,
                         call_568334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568334, url, valid)

proc call*(call_568335: Call_ReportClusterHealth_568328;
          HealthInformation: JsonNode; timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## reportClusterHealth
  ## Sends a health report on a Service Fabric cluster. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway node, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetClusterHealth and check that the report appears in the HealthEvents section.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  var query_568336 = newJObject()
  var body_568337 = newJObject()
  add(query_568336, "timeout", newJInt(timeout))
  add(query_568336, "api-version", newJString(apiVersion))
  if HealthInformation != nil:
    body_568337 = HealthInformation
  result = call_568335.call(nil, query_568336, nil, nil, body_568337)

var reportClusterHealth* = Call_ReportClusterHealth_568328(
    name: "reportClusterHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/ReportClusterHealth",
    validator: validate_ReportClusterHealth_568329, base: "",
    url: url_ReportClusterHealth_568330, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationTypeInfoList_568338 = ref object of OpenApiRestCall_567666
proc url_GetApplicationTypeInfoList_568340(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetApplicationTypeInfoList_568339(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the information about the application types that are provisioned or in the process of being provisioned in the Service Fabric cluster. Each version of an application type is returned as one application type. The response includes the name, version, status and other details about the application type. This is a paged query, meaning that if not all of the application types fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page. For example, if there are 10 application types but a page only fits the first 3 application types, or if max results is set to 3, then 3 is returned. To access the rest of the results, retrieve subsequent pages by using the returned continuation token in the next query. An empty continuation token is returned if there are no subsequent pages.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "4.0".
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   MaxResults: JInt
  ##             : The maximum number of results to be returned as part of the paged queries. This parameter defines the upper bound on the number of results returned. The results returned can be less than the specified maximum results if they do not fit in the message as per the max message size restrictions defined in the configuration. If this parameter is zero or not specified, the paged queries includes as much results as possible that fit in the return message.
  ##   ExcludeApplicationParameters: JBool
  ##                               : The flag that specifies whether application parameters will be excluded from the result.
  section = newJObject()
  var valid_568341 = query.getOrDefault("timeout")
  valid_568341 = validateParameter(valid_568341, JInt, required = false,
                                 default = newJInt(60))
  if valid_568341 != nil:
    section.add "timeout", valid_568341
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568342 = query.getOrDefault("api-version")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = newJString("4.0"))
  if valid_568342 != nil:
    section.add "api-version", valid_568342
  var valid_568343 = query.getOrDefault("ContinuationToken")
  valid_568343 = validateParameter(valid_568343, JString, required = false,
                                 default = nil)
  if valid_568343 != nil:
    section.add "ContinuationToken", valid_568343
  var valid_568344 = query.getOrDefault("MaxResults")
  valid_568344 = validateParameter(valid_568344, JInt, required = false,
                                 default = newJInt(0))
  if valid_568344 != nil:
    section.add "MaxResults", valid_568344
  var valid_568345 = query.getOrDefault("ExcludeApplicationParameters")
  valid_568345 = validateParameter(valid_568345, JBool, required = false,
                                 default = newJBool(false))
  if valid_568345 != nil:
    section.add "ExcludeApplicationParameters", valid_568345
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568346: Call_GetApplicationTypeInfoList_568338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the information about the application types that are provisioned or in the process of being provisioned in the Service Fabric cluster. Each version of an application type is returned as one application type. The response includes the name, version, status and other details about the application type. This is a paged query, meaning that if not all of the application types fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page. For example, if there are 10 application types but a page only fits the first 3 application types, or if max results is set to 3, then 3 is returned. To access the rest of the results, retrieve subsequent pages by using the returned continuation token in the next query. An empty continuation token is returned if there are no subsequent pages.
  ## 
  let valid = call_568346.validator(path, query, header, formData, body)
  let scheme = call_568346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568346.url(scheme.get, call_568346.host, call_568346.base,
                         call_568346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568346, url, valid)

proc call*(call_568347: Call_GetApplicationTypeInfoList_568338; timeout: int = 60;
          apiVersion: string = "4.0"; ContinuationToken: string = "";
          MaxResults: int = 0; ExcludeApplicationParameters: bool = false): Recallable =
  ## getApplicationTypeInfoList
  ## Returns the information about the application types that are provisioned or in the process of being provisioned in the Service Fabric cluster. Each version of an application type is returned as one application type. The response includes the name, version, status and other details about the application type. This is a paged query, meaning that if not all of the application types fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page. For example, if there are 10 application types but a page only fits the first 3 application types, or if max results is set to 3, then 3 is returned. To access the rest of the results, retrieve subsequent pages by using the returned continuation token in the next query. An empty continuation token is returned if there are no subsequent pages.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "4.0".
  ##   ContinuationToken: string
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   MaxResults: int
  ##             : The maximum number of results to be returned as part of the paged queries. This parameter defines the upper bound on the number of results returned. The results returned can be less than the specified maximum results if they do not fit in the message as per the max message size restrictions defined in the configuration. If this parameter is zero or not specified, the paged queries includes as much results as possible that fit in the return message.
  ##   ExcludeApplicationParameters: bool
  ##                               : The flag that specifies whether application parameters will be excluded from the result.
  var query_568348 = newJObject()
  add(query_568348, "timeout", newJInt(timeout))
  add(query_568348, "api-version", newJString(apiVersion))
  add(query_568348, "ContinuationToken", newJString(ContinuationToken))
  add(query_568348, "MaxResults", newJInt(MaxResults))
  add(query_568348, "ExcludeApplicationParameters",
      newJBool(ExcludeApplicationParameters))
  result = call_568347.call(nil, query_568348, nil, nil, nil)

var getApplicationTypeInfoList* = Call_GetApplicationTypeInfoList_568338(
    name: "getApplicationTypeInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ApplicationTypes",
    validator: validate_GetApplicationTypeInfoList_568339, base: "",
    url: url_GetApplicationTypeInfoList_568340,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_ProvisionApplicationType_568349 = ref object of OpenApiRestCall_567666
proc url_ProvisionApplicationType_568351(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProvisionApplicationType_568350(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provisions or registers a Service Fabric application type with the cluster. This is required before any new applications can be instantiated.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568352 = query.getOrDefault("timeout")
  valid_568352 = validateParameter(valid_568352, JInt, required = false,
                                 default = newJInt(60))
  if valid_568352 != nil:
    section.add "timeout", valid_568352
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568353 = query.getOrDefault("api-version")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568353 != nil:
    section.add "api-version", valid_568353
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

proc call*(call_568355: Call_ProvisionApplicationType_568349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provisions or registers a Service Fabric application type with the cluster. This is required before any new applications can be instantiated.
  ## 
  let valid = call_568355.validator(path, query, header, formData, body)
  let scheme = call_568355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568355.url(scheme.get, call_568355.host, call_568355.base,
                         call_568355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568355, url, valid)

proc call*(call_568356: Call_ProvisionApplicationType_568349;
          ApplicationTypeImageStorePath: JsonNode; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## provisionApplicationType
  ## Provisions or registers a Service Fabric application type with the cluster. This is required before any new applications can be instantiated.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationTypeImageStorePath: JObject (required)
  ##                                : The relative path for the application package in the image store specified during the prior copy operation.
  var query_568357 = newJObject()
  var body_568358 = newJObject()
  add(query_568357, "timeout", newJInt(timeout))
  add(query_568357, "api-version", newJString(apiVersion))
  if ApplicationTypeImageStorePath != nil:
    body_568358 = ApplicationTypeImageStorePath
  result = call_568356.call(nil, query_568357, nil, nil, body_568358)

var provisionApplicationType* = Call_ProvisionApplicationType_568349(
    name: "provisionApplicationType", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/ApplicationTypes/$/Provision",
    validator: validate_ProvisionApplicationType_568350, base: "",
    url: url_ProvisionApplicationType_568351, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationTypeInfoListByName_568359 = ref object of OpenApiRestCall_567666
proc url_GetApplicationTypeInfoListByName_568361(protocol: Scheme; host: string;
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

proc validate_GetApplicationTypeInfoListByName_568360(path: JsonNode;
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
  var valid_568376 = path.getOrDefault("applicationTypeName")
  valid_568376 = validateParameter(valid_568376, JString, required = true,
                                 default = nil)
  if valid_568376 != nil:
    section.add "applicationTypeName", valid_568376
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "4.0".
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   MaxResults: JInt
  ##             : The maximum number of results to be returned as part of the paged queries. This parameter defines the upper bound on the number of results returned. The results returned can be less than the specified maximum results if they do not fit in the message as per the max message size restrictions defined in the configuration. If this parameter is zero or not specified, the paged queries includes as much results as possible that fit in the return message.
  ##   ExcludeApplicationParameters: JBool
  ##                               : The flag that specifies whether application parameters will be excluded from the result.
  section = newJObject()
  var valid_568377 = query.getOrDefault("timeout")
  valid_568377 = validateParameter(valid_568377, JInt, required = false,
                                 default = newJInt(60))
  if valid_568377 != nil:
    section.add "timeout", valid_568377
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568378 = query.getOrDefault("api-version")
  valid_568378 = validateParameter(valid_568378, JString, required = true,
                                 default = newJString("4.0"))
  if valid_568378 != nil:
    section.add "api-version", valid_568378
  var valid_568379 = query.getOrDefault("ContinuationToken")
  valid_568379 = validateParameter(valid_568379, JString, required = false,
                                 default = nil)
  if valid_568379 != nil:
    section.add "ContinuationToken", valid_568379
  var valid_568380 = query.getOrDefault("MaxResults")
  valid_568380 = validateParameter(valid_568380, JInt, required = false,
                                 default = newJInt(0))
  if valid_568380 != nil:
    section.add "MaxResults", valid_568380
  var valid_568381 = query.getOrDefault("ExcludeApplicationParameters")
  valid_568381 = validateParameter(valid_568381, JBool, required = false,
                                 default = newJBool(false))
  if valid_568381 != nil:
    section.add "ExcludeApplicationParameters", valid_568381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568382: Call_GetApplicationTypeInfoListByName_568359;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the information about the application types that are provisioned or in the process of being provisioned in the Service Fabric cluster. These results are of application types whose name match exactly the one specified as the parameter, and which comply with the given query parameters. All versions of the application type matching the application type name are returned, with each version returned as one application type. The response includes the name, version, status and other details about the application type. This is a paged query, meaning that if not all of the application types fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page. For example, if there are 10 application types but a page only fits the first 3 application types, or if max results is set to 3, then 3 is returned. To access the rest of the results, retrieve subsequent pages by using the returned continuation token in the next query. An empty continuation token is returned if there are no subsequent pages.
  ## 
  let valid = call_568382.validator(path, query, header, formData, body)
  let scheme = call_568382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568382.url(scheme.get, call_568382.host, call_568382.base,
                         call_568382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568382, url, valid)

proc call*(call_568383: Call_GetApplicationTypeInfoListByName_568359;
          applicationTypeName: string; timeout: int = 60; apiVersion: string = "4.0";
          ContinuationToken: string = ""; MaxResults: int = 0;
          ExcludeApplicationParameters: bool = false): Recallable =
  ## getApplicationTypeInfoListByName
  ## Returns the information about the application types that are provisioned or in the process of being provisioned in the Service Fabric cluster. These results are of application types whose name match exactly the one specified as the parameter, and which comply with the given query parameters. All versions of the application type matching the application type name are returned, with each version returned as one application type. The response includes the name, version, status and other details about the application type. This is a paged query, meaning that if not all of the application types fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page. For example, if there are 10 application types but a page only fits the first 3 application types, or if max results is set to 3, then 3 is returned. To access the rest of the results, retrieve subsequent pages by using the returned continuation token in the next query. An empty continuation token is returned if there are no subsequent pages.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "4.0".
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type.
  ##   ContinuationToken: string
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   MaxResults: int
  ##             : The maximum number of results to be returned as part of the paged queries. This parameter defines the upper bound on the number of results returned. The results returned can be less than the specified maximum results if they do not fit in the message as per the max message size restrictions defined in the configuration. If this parameter is zero or not specified, the paged queries includes as much results as possible that fit in the return message.
  ##   ExcludeApplicationParameters: bool
  ##                               : The flag that specifies whether application parameters will be excluded from the result.
  var path_568384 = newJObject()
  var query_568385 = newJObject()
  add(query_568385, "timeout", newJInt(timeout))
  add(query_568385, "api-version", newJString(apiVersion))
  add(path_568384, "applicationTypeName", newJString(applicationTypeName))
  add(query_568385, "ContinuationToken", newJString(ContinuationToken))
  add(query_568385, "MaxResults", newJInt(MaxResults))
  add(query_568385, "ExcludeApplicationParameters",
      newJBool(ExcludeApplicationParameters))
  result = call_568383.call(path_568384, query_568385, nil, nil, nil)

var getApplicationTypeInfoListByName* = Call_GetApplicationTypeInfoListByName_568359(
    name: "getApplicationTypeInfoListByName", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ApplicationTypes/{applicationTypeName}",
    validator: validate_GetApplicationTypeInfoListByName_568360, base: "",
    url: url_GetApplicationTypeInfoListByName_568361,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationManifest_568386 = ref object of OpenApiRestCall_567666
proc url_GetApplicationManifest_568388(protocol: Scheme; host: string; base: string;
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

proc validate_GetApplicationManifest_568387(path: JsonNode; query: JsonNode;
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
  var valid_568389 = path.getOrDefault("applicationTypeName")
  valid_568389 = validateParameter(valid_568389, JString, required = true,
                                 default = nil)
  if valid_568389 != nil:
    section.add "applicationTypeName", valid_568389
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationTypeVersion: JString (required)
  ##                         : The version of the application type.
  section = newJObject()
  var valid_568390 = query.getOrDefault("timeout")
  valid_568390 = validateParameter(valid_568390, JInt, required = false,
                                 default = newJInt(60))
  if valid_568390 != nil:
    section.add "timeout", valid_568390
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568391 = query.getOrDefault("api-version")
  valid_568391 = validateParameter(valid_568391, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568391 != nil:
    section.add "api-version", valid_568391
  var valid_568392 = query.getOrDefault("ApplicationTypeVersion")
  valid_568392 = validateParameter(valid_568392, JString, required = true,
                                 default = nil)
  if valid_568392 != nil:
    section.add "ApplicationTypeVersion", valid_568392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568393: Call_GetApplicationManifest_568386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the manifest describing an application type. The response contains the application manifest XML as a string.
  ## 
  let valid = call_568393.validator(path, query, header, formData, body)
  let scheme = call_568393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568393.url(scheme.get, call_568393.host, call_568393.base,
                         call_568393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568393, url, valid)

proc call*(call_568394: Call_GetApplicationManifest_568386;
          applicationTypeName: string; ApplicationTypeVersion: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getApplicationManifest
  ## Gets the manifest describing an application type. The response contains the application manifest XML as a string.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type.
  ##   ApplicationTypeVersion: string (required)
  ##                         : The version of the application type.
  var path_568395 = newJObject()
  var query_568396 = newJObject()
  add(query_568396, "timeout", newJInt(timeout))
  add(query_568396, "api-version", newJString(apiVersion))
  add(path_568395, "applicationTypeName", newJString(applicationTypeName))
  add(query_568396, "ApplicationTypeVersion", newJString(ApplicationTypeVersion))
  result = call_568394.call(path_568395, query_568396, nil, nil, nil)

var getApplicationManifest* = Call_GetApplicationManifest_568386(
    name: "getApplicationManifest", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/GetApplicationManifest",
    validator: validate_GetApplicationManifest_568387, base: "",
    url: url_GetApplicationManifest_568388, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceManifest_568397 = ref object of OpenApiRestCall_567666
proc url_GetServiceManifest_568399(protocol: Scheme; host: string; base: string;
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

proc validate_GetServiceManifest_568398(path: JsonNode; query: JsonNode;
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
  var valid_568400 = path.getOrDefault("applicationTypeName")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "applicationTypeName", valid_568400
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationTypeVersion: JString (required)
  ##                         : The version of the application type.
  ##   ServiceManifestName: JString (required)
  ##                      : The name of a service manifest registered as part of an application type in a Service Fabric cluster.
  section = newJObject()
  var valid_568401 = query.getOrDefault("timeout")
  valid_568401 = validateParameter(valid_568401, JInt, required = false,
                                 default = newJInt(60))
  if valid_568401 != nil:
    section.add "timeout", valid_568401
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568402 = query.getOrDefault("api-version")
  valid_568402 = validateParameter(valid_568402, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568402 != nil:
    section.add "api-version", valid_568402
  var valid_568403 = query.getOrDefault("ApplicationTypeVersion")
  valid_568403 = validateParameter(valid_568403, JString, required = true,
                                 default = nil)
  if valid_568403 != nil:
    section.add "ApplicationTypeVersion", valid_568403
  var valid_568404 = query.getOrDefault("ServiceManifestName")
  valid_568404 = validateParameter(valid_568404, JString, required = true,
                                 default = nil)
  if valid_568404 != nil:
    section.add "ServiceManifestName", valid_568404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568405: Call_GetServiceManifest_568397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the manifest describing a service type. The response contains the service manifest XML as a string.
  ## 
  let valid = call_568405.validator(path, query, header, formData, body)
  let scheme = call_568405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568405.url(scheme.get, call_568405.host, call_568405.base,
                         call_568405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568405, url, valid)

proc call*(call_568406: Call_GetServiceManifest_568397;
          applicationTypeName: string; ApplicationTypeVersion: string;
          ServiceManifestName: string; timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getServiceManifest
  ## Gets the manifest describing a service type. The response contains the service manifest XML as a string.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type.
  ##   ApplicationTypeVersion: string (required)
  ##                         : The version of the application type.
  ##   ServiceManifestName: string (required)
  ##                      : The name of a service manifest registered as part of an application type in a Service Fabric cluster.
  var path_568407 = newJObject()
  var query_568408 = newJObject()
  add(query_568408, "timeout", newJInt(timeout))
  add(query_568408, "api-version", newJString(apiVersion))
  add(path_568407, "applicationTypeName", newJString(applicationTypeName))
  add(query_568408, "ApplicationTypeVersion", newJString(ApplicationTypeVersion))
  add(query_568408, "ServiceManifestName", newJString(ServiceManifestName))
  result = call_568406.call(path_568407, query_568408, nil, nil, nil)

var getServiceManifest* = Call_GetServiceManifest_568397(
    name: "getServiceManifest", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/GetServiceManifest",
    validator: validate_GetServiceManifest_568398, base: "",
    url: url_GetServiceManifest_568399, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceTypeInfoList_568409 = ref object of OpenApiRestCall_567666
proc url_GetServiceTypeInfoList_568411(protocol: Scheme; host: string; base: string;
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

proc validate_GetServiceTypeInfoList_568410(path: JsonNode; query: JsonNode;
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
  var valid_568412 = path.getOrDefault("applicationTypeName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "applicationTypeName", valid_568412
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationTypeVersion: JString (required)
  ##                         : The version of the application type.
  section = newJObject()
  var valid_568413 = query.getOrDefault("timeout")
  valid_568413 = validateParameter(valid_568413, JInt, required = false,
                                 default = newJInt(60))
  if valid_568413 != nil:
    section.add "timeout", valid_568413
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568414 = query.getOrDefault("api-version")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568414 != nil:
    section.add "api-version", valid_568414
  var valid_568415 = query.getOrDefault("ApplicationTypeVersion")
  valid_568415 = validateParameter(valid_568415, JString, required = true,
                                 default = nil)
  if valid_568415 != nil:
    section.add "ApplicationTypeVersion", valid_568415
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568416: Call_GetServiceTypeInfoList_568409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list containing the information about service types that are supported by a provisioned application type in a Service Fabric cluster. The response includes the name of the service type, the name and version of the service manifest the type is defined in, kind (stateless or stateless) of the service type and other information about it.
  ## 
  let valid = call_568416.validator(path, query, header, formData, body)
  let scheme = call_568416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568416.url(scheme.get, call_568416.host, call_568416.base,
                         call_568416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568416, url, valid)

proc call*(call_568417: Call_GetServiceTypeInfoList_568409;
          applicationTypeName: string; ApplicationTypeVersion: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getServiceTypeInfoList
  ## Gets the list containing the information about service types that are supported by a provisioned application type in a Service Fabric cluster. The response includes the name of the service type, the name and version of the service manifest the type is defined in, kind (stateless or stateless) of the service type and other information about it.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type.
  ##   ApplicationTypeVersion: string (required)
  ##                         : The version of the application type.
  var path_568418 = newJObject()
  var query_568419 = newJObject()
  add(query_568419, "timeout", newJInt(timeout))
  add(query_568419, "api-version", newJString(apiVersion))
  add(path_568418, "applicationTypeName", newJString(applicationTypeName))
  add(query_568419, "ApplicationTypeVersion", newJString(ApplicationTypeVersion))
  result = call_568417.call(path_568418, query_568419, nil, nil, nil)

var getServiceTypeInfoList* = Call_GetServiceTypeInfoList_568409(
    name: "getServiceTypeInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/GetServiceTypes",
    validator: validate_GetServiceTypeInfoList_568410, base: "",
    url: url_GetServiceTypeInfoList_568411, schemes: {Scheme.Https, Scheme.Http})
type
  Call_UnprovisionApplicationType_568420 = ref object of OpenApiRestCall_567666
proc url_UnprovisionApplicationType_568422(protocol: Scheme; host: string;
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

proc validate_UnprovisionApplicationType_568421(path: JsonNode; query: JsonNode;
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
  var valid_568423 = path.getOrDefault("applicationTypeName")
  valid_568423 = validateParameter(valid_568423, JString, required = true,
                                 default = nil)
  if valid_568423 != nil:
    section.add "applicationTypeName", valid_568423
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568424 = query.getOrDefault("timeout")
  valid_568424 = validateParameter(valid_568424, JInt, required = false,
                                 default = newJInt(60))
  if valid_568424 != nil:
    section.add "timeout", valid_568424
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568425 = query.getOrDefault("api-version")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568425 != nil:
    section.add "api-version", valid_568425
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

proc call*(call_568427: Call_UnprovisionApplicationType_568420; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes or unregisters a Service Fabric application type from the cluster. This operation can only be performed if all application instance of the application type has been deleted. Once the application type is unregistered, no new application instance can be created for this particular application type.
  ## 
  let valid = call_568427.validator(path, query, header, formData, body)
  let scheme = call_568427.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568427.url(scheme.get, call_568427.host, call_568427.base,
                         call_568427.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568427, url, valid)

proc call*(call_568428: Call_UnprovisionApplicationType_568420;
          ApplicationTypeImageStoreVersion: JsonNode; applicationTypeName: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## unprovisionApplicationType
  ## Removes or unregisters a Service Fabric application type from the cluster. This operation can only be performed if all application instance of the application type has been deleted. Once the application type is unregistered, no new application instance can be created for this particular application type.
  ##   ApplicationTypeImageStoreVersion: JObject (required)
  ##                                   : The version of the application type in the image store.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   applicationTypeName: string (required)
  ##                      : The name of the application type.
  var path_568429 = newJObject()
  var query_568430 = newJObject()
  var body_568431 = newJObject()
  if ApplicationTypeImageStoreVersion != nil:
    body_568431 = ApplicationTypeImageStoreVersion
  add(query_568430, "timeout", newJInt(timeout))
  add(query_568430, "api-version", newJString(apiVersion))
  add(path_568429, "applicationTypeName", newJString(applicationTypeName))
  result = call_568428.call(path_568429, query_568430, nil, nil, body_568431)

var unprovisionApplicationType* = Call_UnprovisionApplicationType_568420(
    name: "unprovisionApplicationType", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/Unprovision",
    validator: validate_UnprovisionApplicationType_568421, base: "",
    url: url_UnprovisionApplicationType_568422,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationInfoList_568432 = ref object of OpenApiRestCall_567666
proc url_GetApplicationInfoList_568434(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetApplicationInfoList_568433(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the applications that were created or in the process of being created in the Service Fabric cluster and match filters specified as the parameter. The response includes the name, type, status, parameters and other details about the application. If the applications do not fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationTypeName: JString
  ##                      : The application type name used to filter the applications to query for. This value should not contain the application type version.
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   ExcludeApplicationParameters: JBool
  ##                               : The flag that specifies whether application parameters will be excluded from the result.
  section = newJObject()
  var valid_568435 = query.getOrDefault("timeout")
  valid_568435 = validateParameter(valid_568435, JInt, required = false,
                                 default = newJInt(60))
  if valid_568435 != nil:
    section.add "timeout", valid_568435
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568436 = query.getOrDefault("api-version")
  valid_568436 = validateParameter(valid_568436, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568436 != nil:
    section.add "api-version", valid_568436
  var valid_568437 = query.getOrDefault("ApplicationTypeName")
  valid_568437 = validateParameter(valid_568437, JString, required = false,
                                 default = nil)
  if valid_568437 != nil:
    section.add "ApplicationTypeName", valid_568437
  var valid_568438 = query.getOrDefault("ContinuationToken")
  valid_568438 = validateParameter(valid_568438, JString, required = false,
                                 default = nil)
  if valid_568438 != nil:
    section.add "ContinuationToken", valid_568438
  var valid_568439 = query.getOrDefault("ExcludeApplicationParameters")
  valid_568439 = validateParameter(valid_568439, JBool, required = false,
                                 default = newJBool(false))
  if valid_568439 != nil:
    section.add "ExcludeApplicationParameters", valid_568439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568440: Call_GetApplicationInfoList_568432; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the applications that were created or in the process of being created in the Service Fabric cluster and match filters specified as the parameter. The response includes the name, type, status, parameters and other details about the application. If the applications do not fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page.
  ## 
  let valid = call_568440.validator(path, query, header, formData, body)
  let scheme = call_568440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568440.url(scheme.get, call_568440.host, call_568440.base,
                         call_568440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568440, url, valid)

proc call*(call_568441: Call_GetApplicationInfoList_568432; timeout: int = 60;
          apiVersion: string = "3.0"; ApplicationTypeName: string = "";
          ContinuationToken: string = ""; ExcludeApplicationParameters: bool = false): Recallable =
  ## getApplicationInfoList
  ## Gets the information about the applications that were created or in the process of being created in the Service Fabric cluster and match filters specified as the parameter. The response includes the name, type, status, parameters and other details about the application. If the applications do not fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationTypeName: string
  ##                      : The application type name used to filter the applications to query for. This value should not contain the application type version.
  ##   ContinuationToken: string
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   ExcludeApplicationParameters: bool
  ##                               : The flag that specifies whether application parameters will be excluded from the result.
  var query_568442 = newJObject()
  add(query_568442, "timeout", newJInt(timeout))
  add(query_568442, "api-version", newJString(apiVersion))
  add(query_568442, "ApplicationTypeName", newJString(ApplicationTypeName))
  add(query_568442, "ContinuationToken", newJString(ContinuationToken))
  add(query_568442, "ExcludeApplicationParameters",
      newJBool(ExcludeApplicationParameters))
  result = call_568441.call(nil, query_568442, nil, nil, nil)

var getApplicationInfoList* = Call_GetApplicationInfoList_568432(
    name: "getApplicationInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Applications",
    validator: validate_GetApplicationInfoList_568433, base: "",
    url: url_GetApplicationInfoList_568434, schemes: {Scheme.Https, Scheme.Http})
type
  Call_CreateApplication_568443 = ref object of OpenApiRestCall_567666
proc url_CreateApplication_568445(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CreateApplication_568444(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a Service Fabric application using the specified description.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568446 = query.getOrDefault("timeout")
  valid_568446 = validateParameter(valid_568446, JInt, required = false,
                                 default = newJInt(60))
  if valid_568446 != nil:
    section.add "timeout", valid_568446
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568447 = query.getOrDefault("api-version")
  valid_568447 = validateParameter(valid_568447, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568447 != nil:
    section.add "api-version", valid_568447
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

proc call*(call_568449: Call_CreateApplication_568443; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Service Fabric application using the specified description.
  ## 
  let valid = call_568449.validator(path, query, header, formData, body)
  let scheme = call_568449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568449.url(scheme.get, call_568449.host, call_568449.base,
                         call_568449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568449, url, valid)

proc call*(call_568450: Call_CreateApplication_568443;
          ApplicationDescription: JsonNode; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## createApplication
  ## Creates a Service Fabric application using the specified description.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationDescription: JObject (required)
  ##                         : Describes the application to be created.
  var query_568451 = newJObject()
  var body_568452 = newJObject()
  add(query_568451, "timeout", newJInt(timeout))
  add(query_568451, "api-version", newJString(apiVersion))
  if ApplicationDescription != nil:
    body_568452 = ApplicationDescription
  result = call_568450.call(nil, query_568451, nil, nil, body_568452)

var createApplication* = Call_CreateApplication_568443(name: "createApplication",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Applications/$/Create", validator: validate_CreateApplication_568444,
    base: "", url: url_CreateApplication_568445,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationInfo_568453 = ref object of OpenApiRestCall_567666
proc url_GetApplicationInfo_568455(protocol: Scheme; host: string; base: string;
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

proc validate_GetApplicationInfo_568454(path: JsonNode; query: JsonNode;
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
  var valid_568456 = path.getOrDefault("applicationId")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "applicationId", valid_568456
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ExcludeApplicationParameters: JBool
  ##                               : The flag that specifies whether application parameters will be excluded from the result.
  section = newJObject()
  var valid_568457 = query.getOrDefault("timeout")
  valid_568457 = validateParameter(valid_568457, JInt, required = false,
                                 default = newJInt(60))
  if valid_568457 != nil:
    section.add "timeout", valid_568457
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568458 = query.getOrDefault("api-version")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568458 != nil:
    section.add "api-version", valid_568458
  var valid_568459 = query.getOrDefault("ExcludeApplicationParameters")
  valid_568459 = validateParameter(valid_568459, JBool, required = false,
                                 default = newJBool(false))
  if valid_568459 != nil:
    section.add "ExcludeApplicationParameters", valid_568459
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568460: Call_GetApplicationInfo_568453; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the information about the application that was created or in the process of being created in the Service Fabric cluster and whose name matches the one specified as the parameter. The response includes the name, type, status, parameters and other details about the application.
  ## 
  let valid = call_568460.validator(path, query, header, formData, body)
  let scheme = call_568460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568460.url(scheme.get, call_568460.host, call_568460.base,
                         call_568460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568460, url, valid)

proc call*(call_568461: Call_GetApplicationInfo_568453; applicationId: string;
          timeout: int = 60; apiVersion: string = "3.0";
          ExcludeApplicationParameters: bool = false): Recallable =
  ## getApplicationInfo
  ## Returns the information about the application that was created or in the process of being created in the Service Fabric cluster and whose name matches the one specified as the parameter. The response includes the name, type, status, parameters and other details about the application.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  ##   ExcludeApplicationParameters: bool
  ##                               : The flag that specifies whether application parameters will be excluded from the result.
  var path_568462 = newJObject()
  var query_568463 = newJObject()
  add(query_568463, "timeout", newJInt(timeout))
  add(query_568463, "api-version", newJString(apiVersion))
  add(path_568462, "applicationId", newJString(applicationId))
  add(query_568463, "ExcludeApplicationParameters",
      newJBool(ExcludeApplicationParameters))
  result = call_568461.call(path_568462, query_568463, nil, nil, nil)

var getApplicationInfo* = Call_GetApplicationInfo_568453(
    name: "getApplicationInfo", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Applications/{applicationId}",
    validator: validate_GetApplicationInfo_568454, base: "",
    url: url_GetApplicationInfo_568455, schemes: {Scheme.Https, Scheme.Http})
type
  Call_DeleteApplication_568464 = ref object of OpenApiRestCall_567666
proc url_DeleteApplication_568466(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteApplication_568465(path: JsonNode; query: JsonNode;
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
  var valid_568467 = path.getOrDefault("applicationId")
  valid_568467 = validateParameter(valid_568467, JString, required = true,
                                 default = nil)
  if valid_568467 != nil:
    section.add "applicationId", valid_568467
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ForceRemove: JBool
  ##              : Remove a Service Fabric application or service forcefully without going through the graceful shutdown sequence. This parameter can be used to forcefully delete an application or service for which delete is timing out due to issues in the service code that prevents graceful close of replicas.
  section = newJObject()
  var valid_568468 = query.getOrDefault("timeout")
  valid_568468 = validateParameter(valid_568468, JInt, required = false,
                                 default = newJInt(60))
  if valid_568468 != nil:
    section.add "timeout", valid_568468
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568469 = query.getOrDefault("api-version")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568469 != nil:
    section.add "api-version", valid_568469
  var valid_568470 = query.getOrDefault("ForceRemove")
  valid_568470 = validateParameter(valid_568470, JBool, required = false, default = nil)
  if valid_568470 != nil:
    section.add "ForceRemove", valid_568470
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568471: Call_DeleteApplication_568464; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Service Fabric application. An application must be created before it can be deleted. Deleting an application will delete all services that are part of that application. By default Service Fabric will try to close service replicas in a graceful manner and then delete the service. However if service is having issues closing the replica gracefully, the delete operation may take a long time or get stuck. Use the optional ForceRemove flag to skip the graceful close sequence and forcefully delete the application and all of the its services.
  ## 
  let valid = call_568471.validator(path, query, header, formData, body)
  let scheme = call_568471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568471.url(scheme.get, call_568471.host, call_568471.base,
                         call_568471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568471, url, valid)

proc call*(call_568472: Call_DeleteApplication_568464; applicationId: string;
          timeout: int = 60; apiVersion: string = "3.0"; ForceRemove: bool = false): Recallable =
  ## deleteApplication
  ## Deletes an existing Service Fabric application. An application must be created before it can be deleted. Deleting an application will delete all services that are part of that application. By default Service Fabric will try to close service replicas in a graceful manner and then delete the service. However if service is having issues closing the replica gracefully, the delete operation may take a long time or get stuck. Use the optional ForceRemove flag to skip the graceful close sequence and forcefully delete the application and all of the its services.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ForceRemove: bool
  ##              : Remove a Service Fabric application or service forcefully without going through the graceful shutdown sequence. This parameter can be used to forcefully delete an application or service for which delete is timing out due to issues in the service code that prevents graceful close of replicas.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_568473 = newJObject()
  var query_568474 = newJObject()
  add(query_568474, "timeout", newJInt(timeout))
  add(query_568474, "api-version", newJString(apiVersion))
  add(query_568474, "ForceRemove", newJBool(ForceRemove))
  add(path_568473, "applicationId", newJString(applicationId))
  result = call_568472.call(path_568473, query_568474, nil, nil, nil)

var deleteApplication* = Call_DeleteApplication_568464(name: "deleteApplication",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/Delete",
    validator: validate_DeleteApplication_568465, base: "",
    url: url_DeleteApplication_568466, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationHealthUsingPolicy_568488 = ref object of OpenApiRestCall_567666
proc url_GetApplicationHealthUsingPolicy_568490(protocol: Scheme; host: string;
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

proc validate_GetApplicationHealthUsingPolicy_568489(path: JsonNode;
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
  var valid_568491 = path.getOrDefault("applicationId")
  valid_568491 = validateParameter(valid_568491, JString, required = true,
                                 default = nil)
  if valid_568491 != nil:
    section.add "applicationId", valid_568491
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
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
  var valid_568492 = query.getOrDefault("timeout")
  valid_568492 = validateParameter(valid_568492, JInt, required = false,
                                 default = newJInt(60))
  if valid_568492 != nil:
    section.add "timeout", valid_568492
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568493 = query.getOrDefault("api-version")
  valid_568493 = validateParameter(valid_568493, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568493 != nil:
    section.add "api-version", valid_568493
  var valid_568494 = query.getOrDefault("EventsHealthStateFilter")
  valid_568494 = validateParameter(valid_568494, JInt, required = false,
                                 default = newJInt(0))
  if valid_568494 != nil:
    section.add "EventsHealthStateFilter", valid_568494
  var valid_568495 = query.getOrDefault("ServicesHealthStateFilter")
  valid_568495 = validateParameter(valid_568495, JInt, required = false,
                                 default = newJInt(0))
  if valid_568495 != nil:
    section.add "ServicesHealthStateFilter", valid_568495
  var valid_568496 = query.getOrDefault("DeployedApplicationsHealthStateFilter")
  valid_568496 = validateParameter(valid_568496, JInt, required = false,
                                 default = newJInt(0))
  if valid_568496 != nil:
    section.add "DeployedApplicationsHealthStateFilter", valid_568496
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

proc call*(call_568498: Call_GetApplicationHealthUsingPolicy_568488;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric application. Use EventsHealthStateFilter to filter the collection of health events reported on the node based on the health state. Use ClusterHealthPolicies to override the health policies used to evaluate the health.
  ## 
  let valid = call_568498.validator(path, query, header, formData, body)
  let scheme = call_568498.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568498.url(scheme.get, call_568498.host, call_568498.base,
                         call_568498.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568498, url, valid)

proc call*(call_568499: Call_GetApplicationHealthUsingPolicy_568488;
          applicationId: string; timeout: int = 60; apiVersion: string = "3.0";
          ApplicationHealthPolicy: JsonNode = nil; EventsHealthStateFilter: int = 0;
          ServicesHealthStateFilter: int = 0;
          DeployedApplicationsHealthStateFilter: int = 0): Recallable =
  ## getApplicationHealthUsingPolicy
  ## Gets the health of a Service Fabric application. Use EventsHealthStateFilter to filter the collection of health events reported on the node based on the health state. Use ClusterHealthPolicies to override the health policies used to evaluate the health.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationHealthPolicy: JObject
  ##                          : Describes the health policies used to evaluate the health of an application or one of its children.
  ## If not present, the health evaluation uses the health policy from application manifest or the default health policy.
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
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
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
  var path_568500 = newJObject()
  var query_568501 = newJObject()
  var body_568502 = newJObject()
  add(query_568501, "timeout", newJInt(timeout))
  add(query_568501, "api-version", newJString(apiVersion))
  if ApplicationHealthPolicy != nil:
    body_568502 = ApplicationHealthPolicy
  add(query_568501, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_568500, "applicationId", newJString(applicationId))
  add(query_568501, "ServicesHealthStateFilter",
      newJInt(ServicesHealthStateFilter))
  add(query_568501, "DeployedApplicationsHealthStateFilter",
      newJInt(DeployedApplicationsHealthStateFilter))
  result = call_568499.call(path_568500, query_568501, nil, nil, body_568502)

var getApplicationHealthUsingPolicy* = Call_GetApplicationHealthUsingPolicy_568488(
    name: "getApplicationHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationId}/$/GetHealth",
    validator: validate_GetApplicationHealthUsingPolicy_568489, base: "",
    url: url_GetApplicationHealthUsingPolicy_568490,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationHealth_568475 = ref object of OpenApiRestCall_567666
proc url_GetApplicationHealth_568477(protocol: Scheme; host: string; base: string;
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

proc validate_GetApplicationHealth_568476(path: JsonNode; query: JsonNode;
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
  var valid_568478 = path.getOrDefault("applicationId")
  valid_568478 = validateParameter(valid_568478, JString, required = true,
                                 default = nil)
  if valid_568478 != nil:
    section.add "applicationId", valid_568478
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
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
  var valid_568479 = query.getOrDefault("timeout")
  valid_568479 = validateParameter(valid_568479, JInt, required = false,
                                 default = newJInt(60))
  if valid_568479 != nil:
    section.add "timeout", valid_568479
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568480 = query.getOrDefault("api-version")
  valid_568480 = validateParameter(valid_568480, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568480 != nil:
    section.add "api-version", valid_568480
  var valid_568481 = query.getOrDefault("EventsHealthStateFilter")
  valid_568481 = validateParameter(valid_568481, JInt, required = false,
                                 default = newJInt(0))
  if valid_568481 != nil:
    section.add "EventsHealthStateFilter", valid_568481
  var valid_568482 = query.getOrDefault("ServicesHealthStateFilter")
  valid_568482 = validateParameter(valid_568482, JInt, required = false,
                                 default = newJInt(0))
  if valid_568482 != nil:
    section.add "ServicesHealthStateFilter", valid_568482
  var valid_568483 = query.getOrDefault("DeployedApplicationsHealthStateFilter")
  valid_568483 = validateParameter(valid_568483, JInt, required = false,
                                 default = newJInt(0))
  if valid_568483 != nil:
    section.add "DeployedApplicationsHealthStateFilter", valid_568483
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568484: Call_GetApplicationHealth_568475; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the heath state of the service fabric application. The response reports either Ok, Error or Warning health state. If the entity is not found in the helath store, it will return Error.
  ## 
  let valid = call_568484.validator(path, query, header, formData, body)
  let scheme = call_568484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568484.url(scheme.get, call_568484.host, call_568484.base,
                         call_568484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568484, url, valid)

proc call*(call_568485: Call_GetApplicationHealth_568475; applicationId: string;
          timeout: int = 60; apiVersion: string = "3.0";
          EventsHealthStateFilter: int = 0; ServicesHealthStateFilter: int = 0;
          DeployedApplicationsHealthStateFilter: int = 0): Recallable =
  ## getApplicationHealth
  ## Returns the heath state of the service fabric application. The response reports either Ok, Error or Warning health state. If the entity is not found in the helath store, it will return Error.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
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
  var path_568486 = newJObject()
  var query_568487 = newJObject()
  add(query_568487, "timeout", newJInt(timeout))
  add(query_568487, "api-version", newJString(apiVersion))
  add(query_568487, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_568486, "applicationId", newJString(applicationId))
  add(query_568487, "ServicesHealthStateFilter",
      newJInt(ServicesHealthStateFilter))
  add(query_568487, "DeployedApplicationsHealthStateFilter",
      newJInt(DeployedApplicationsHealthStateFilter))
  result = call_568485.call(path_568486, query_568487, nil, nil, nil)

var getApplicationHealth* = Call_GetApplicationHealth_568475(
    name: "getApplicationHealth", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Applications/{applicationId}/$/GetHealth",
    validator: validate_GetApplicationHealth_568476, base: "",
    url: url_GetApplicationHealth_568477, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceInfoList_568503 = ref object of OpenApiRestCall_567666
proc url_GetServiceInfoList_568505(protocol: Scheme; host: string; base: string;
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

proc validate_GetServiceInfoList_568504(path: JsonNode; query: JsonNode;
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
  var valid_568506 = path.getOrDefault("applicationId")
  valid_568506 = validateParameter(valid_568506, JString, required = true,
                                 default = nil)
  if valid_568506 != nil:
    section.add "applicationId", valid_568506
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   ServiceTypeName: JString
  ##                  : The service type name used to filter the services to query for.
  section = newJObject()
  var valid_568507 = query.getOrDefault("timeout")
  valid_568507 = validateParameter(valid_568507, JInt, required = false,
                                 default = newJInt(60))
  if valid_568507 != nil:
    section.add "timeout", valid_568507
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568508 = query.getOrDefault("api-version")
  valid_568508 = validateParameter(valid_568508, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568508 != nil:
    section.add "api-version", valid_568508
  var valid_568509 = query.getOrDefault("ContinuationToken")
  valid_568509 = validateParameter(valid_568509, JString, required = false,
                                 default = nil)
  if valid_568509 != nil:
    section.add "ContinuationToken", valid_568509
  var valid_568510 = query.getOrDefault("ServiceTypeName")
  valid_568510 = validateParameter(valid_568510, JString, required = false,
                                 default = nil)
  if valid_568510 != nil:
    section.add "ServiceTypeName", valid_568510
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568511: Call_GetServiceInfoList_568503; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the information about all services belonging to the application specified by the application id.
  ## 
  let valid = call_568511.validator(path, query, header, formData, body)
  let scheme = call_568511.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568511.url(scheme.get, call_568511.host, call_568511.base,
                         call_568511.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568511, url, valid)

proc call*(call_568512: Call_GetServiceInfoList_568503; applicationId: string;
          timeout: int = 60; apiVersion: string = "3.0"; ContinuationToken: string = "";
          ServiceTypeName: string = ""): Recallable =
  ## getServiceInfoList
  ## Returns the information about all services belonging to the application specified by the application id.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  ##   ContinuationToken: string
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   ServiceTypeName: string
  ##                  : The service type name used to filter the services to query for.
  var path_568513 = newJObject()
  var query_568514 = newJObject()
  add(query_568514, "timeout", newJInt(timeout))
  add(query_568514, "api-version", newJString(apiVersion))
  add(path_568513, "applicationId", newJString(applicationId))
  add(query_568514, "ContinuationToken", newJString(ContinuationToken))
  add(query_568514, "ServiceTypeName", newJString(ServiceTypeName))
  result = call_568512.call(path_568513, query_568514, nil, nil, nil)

var getServiceInfoList* = Call_GetServiceInfoList_568503(
    name: "getServiceInfoList", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/GetServices",
    validator: validate_GetServiceInfoList_568504, base: "",
    url: url_GetServiceInfoList_568505, schemes: {Scheme.Https, Scheme.Http})
type
  Call_CreateService_568515 = ref object of OpenApiRestCall_567666
proc url_CreateService_568517(protocol: Scheme; host: string; base: string;
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

proc validate_CreateService_568516(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568518 = path.getOrDefault("applicationId")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "applicationId", valid_568518
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568519 = query.getOrDefault("timeout")
  valid_568519 = validateParameter(valid_568519, JInt, required = false,
                                 default = newJInt(60))
  if valid_568519 != nil:
    section.add "timeout", valid_568519
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568520 = query.getOrDefault("api-version")
  valid_568520 = validateParameter(valid_568520, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568520 != nil:
    section.add "api-version", valid_568520
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

proc call*(call_568522: Call_CreateService_568515; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the specified service.
  ## 
  let valid = call_568522.validator(path, query, header, formData, body)
  let scheme = call_568522.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568522.url(scheme.get, call_568522.host, call_568522.base,
                         call_568522.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568522, url, valid)

proc call*(call_568523: Call_CreateService_568515; applicationId: string;
          ServiceDescription: JsonNode; timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## createService
  ## Creates the specified service.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  ##   ServiceDescription: JObject (required)
  ##                     : The configuration for the service.
  var path_568524 = newJObject()
  var query_568525 = newJObject()
  var body_568526 = newJObject()
  add(query_568525, "timeout", newJInt(timeout))
  add(query_568525, "api-version", newJString(apiVersion))
  add(path_568524, "applicationId", newJString(applicationId))
  if ServiceDescription != nil:
    body_568526 = ServiceDescription
  result = call_568523.call(path_568524, query_568525, nil, nil, body_568526)

var createService* = Call_CreateService_568515(name: "createService",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/GetServices/$/Create",
    validator: validate_CreateService_568516, base: "", url: url_CreateService_568517,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_CreateServiceFromTemplate_568527 = ref object of OpenApiRestCall_567666
proc url_CreateServiceFromTemplate_568529(protocol: Scheme; host: string;
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

proc validate_CreateServiceFromTemplate_568528(path: JsonNode; query: JsonNode;
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
  var valid_568530 = path.getOrDefault("applicationId")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "applicationId", valid_568530
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568531 = query.getOrDefault("timeout")
  valid_568531 = validateParameter(valid_568531, JInt, required = false,
                                 default = newJInt(60))
  if valid_568531 != nil:
    section.add "timeout", valid_568531
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568532 = query.getOrDefault("api-version")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568532 != nil:
    section.add "api-version", valid_568532
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

proc call*(call_568534: Call_CreateServiceFromTemplate_568527; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Service Fabric service from the service template defined in the application manifest.
  ## 
  let valid = call_568534.validator(path, query, header, formData, body)
  let scheme = call_568534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568534.url(scheme.get, call_568534.host, call_568534.base,
                         call_568534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568534, url, valid)

proc call*(call_568535: Call_CreateServiceFromTemplate_568527;
          ServiceFromTemplateDescription: JsonNode; applicationId: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## createServiceFromTemplate
  ## Creates a Service Fabric service from the service template defined in the application manifest.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ServiceFromTemplateDescription: JObject (required)
  ##                                 : Describes the service that needs to be created from the template defined in the application manifest.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_568536 = newJObject()
  var query_568537 = newJObject()
  var body_568538 = newJObject()
  add(query_568537, "timeout", newJInt(timeout))
  add(query_568537, "api-version", newJString(apiVersion))
  if ServiceFromTemplateDescription != nil:
    body_568538 = ServiceFromTemplateDescription
  add(path_568536, "applicationId", newJString(applicationId))
  result = call_568535.call(path_568536, query_568537, nil, nil, body_568538)

var createServiceFromTemplate* = Call_CreateServiceFromTemplate_568527(
    name: "createServiceFromTemplate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/GetServices/$/CreateFromTemplate",
    validator: validate_CreateServiceFromTemplate_568528, base: "",
    url: url_CreateServiceFromTemplate_568529,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceInfo_568539 = ref object of OpenApiRestCall_567666
proc url_GetServiceInfo_568541(protocol: Scheme; host: string; base: string;
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

proc validate_GetServiceInfo_568540(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Returns the information about specified service belonging to the specified Service Fabric application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  ##   serviceId: JString (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationId` field"
  var valid_568542 = path.getOrDefault("applicationId")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "applicationId", valid_568542
  var valid_568543 = path.getOrDefault("serviceId")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "serviceId", valid_568543
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568544 = query.getOrDefault("timeout")
  valid_568544 = validateParameter(valid_568544, JInt, required = false,
                                 default = newJInt(60))
  if valid_568544 != nil:
    section.add "timeout", valid_568544
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568545 = query.getOrDefault("api-version")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568545 != nil:
    section.add "api-version", valid_568545
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568546: Call_GetServiceInfo_568539; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the information about specified service belonging to the specified Service Fabric application.
  ## 
  let valid = call_568546.validator(path, query, header, formData, body)
  let scheme = call_568546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568546.url(scheme.get, call_568546.host, call_568546.base,
                         call_568546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568546, url, valid)

proc call*(call_568547: Call_GetServiceInfo_568539; applicationId: string;
          serviceId: string; timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getServiceInfo
  ## Returns the information about specified service belonging to the specified Service Fabric application.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_568548 = newJObject()
  var query_568549 = newJObject()
  add(query_568549, "timeout", newJInt(timeout))
  add(query_568549, "api-version", newJString(apiVersion))
  add(path_568548, "applicationId", newJString(applicationId))
  add(path_568548, "serviceId", newJString(serviceId))
  result = call_568547.call(path_568548, query_568549, nil, nil, nil)

var getServiceInfo* = Call_GetServiceInfo_568539(name: "getServiceInfo",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/GetServices/{serviceId}",
    validator: validate_GetServiceInfo_568540, base: "", url: url_GetServiceInfo_568541,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationUpgrade_568550 = ref object of OpenApiRestCall_567666
proc url_GetApplicationUpgrade_568552(protocol: Scheme; host: string; base: string;
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

proc validate_GetApplicationUpgrade_568551(path: JsonNode; query: JsonNode;
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
  var valid_568553 = path.getOrDefault("applicationId")
  valid_568553 = validateParameter(valid_568553, JString, required = true,
                                 default = nil)
  if valid_568553 != nil:
    section.add "applicationId", valid_568553
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568554 = query.getOrDefault("timeout")
  valid_568554 = validateParameter(valid_568554, JInt, required = false,
                                 default = newJInt(60))
  if valid_568554 != nil:
    section.add "timeout", valid_568554
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568555 = query.getOrDefault("api-version")
  valid_568555 = validateParameter(valid_568555, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568555 != nil:
    section.add "api-version", valid_568555
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568556: Call_GetApplicationUpgrade_568550; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the state of the latest application upgrade along with details to aid debugging application health issues.
  ## 
  let valid = call_568556.validator(path, query, header, formData, body)
  let scheme = call_568556.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568556.url(scheme.get, call_568556.host, call_568556.base,
                         call_568556.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568556, url, valid)

proc call*(call_568557: Call_GetApplicationUpgrade_568550; applicationId: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getApplicationUpgrade
  ## Returns information about the state of the latest application upgrade along with details to aid debugging application health issues.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_568558 = newJObject()
  var query_568559 = newJObject()
  add(query_568559, "timeout", newJInt(timeout))
  add(query_568559, "api-version", newJString(apiVersion))
  add(path_568558, "applicationId", newJString(applicationId))
  result = call_568557.call(path_568558, query_568559, nil, nil, nil)

var getApplicationUpgrade* = Call_GetApplicationUpgrade_568550(
    name: "getApplicationUpgrade", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/GetUpgradeProgress",
    validator: validate_GetApplicationUpgrade_568551, base: "",
    url: url_GetApplicationUpgrade_568552, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ResumeApplicationUpgrade_568560 = ref object of OpenApiRestCall_567666
proc url_ResumeApplicationUpgrade_568562(protocol: Scheme; host: string;
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

proc validate_ResumeApplicationUpgrade_568561(path: JsonNode; query: JsonNode;
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
  var valid_568563 = path.getOrDefault("applicationId")
  valid_568563 = validateParameter(valid_568563, JString, required = true,
                                 default = nil)
  if valid_568563 != nil:
    section.add "applicationId", valid_568563
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568564 = query.getOrDefault("timeout")
  valid_568564 = validateParameter(valid_568564, JInt, required = false,
                                 default = newJInt(60))
  if valid_568564 != nil:
    section.add "timeout", valid_568564
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568565 = query.getOrDefault("api-version")
  valid_568565 = validateParameter(valid_568565, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568565 != nil:
    section.add "api-version", valid_568565
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

proc call*(call_568567: Call_ResumeApplicationUpgrade_568560; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resumes an unmonitored manual Service Fabric application upgrade. Service Fabric upgrades one upgrade domain at a time. For unmonitored manual upgrades, after Service Fabric finishes an upgrade domain, it waits for you to call this API before proceeding to the next upgrade domain.
  ## 
  let valid = call_568567.validator(path, query, header, formData, body)
  let scheme = call_568567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568567.url(scheme.get, call_568567.host, call_568567.base,
                         call_568567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568567, url, valid)

proc call*(call_568568: Call_ResumeApplicationUpgrade_568560;
          ResumeApplicationUpgradeDescription: JsonNode; applicationId: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## resumeApplicationUpgrade
  ## Resumes an unmonitored manual Service Fabric application upgrade. Service Fabric upgrades one upgrade domain at a time. For unmonitored manual upgrades, after Service Fabric finishes an upgrade domain, it waits for you to call this API before proceeding to the next upgrade domain.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   ResumeApplicationUpgradeDescription: JObject (required)
  ##                                      : Describes the parameters for resuming an application upgrade.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_568569 = newJObject()
  var query_568570 = newJObject()
  var body_568571 = newJObject()
  add(query_568570, "timeout", newJInt(timeout))
  if ResumeApplicationUpgradeDescription != nil:
    body_568571 = ResumeApplicationUpgradeDescription
  add(query_568570, "api-version", newJString(apiVersion))
  add(path_568569, "applicationId", newJString(applicationId))
  result = call_568568.call(path_568569, query_568570, nil, nil, body_568571)

var resumeApplicationUpgrade* = Call_ResumeApplicationUpgrade_568560(
    name: "resumeApplicationUpgrade", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/MoveToNextUpgradeDomain",
    validator: validate_ResumeApplicationUpgrade_568561, base: "",
    url: url_ResumeApplicationUpgrade_568562, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportApplicationHealth_568572 = ref object of OpenApiRestCall_567666
proc url_ReportApplicationHealth_568574(protocol: Scheme; host: string; base: string;
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

proc validate_ReportApplicationHealth_568573(path: JsonNode; query: JsonNode;
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
  var valid_568575 = path.getOrDefault("applicationId")
  valid_568575 = validateParameter(valid_568575, JString, required = true,
                                 default = nil)
  if valid_568575 != nil:
    section.add "applicationId", valid_568575
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568576 = query.getOrDefault("timeout")
  valid_568576 = validateParameter(valid_568576, JInt, required = false,
                                 default = newJInt(60))
  if valid_568576 != nil:
    section.add "timeout", valid_568576
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568577 = query.getOrDefault("api-version")
  valid_568577 = validateParameter(valid_568577, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568577 != nil:
    section.add "api-version", valid_568577
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

proc call*(call_568579: Call_ReportApplicationHealth_568572; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reports health state of the specified Service Fabric application. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Application, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetApplicationHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_568579.validator(path, query, header, formData, body)
  let scheme = call_568579.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568579.url(scheme.get, call_568579.host, call_568579.base,
                         call_568579.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568579, url, valid)

proc call*(call_568580: Call_ReportApplicationHealth_568572;
          HealthInformation: JsonNode; applicationId: string; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## reportApplicationHealth
  ## Reports health state of the specified Service Fabric application. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Application, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetApplicationHealth and check that the report appears in the HealthEvents section.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_568581 = newJObject()
  var query_568582 = newJObject()
  var body_568583 = newJObject()
  add(query_568582, "timeout", newJInt(timeout))
  add(query_568582, "api-version", newJString(apiVersion))
  if HealthInformation != nil:
    body_568583 = HealthInformation
  add(path_568581, "applicationId", newJString(applicationId))
  result = call_568580.call(path_568581, query_568582, nil, nil, body_568583)

var reportApplicationHealth* = Call_ReportApplicationHealth_568572(
    name: "reportApplicationHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/ReportHealth",
    validator: validate_ReportApplicationHealth_568573, base: "",
    url: url_ReportApplicationHealth_568574, schemes: {Scheme.Https, Scheme.Http})
type
  Call_RollbackApplicationUpgrade_568584 = ref object of OpenApiRestCall_567666
proc url_RollbackApplicationUpgrade_568586(protocol: Scheme; host: string;
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

proc validate_RollbackApplicationUpgrade_568585(path: JsonNode; query: JsonNode;
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
  var valid_568587 = path.getOrDefault("applicationId")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "applicationId", valid_568587
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568588 = query.getOrDefault("timeout")
  valid_568588 = validateParameter(valid_568588, JInt, required = false,
                                 default = newJInt(60))
  if valid_568588 != nil:
    section.add "timeout", valid_568588
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568589 = query.getOrDefault("api-version")
  valid_568589 = validateParameter(valid_568589, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568589 != nil:
    section.add "api-version", valid_568589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568590: Call_RollbackApplicationUpgrade_568584; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts rolling back the current application upgrade to the previous version. This API can only be used to rollback the current in-progress upgrade that is rolling forward to new version. If the application is not currently being upgraded use StartApplicationUpgrade API to upgrade it to desired version including rolling back to a previous version.
  ## 
  let valid = call_568590.validator(path, query, header, formData, body)
  let scheme = call_568590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568590.url(scheme.get, call_568590.host, call_568590.base,
                         call_568590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568590, url, valid)

proc call*(call_568591: Call_RollbackApplicationUpgrade_568584;
          applicationId: string; timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## rollbackApplicationUpgrade
  ## Starts rolling back the current application upgrade to the previous version. This API can only be used to rollback the current in-progress upgrade that is rolling forward to new version. If the application is not currently being upgraded use StartApplicationUpgrade API to upgrade it to desired version including rolling back to a previous version.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_568592 = newJObject()
  var query_568593 = newJObject()
  add(query_568593, "timeout", newJInt(timeout))
  add(query_568593, "api-version", newJString(apiVersion))
  add(path_568592, "applicationId", newJString(applicationId))
  result = call_568591.call(path_568592, query_568593, nil, nil, nil)

var rollbackApplicationUpgrade* = Call_RollbackApplicationUpgrade_568584(
    name: "rollbackApplicationUpgrade", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/RollbackUpgrade",
    validator: validate_RollbackApplicationUpgrade_568585, base: "",
    url: url_RollbackApplicationUpgrade_568586,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_UpdateApplicationUpgrade_568594 = ref object of OpenApiRestCall_567666
proc url_UpdateApplicationUpgrade_568596(protocol: Scheme; host: string;
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

proc validate_UpdateApplicationUpgrade_568595(path: JsonNode; query: JsonNode;
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
  var valid_568597 = path.getOrDefault("applicationId")
  valid_568597 = validateParameter(valid_568597, JString, required = true,
                                 default = nil)
  if valid_568597 != nil:
    section.add "applicationId", valid_568597
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568598 = query.getOrDefault("timeout")
  valid_568598 = validateParameter(valid_568598, JInt, required = false,
                                 default = newJInt(60))
  if valid_568598 != nil:
    section.add "timeout", valid_568598
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568599 = query.getOrDefault("api-version")
  valid_568599 = validateParameter(valid_568599, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568599 != nil:
    section.add "api-version", valid_568599
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

proc call*(call_568601: Call_UpdateApplicationUpgrade_568594; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the parameters of an ongoing application upgrade from the ones specified at the time of starting the application upgrade. This may be required to mitigate stuck application upgrades due to incorrect parameters or issues in the application to make progress.
  ## 
  let valid = call_568601.validator(path, query, header, formData, body)
  let scheme = call_568601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568601.url(scheme.get, call_568601.host, call_568601.base,
                         call_568601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568601, url, valid)

proc call*(call_568602: Call_UpdateApplicationUpgrade_568594;
          applicationId: string; ApplicationUpgradeUpdateDescription: JsonNode;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## updateApplicationUpgrade
  ## Updates the parameters of an ongoing application upgrade from the ones specified at the time of starting the application upgrade. This may be required to mitigate stuck application upgrades due to incorrect parameters or issues in the application to make progress.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  ##   ApplicationUpgradeUpdateDescription: JObject (required)
  ##                                      : Describes the parameters for updating an existing application upgrade.
  var path_568603 = newJObject()
  var query_568604 = newJObject()
  var body_568605 = newJObject()
  add(query_568604, "timeout", newJInt(timeout))
  add(query_568604, "api-version", newJString(apiVersion))
  add(path_568603, "applicationId", newJString(applicationId))
  if ApplicationUpgradeUpdateDescription != nil:
    body_568605 = ApplicationUpgradeUpdateDescription
  result = call_568602.call(path_568603, query_568604, nil, nil, body_568605)

var updateApplicationUpgrade* = Call_UpdateApplicationUpgrade_568594(
    name: "updateApplicationUpgrade", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/UpdateUpgrade",
    validator: validate_UpdateApplicationUpgrade_568595, base: "",
    url: url_UpdateApplicationUpgrade_568596, schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartApplicationUpgrade_568606 = ref object of OpenApiRestCall_567666
proc url_StartApplicationUpgrade_568608(protocol: Scheme; host: string; base: string;
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

proc validate_StartApplicationUpgrade_568607(path: JsonNode; query: JsonNode;
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
  var valid_568609 = path.getOrDefault("applicationId")
  valid_568609 = validateParameter(valid_568609, JString, required = true,
                                 default = nil)
  if valid_568609 != nil:
    section.add "applicationId", valid_568609
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568610 = query.getOrDefault("timeout")
  valid_568610 = validateParameter(valid_568610, JInt, required = false,
                                 default = newJInt(60))
  if valid_568610 != nil:
    section.add "timeout", valid_568610
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568611 = query.getOrDefault("api-version")
  valid_568611 = validateParameter(valid_568611, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568611 != nil:
    section.add "api-version", valid_568611
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

proc call*(call_568613: Call_StartApplicationUpgrade_568606; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the supplied application upgrade parameters and starts upgrading the application if the parameters are valid.
  ## 
  let valid = call_568613.validator(path, query, header, formData, body)
  let scheme = call_568613.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568613.url(scheme.get, call_568613.host, call_568613.base,
                         call_568613.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568613, url, valid)

proc call*(call_568614: Call_StartApplicationUpgrade_568606; applicationId: string;
          ApplicationUpgradeDescription: JsonNode; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## startApplicationUpgrade
  ## Validates the supplied application upgrade parameters and starts upgrading the application if the parameters are valid.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  ##   ApplicationUpgradeDescription: JObject (required)
  ##                                : Describes the parameters for an application upgrade.
  var path_568615 = newJObject()
  var query_568616 = newJObject()
  var body_568617 = newJObject()
  add(query_568616, "timeout", newJInt(timeout))
  add(query_568616, "api-version", newJString(apiVersion))
  add(path_568615, "applicationId", newJString(applicationId))
  if ApplicationUpgradeDescription != nil:
    body_568617 = ApplicationUpgradeDescription
  result = call_568614.call(path_568615, query_568616, nil, nil, body_568617)

var startApplicationUpgrade* = Call_StartApplicationUpgrade_568606(
    name: "startApplicationUpgrade", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationId}/$/Upgrade",
    validator: validate_StartApplicationUpgrade_568607, base: "",
    url: url_StartApplicationUpgrade_568608, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetComposeApplicationStatusList_568618 = ref object of OpenApiRestCall_567666
proc url_GetComposeApplicationStatusList_568620(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetComposeApplicationStatusList_568619(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the status about the compose applications that were created or in the process of being created in the Service Fabric cluster. The response includes the name, status and other details about the compose application. If the applications do not fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "4.0-preview".
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   MaxResults: JInt
  ##             : The maximum number of results to be returned as part of the paged queries. This parameter defines the upper bound on the number of results returned. The results returned can be less than the specified maximum results if they do not fit in the message as per the max message size restrictions defined in the configuration. If this parameter is zero or not specified, the paged queries includes as much results as possible that fit in the return message.
  section = newJObject()
  var valid_568621 = query.getOrDefault("timeout")
  valid_568621 = validateParameter(valid_568621, JInt, required = false,
                                 default = newJInt(60))
  if valid_568621 != nil:
    section.add "timeout", valid_568621
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568622 = query.getOrDefault("api-version")
  valid_568622 = validateParameter(valid_568622, JString, required = true,
                                 default = newJString("4.0-preview"))
  if valid_568622 != nil:
    section.add "api-version", valid_568622
  var valid_568623 = query.getOrDefault("ContinuationToken")
  valid_568623 = validateParameter(valid_568623, JString, required = false,
                                 default = nil)
  if valid_568623 != nil:
    section.add "ContinuationToken", valid_568623
  var valid_568624 = query.getOrDefault("MaxResults")
  valid_568624 = validateParameter(valid_568624, JInt, required = false,
                                 default = newJInt(0))
  if valid_568624 != nil:
    section.add "MaxResults", valid_568624
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568625: Call_GetComposeApplicationStatusList_568618;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status about the compose applications that were created or in the process of being created in the Service Fabric cluster. The response includes the name, status and other details about the compose application. If the applications do not fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page.
  ## 
  let valid = call_568625.validator(path, query, header, formData, body)
  let scheme = call_568625.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568625.url(scheme.get, call_568625.host, call_568625.base,
                         call_568625.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568625, url, valid)

proc call*(call_568626: Call_GetComposeApplicationStatusList_568618;
          timeout: int = 60; apiVersion: string = "4.0-preview";
          ContinuationToken: string = ""; MaxResults: int = 0): Recallable =
  ## getComposeApplicationStatusList
  ## Gets the status about the compose applications that were created or in the process of being created in the Service Fabric cluster. The response includes the name, status and other details about the compose application. If the applications do not fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "4.0-preview".
  ##   ContinuationToken: string
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   MaxResults: int
  ##             : The maximum number of results to be returned as part of the paged queries. This parameter defines the upper bound on the number of results returned. The results returned can be less than the specified maximum results if they do not fit in the message as per the max message size restrictions defined in the configuration. If this parameter is zero or not specified, the paged queries includes as much results as possible that fit in the return message.
  var query_568627 = newJObject()
  add(query_568627, "timeout", newJInt(timeout))
  add(query_568627, "api-version", newJString(apiVersion))
  add(query_568627, "ContinuationToken", newJString(ContinuationToken))
  add(query_568627, "MaxResults", newJInt(MaxResults))
  result = call_568626.call(nil, query_568627, nil, nil, nil)

var getComposeApplicationStatusList* = Call_GetComposeApplicationStatusList_568618(
    name: "getComposeApplicationStatusList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ComposeDeployments",
    validator: validate_GetComposeApplicationStatusList_568619, base: "",
    url: url_GetComposeApplicationStatusList_568620,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_CreateComposeApplication_568628 = ref object of OpenApiRestCall_567666
proc url_CreateComposeApplication_568630(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CreateComposeApplication_568629(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Service Fabric compose application.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "4.0-preview".
  section = newJObject()
  var valid_568631 = query.getOrDefault("timeout")
  valid_568631 = validateParameter(valid_568631, JInt, required = false,
                                 default = newJInt(60))
  if valid_568631 != nil:
    section.add "timeout", valid_568631
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568632 = query.getOrDefault("api-version")
  valid_568632 = validateParameter(valid_568632, JString, required = true,
                                 default = newJString("4.0-preview"))
  if valid_568632 != nil:
    section.add "api-version", valid_568632
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

proc call*(call_568634: Call_CreateComposeApplication_568628; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Service Fabric compose application.
  ## 
  let valid = call_568634.validator(path, query, header, formData, body)
  let scheme = call_568634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568634.url(scheme.get, call_568634.host, call_568634.base,
                         call_568634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568634, url, valid)

proc call*(call_568635: Call_CreateComposeApplication_568628;
          CreateComposeApplicationDescription: JsonNode; timeout: int = 60;
          apiVersion: string = "4.0-preview"): Recallable =
  ## createComposeApplication
  ## Creates a Service Fabric compose application.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "4.0-preview".
  ##   CreateComposeApplicationDescription: JObject (required)
  ##                                      : Describes the compose application that needs to be created.
  var query_568636 = newJObject()
  var body_568637 = newJObject()
  add(query_568636, "timeout", newJInt(timeout))
  add(query_568636, "api-version", newJString(apiVersion))
  if CreateComposeApplicationDescription != nil:
    body_568637 = CreateComposeApplicationDescription
  result = call_568635.call(nil, query_568636, nil, nil, body_568637)

var createComposeApplication* = Call_CreateComposeApplication_568628(
    name: "createComposeApplication", meth: HttpMethod.HttpPut,
    host: "azure.local:19080", route: "/ComposeDeployments/$/Create",
    validator: validate_CreateComposeApplication_568629, base: "",
    url: url_CreateComposeApplication_568630, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetComposeApplicationStatus_568638 = ref object of OpenApiRestCall_567666
proc url_GetComposeApplicationStatus_568640(protocol: Scheme; host: string;
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

proc validate_GetComposeApplicationStatus_568639(path: JsonNode; query: JsonNode;
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
  var valid_568641 = path.getOrDefault("applicationId")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "applicationId", valid_568641
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "4.0-preview".
  section = newJObject()
  var valid_568642 = query.getOrDefault("timeout")
  valid_568642 = validateParameter(valid_568642, JInt, required = false,
                                 default = newJInt(60))
  if valid_568642 != nil:
    section.add "timeout", valid_568642
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568643 = query.getOrDefault("api-version")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = newJString("4.0-preview"))
  if valid_568643 != nil:
    section.add "api-version", valid_568643
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568644: Call_GetComposeApplicationStatus_568638; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the status of compose application that was created or in the process of being created in the Service Fabric cluster and whose name matches the one specified as the parameter. The response includes the name, status and other details about the application.
  ## 
  let valid = call_568644.validator(path, query, header, formData, body)
  let scheme = call_568644.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568644.url(scheme.get, call_568644.host, call_568644.base,
                         call_568644.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568644, url, valid)

proc call*(call_568645: Call_GetComposeApplicationStatus_568638;
          applicationId: string; timeout: int = 60; apiVersion: string = "4.0-preview"): Recallable =
  ## getComposeApplicationStatus
  ## Returns the status of compose application that was created or in the process of being created in the Service Fabric cluster and whose name matches the one specified as the parameter. The response includes the name, status and other details about the application.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "4.0-preview".
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_568646 = newJObject()
  var query_568647 = newJObject()
  add(query_568647, "timeout", newJInt(timeout))
  add(query_568647, "api-version", newJString(apiVersion))
  add(path_568646, "applicationId", newJString(applicationId))
  result = call_568645.call(path_568646, query_568647, nil, nil, nil)

var getComposeApplicationStatus* = Call_GetComposeApplicationStatus_568638(
    name: "getComposeApplicationStatus", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ComposeDeployments/{applicationId}",
    validator: validate_GetComposeApplicationStatus_568639, base: "",
    url: url_GetComposeApplicationStatus_568640,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_RemoveComposeApplication_568648 = ref object of OpenApiRestCall_567666
proc url_RemoveComposeApplication_568650(protocol: Scheme; host: string;
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

proc validate_RemoveComposeApplication_568649(path: JsonNode; query: JsonNode;
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
  var valid_568651 = path.getOrDefault("applicationId")
  valid_568651 = validateParameter(valid_568651, JString, required = true,
                                 default = nil)
  if valid_568651 != nil:
    section.add "applicationId", valid_568651
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "4.0-preview".
  section = newJObject()
  var valid_568652 = query.getOrDefault("timeout")
  valid_568652 = validateParameter(valid_568652, JInt, required = false,
                                 default = newJInt(60))
  if valid_568652 != nil:
    section.add "timeout", valid_568652
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568653 = query.getOrDefault("api-version")
  valid_568653 = validateParameter(valid_568653, JString, required = true,
                                 default = newJString("4.0-preview"))
  if valid_568653 != nil:
    section.add "api-version", valid_568653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568654: Call_RemoveComposeApplication_568648; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Service Fabric compose application. An application must be created before it can be deleted.
  ## 
  let valid = call_568654.validator(path, query, header, formData, body)
  let scheme = call_568654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568654.url(scheme.get, call_568654.host, call_568654.base,
                         call_568654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568654, url, valid)

proc call*(call_568655: Call_RemoveComposeApplication_568648;
          applicationId: string; timeout: int = 60; apiVersion: string = "4.0-preview"): Recallable =
  ## removeComposeApplication
  ## Deletes an existing Service Fabric compose application. An application must be created before it can be deleted.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "4.0-preview".
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_568656 = newJObject()
  var query_568657 = newJObject()
  add(query_568657, "timeout", newJInt(timeout))
  add(query_568657, "api-version", newJString(apiVersion))
  add(path_568656, "applicationId", newJString(applicationId))
  result = call_568655.call(path_568656, query_568657, nil, nil, nil)

var removeComposeApplication* = Call_RemoveComposeApplication_568648(
    name: "removeComposeApplication", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/ComposeDeployments/{applicationId}/$/Delete",
    validator: validate_RemoveComposeApplication_568649, base: "",
    url: url_RemoveComposeApplication_568650, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetFaultOperationList_568658 = ref object of OpenApiRestCall_567666
proc url_GetFaultOperationList_568660(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetFaultOperationList_568659(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the a list of user-induced fault operations filtered by provided input.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
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
  var valid_568661 = query.getOrDefault("timeout")
  valid_568661 = validateParameter(valid_568661, JInt, required = false,
                                 default = newJInt(60))
  if valid_568661 != nil:
    section.add "timeout", valid_568661
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568662 = query.getOrDefault("api-version")
  valid_568662 = validateParameter(valid_568662, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568662 != nil:
    section.add "api-version", valid_568662
  var valid_568663 = query.getOrDefault("TypeFilter")
  valid_568663 = validateParameter(valid_568663, JInt, required = true,
                                 default = newJInt(65535))
  if valid_568663 != nil:
    section.add "TypeFilter", valid_568663
  var valid_568664 = query.getOrDefault("StateFilter")
  valid_568664 = validateParameter(valid_568664, JInt, required = true,
                                 default = newJInt(65535))
  if valid_568664 != nil:
    section.add "StateFilter", valid_568664
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568665: Call_GetFaultOperationList_568658; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the a list of user-induced fault operations filtered by provided input.
  ## 
  let valid = call_568665.validator(path, query, header, formData, body)
  let scheme = call_568665.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568665.url(scheme.get, call_568665.host, call_568665.base,
                         call_568665.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568665, url, valid)

proc call*(call_568666: Call_GetFaultOperationList_568658; timeout: int = 60;
          apiVersion: string = "3.0"; TypeFilter: int = 65535; StateFilter: int = 65535): Recallable =
  ## getFaultOperationList
  ## Gets the a list of user-induced fault operations filtered by provided input.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
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
  var query_568667 = newJObject()
  add(query_568667, "timeout", newJInt(timeout))
  add(query_568667, "api-version", newJString(apiVersion))
  add(query_568667, "TypeFilter", newJInt(TypeFilter))
  add(query_568667, "StateFilter", newJInt(StateFilter))
  result = call_568666.call(nil, query_568667, nil, nil, nil)

var getFaultOperationList* = Call_GetFaultOperationList_568658(
    name: "getFaultOperationList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Faults/",
    validator: validate_GetFaultOperationList_568659, base: "",
    url: url_GetFaultOperationList_568660, schemes: {Scheme.Https, Scheme.Http})
type
  Call_CancelOperation_568668 = ref object of OpenApiRestCall_567666
proc url_CancelOperation_568670(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CancelOperation_568669(path: JsonNode; query: JsonNode;
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
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  ##   Force: JBool (required)
  ##        : Indicates whether to gracefully rollback and clean up internal system state modified by executing the user-induced operation.
  section = newJObject()
  var valid_568671 = query.getOrDefault("timeout")
  valid_568671 = validateParameter(valid_568671, JInt, required = false,
                                 default = newJInt(60))
  if valid_568671 != nil:
    section.add "timeout", valid_568671
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568672 = query.getOrDefault("api-version")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568672 != nil:
    section.add "api-version", valid_568672
  var valid_568673 = query.getOrDefault("OperationId")
  valid_568673 = validateParameter(valid_568673, JString, required = true,
                                 default = nil)
  if valid_568673 != nil:
    section.add "OperationId", valid_568673
  var valid_568674 = query.getOrDefault("Force")
  valid_568674 = validateParameter(valid_568674, JBool, required = true,
                                 default = newJBool(false))
  if valid_568674 != nil:
    section.add "Force", valid_568674
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568675: Call_CancelOperation_568668; path: JsonNode; query: JsonNode;
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
  let valid = call_568675.validator(path, query, header, formData, body)
  let scheme = call_568675.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568675.url(scheme.get, call_568675.host, call_568675.base,
                         call_568675.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568675, url, valid)

proc call*(call_568676: Call_CancelOperation_568668; OperationId: string;
          timeout: int = 60; apiVersion: string = "3.0"; Force: bool = false): Recallable =
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
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   OperationId: string (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  ##   Force: bool (required)
  ##        : Indicates whether to gracefully rollback and clean up internal system state modified by executing the user-induced operation.
  var query_568677 = newJObject()
  add(query_568677, "timeout", newJInt(timeout))
  add(query_568677, "api-version", newJString(apiVersion))
  add(query_568677, "OperationId", newJString(OperationId))
  add(query_568677, "Force", newJBool(Force))
  result = call_568676.call(nil, query_568677, nil, nil, nil)

var cancelOperation* = Call_CancelOperation_568668(name: "cancelOperation",
    meth: HttpMethod.HttpPost, host: "azure.local:19080", route: "/Faults/$/Cancel",
    validator: validate_CancelOperation_568669, base: "", url: url_CancelOperation_568670,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetNodeTransitionProgress_568678 = ref object of OpenApiRestCall_567666
proc url_GetNodeTransitionProgress_568680(protocol: Scheme; host: string;
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

proc validate_GetNodeTransitionProgress_568679(path: JsonNode; query: JsonNode;
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
  var valid_568681 = path.getOrDefault("nodeName")
  valid_568681 = validateParameter(valid_568681, JString, required = true,
                                 default = nil)
  if valid_568681 != nil:
    section.add "nodeName", valid_568681
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  section = newJObject()
  var valid_568682 = query.getOrDefault("timeout")
  valid_568682 = validateParameter(valid_568682, JInt, required = false,
                                 default = newJInt(60))
  if valid_568682 != nil:
    section.add "timeout", valid_568682
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568683 = query.getOrDefault("api-version")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568683 != nil:
    section.add "api-version", valid_568683
  var valid_568684 = query.getOrDefault("OperationId")
  valid_568684 = validateParameter(valid_568684, JString, required = true,
                                 default = nil)
  if valid_568684 != nil:
    section.add "OperationId", valid_568684
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568685: Call_GetNodeTransitionProgress_568678; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the progress of an operation started with StartNodeTransition using the provided OperationId.
  ## 
  ## 
  let valid = call_568685.validator(path, query, header, formData, body)
  let scheme = call_568685.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568685.url(scheme.get, call_568685.host, call_568685.base,
                         call_568685.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568685, url, valid)

proc call*(call_568686: Call_GetNodeTransitionProgress_568678; nodeName: string;
          OperationId: string; timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getNodeTransitionProgress
  ## Gets the progress of an operation started with StartNodeTransition using the provided OperationId.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   OperationId: string (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  var path_568687 = newJObject()
  var query_568688 = newJObject()
  add(query_568688, "timeout", newJInt(timeout))
  add(query_568688, "api-version", newJString(apiVersion))
  add(path_568687, "nodeName", newJString(nodeName))
  add(query_568688, "OperationId", newJString(OperationId))
  result = call_568686.call(path_568687, query_568688, nil, nil, nil)

var getNodeTransitionProgress* = Call_GetNodeTransitionProgress_568678(
    name: "getNodeTransitionProgress", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Faults/Nodes/{nodeName}/$/GetTransitionProgress",
    validator: validate_GetNodeTransitionProgress_568679, base: "",
    url: url_GetNodeTransitionProgress_568680,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartNodeTransition_568689 = ref object of OpenApiRestCall_567666
proc url_StartNodeTransition_568691(protocol: Scheme; host: string; base: string;
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

proc validate_StartNodeTransition_568690(path: JsonNode; query: JsonNode;
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
  var valid_568692 = path.getOrDefault("nodeName")
  valid_568692 = validateParameter(valid_568692, JString, required = true,
                                 default = nil)
  if valid_568692 != nil:
    section.add "nodeName", valid_568692
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   NodeInstanceId: JString (required)
  ##                 : The node instance ID of the target node.  This can be determined through GetNodeInfo API.
  ##   StopDurationInSeconds: JInt (required)
  ##                        : The duration, in seconds, to keep the node stopped.  The minimum value is 600, the maximum is 14400.  After this time expires, the node will automatically come back up.
  ##   NodeTransitionType: JString (required)
  ##                     : Indicates the type of transition to perform.  NodeTransitionType.Start will start a stopped node.  NodeTransitionType.Stop will stop a node that is up.
  ##   - Invalid - Reserved.  Do not pass into API.
  ##   - Start - Transition a stopped node to up.
  ##   - Stop - Transition an up node to stopped.
  ## 
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  section = newJObject()
  var valid_568693 = query.getOrDefault("timeout")
  valid_568693 = validateParameter(valid_568693, JInt, required = false,
                                 default = newJInt(60))
  if valid_568693 != nil:
    section.add "timeout", valid_568693
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568694 = query.getOrDefault("api-version")
  valid_568694 = validateParameter(valid_568694, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568694 != nil:
    section.add "api-version", valid_568694
  var valid_568695 = query.getOrDefault("NodeInstanceId")
  valid_568695 = validateParameter(valid_568695, JString, required = true,
                                 default = nil)
  if valid_568695 != nil:
    section.add "NodeInstanceId", valid_568695
  var valid_568696 = query.getOrDefault("StopDurationInSeconds")
  valid_568696 = validateParameter(valid_568696, JInt, required = true, default = nil)
  if valid_568696 != nil:
    section.add "StopDurationInSeconds", valid_568696
  var valid_568697 = query.getOrDefault("NodeTransitionType")
  valid_568697 = validateParameter(valid_568697, JString, required = true,
                                 default = newJString("Invalid"))
  if valid_568697 != nil:
    section.add "NodeTransitionType", valid_568697
  var valid_568698 = query.getOrDefault("OperationId")
  valid_568698 = validateParameter(valid_568698, JString, required = true,
                                 default = nil)
  if valid_568698 != nil:
    section.add "OperationId", valid_568698
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568699: Call_StartNodeTransition_568689; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts or stops a cluster node.  A cluster node is a process, not the OS instance itself.  To start a node, pass in "Start" for the NodeTransitionType parameter.
  ## To stop a node, pass in "Stop" for the NodeTransitionType parameter.  This API starts the operation - when the API returns the node may not have finished transitioning yet.
  ## Call GetNodeTransitionProgress with the same OperationId to get the progress of the operation.
  ## 
  ## 
  let valid = call_568699.validator(path, query, header, formData, body)
  let scheme = call_568699.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568699.url(scheme.get, call_568699.host, call_568699.base,
                         call_568699.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568699, url, valid)

proc call*(call_568700: Call_StartNodeTransition_568689; nodeName: string;
          NodeInstanceId: string; StopDurationInSeconds: int; OperationId: string;
          timeout: int = 60; apiVersion: string = "3.0";
          NodeTransitionType: string = "Invalid"): Recallable =
  ## startNodeTransition
  ## Starts or stops a cluster node.  A cluster node is a process, not the OS instance itself.  To start a node, pass in "Start" for the NodeTransitionType parameter.
  ## To stop a node, pass in "Stop" for the NodeTransitionType parameter.  This API starts the operation - when the API returns the node may not have finished transitioning yet.
  ## Call GetNodeTransitionProgress with the same OperationId to get the progress of the operation.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   NodeInstanceId: string (required)
  ##                 : The node instance ID of the target node.  This can be determined through GetNodeInfo API.
  ##   StopDurationInSeconds: int (required)
  ##                        : The duration, in seconds, to keep the node stopped.  The minimum value is 600, the maximum is 14400.  After this time expires, the node will automatically come back up.
  ##   NodeTransitionType: string (required)
  ##                     : Indicates the type of transition to perform.  NodeTransitionType.Start will start a stopped node.  NodeTransitionType.Stop will stop a node that is up.
  ##   - Invalid - Reserved.  Do not pass into API.
  ##   - Start - Transition a stopped node to up.
  ##   - Stop - Transition an up node to stopped.
  ## 
  ##   OperationId: string (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  var path_568701 = newJObject()
  var query_568702 = newJObject()
  add(query_568702, "timeout", newJInt(timeout))
  add(query_568702, "api-version", newJString(apiVersion))
  add(path_568701, "nodeName", newJString(nodeName))
  add(query_568702, "NodeInstanceId", newJString(NodeInstanceId))
  add(query_568702, "StopDurationInSeconds", newJInt(StopDurationInSeconds))
  add(query_568702, "NodeTransitionType", newJString(NodeTransitionType))
  add(query_568702, "OperationId", newJString(OperationId))
  result = call_568700.call(path_568701, query_568702, nil, nil, nil)

var startNodeTransition* = Call_StartNodeTransition_568689(
    name: "startNodeTransition", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Faults/Nodes/{nodeName}/$/StartTransition/",
    validator: validate_StartNodeTransition_568690, base: "",
    url: url_StartNodeTransition_568691, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDataLossProgress_568703 = ref object of OpenApiRestCall_567666
proc url_GetDataLossProgress_568705(protocol: Scheme; host: string; base: string;
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

proc validate_GetDataLossProgress_568704(path: JsonNode; query: JsonNode;
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
  var valid_568706 = path.getOrDefault("partitionId")
  valid_568706 = validateParameter(valid_568706, JString, required = true,
                                 default = nil)
  if valid_568706 != nil:
    section.add "partitionId", valid_568706
  var valid_568707 = path.getOrDefault("serviceId")
  valid_568707 = validateParameter(valid_568707, JString, required = true,
                                 default = nil)
  if valid_568707 != nil:
    section.add "serviceId", valid_568707
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  section = newJObject()
  var valid_568708 = query.getOrDefault("timeout")
  valid_568708 = validateParameter(valid_568708, JInt, required = false,
                                 default = newJInt(60))
  if valid_568708 != nil:
    section.add "timeout", valid_568708
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568709 = query.getOrDefault("api-version")
  valid_568709 = validateParameter(valid_568709, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568709 != nil:
    section.add "api-version", valid_568709
  var valid_568710 = query.getOrDefault("OperationId")
  valid_568710 = validateParameter(valid_568710, JString, required = true,
                                 default = nil)
  if valid_568710 != nil:
    section.add "OperationId", valid_568710
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568711: Call_GetDataLossProgress_568703; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the progress of a data loss operation started with StartDataLoss, using the OperationId.
  ## 
  ## 
  let valid = call_568711.validator(path, query, header, formData, body)
  let scheme = call_568711.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568711.url(scheme.get, call_568711.host, call_568711.base,
                         call_568711.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568711, url, valid)

proc call*(call_568712: Call_GetDataLossProgress_568703; partitionId: string;
          serviceId: string; OperationId: string; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## getDataLossProgress
  ## Gets the progress of a data loss operation started with StartDataLoss, using the OperationId.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  ##   OperationId: string (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  var path_568713 = newJObject()
  var query_568714 = newJObject()
  add(query_568714, "timeout", newJInt(timeout))
  add(query_568714, "api-version", newJString(apiVersion))
  add(path_568713, "partitionId", newJString(partitionId))
  add(path_568713, "serviceId", newJString(serviceId))
  add(query_568714, "OperationId", newJString(OperationId))
  result = call_568712.call(path_568713, query_568714, nil, nil, nil)

var getDataLossProgress* = Call_GetDataLossProgress_568703(
    name: "getDataLossProgress", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Faults/Services/{serviceId}/$/GetPartitions/{partitionId}/$/GetDataLossProgress",
    validator: validate_GetDataLossProgress_568704, base: "",
    url: url_GetDataLossProgress_568705, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetQuorumLossProgress_568715 = ref object of OpenApiRestCall_567666
proc url_GetQuorumLossProgress_568717(protocol: Scheme; host: string; base: string;
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

proc validate_GetQuorumLossProgress_568716(path: JsonNode; query: JsonNode;
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
  var valid_568718 = path.getOrDefault("partitionId")
  valid_568718 = validateParameter(valid_568718, JString, required = true,
                                 default = nil)
  if valid_568718 != nil:
    section.add "partitionId", valid_568718
  var valid_568719 = path.getOrDefault("serviceId")
  valid_568719 = validateParameter(valid_568719, JString, required = true,
                                 default = nil)
  if valid_568719 != nil:
    section.add "serviceId", valid_568719
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  section = newJObject()
  var valid_568720 = query.getOrDefault("timeout")
  valid_568720 = validateParameter(valid_568720, JInt, required = false,
                                 default = newJInt(60))
  if valid_568720 != nil:
    section.add "timeout", valid_568720
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568721 = query.getOrDefault("api-version")
  valid_568721 = validateParameter(valid_568721, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568721 != nil:
    section.add "api-version", valid_568721
  var valid_568722 = query.getOrDefault("OperationId")
  valid_568722 = validateParameter(valid_568722, JString, required = true,
                                 default = nil)
  if valid_568722 != nil:
    section.add "OperationId", valid_568722
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568723: Call_GetQuorumLossProgress_568715; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the progress of a quorum loss operation started with StartQuorumLoss, using the provided OperationId.
  ## 
  ## 
  let valid = call_568723.validator(path, query, header, formData, body)
  let scheme = call_568723.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568723.url(scheme.get, call_568723.host, call_568723.base,
                         call_568723.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568723, url, valid)

proc call*(call_568724: Call_GetQuorumLossProgress_568715; partitionId: string;
          serviceId: string; OperationId: string; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## getQuorumLossProgress
  ## Gets the progress of a quorum loss operation started with StartQuorumLoss, using the provided OperationId.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  ##   OperationId: string (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  var path_568725 = newJObject()
  var query_568726 = newJObject()
  add(query_568726, "timeout", newJInt(timeout))
  add(query_568726, "api-version", newJString(apiVersion))
  add(path_568725, "partitionId", newJString(partitionId))
  add(path_568725, "serviceId", newJString(serviceId))
  add(query_568726, "OperationId", newJString(OperationId))
  result = call_568724.call(path_568725, query_568726, nil, nil, nil)

var getQuorumLossProgress* = Call_GetQuorumLossProgress_568715(
    name: "getQuorumLossProgress", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Faults/Services/{serviceId}/$/GetPartitions/{partitionId}/$/GetQuorumLossProgress",
    validator: validate_GetQuorumLossProgress_568716, base: "",
    url: url_GetQuorumLossProgress_568717, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetPartitionRestartProgress_568727 = ref object of OpenApiRestCall_567666
proc url_GetPartitionRestartProgress_568729(protocol: Scheme; host: string;
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

proc validate_GetPartitionRestartProgress_568728(path: JsonNode; query: JsonNode;
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
  var valid_568730 = path.getOrDefault("partitionId")
  valid_568730 = validateParameter(valid_568730, JString, required = true,
                                 default = nil)
  if valid_568730 != nil:
    section.add "partitionId", valid_568730
  var valid_568731 = path.getOrDefault("serviceId")
  valid_568731 = validateParameter(valid_568731, JString, required = true,
                                 default = nil)
  if valid_568731 != nil:
    section.add "serviceId", valid_568731
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  section = newJObject()
  var valid_568732 = query.getOrDefault("timeout")
  valid_568732 = validateParameter(valid_568732, JInt, required = false,
                                 default = newJInt(60))
  if valid_568732 != nil:
    section.add "timeout", valid_568732
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568733 = query.getOrDefault("api-version")
  valid_568733 = validateParameter(valid_568733, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568733 != nil:
    section.add "api-version", valid_568733
  var valid_568734 = query.getOrDefault("OperationId")
  valid_568734 = validateParameter(valid_568734, JString, required = true,
                                 default = nil)
  if valid_568734 != nil:
    section.add "OperationId", valid_568734
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568735: Call_GetPartitionRestartProgress_568727; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the progress of a PartitionRestart started with StartPartitionRestart using the provided OperationId.
  ## 
  ## 
  let valid = call_568735.validator(path, query, header, formData, body)
  let scheme = call_568735.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568735.url(scheme.get, call_568735.host, call_568735.base,
                         call_568735.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568735, url, valid)

proc call*(call_568736: Call_GetPartitionRestartProgress_568727;
          partitionId: string; serviceId: string; OperationId: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getPartitionRestartProgress
  ## Gets the progress of a PartitionRestart started with StartPartitionRestart using the provided OperationId.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  ##   OperationId: string (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  var path_568737 = newJObject()
  var query_568738 = newJObject()
  add(query_568738, "timeout", newJInt(timeout))
  add(query_568738, "api-version", newJString(apiVersion))
  add(path_568737, "partitionId", newJString(partitionId))
  add(path_568737, "serviceId", newJString(serviceId))
  add(query_568738, "OperationId", newJString(OperationId))
  result = call_568736.call(path_568737, query_568738, nil, nil, nil)

var getPartitionRestartProgress* = Call_GetPartitionRestartProgress_568727(
    name: "getPartitionRestartProgress", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Faults/Services/{serviceId}/$/GetPartitions/{partitionId}/$/GetRestartProgress",
    validator: validate_GetPartitionRestartProgress_568728, base: "",
    url: url_GetPartitionRestartProgress_568729,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartDataLoss_568739 = ref object of OpenApiRestCall_567666
proc url_StartDataLoss_568741(protocol: Scheme; host: string; base: string;
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

proc validate_StartDataLoss_568740(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568742 = path.getOrDefault("partitionId")
  valid_568742 = validateParameter(valid_568742, JString, required = true,
                                 default = nil)
  if valid_568742 != nil:
    section.add "partitionId", valid_568742
  var valid_568743 = path.getOrDefault("serviceId")
  valid_568743 = validateParameter(valid_568743, JString, required = true,
                                 default = nil)
  if valid_568743 != nil:
    section.add "serviceId", valid_568743
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   DataLossMode: JString (required)
  ##               : This enum is passed to the StartDataLoss API to indicate what type of data loss to induce.
  ## - Invalid - Reserved.  Do not pass into API.
  ## - PartialDataLoss - PartialDataLoss option will cause a quorum of replicas to go down, triggering an OnDataLoss event in the system for the given partition.
  ## - FullDataLoss - FullDataLoss option will drop all the replicas which means that all the data will be lost.
  ## 
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  section = newJObject()
  var valid_568744 = query.getOrDefault("timeout")
  valid_568744 = validateParameter(valid_568744, JInt, required = false,
                                 default = newJInt(60))
  if valid_568744 != nil:
    section.add "timeout", valid_568744
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568745 = query.getOrDefault("api-version")
  valid_568745 = validateParameter(valid_568745, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568745 != nil:
    section.add "api-version", valid_568745
  var valid_568746 = query.getOrDefault("DataLossMode")
  valid_568746 = validateParameter(valid_568746, JString, required = true,
                                 default = newJString("Invalid"))
  if valid_568746 != nil:
    section.add "DataLossMode", valid_568746
  var valid_568747 = query.getOrDefault("OperationId")
  valid_568747 = validateParameter(valid_568747, JString, required = true,
                                 default = nil)
  if valid_568747 != nil:
    section.add "OperationId", valid_568747
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568748: Call_StartDataLoss_568739; path: JsonNode; query: JsonNode;
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
  let valid = call_568748.validator(path, query, header, formData, body)
  let scheme = call_568748.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568748.url(scheme.get, call_568748.host, call_568748.base,
                         call_568748.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568748, url, valid)

proc call*(call_568749: Call_StartDataLoss_568739; partitionId: string;
          serviceId: string; OperationId: string; timeout: int = 60;
          apiVersion: string = "3.0"; DataLossMode: string = "Invalid"): Recallable =
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
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  ##   DataLossMode: string (required)
  ##               : This enum is passed to the StartDataLoss API to indicate what type of data loss to induce.
  ## - Invalid - Reserved.  Do not pass into API.
  ## - PartialDataLoss - PartialDataLoss option will cause a quorum of replicas to go down, triggering an OnDataLoss event in the system for the given partition.
  ## - FullDataLoss - FullDataLoss option will drop all the replicas which means that all the data will be lost.
  ## 
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  ##   OperationId: string (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  var path_568750 = newJObject()
  var query_568751 = newJObject()
  add(query_568751, "timeout", newJInt(timeout))
  add(query_568751, "api-version", newJString(apiVersion))
  add(path_568750, "partitionId", newJString(partitionId))
  add(query_568751, "DataLossMode", newJString(DataLossMode))
  add(path_568750, "serviceId", newJString(serviceId))
  add(query_568751, "OperationId", newJString(OperationId))
  result = call_568749.call(path_568750, query_568751, nil, nil, nil)

var startDataLoss* = Call_StartDataLoss_568739(name: "startDataLoss",
    meth: HttpMethod.HttpPost, host: "azure.local:19080", route: "/Faults/Services/{serviceId}/$/GetPartitions/{partitionId}/$/StartDataLoss",
    validator: validate_StartDataLoss_568740, base: "", url: url_StartDataLoss_568741,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartQuorumLoss_568752 = ref object of OpenApiRestCall_567666
proc url_StartQuorumLoss_568754(protocol: Scheme; host: string; base: string;
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

proc validate_StartQuorumLoss_568753(path: JsonNode; query: JsonNode;
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
  var valid_568755 = path.getOrDefault("partitionId")
  valid_568755 = validateParameter(valid_568755, JString, required = true,
                                 default = nil)
  if valid_568755 != nil:
    section.add "partitionId", valid_568755
  var valid_568756 = path.getOrDefault("serviceId")
  valid_568756 = validateParameter(valid_568756, JString, required = true,
                                 default = nil)
  if valid_568756 != nil:
    section.add "serviceId", valid_568756
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   QuorumLossMode: JString (required)
  ##                 : This enum is passed to the StartQuorumLoss API to indicate what type of quorum loss to induce.
  ##   - Invalid - Reserved.  Do not pass into API.
  ##   - QuorumReplicas - Partial Quorum loss mode : Minimum number of replicas for a partition will be down that will cause a quorum loss.
  ##   - AllReplicas- Full Quorum loss mode : All replicas for a partition will be down that will cause a quorum loss.
  ## 
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   QuorumLossDuration: JInt (required)
  ##                     : The amount of time for which the partition will be kept in quorum loss.  This must be specified in seconds.
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  section = newJObject()
  var valid_568757 = query.getOrDefault("timeout")
  valid_568757 = validateParameter(valid_568757, JInt, required = false,
                                 default = newJInt(60))
  if valid_568757 != nil:
    section.add "timeout", valid_568757
  assert query != nil,
        "query argument is necessary due to required `QuorumLossMode` field"
  var valid_568758 = query.getOrDefault("QuorumLossMode")
  valid_568758 = validateParameter(valid_568758, JString, required = true,
                                 default = newJString("Invalid"))
  if valid_568758 != nil:
    section.add "QuorumLossMode", valid_568758
  var valid_568759 = query.getOrDefault("api-version")
  valid_568759 = validateParameter(valid_568759, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568759 != nil:
    section.add "api-version", valid_568759
  var valid_568760 = query.getOrDefault("QuorumLossDuration")
  valid_568760 = validateParameter(valid_568760, JInt, required = true, default = nil)
  if valid_568760 != nil:
    section.add "QuorumLossDuration", valid_568760
  var valid_568761 = query.getOrDefault("OperationId")
  valid_568761 = validateParameter(valid_568761, JString, required = true,
                                 default = nil)
  if valid_568761 != nil:
    section.add "OperationId", valid_568761
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568762: Call_StartQuorumLoss_568752; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Induces quorum loss for a given stateful service partition.  This API is useful for a temporary quorum loss situation on your service.
  ## 
  ## Call the GetQuorumLossProgress API with the same OperationId to return information on the operation started with this API.
  ## 
  ## This can only be called on stateful persisted (HasPersistedState==true) services.  Do not use this API on stateless services or stateful in-memory only services.
  ## 
  ## 
  let valid = call_568762.validator(path, query, header, formData, body)
  let scheme = call_568762.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568762.url(scheme.get, call_568762.host, call_568762.base,
                         call_568762.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568762, url, valid)

proc call*(call_568763: Call_StartQuorumLoss_568752; partitionId: string;
          QuorumLossDuration: int; serviceId: string; OperationId: string;
          timeout: int = 60; QuorumLossMode: string = "Invalid";
          apiVersion: string = "3.0"): Recallable =
  ## startQuorumLoss
  ## Induces quorum loss for a given stateful service partition.  This API is useful for a temporary quorum loss situation on your service.
  ## 
  ## Call the GetQuorumLossProgress API with the same OperationId to return information on the operation started with this API.
  ## 
  ## This can only be called on stateful persisted (HasPersistedState==true) services.  Do not use this API on stateless services or stateful in-memory only services.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   QuorumLossMode: string (required)
  ##                 : This enum is passed to the StartQuorumLoss API to indicate what type of quorum loss to induce.
  ##   - Invalid - Reserved.  Do not pass into API.
  ##   - QuorumReplicas - Partial Quorum loss mode : Minimum number of replicas for a partition will be down that will cause a quorum loss.
  ##   - AllReplicas- Full Quorum loss mode : All replicas for a partition will be down that will cause a quorum loss.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  ##   QuorumLossDuration: int (required)
  ##                     : The amount of time for which the partition will be kept in quorum loss.  This must be specified in seconds.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  ##   OperationId: string (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  var path_568764 = newJObject()
  var query_568765 = newJObject()
  add(query_568765, "timeout", newJInt(timeout))
  add(query_568765, "QuorumLossMode", newJString(QuorumLossMode))
  add(query_568765, "api-version", newJString(apiVersion))
  add(path_568764, "partitionId", newJString(partitionId))
  add(query_568765, "QuorumLossDuration", newJInt(QuorumLossDuration))
  add(path_568764, "serviceId", newJString(serviceId))
  add(query_568765, "OperationId", newJString(OperationId))
  result = call_568763.call(path_568764, query_568765, nil, nil, nil)

var startQuorumLoss* = Call_StartQuorumLoss_568752(name: "startQuorumLoss",
    meth: HttpMethod.HttpPost, host: "azure.local:19080", route: "/Faults/Services/{serviceId}/$/GetPartitions/{partitionId}/$/StartQuorumLoss",
    validator: validate_StartQuorumLoss_568753, base: "", url: url_StartQuorumLoss_568754,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartPartitionRestart_568766 = ref object of OpenApiRestCall_567666
proc url_StartPartitionRestart_568768(protocol: Scheme; host: string; base: string;
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

proc validate_StartPartitionRestart_568767(path: JsonNode; query: JsonNode;
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
  var valid_568769 = path.getOrDefault("partitionId")
  valid_568769 = validateParameter(valid_568769, JString, required = true,
                                 default = nil)
  if valid_568769 != nil:
    section.add "partitionId", valid_568769
  var valid_568770 = path.getOrDefault("serviceId")
  valid_568770 = validateParameter(valid_568770, JString, required = true,
                                 default = nil)
  if valid_568770 != nil:
    section.add "serviceId", valid_568770
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   RestartPartitionMode: JString (required)
  ##                       : - Invalid - Reserved.  Do not pass into API.
  ## - AllReplicasOrInstances - All replicas or instances in the partition are restarted at once.
  ## - OnlyActiveSecondaries - Only the secondary replicas are restarted.
  ## 
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  section = newJObject()
  var valid_568771 = query.getOrDefault("timeout")
  valid_568771 = validateParameter(valid_568771, JInt, required = false,
                                 default = newJInt(60))
  if valid_568771 != nil:
    section.add "timeout", valid_568771
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568772 = query.getOrDefault("api-version")
  valid_568772 = validateParameter(valid_568772, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568772 != nil:
    section.add "api-version", valid_568772
  var valid_568773 = query.getOrDefault("RestartPartitionMode")
  valid_568773 = validateParameter(valid_568773, JString, required = true,
                                 default = newJString("Invalid"))
  if valid_568773 != nil:
    section.add "RestartPartitionMode", valid_568773
  var valid_568774 = query.getOrDefault("OperationId")
  valid_568774 = validateParameter(valid_568774, JString, required = true,
                                 default = nil)
  if valid_568774 != nil:
    section.add "OperationId", valid_568774
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568775: Call_StartPartitionRestart_568766; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This API is useful for testing failover.
  ## 
  ## If used to target a stateless service partition, RestartPartitionMode must be AllReplicasOrInstances.
  ## 
  ## Call the GetPartitionRestartProgress API using the same OperationId to get the progress.
  ## 
  ## 
  let valid = call_568775.validator(path, query, header, formData, body)
  let scheme = call_568775.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568775.url(scheme.get, call_568775.host, call_568775.base,
                         call_568775.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568775, url, valid)

proc call*(call_568776: Call_StartPartitionRestart_568766; partitionId: string;
          serviceId: string; OperationId: string; timeout: int = 60;
          apiVersion: string = "3.0"; RestartPartitionMode: string = "Invalid"): Recallable =
  ## startPartitionRestart
  ## This API is useful for testing failover.
  ## 
  ## If used to target a stateless service partition, RestartPartitionMode must be AllReplicasOrInstances.
  ## 
  ## Call the GetPartitionRestartProgress API using the same OperationId to get the progress.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   RestartPartitionMode: string (required)
  ##                       : - Invalid - Reserved.  Do not pass into API.
  ## - AllReplicasOrInstances - All replicas or instances in the partition are restarted at once.
  ## - OnlyActiveSecondaries - Only the secondary replicas are restarted.
  ## 
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  ##   OperationId: string (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  var path_568777 = newJObject()
  var query_568778 = newJObject()
  add(query_568778, "timeout", newJInt(timeout))
  add(query_568778, "api-version", newJString(apiVersion))
  add(query_568778, "RestartPartitionMode", newJString(RestartPartitionMode))
  add(path_568777, "partitionId", newJString(partitionId))
  add(path_568777, "serviceId", newJString(serviceId))
  add(query_568778, "OperationId", newJString(OperationId))
  result = call_568776.call(path_568777, query_568778, nil, nil, nil)

var startPartitionRestart* = Call_StartPartitionRestart_568766(
    name: "startPartitionRestart", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Faults/Services/{serviceId}/$/GetPartitions/{partitionId}/$/StartRestart",
    validator: validate_StartPartitionRestart_568767, base: "",
    url: url_StartPartitionRestart_568768, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetImageStoreRootContent_568779 = ref object of OpenApiRestCall_567666
proc url_GetImageStoreRootContent_568781(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetImageStoreRootContent_568780(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the information about the image store content at the root of the image store.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568782 = query.getOrDefault("timeout")
  valid_568782 = validateParameter(valid_568782, JInt, required = false,
                                 default = newJInt(60))
  if valid_568782 != nil:
    section.add "timeout", valid_568782
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568783 = query.getOrDefault("api-version")
  valid_568783 = validateParameter(valid_568783, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568783 != nil:
    section.add "api-version", valid_568783
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568784: Call_GetImageStoreRootContent_568779; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the information about the image store content at the root of the image store.
  ## 
  let valid = call_568784.validator(path, query, header, formData, body)
  let scheme = call_568784.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568784.url(scheme.get, call_568784.host, call_568784.base,
                         call_568784.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568784, url, valid)

proc call*(call_568785: Call_GetImageStoreRootContent_568779; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## getImageStoreRootContent
  ## Returns the information about the image store content at the root of the image store.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  var query_568786 = newJObject()
  add(query_568786, "timeout", newJInt(timeout))
  add(query_568786, "api-version", newJString(apiVersion))
  result = call_568785.call(nil, query_568786, nil, nil, nil)

var getImageStoreRootContent* = Call_GetImageStoreRootContent_568779(
    name: "getImageStoreRootContent", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ImageStore",
    validator: validate_GetImageStoreRootContent_568780, base: "",
    url: url_GetImageStoreRootContent_568781, schemes: {Scheme.Https, Scheme.Http})
type
  Call_CopyImageStoreContent_568787 = ref object of OpenApiRestCall_567666
proc url_CopyImageStoreContent_568789(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CopyImageStoreContent_568788(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Copies the image store content from the source image store relative path to the destination image store relative path.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568790 = query.getOrDefault("timeout")
  valid_568790 = validateParameter(valid_568790, JInt, required = false,
                                 default = newJInt(60))
  if valid_568790 != nil:
    section.add "timeout", valid_568790
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568791 = query.getOrDefault("api-version")
  valid_568791 = validateParameter(valid_568791, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568791 != nil:
    section.add "api-version", valid_568791
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

proc call*(call_568793: Call_CopyImageStoreContent_568787; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies the image store content from the source image store relative path to the destination image store relative path.
  ## 
  let valid = call_568793.validator(path, query, header, formData, body)
  let scheme = call_568793.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568793.url(scheme.get, call_568793.host, call_568793.base,
                         call_568793.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568793, url, valid)

proc call*(call_568794: Call_CopyImageStoreContent_568787;
          ImageStoreCopyDescription: JsonNode; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## copyImageStoreContent
  ## Copies the image store content from the source image store relative path to the destination image store relative path.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ImageStoreCopyDescription: JObject (required)
  ##                            : Describes the copy description for the image store.
  var query_568795 = newJObject()
  var body_568796 = newJObject()
  add(query_568795, "timeout", newJInt(timeout))
  add(query_568795, "api-version", newJString(apiVersion))
  if ImageStoreCopyDescription != nil:
    body_568796 = ImageStoreCopyDescription
  result = call_568794.call(nil, query_568795, nil, nil, body_568796)

var copyImageStoreContent* = Call_CopyImageStoreContent_568787(
    name: "copyImageStoreContent", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/ImageStore/$/Copy",
    validator: validate_CopyImageStoreContent_568788, base: "",
    url: url_CopyImageStoreContent_568789, schemes: {Scheme.Https, Scheme.Http})
type
  Call_UploadFile_568807 = ref object of OpenApiRestCall_567666
proc url_UploadFile_568809(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UploadFile_568808(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568810 = path.getOrDefault("contentPath")
  valid_568810 = validateParameter(valid_568810, JString, required = true,
                                 default = nil)
  if valid_568810 != nil:
    section.add "contentPath", valid_568810
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568811 = query.getOrDefault("timeout")
  valid_568811 = validateParameter(valid_568811, JInt, required = false,
                                 default = newJInt(60))
  if valid_568811 != nil:
    section.add "timeout", valid_568811
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568812 = query.getOrDefault("api-version")
  valid_568812 = validateParameter(valid_568812, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568812 != nil:
    section.add "api-version", valid_568812
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568813: Call_UploadFile_568807; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads contents of the file to the image store. Use this API if the file is small enough to upload again if the connection fails. The file's data needs to be added to the request body. The contents will be uploaded to the specified path.
  ## 
  let valid = call_568813.validator(path, query, header, formData, body)
  let scheme = call_568813.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568813.url(scheme.get, call_568813.host, call_568813.base,
                         call_568813.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568813, url, valid)

proc call*(call_568814: Call_UploadFile_568807; contentPath: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## uploadFile
  ## Uploads contents of the file to the image store. Use this API if the file is small enough to upload again if the connection fails. The file's data needs to be added to the request body. The contents will be uploaded to the specified path.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   contentPath: string (required)
  ##              : Relative path to file or folder in the image store from its root.
  var path_568815 = newJObject()
  var query_568816 = newJObject()
  add(query_568816, "timeout", newJInt(timeout))
  add(query_568816, "api-version", newJString(apiVersion))
  add(path_568815, "contentPath", newJString(contentPath))
  result = call_568814.call(path_568815, query_568816, nil, nil, nil)

var uploadFile* = Call_UploadFile_568807(name: "uploadFile",
                                      meth: HttpMethod.HttpPut,
                                      host: "azure.local:19080",
                                      route: "/ImageStore/{contentPath}",
                                      validator: validate_UploadFile_568808,
                                      base: "", url: url_UploadFile_568809,
                                      schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetImageStoreContent_568797 = ref object of OpenApiRestCall_567666
proc url_GetImageStoreContent_568799(protocol: Scheme; host: string; base: string;
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

proc validate_GetImageStoreContent_568798(path: JsonNode; query: JsonNode;
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
  var valid_568800 = path.getOrDefault("contentPath")
  valid_568800 = validateParameter(valid_568800, JString, required = true,
                                 default = nil)
  if valid_568800 != nil:
    section.add "contentPath", valid_568800
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568801 = query.getOrDefault("timeout")
  valid_568801 = validateParameter(valid_568801, JInt, required = false,
                                 default = newJInt(60))
  if valid_568801 != nil:
    section.add "timeout", valid_568801
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568802 = query.getOrDefault("api-version")
  valid_568802 = validateParameter(valid_568802, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568802 != nil:
    section.add "api-version", valid_568802
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568803: Call_GetImageStoreContent_568797; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the information about the image store content at the specified contentPath relative to the root of the image store.
  ## 
  let valid = call_568803.validator(path, query, header, formData, body)
  let scheme = call_568803.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568803.url(scheme.get, call_568803.host, call_568803.base,
                         call_568803.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568803, url, valid)

proc call*(call_568804: Call_GetImageStoreContent_568797; contentPath: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getImageStoreContent
  ## Returns the information about the image store content at the specified contentPath relative to the root of the image store.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   contentPath: string (required)
  ##              : Relative path to file or folder in the image store from its root.
  var path_568805 = newJObject()
  var query_568806 = newJObject()
  add(query_568806, "timeout", newJInt(timeout))
  add(query_568806, "api-version", newJString(apiVersion))
  add(path_568805, "contentPath", newJString(contentPath))
  result = call_568804.call(path_568805, query_568806, nil, nil, nil)

var getImageStoreContent* = Call_GetImageStoreContent_568797(
    name: "getImageStoreContent", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ImageStore/{contentPath}",
    validator: validate_GetImageStoreContent_568798, base: "",
    url: url_GetImageStoreContent_568799, schemes: {Scheme.Https, Scheme.Http})
type
  Call_DeleteImageStoreContent_568817 = ref object of OpenApiRestCall_567666
proc url_DeleteImageStoreContent_568819(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteImageStoreContent_568818(path: JsonNode; query: JsonNode;
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
  var valid_568820 = path.getOrDefault("contentPath")
  valid_568820 = validateParameter(valid_568820, JString, required = true,
                                 default = nil)
  if valid_568820 != nil:
    section.add "contentPath", valid_568820
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568821 = query.getOrDefault("timeout")
  valid_568821 = validateParameter(valid_568821, JInt, required = false,
                                 default = newJInt(60))
  if valid_568821 != nil:
    section.add "timeout", valid_568821
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568822 = query.getOrDefault("api-version")
  valid_568822 = validateParameter(valid_568822, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568822 != nil:
    section.add "api-version", valid_568822
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568823: Call_DeleteImageStoreContent_568817; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes existing image store content being found within the given image store relative path. This can be used to delete uploaded application packages once they are provisioned.
  ## 
  let valid = call_568823.validator(path, query, header, formData, body)
  let scheme = call_568823.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568823.url(scheme.get, call_568823.host, call_568823.base,
                         call_568823.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568823, url, valid)

proc call*(call_568824: Call_DeleteImageStoreContent_568817; contentPath: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## deleteImageStoreContent
  ## Deletes existing image store content being found within the given image store relative path. This can be used to delete uploaded application packages once they are provisioned.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   contentPath: string (required)
  ##              : Relative path to file or folder in the image store from its root.
  var path_568825 = newJObject()
  var query_568826 = newJObject()
  add(query_568826, "timeout", newJInt(timeout))
  add(query_568826, "api-version", newJString(apiVersion))
  add(path_568825, "contentPath", newJString(contentPath))
  result = call_568824.call(path_568825, query_568826, nil, nil, nil)

var deleteImageStoreContent* = Call_DeleteImageStoreContent_568817(
    name: "deleteImageStoreContent", meth: HttpMethod.HttpDelete,
    host: "azure.local:19080", route: "/ImageStore/{contentPath}",
    validator: validate_DeleteImageStoreContent_568818, base: "",
    url: url_DeleteImageStoreContent_568819, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetNodeInfoList_568827 = ref object of OpenApiRestCall_567666
proc url_GetNodeInfoList_568829(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetNodeInfoList_568828(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## The Nodes endpoint returns information about the nodes in the Service Fabric Cluster. The respons include the name, status, id, health, uptime and other details about the node.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
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
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  section = newJObject()
  var valid_568830 = query.getOrDefault("timeout")
  valid_568830 = validateParameter(valid_568830, JInt, required = false,
                                 default = newJInt(60))
  if valid_568830 != nil:
    section.add "timeout", valid_568830
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568831 = query.getOrDefault("api-version")
  valid_568831 = validateParameter(valid_568831, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568831 != nil:
    section.add "api-version", valid_568831
  var valid_568832 = query.getOrDefault("NodeStatusFilter")
  valid_568832 = validateParameter(valid_568832, JString, required = false,
                                 default = newJString("default"))
  if valid_568832 != nil:
    section.add "NodeStatusFilter", valid_568832
  var valid_568833 = query.getOrDefault("ContinuationToken")
  valid_568833 = validateParameter(valid_568833, JString, required = false,
                                 default = nil)
  if valid_568833 != nil:
    section.add "ContinuationToken", valid_568833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568834: Call_GetNodeInfoList_568827; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Nodes endpoint returns information about the nodes in the Service Fabric Cluster. The respons include the name, status, id, health, uptime and other details about the node.
  ## 
  let valid = call_568834.validator(path, query, header, formData, body)
  let scheme = call_568834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568834.url(scheme.get, call_568834.host, call_568834.base,
                         call_568834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568834, url, valid)

proc call*(call_568835: Call_GetNodeInfoList_568827; timeout: int = 60;
          apiVersion: string = "3.0"; NodeStatusFilter: string = "default";
          ContinuationToken: string = ""): Recallable =
  ## getNodeInfoList
  ## The Nodes endpoint returns information about the nodes in the Service Fabric Cluster. The respons include the name, status, id, health, uptime and other details about the node.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
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
  ##   ContinuationToken: string
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  var query_568836 = newJObject()
  add(query_568836, "timeout", newJInt(timeout))
  add(query_568836, "api-version", newJString(apiVersion))
  add(query_568836, "NodeStatusFilter", newJString(NodeStatusFilter))
  add(query_568836, "ContinuationToken", newJString(ContinuationToken))
  result = call_568835.call(nil, query_568836, nil, nil, nil)

var getNodeInfoList* = Call_GetNodeInfoList_568827(name: "getNodeInfoList",
    meth: HttpMethod.HttpGet, host: "azure.local:19080", route: "/Nodes",
    validator: validate_GetNodeInfoList_568828, base: "", url: url_GetNodeInfoList_568829,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetNodeInfo_568837 = ref object of OpenApiRestCall_567666
proc url_GetNodeInfo_568839(protocol: Scheme; host: string; base: string;
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

proc validate_GetNodeInfo_568838(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568840 = path.getOrDefault("nodeName")
  valid_568840 = validateParameter(valid_568840, JString, required = true,
                                 default = nil)
  if valid_568840 != nil:
    section.add "nodeName", valid_568840
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568841 = query.getOrDefault("timeout")
  valid_568841 = validateParameter(valid_568841, JInt, required = false,
                                 default = newJInt(60))
  if valid_568841 != nil:
    section.add "timeout", valid_568841
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568842 = query.getOrDefault("api-version")
  valid_568842 = validateParameter(valid_568842, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568842 != nil:
    section.add "api-version", valid_568842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568843: Call_GetNodeInfo_568837; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about a specific node in the Service Fabric Cluster.The respons include the name, status, id, health, uptime and other details about the node.
  ## 
  let valid = call_568843.validator(path, query, header, formData, body)
  let scheme = call_568843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568843.url(scheme.get, call_568843.host, call_568843.base,
                         call_568843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568843, url, valid)

proc call*(call_568844: Call_GetNodeInfo_568837; nodeName: string; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## getNodeInfo
  ## Gets the information about a specific node in the Service Fabric Cluster.The respons include the name, status, id, health, uptime and other details about the node.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_568845 = newJObject()
  var query_568846 = newJObject()
  add(query_568846, "timeout", newJInt(timeout))
  add(query_568846, "api-version", newJString(apiVersion))
  add(path_568845, "nodeName", newJString(nodeName))
  result = call_568844.call(path_568845, query_568846, nil, nil, nil)

var getNodeInfo* = Call_GetNodeInfo_568837(name: "getNodeInfo",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local:19080",
                                        route: "/Nodes/{nodeName}",
                                        validator: validate_GetNodeInfo_568838,
                                        base: "", url: url_GetNodeInfo_568839,
                                        schemes: {Scheme.Https, Scheme.Http})
type
  Call_EnableNode_568847 = ref object of OpenApiRestCall_567666
proc url_EnableNode_568849(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_EnableNode_568848(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568850 = path.getOrDefault("nodeName")
  valid_568850 = validateParameter(valid_568850, JString, required = true,
                                 default = nil)
  if valid_568850 != nil:
    section.add "nodeName", valid_568850
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568851 = query.getOrDefault("timeout")
  valid_568851 = validateParameter(valid_568851, JInt, required = false,
                                 default = newJInt(60))
  if valid_568851 != nil:
    section.add "timeout", valid_568851
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568852 = query.getOrDefault("api-version")
  valid_568852 = validateParameter(valid_568852, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568852 != nil:
    section.add "api-version", valid_568852
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568853: Call_EnableNode_568847; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activates a Service Fabric cluster node which is currently deactivated. Once activated, the node will again become a viable target for placing new replicas, and any deactivated replicas remaining on the node will be reactivated.
  ## 
  let valid = call_568853.validator(path, query, header, formData, body)
  let scheme = call_568853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568853.url(scheme.get, call_568853.host, call_568853.base,
                         call_568853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568853, url, valid)

proc call*(call_568854: Call_EnableNode_568847; nodeName: string; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## enableNode
  ## Activates a Service Fabric cluster node which is currently deactivated. Once activated, the node will again become a viable target for placing new replicas, and any deactivated replicas remaining on the node will be reactivated.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_568855 = newJObject()
  var query_568856 = newJObject()
  add(query_568856, "timeout", newJInt(timeout))
  add(query_568856, "api-version", newJString(apiVersion))
  add(path_568855, "nodeName", newJString(nodeName))
  result = call_568854.call(path_568855, query_568856, nil, nil, nil)

var enableNode* = Call_EnableNode_568847(name: "enableNode",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local:19080",
                                      route: "/Nodes/{nodeName}/$/Activate",
                                      validator: validate_EnableNode_568848,
                                      base: "", url: url_EnableNode_568849,
                                      schemes: {Scheme.Https, Scheme.Http})
type
  Call_DisableNode_568857 = ref object of OpenApiRestCall_567666
proc url_DisableNode_568859(protocol: Scheme; host: string; base: string;
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

proc validate_DisableNode_568858(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_568860 = path.getOrDefault("nodeName")
  valid_568860 = validateParameter(valid_568860, JString, required = true,
                                 default = nil)
  if valid_568860 != nil:
    section.add "nodeName", valid_568860
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568861 = query.getOrDefault("timeout")
  valid_568861 = validateParameter(valid_568861, JInt, required = false,
                                 default = newJInt(60))
  if valid_568861 != nil:
    section.add "timeout", valid_568861
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568862 = query.getOrDefault("api-version")
  valid_568862 = validateParameter(valid_568862, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568862 != nil:
    section.add "api-version", valid_568862
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

proc call*(call_568864: Call_DisableNode_568857; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deactivate a Service Fabric cluster node with the specified deactivation intent. Once the deactivation is in progress, the deactivation intent can be increased, but not decreased (for example, a node which is was deactivated with the Pause intent can be deactivated further with Restart, but not the other way around. Nodes may be reactivated using the Activate a node operation any time after they are deactivated. If the deactivation is not complete this will cancel the deactivation. A node which goes down and comes back up while deactivated will still need to be reactivated before services will be placed on that node.
  ## 
  let valid = call_568864.validator(path, query, header, formData, body)
  let scheme = call_568864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568864.url(scheme.get, call_568864.host, call_568864.base,
                         call_568864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568864, url, valid)

proc call*(call_568865: Call_DisableNode_568857; nodeName: string;
          DeactivationIntentDescription: JsonNode; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## disableNode
  ## Deactivate a Service Fabric cluster node with the specified deactivation intent. Once the deactivation is in progress, the deactivation intent can be increased, but not decreased (for example, a node which is was deactivated with the Pause intent can be deactivated further with Restart, but not the other way around. Nodes may be reactivated using the Activate a node operation any time after they are deactivated. If the deactivation is not complete this will cancel the deactivation. A node which goes down and comes back up while deactivated will still need to be reactivated before services will be placed on that node.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   DeactivationIntentDescription: JObject (required)
  ##                                : Describes the intent or reason for deactivating the node.
  var path_568866 = newJObject()
  var query_568867 = newJObject()
  var body_568868 = newJObject()
  add(query_568867, "timeout", newJInt(timeout))
  add(query_568867, "api-version", newJString(apiVersion))
  add(path_568866, "nodeName", newJString(nodeName))
  if DeactivationIntentDescription != nil:
    body_568868 = DeactivationIntentDescription
  result = call_568865.call(path_568866, query_568867, nil, nil, body_568868)

var disableNode* = Call_DisableNode_568857(name: "disableNode",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local:19080", route: "/Nodes/{nodeName}/$/Deactivate",
                                        validator: validate_DisableNode_568858,
                                        base: "", url: url_DisableNode_568859,
                                        schemes: {Scheme.Https, Scheme.Http})
type
  Call_DeployedServicePackageToNode_568869 = ref object of OpenApiRestCall_567666
proc url_DeployedServicePackageToNode_568871(protocol: Scheme; host: string;
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

proc validate_DeployedServicePackageToNode_568870(path: JsonNode; query: JsonNode;
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
  var valid_568872 = path.getOrDefault("nodeName")
  valid_568872 = validateParameter(valid_568872, JString, required = true,
                                 default = nil)
  if valid_568872 != nil:
    section.add "nodeName", valid_568872
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568873 = query.getOrDefault("timeout")
  valid_568873 = validateParameter(valid_568873, JInt, required = false,
                                 default = newJInt(60))
  if valid_568873 != nil:
    section.add "timeout", valid_568873
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568874 = query.getOrDefault("api-version")
  valid_568874 = validateParameter(valid_568874, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568874 != nil:
    section.add "api-version", valid_568874
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

proc call*(call_568876: Call_DeployedServicePackageToNode_568869; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Downloads packages associated with specified service manifest to image cache on specified node.
  ## 
  ## 
  let valid = call_568876.validator(path, query, header, formData, body)
  let scheme = call_568876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568876.url(scheme.get, call_568876.host, call_568876.base,
                         call_568876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568876, url, valid)

proc call*(call_568877: Call_DeployedServicePackageToNode_568869; nodeName: string;
          DeployServicePackageToNodeDescription: JsonNode; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## deployedServicePackageToNode
  ## Downloads packages associated with specified service manifest to image cache on specified node.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   DeployServicePackageToNodeDescription: JObject (required)
  ##                                        : Describes information for deploying a service package to a Service Fabric node.
  var path_568878 = newJObject()
  var query_568879 = newJObject()
  var body_568880 = newJObject()
  add(query_568879, "timeout", newJInt(timeout))
  add(query_568879, "api-version", newJString(apiVersion))
  add(path_568878, "nodeName", newJString(nodeName))
  if DeployServicePackageToNodeDescription != nil:
    body_568880 = DeployServicePackageToNodeDescription
  result = call_568877.call(path_568878, query_568879, nil, nil, body_568880)

var deployedServicePackageToNode* = Call_DeployedServicePackageToNode_568869(
    name: "deployedServicePackageToNode", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/DeployServicePackage",
    validator: validate_DeployedServicePackageToNode_568870, base: "",
    url: url_DeployedServicePackageToNode_568871,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedApplicationInfoList_568881 = ref object of OpenApiRestCall_567666
proc url_GetDeployedApplicationInfoList_568883(protocol: Scheme; host: string;
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

proc validate_GetDeployedApplicationInfoList_568882(path: JsonNode;
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
  var valid_568884 = path.getOrDefault("nodeName")
  valid_568884 = validateParameter(valid_568884, JString, required = true,
                                 default = nil)
  if valid_568884 != nil:
    section.add "nodeName", valid_568884
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568885 = query.getOrDefault("timeout")
  valid_568885 = validateParameter(valid_568885, JInt, required = false,
                                 default = newJInt(60))
  if valid_568885 != nil:
    section.add "timeout", valid_568885
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568886 = query.getOrDefault("api-version")
  valid_568886 = validateParameter(valid_568886, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568886 != nil:
    section.add "api-version", valid_568886
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568887: Call_GetDeployedApplicationInfoList_568881; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of applications deployed on a Service Fabric node.
  ## 
  let valid = call_568887.validator(path, query, header, formData, body)
  let scheme = call_568887.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568887.url(scheme.get, call_568887.host, call_568887.base,
                         call_568887.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568887, url, valid)

proc call*(call_568888: Call_GetDeployedApplicationInfoList_568881;
          nodeName: string; timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getDeployedApplicationInfoList
  ## Gets the list of applications deployed on a Service Fabric node.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_568889 = newJObject()
  var query_568890 = newJObject()
  add(query_568890, "timeout", newJInt(timeout))
  add(query_568890, "api-version", newJString(apiVersion))
  add(path_568889, "nodeName", newJString(nodeName))
  result = call_568888.call(path_568889, query_568890, nil, nil, nil)

var getDeployedApplicationInfoList* = Call_GetDeployedApplicationInfoList_568881(
    name: "getDeployedApplicationInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications",
    validator: validate_GetDeployedApplicationInfoList_568882, base: "",
    url: url_GetDeployedApplicationInfoList_568883,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedApplicationInfo_568891 = ref object of OpenApiRestCall_567666
proc url_GetDeployedApplicationInfo_568893(protocol: Scheme; host: string;
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

proc validate_GetDeployedApplicationInfo_568892(path: JsonNode; query: JsonNode;
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
  var valid_568894 = path.getOrDefault("nodeName")
  valid_568894 = validateParameter(valid_568894, JString, required = true,
                                 default = nil)
  if valid_568894 != nil:
    section.add "nodeName", valid_568894
  var valid_568895 = path.getOrDefault("applicationId")
  valid_568895 = validateParameter(valid_568895, JString, required = true,
                                 default = nil)
  if valid_568895 != nil:
    section.add "applicationId", valid_568895
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568896 = query.getOrDefault("timeout")
  valid_568896 = validateParameter(valid_568896, JInt, required = false,
                                 default = newJInt(60))
  if valid_568896 != nil:
    section.add "timeout", valid_568896
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568897 = query.getOrDefault("api-version")
  valid_568897 = validateParameter(valid_568897, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568897 != nil:
    section.add "api-version", valid_568897
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568898: Call_GetDeployedApplicationInfo_568891; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about an application deployed on a Service Fabric node.
  ## 
  let valid = call_568898.validator(path, query, header, formData, body)
  let scheme = call_568898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568898.url(scheme.get, call_568898.host, call_568898.base,
                         call_568898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568898, url, valid)

proc call*(call_568899: Call_GetDeployedApplicationInfo_568891; nodeName: string;
          applicationId: string; timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getDeployedApplicationInfo
  ## Gets the information about an application deployed on a Service Fabric node.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_568900 = newJObject()
  var query_568901 = newJObject()
  add(query_568901, "timeout", newJInt(timeout))
  add(query_568901, "api-version", newJString(apiVersion))
  add(path_568900, "nodeName", newJString(nodeName))
  add(path_568900, "applicationId", newJString(applicationId))
  result = call_568899.call(path_568900, query_568901, nil, nil, nil)

var getDeployedApplicationInfo* = Call_GetDeployedApplicationInfo_568891(
    name: "getDeployedApplicationInfo", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}",
    validator: validate_GetDeployedApplicationInfo_568892, base: "",
    url: url_GetDeployedApplicationInfo_568893,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedCodePackageInfoList_568902 = ref object of OpenApiRestCall_567666
proc url_GetDeployedCodePackageInfoList_568904(protocol: Scheme; host: string;
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

proc validate_GetDeployedCodePackageInfoList_568903(path: JsonNode;
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
  var valid_568905 = path.getOrDefault("nodeName")
  valid_568905 = validateParameter(valid_568905, JString, required = true,
                                 default = nil)
  if valid_568905 != nil:
    section.add "nodeName", valid_568905
  var valid_568906 = path.getOrDefault("applicationId")
  valid_568906 = validateParameter(valid_568906, JString, required = true,
                                 default = nil)
  if valid_568906 != nil:
    section.add "applicationId", valid_568906
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ServiceManifestName: JString
  ##                      : The name of a service manifest registered as part of an application type in a Service Fabric cluster.
  ##   CodePackageName: JString
  ##                  : The name of code package specified in service manifest registered as part of an application type in a Service Fabric cluster.
  section = newJObject()
  var valid_568907 = query.getOrDefault("timeout")
  valid_568907 = validateParameter(valid_568907, JInt, required = false,
                                 default = newJInt(60))
  if valid_568907 != nil:
    section.add "timeout", valid_568907
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568908 = query.getOrDefault("api-version")
  valid_568908 = validateParameter(valid_568908, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568908 != nil:
    section.add "api-version", valid_568908
  var valid_568909 = query.getOrDefault("ServiceManifestName")
  valid_568909 = validateParameter(valid_568909, JString, required = false,
                                 default = nil)
  if valid_568909 != nil:
    section.add "ServiceManifestName", valid_568909
  var valid_568910 = query.getOrDefault("CodePackageName")
  valid_568910 = validateParameter(valid_568910, JString, required = false,
                                 default = nil)
  if valid_568910 != nil:
    section.add "CodePackageName", valid_568910
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568911: Call_GetDeployedCodePackageInfoList_568902; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of code packages deployed on a Service Fabric node for the given application.
  ## 
  let valid = call_568911.validator(path, query, header, formData, body)
  let scheme = call_568911.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568911.url(scheme.get, call_568911.host, call_568911.base,
                         call_568911.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568911, url, valid)

proc call*(call_568912: Call_GetDeployedCodePackageInfoList_568902;
          nodeName: string; applicationId: string; timeout: int = 60;
          apiVersion: string = "3.0"; ServiceManifestName: string = "";
          CodePackageName: string = ""): Recallable =
  ## getDeployedCodePackageInfoList
  ## Gets the list of code packages deployed on a Service Fabric node for the given application.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   ServiceManifestName: string
  ##                      : The name of a service manifest registered as part of an application type in a Service Fabric cluster.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  ##   CodePackageName: string
  ##                  : The name of code package specified in service manifest registered as part of an application type in a Service Fabric cluster.
  var path_568913 = newJObject()
  var query_568914 = newJObject()
  add(query_568914, "timeout", newJInt(timeout))
  add(query_568914, "api-version", newJString(apiVersion))
  add(path_568913, "nodeName", newJString(nodeName))
  add(query_568914, "ServiceManifestName", newJString(ServiceManifestName))
  add(path_568913, "applicationId", newJString(applicationId))
  add(query_568914, "CodePackageName", newJString(CodePackageName))
  result = call_568912.call(path_568913, query_568914, nil, nil, nil)

var getDeployedCodePackageInfoList* = Call_GetDeployedCodePackageInfoList_568902(
    name: "getDeployedCodePackageInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetCodePackages",
    validator: validate_GetDeployedCodePackageInfoList_568903, base: "",
    url: url_GetDeployedCodePackageInfoList_568904,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_RestartDeployedCodePackage_568915 = ref object of OpenApiRestCall_567666
proc url_RestartDeployedCodePackage_568917(protocol: Scheme; host: string;
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

proc validate_RestartDeployedCodePackage_568916(path: JsonNode; query: JsonNode;
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
  var valid_568918 = path.getOrDefault("nodeName")
  valid_568918 = validateParameter(valid_568918, JString, required = true,
                                 default = nil)
  if valid_568918 != nil:
    section.add "nodeName", valid_568918
  var valid_568919 = path.getOrDefault("applicationId")
  valid_568919 = validateParameter(valid_568919, JString, required = true,
                                 default = nil)
  if valid_568919 != nil:
    section.add "applicationId", valid_568919
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568920 = query.getOrDefault("timeout")
  valid_568920 = validateParameter(valid_568920, JInt, required = false,
                                 default = newJInt(60))
  if valid_568920 != nil:
    section.add "timeout", valid_568920
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568921 = query.getOrDefault("api-version")
  valid_568921 = validateParameter(valid_568921, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568921 != nil:
    section.add "api-version", valid_568921
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

proc call*(call_568923: Call_RestartDeployedCodePackage_568915; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a code package deployed on a Service Fabric node in a cluster. This aborts the code package process, which will restart all the user service replicas hosted in that process.
  ## 
  let valid = call_568923.validator(path, query, header, formData, body)
  let scheme = call_568923.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568923.url(scheme.get, call_568923.host, call_568923.base,
                         call_568923.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568923, url, valid)

proc call*(call_568924: Call_RestartDeployedCodePackage_568915; nodeName: string;
          applicationId: string; RestartDeployedCodePackageDescription: JsonNode;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## restartDeployedCodePackage
  ## Restarts a code package deployed on a Service Fabric node in a cluster. This aborts the code package process, which will restart all the user service replicas hosted in that process.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  ##   RestartDeployedCodePackageDescription: JObject (required)
  ##                                        : Describes the deployed code package on Service Fabric node to restart.
  var path_568925 = newJObject()
  var query_568926 = newJObject()
  var body_568927 = newJObject()
  add(query_568926, "timeout", newJInt(timeout))
  add(query_568926, "api-version", newJString(apiVersion))
  add(path_568925, "nodeName", newJString(nodeName))
  add(path_568925, "applicationId", newJString(applicationId))
  if RestartDeployedCodePackageDescription != nil:
    body_568927 = RestartDeployedCodePackageDescription
  result = call_568924.call(path_568925, query_568926, nil, nil, body_568927)

var restartDeployedCodePackage* = Call_RestartDeployedCodePackage_568915(
    name: "restartDeployedCodePackage", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetCodePackages/$/Restart",
    validator: validate_RestartDeployedCodePackage_568916, base: "",
    url: url_RestartDeployedCodePackage_568917,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedApplicationHealthUsingPolicy_568941 = ref object of OpenApiRestCall_567666
proc url_GetDeployedApplicationHealthUsingPolicy_568943(protocol: Scheme;
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

proc validate_GetDeployedApplicationHealthUsingPolicy_568942(path: JsonNode;
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
  var valid_568944 = path.getOrDefault("nodeName")
  valid_568944 = validateParameter(valid_568944, JString, required = true,
                                 default = nil)
  if valid_568944 != nil:
    section.add "nodeName", valid_568944
  var valid_568945 = path.getOrDefault("applicationId")
  valid_568945 = validateParameter(valid_568945, JString, required = true,
                                 default = nil)
  if valid_568945 != nil:
    section.add "applicationId", valid_568945
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
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
  var valid_568946 = query.getOrDefault("timeout")
  valid_568946 = validateParameter(valid_568946, JInt, required = false,
                                 default = newJInt(60))
  if valid_568946 != nil:
    section.add "timeout", valid_568946
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568947 = query.getOrDefault("api-version")
  valid_568947 = validateParameter(valid_568947, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568947 != nil:
    section.add "api-version", valid_568947
  var valid_568948 = query.getOrDefault("DeployedServicePackagesHealthStateFilter")
  valid_568948 = validateParameter(valid_568948, JInt, required = false,
                                 default = newJInt(0))
  if valid_568948 != nil:
    section.add "DeployedServicePackagesHealthStateFilter", valid_568948
  var valid_568949 = query.getOrDefault("EventsHealthStateFilter")
  valid_568949 = validateParameter(valid_568949, JInt, required = false,
                                 default = newJInt(0))
  if valid_568949 != nil:
    section.add "EventsHealthStateFilter", valid_568949
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

proc call*(call_568951: Call_GetDeployedApplicationHealthUsingPolicy_568941;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the information about health of an application deployed on a Service Fabric node using the specified policy. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed application based on health state. Use DeployedServicePackagesHealthStateFilter to optionally filter for DeployedServicePackageHealth children based on health state. Use ApplicationHealthPolicy to optionally override the health policies used to evaluate the health. This API only uses 'ConsiderWarningAsError' field of the ApplicationHealthPolicy. The rest of the fields are ignored while evaluating the health of the deployed application.
  ## 
  ## 
  let valid = call_568951.validator(path, query, header, formData, body)
  let scheme = call_568951.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568951.url(scheme.get, call_568951.host, call_568951.base,
                         call_568951.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568951, url, valid)

proc call*(call_568952: Call_GetDeployedApplicationHealthUsingPolicy_568941;
          nodeName: string; applicationId: string; timeout: int = 60;
          apiVersion: string = "3.0"; ApplicationHealthPolicy: JsonNode = nil;
          DeployedServicePackagesHealthStateFilter: int = 0;
          EventsHealthStateFilter: int = 0): Recallable =
  ## getDeployedApplicationHealthUsingPolicy
  ## Gets the information about health of an application deployed on a Service Fabric node using the specified policy. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed application based on health state. Use DeployedServicePackagesHealthStateFilter to optionally filter for DeployedServicePackageHealth children based on health state. Use ApplicationHealthPolicy to optionally override the health policies used to evaluate the health. This API only uses 'ConsiderWarningAsError' field of the ApplicationHealthPolicy. The rest of the fields are ignored while evaluating the health of the deployed application.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   ApplicationHealthPolicy: JObject
  ##                          : Describes the health policies used to evaluate the health of an application or one of its children.
  ## If not present, the health evaluation uses the health policy from application manifest or the default health policy.
  ## 
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
  var path_568953 = newJObject()
  var query_568954 = newJObject()
  var body_568955 = newJObject()
  add(query_568954, "timeout", newJInt(timeout))
  add(query_568954, "api-version", newJString(apiVersion))
  add(path_568953, "nodeName", newJString(nodeName))
  if ApplicationHealthPolicy != nil:
    body_568955 = ApplicationHealthPolicy
  add(query_568954, "DeployedServicePackagesHealthStateFilter",
      newJInt(DeployedServicePackagesHealthStateFilter))
  add(query_568954, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_568953, "applicationId", newJString(applicationId))
  result = call_568952.call(path_568953, query_568954, nil, nil, body_568955)

var getDeployedApplicationHealthUsingPolicy* = Call_GetDeployedApplicationHealthUsingPolicy_568941(
    name: "getDeployedApplicationHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetHealth",
    validator: validate_GetDeployedApplicationHealthUsingPolicy_568942, base: "",
    url: url_GetDeployedApplicationHealthUsingPolicy_568943,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedApplicationHealth_568928 = ref object of OpenApiRestCall_567666
proc url_GetDeployedApplicationHealth_568930(protocol: Scheme; host: string;
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

proc validate_GetDeployedApplicationHealth_568929(path: JsonNode; query: JsonNode;
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
  var valid_568931 = path.getOrDefault("nodeName")
  valid_568931 = validateParameter(valid_568931, JString, required = true,
                                 default = nil)
  if valid_568931 != nil:
    section.add "nodeName", valid_568931
  var valid_568932 = path.getOrDefault("applicationId")
  valid_568932 = validateParameter(valid_568932, JString, required = true,
                                 default = nil)
  if valid_568932 != nil:
    section.add "applicationId", valid_568932
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
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
  var valid_568933 = query.getOrDefault("timeout")
  valid_568933 = validateParameter(valid_568933, JInt, required = false,
                                 default = newJInt(60))
  if valid_568933 != nil:
    section.add "timeout", valid_568933
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568934 = query.getOrDefault("api-version")
  valid_568934 = validateParameter(valid_568934, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568934 != nil:
    section.add "api-version", valid_568934
  var valid_568935 = query.getOrDefault("DeployedServicePackagesHealthStateFilter")
  valid_568935 = validateParameter(valid_568935, JInt, required = false,
                                 default = newJInt(0))
  if valid_568935 != nil:
    section.add "DeployedServicePackagesHealthStateFilter", valid_568935
  var valid_568936 = query.getOrDefault("EventsHealthStateFilter")
  valid_568936 = validateParameter(valid_568936, JInt, required = false,
                                 default = newJInt(0))
  if valid_568936 != nil:
    section.add "EventsHealthStateFilter", valid_568936
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568937: Call_GetDeployedApplicationHealth_568928; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about health of an application deployed on a Service Fabric node. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed application based on health state. Use DeployedServicePackagesHealthStateFilter to optionally filter for DeployedServicePackageHealth children based on health state.
  ## 
  let valid = call_568937.validator(path, query, header, formData, body)
  let scheme = call_568937.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568937.url(scheme.get, call_568937.host, call_568937.base,
                         call_568937.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568937, url, valid)

proc call*(call_568938: Call_GetDeployedApplicationHealth_568928; nodeName: string;
          applicationId: string; timeout: int = 60; apiVersion: string = "3.0";
          DeployedServicePackagesHealthStateFilter: int = 0;
          EventsHealthStateFilter: int = 0): Recallable =
  ## getDeployedApplicationHealth
  ## Gets the information about health of an application deployed on a Service Fabric node. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed application based on health state. Use DeployedServicePackagesHealthStateFilter to optionally filter for DeployedServicePackageHealth children based on health state.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
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
  var path_568939 = newJObject()
  var query_568940 = newJObject()
  add(query_568940, "timeout", newJInt(timeout))
  add(query_568940, "api-version", newJString(apiVersion))
  add(path_568939, "nodeName", newJString(nodeName))
  add(query_568940, "DeployedServicePackagesHealthStateFilter",
      newJInt(DeployedServicePackagesHealthStateFilter))
  add(query_568940, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_568939, "applicationId", newJString(applicationId))
  result = call_568938.call(path_568939, query_568940, nil, nil, nil)

var getDeployedApplicationHealth* = Call_GetDeployedApplicationHealth_568928(
    name: "getDeployedApplicationHealth", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetHealth",
    validator: validate_GetDeployedApplicationHealth_568929, base: "",
    url: url_GetDeployedApplicationHealth_568930,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServiceReplicaInfoList_568956 = ref object of OpenApiRestCall_567666
proc url_GetDeployedServiceReplicaInfoList_568958(protocol: Scheme; host: string;
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

proc validate_GetDeployedServiceReplicaInfoList_568957(path: JsonNode;
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
  var valid_568959 = path.getOrDefault("nodeName")
  valid_568959 = validateParameter(valid_568959, JString, required = true,
                                 default = nil)
  if valid_568959 != nil:
    section.add "nodeName", valid_568959
  var valid_568960 = path.getOrDefault("applicationId")
  valid_568960 = validateParameter(valid_568960, JString, required = true,
                                 default = nil)
  if valid_568960 != nil:
    section.add "applicationId", valid_568960
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ServiceManifestName: JString
  ##                      : The name of a service manifest registered as part of an application type in a Service Fabric cluster.
  ##   PartitionId: JString
  ##              : The identity of the partition.
  section = newJObject()
  var valid_568961 = query.getOrDefault("timeout")
  valid_568961 = validateParameter(valid_568961, JInt, required = false,
                                 default = newJInt(60))
  if valid_568961 != nil:
    section.add "timeout", valid_568961
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568962 = query.getOrDefault("api-version")
  valid_568962 = validateParameter(valid_568962, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568962 != nil:
    section.add "api-version", valid_568962
  var valid_568963 = query.getOrDefault("ServiceManifestName")
  valid_568963 = validateParameter(valid_568963, JString, required = false,
                                 default = nil)
  if valid_568963 != nil:
    section.add "ServiceManifestName", valid_568963
  var valid_568964 = query.getOrDefault("PartitionId")
  valid_568964 = validateParameter(valid_568964, JString, required = false,
                                 default = nil)
  if valid_568964 != nil:
    section.add "PartitionId", valid_568964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568965: Call_GetDeployedServiceReplicaInfoList_568956;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list containing the information about replicas deployed on a Service Fabric node. The information include partition id, replica id, status of the replica, name of the service, name of the service type and other information. Use PartitionId or ServiceManifestName query parameters to return information about the deployed replicas matching the specified values for those parameters.
  ## 
  let valid = call_568965.validator(path, query, header, formData, body)
  let scheme = call_568965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568965.url(scheme.get, call_568965.host, call_568965.base,
                         call_568965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568965, url, valid)

proc call*(call_568966: Call_GetDeployedServiceReplicaInfoList_568956;
          nodeName: string; applicationId: string; timeout: int = 60;
          apiVersion: string = "3.0"; ServiceManifestName: string = "";
          PartitionId: string = ""): Recallable =
  ## getDeployedServiceReplicaInfoList
  ## Gets the list containing the information about replicas deployed on a Service Fabric node. The information include partition id, replica id, status of the replica, name of the service, name of the service type and other information. Use PartitionId or ServiceManifestName query parameters to return information about the deployed replicas matching the specified values for those parameters.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   ServiceManifestName: string
  ##                      : The name of a service manifest registered as part of an application type in a Service Fabric cluster.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  ##   PartitionId: string
  ##              : The identity of the partition.
  var path_568967 = newJObject()
  var query_568968 = newJObject()
  add(query_568968, "timeout", newJInt(timeout))
  add(query_568968, "api-version", newJString(apiVersion))
  add(path_568967, "nodeName", newJString(nodeName))
  add(query_568968, "ServiceManifestName", newJString(ServiceManifestName))
  add(path_568967, "applicationId", newJString(applicationId))
  add(query_568968, "PartitionId", newJString(PartitionId))
  result = call_568966.call(path_568967, query_568968, nil, nil, nil)

var getDeployedServiceReplicaInfoList* = Call_GetDeployedServiceReplicaInfoList_568956(
    name: "getDeployedServiceReplicaInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetReplicas",
    validator: validate_GetDeployedServiceReplicaInfoList_568957, base: "",
    url: url_GetDeployedServiceReplicaInfoList_568958,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServicePackageInfoList_568969 = ref object of OpenApiRestCall_567666
proc url_GetDeployedServicePackageInfoList_568971(protocol: Scheme; host: string;
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

proc validate_GetDeployedServicePackageInfoList_568970(path: JsonNode;
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
  var valid_568972 = path.getOrDefault("nodeName")
  valid_568972 = validateParameter(valid_568972, JString, required = true,
                                 default = nil)
  if valid_568972 != nil:
    section.add "nodeName", valid_568972
  var valid_568973 = path.getOrDefault("applicationId")
  valid_568973 = validateParameter(valid_568973, JString, required = true,
                                 default = nil)
  if valid_568973 != nil:
    section.add "applicationId", valid_568973
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568974 = query.getOrDefault("timeout")
  valid_568974 = validateParameter(valid_568974, JInt, required = false,
                                 default = newJInt(60))
  if valid_568974 != nil:
    section.add "timeout", valid_568974
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568975 = query.getOrDefault("api-version")
  valid_568975 = validateParameter(valid_568975, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568975 != nil:
    section.add "api-version", valid_568975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568976: Call_GetDeployedServicePackageInfoList_568969;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the information about the service packages deployed on a Service Fabric node for the given application.
  ## 
  let valid = call_568976.validator(path, query, header, formData, body)
  let scheme = call_568976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568976.url(scheme.get, call_568976.host, call_568976.base,
                         call_568976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568976, url, valid)

proc call*(call_568977: Call_GetDeployedServicePackageInfoList_568969;
          nodeName: string; applicationId: string; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## getDeployedServicePackageInfoList
  ## Returns the information about the service packages deployed on a Service Fabric node for the given application.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_568978 = newJObject()
  var query_568979 = newJObject()
  add(query_568979, "timeout", newJInt(timeout))
  add(query_568979, "api-version", newJString(apiVersion))
  add(path_568978, "nodeName", newJString(nodeName))
  add(path_568978, "applicationId", newJString(applicationId))
  result = call_568977.call(path_568978, query_568979, nil, nil, nil)

var getDeployedServicePackageInfoList* = Call_GetDeployedServicePackageInfoList_568969(
    name: "getDeployedServicePackageInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServicePackages",
    validator: validate_GetDeployedServicePackageInfoList_568970, base: "",
    url: url_GetDeployedServicePackageInfoList_568971,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServicePackageInfoListByName_568980 = ref object of OpenApiRestCall_567666
proc url_GetDeployedServicePackageInfoListByName_568982(protocol: Scheme;
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

proc validate_GetDeployedServicePackageInfoListByName_568981(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the information about the service packages deployed on a Service Fabric node for the given application. These results are of service packages whose name match exactly the service package name specified as the parameter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  ##   servicePackageName: JString (required)
  ##                     : The name of the service package.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_568983 = path.getOrDefault("nodeName")
  valid_568983 = validateParameter(valid_568983, JString, required = true,
                                 default = nil)
  if valid_568983 != nil:
    section.add "nodeName", valid_568983
  var valid_568984 = path.getOrDefault("applicationId")
  valid_568984 = validateParameter(valid_568984, JString, required = true,
                                 default = nil)
  if valid_568984 != nil:
    section.add "applicationId", valid_568984
  var valid_568985 = path.getOrDefault("servicePackageName")
  valid_568985 = validateParameter(valid_568985, JString, required = true,
                                 default = nil)
  if valid_568985 != nil:
    section.add "servicePackageName", valid_568985
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_568986 = query.getOrDefault("timeout")
  valid_568986 = validateParameter(valid_568986, JInt, required = false,
                                 default = newJInt(60))
  if valid_568986 != nil:
    section.add "timeout", valid_568986
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568987 = query.getOrDefault("api-version")
  valid_568987 = validateParameter(valid_568987, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568987 != nil:
    section.add "api-version", valid_568987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568988: Call_GetDeployedServicePackageInfoListByName_568980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the information about the service packages deployed on a Service Fabric node for the given application. These results are of service packages whose name match exactly the service package name specified as the parameter.
  ## 
  let valid = call_568988.validator(path, query, header, formData, body)
  let scheme = call_568988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568988.url(scheme.get, call_568988.host, call_568988.base,
                         call_568988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568988, url, valid)

proc call*(call_568989: Call_GetDeployedServicePackageInfoListByName_568980;
          nodeName: string; applicationId: string; servicePackageName: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getDeployedServicePackageInfoListByName
  ## Returns the information about the service packages deployed on a Service Fabric node for the given application. These results are of service packages whose name match exactly the service package name specified as the parameter.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  ##   servicePackageName: string (required)
  ##                     : The name of the service package.
  var path_568990 = newJObject()
  var query_568991 = newJObject()
  add(query_568991, "timeout", newJInt(timeout))
  add(query_568991, "api-version", newJString(apiVersion))
  add(path_568990, "nodeName", newJString(nodeName))
  add(path_568990, "applicationId", newJString(applicationId))
  add(path_568990, "servicePackageName", newJString(servicePackageName))
  result = call_568989.call(path_568990, query_568991, nil, nil, nil)

var getDeployedServicePackageInfoListByName* = Call_GetDeployedServicePackageInfoListByName_568980(
    name: "getDeployedServicePackageInfoListByName", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServicePackages/{servicePackageName}",
    validator: validate_GetDeployedServicePackageInfoListByName_568981, base: "",
    url: url_GetDeployedServicePackageInfoListByName_568982,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServicePackageHealthUsingPolicy_569005 = ref object of OpenApiRestCall_567666
proc url_GetDeployedServicePackageHealthUsingPolicy_569007(protocol: Scheme;
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

proc validate_GetDeployedServicePackageHealthUsingPolicy_569006(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about health of an service package for a specific application deployed on a Service Fabric node. using the specified policy. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed service package based on health state. Use ApplicationHealthPolicy to optionally override the health policies used to evaluate the health. This API only uses 'ConsiderWarningAsError' field of the ApplicationHealthPolicy. The rest of the fields are ignored while evaluating the health of the deployed service package.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  ##   servicePackageName: JString (required)
  ##                     : The name of the service package.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_569008 = path.getOrDefault("nodeName")
  valid_569008 = validateParameter(valid_569008, JString, required = true,
                                 default = nil)
  if valid_569008 != nil:
    section.add "nodeName", valid_569008
  var valid_569009 = path.getOrDefault("applicationId")
  valid_569009 = validateParameter(valid_569009, JString, required = true,
                                 default = nil)
  if valid_569009 != nil:
    section.add "applicationId", valid_569009
  var valid_569010 = path.getOrDefault("servicePackageName")
  valid_569010 = validateParameter(valid_569010, JString, required = true,
                                 default = nil)
  if valid_569010 != nil:
    section.add "servicePackageName", valid_569010
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
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
  var valid_569011 = query.getOrDefault("timeout")
  valid_569011 = validateParameter(valid_569011, JInt, required = false,
                                 default = newJInt(60))
  if valid_569011 != nil:
    section.add "timeout", valid_569011
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569012 = query.getOrDefault("api-version")
  valid_569012 = validateParameter(valid_569012, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569012 != nil:
    section.add "api-version", valid_569012
  var valid_569013 = query.getOrDefault("EventsHealthStateFilter")
  valid_569013 = validateParameter(valid_569013, JInt, required = false,
                                 default = newJInt(0))
  if valid_569013 != nil:
    section.add "EventsHealthStateFilter", valid_569013
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

proc call*(call_569015: Call_GetDeployedServicePackageHealthUsingPolicy_569005;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the information about health of an service package for a specific application deployed on a Service Fabric node. using the specified policy. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed service package based on health state. Use ApplicationHealthPolicy to optionally override the health policies used to evaluate the health. This API only uses 'ConsiderWarningAsError' field of the ApplicationHealthPolicy. The rest of the fields are ignored while evaluating the health of the deployed service package.
  ## 
  ## 
  let valid = call_569015.validator(path, query, header, formData, body)
  let scheme = call_569015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569015.url(scheme.get, call_569015.host, call_569015.base,
                         call_569015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569015, url, valid)

proc call*(call_569016: Call_GetDeployedServicePackageHealthUsingPolicy_569005;
          nodeName: string; applicationId: string; servicePackageName: string;
          timeout: int = 60; apiVersion: string = "3.0";
          ApplicationHealthPolicy: JsonNode = nil; EventsHealthStateFilter: int = 0): Recallable =
  ## getDeployedServicePackageHealthUsingPolicy
  ## Gets the information about health of an service package for a specific application deployed on a Service Fabric node. using the specified policy. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed service package based on health state. Use ApplicationHealthPolicy to optionally override the health policies used to evaluate the health. This API only uses 'ConsiderWarningAsError' field of the ApplicationHealthPolicy. The rest of the fields are ignored while evaluating the health of the deployed service package.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   ApplicationHealthPolicy: JObject
  ##                          : Describes the health policies used to evaluate the health of an application or one of its children.
  ## If not present, the health evaluation uses the health policy from application manifest or the default health policy.
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
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  ##   servicePackageName: string (required)
  ##                     : The name of the service package.
  var path_569017 = newJObject()
  var query_569018 = newJObject()
  var body_569019 = newJObject()
  add(query_569018, "timeout", newJInt(timeout))
  add(query_569018, "api-version", newJString(apiVersion))
  add(path_569017, "nodeName", newJString(nodeName))
  if ApplicationHealthPolicy != nil:
    body_569019 = ApplicationHealthPolicy
  add(query_569018, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_569017, "applicationId", newJString(applicationId))
  add(path_569017, "servicePackageName", newJString(servicePackageName))
  result = call_569016.call(path_569017, query_569018, nil, nil, body_569019)

var getDeployedServicePackageHealthUsingPolicy* = Call_GetDeployedServicePackageHealthUsingPolicy_569005(
    name: "getDeployedServicePackageHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServicePackages/{servicePackageName}/$/GetHealth",
    validator: validate_GetDeployedServicePackageHealthUsingPolicy_569006,
    base: "", url: url_GetDeployedServicePackageHealthUsingPolicy_569007,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServicePackageHealth_568992 = ref object of OpenApiRestCall_567666
proc url_GetDeployedServicePackageHealth_568994(protocol: Scheme; host: string;
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

proc validate_GetDeployedServicePackageHealth_568993(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about health of service package for a specific application deployed on a Service Fabric node. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed service package based on health state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  ##   servicePackageName: JString (required)
  ##                     : The name of the service package.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_568995 = path.getOrDefault("nodeName")
  valid_568995 = validateParameter(valid_568995, JString, required = true,
                                 default = nil)
  if valid_568995 != nil:
    section.add "nodeName", valid_568995
  var valid_568996 = path.getOrDefault("applicationId")
  valid_568996 = validateParameter(valid_568996, JString, required = true,
                                 default = nil)
  if valid_568996 != nil:
    section.add "applicationId", valid_568996
  var valid_568997 = path.getOrDefault("servicePackageName")
  valid_568997 = validateParameter(valid_568997, JString, required = true,
                                 default = nil)
  if valid_568997 != nil:
    section.add "servicePackageName", valid_568997
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
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
  var valid_568998 = query.getOrDefault("timeout")
  valid_568998 = validateParameter(valid_568998, JInt, required = false,
                                 default = newJInt(60))
  if valid_568998 != nil:
    section.add "timeout", valid_568998
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568999 = query.getOrDefault("api-version")
  valid_568999 = validateParameter(valid_568999, JString, required = true,
                                 default = newJString("3.0"))
  if valid_568999 != nil:
    section.add "api-version", valid_568999
  var valid_569000 = query.getOrDefault("EventsHealthStateFilter")
  valid_569000 = validateParameter(valid_569000, JInt, required = false,
                                 default = newJInt(0))
  if valid_569000 != nil:
    section.add "EventsHealthStateFilter", valid_569000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569001: Call_GetDeployedServicePackageHealth_568992;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the information about health of service package for a specific application deployed on a Service Fabric node. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed service package based on health state.
  ## 
  let valid = call_569001.validator(path, query, header, formData, body)
  let scheme = call_569001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569001.url(scheme.get, call_569001.host, call_569001.base,
                         call_569001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569001, url, valid)

proc call*(call_569002: Call_GetDeployedServicePackageHealth_568992;
          nodeName: string; applicationId: string; servicePackageName: string;
          timeout: int = 60; apiVersion: string = "3.0";
          EventsHealthStateFilter: int = 0): Recallable =
  ## getDeployedServicePackageHealth
  ## Gets the information about health of service package for a specific application deployed on a Service Fabric node. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed service package based on health state.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
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
  ##   servicePackageName: string (required)
  ##                     : The name of the service package.
  var path_569003 = newJObject()
  var query_569004 = newJObject()
  add(query_569004, "timeout", newJInt(timeout))
  add(query_569004, "api-version", newJString(apiVersion))
  add(path_569003, "nodeName", newJString(nodeName))
  add(query_569004, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_569003, "applicationId", newJString(applicationId))
  add(path_569003, "servicePackageName", newJString(servicePackageName))
  result = call_569002.call(path_569003, query_569004, nil, nil, nil)

var getDeployedServicePackageHealth* = Call_GetDeployedServicePackageHealth_568992(
    name: "getDeployedServicePackageHealth", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServicePackages/{servicePackageName}/$/GetHealth",
    validator: validate_GetDeployedServicePackageHealth_568993, base: "",
    url: url_GetDeployedServicePackageHealth_568994,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportDeployedServicePackageHealth_569020 = ref object of OpenApiRestCall_567666
proc url_ReportDeployedServicePackageHealth_569022(protocol: Scheme; host: string;
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

proc validate_ReportDeployedServicePackageHealth_569021(path: JsonNode;
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
  ##   nodeName: JString (required)
  ##           : The name of the node.
  ##   applicationId: JString (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  ##   servicePackageName: JString (required)
  ##                     : The name of the service package.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `nodeName` field"
  var valid_569023 = path.getOrDefault("nodeName")
  valid_569023 = validateParameter(valid_569023, JString, required = true,
                                 default = nil)
  if valid_569023 != nil:
    section.add "nodeName", valid_569023
  var valid_569024 = path.getOrDefault("applicationId")
  valid_569024 = validateParameter(valid_569024, JString, required = true,
                                 default = nil)
  if valid_569024 != nil:
    section.add "applicationId", valid_569024
  var valid_569025 = path.getOrDefault("servicePackageName")
  valid_569025 = validateParameter(valid_569025, JString, required = true,
                                 default = nil)
  if valid_569025 != nil:
    section.add "servicePackageName", valid_569025
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569026 = query.getOrDefault("timeout")
  valid_569026 = validateParameter(valid_569026, JInt, required = false,
                                 default = newJInt(60))
  if valid_569026 != nil:
    section.add "timeout", valid_569026
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569027 = query.getOrDefault("api-version")
  valid_569027 = validateParameter(valid_569027, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569027 != nil:
    section.add "api-version", valid_569027
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

proc call*(call_569029: Call_ReportDeployedServicePackageHealth_569020;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reports health state of the service package of the application deployed on a Service Fabric node. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Service, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, get deployed service package health and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_569029.validator(path, query, header, formData, body)
  let scheme = call_569029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569029.url(scheme.get, call_569029.host, call_569029.base,
                         call_569029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569029, url, valid)

proc call*(call_569030: Call_ReportDeployedServicePackageHealth_569020;
          nodeName: string; HealthInformation: JsonNode; applicationId: string;
          servicePackageName: string; timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## reportDeployedServicePackageHealth
  ## Reports health state of the service package of the application deployed on a Service Fabric node. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Service, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, get deployed service package health and check that the report appears in the HealthEvents section.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  ##   servicePackageName: string (required)
  ##                     : The name of the service package.
  var path_569031 = newJObject()
  var query_569032 = newJObject()
  var body_569033 = newJObject()
  add(query_569032, "timeout", newJInt(timeout))
  add(query_569032, "api-version", newJString(apiVersion))
  add(path_569031, "nodeName", newJString(nodeName))
  if HealthInformation != nil:
    body_569033 = HealthInformation
  add(path_569031, "applicationId", newJString(applicationId))
  add(path_569031, "servicePackageName", newJString(servicePackageName))
  result = call_569030.call(path_569031, query_569032, nil, nil, body_569033)

var reportDeployedServicePackageHealth* = Call_ReportDeployedServicePackageHealth_569020(
    name: "reportDeployedServicePackageHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServicePackages/{servicePackageName}/$/ReportHealth",
    validator: validate_ReportDeployedServicePackageHealth_569021, base: "",
    url: url_ReportDeployedServicePackageHealth_569022,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServiceTypeInfoList_569034 = ref object of OpenApiRestCall_567666
proc url_GetDeployedServiceTypeInfoList_569036(protocol: Scheme; host: string;
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

proc validate_GetDeployedServiceTypeInfoList_569035(path: JsonNode;
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
  var valid_569037 = path.getOrDefault("nodeName")
  valid_569037 = validateParameter(valid_569037, JString, required = true,
                                 default = nil)
  if valid_569037 != nil:
    section.add "nodeName", valid_569037
  var valid_569038 = path.getOrDefault("applicationId")
  valid_569038 = validateParameter(valid_569038, JString, required = true,
                                 default = nil)
  if valid_569038 != nil:
    section.add "applicationId", valid_569038
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ServiceManifestName: JString
  ##                      : The name of the service manifest to filter the list of deployed service type information. If specified, the response will only contain the information about service types that are defined in this service manifest.
  section = newJObject()
  var valid_569039 = query.getOrDefault("timeout")
  valid_569039 = validateParameter(valid_569039, JInt, required = false,
                                 default = newJInt(60))
  if valid_569039 != nil:
    section.add "timeout", valid_569039
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569040 = query.getOrDefault("api-version")
  valid_569040 = validateParameter(valid_569040, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569040 != nil:
    section.add "api-version", valid_569040
  var valid_569041 = query.getOrDefault("ServiceManifestName")
  valid_569041 = validateParameter(valid_569041, JString, required = false,
                                 default = nil)
  if valid_569041 != nil:
    section.add "ServiceManifestName", valid_569041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569042: Call_GetDeployedServiceTypeInfoList_569034; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list containing the information about service types from the applications deployed on a node in a Service Fabric cluster. The response includes the name of the service type, its registration status, the code package that registered it and activation id of the service package.
  ## 
  let valid = call_569042.validator(path, query, header, formData, body)
  let scheme = call_569042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569042.url(scheme.get, call_569042.host, call_569042.base,
                         call_569042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569042, url, valid)

proc call*(call_569043: Call_GetDeployedServiceTypeInfoList_569034;
          nodeName: string; applicationId: string; timeout: int = 60;
          apiVersion: string = "3.0"; ServiceManifestName: string = ""): Recallable =
  ## getDeployedServiceTypeInfoList
  ## Gets the list containing the information about service types from the applications deployed on a node in a Service Fabric cluster. The response includes the name of the service type, its registration status, the code package that registered it and activation id of the service package.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   ServiceManifestName: string
  ##                      : The name of the service manifest to filter the list of deployed service type information. If specified, the response will only contain the information about service types that are defined in this service manifest.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_569044 = newJObject()
  var query_569045 = newJObject()
  add(query_569045, "timeout", newJInt(timeout))
  add(query_569045, "api-version", newJString(apiVersion))
  add(path_569044, "nodeName", newJString(nodeName))
  add(query_569045, "ServiceManifestName", newJString(ServiceManifestName))
  add(path_569044, "applicationId", newJString(applicationId))
  result = call_569043.call(path_569044, query_569045, nil, nil, nil)

var getDeployedServiceTypeInfoList* = Call_GetDeployedServiceTypeInfoList_569034(
    name: "getDeployedServiceTypeInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServiceTypes",
    validator: validate_GetDeployedServiceTypeInfoList_569035, base: "",
    url: url_GetDeployedServiceTypeInfoList_569036,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServiceTypeInfoByName_569046 = ref object of OpenApiRestCall_567666
proc url_GetDeployedServiceTypeInfoByName_569048(protocol: Scheme; host: string;
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

proc validate_GetDeployedServiceTypeInfoByName_569047(path: JsonNode;
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
  var valid_569049 = path.getOrDefault("serviceTypeName")
  valid_569049 = validateParameter(valid_569049, JString, required = true,
                                 default = nil)
  if valid_569049 != nil:
    section.add "serviceTypeName", valid_569049
  var valid_569050 = path.getOrDefault("nodeName")
  valid_569050 = validateParameter(valid_569050, JString, required = true,
                                 default = nil)
  if valid_569050 != nil:
    section.add "nodeName", valid_569050
  var valid_569051 = path.getOrDefault("applicationId")
  valid_569051 = validateParameter(valid_569051, JString, required = true,
                                 default = nil)
  if valid_569051 != nil:
    section.add "applicationId", valid_569051
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ServiceManifestName: JString
  ##                      : The name of the service manifest to filter the list of deployed service type information. If specified, the response will only contain the information about service types that are defined in this service manifest.
  section = newJObject()
  var valid_569052 = query.getOrDefault("timeout")
  valid_569052 = validateParameter(valid_569052, JInt, required = false,
                                 default = newJInt(60))
  if valid_569052 != nil:
    section.add "timeout", valid_569052
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569053 = query.getOrDefault("api-version")
  valid_569053 = validateParameter(valid_569053, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569053 != nil:
    section.add "api-version", valid_569053
  var valid_569054 = query.getOrDefault("ServiceManifestName")
  valid_569054 = validateParameter(valid_569054, JString, required = false,
                                 default = nil)
  if valid_569054 != nil:
    section.add "ServiceManifestName", valid_569054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569055: Call_GetDeployedServiceTypeInfoByName_569046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the information about a specified service type of the application deployed on a node in a Service Fabric cluster. The response includes the name of the service type, its registration status, the code package that registered it and activation id of the service package.
  ## 
  let valid = call_569055.validator(path, query, header, formData, body)
  let scheme = call_569055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569055.url(scheme.get, call_569055.host, call_569055.base,
                         call_569055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569055, url, valid)

proc call*(call_569056: Call_GetDeployedServiceTypeInfoByName_569046;
          serviceTypeName: string; nodeName: string; applicationId: string;
          timeout: int = 60; apiVersion: string = "3.0";
          ServiceManifestName: string = ""): Recallable =
  ## getDeployedServiceTypeInfoByName
  ## Gets the information about a specified service type of the application deployed on a node in a Service Fabric cluster. The response includes the name of the service type, its registration status, the code package that registered it and activation id of the service package.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   serviceTypeName: string (required)
  ##                  : Specifies the name of a Service Fabric service type.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   ServiceManifestName: string
  ##                      : The name of the service manifest to filter the list of deployed service type information. If specified, the response will only contain the information about service types that are defined in this service manifest.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_569057 = newJObject()
  var query_569058 = newJObject()
  add(query_569058, "timeout", newJInt(timeout))
  add(path_569057, "serviceTypeName", newJString(serviceTypeName))
  add(query_569058, "api-version", newJString(apiVersion))
  add(path_569057, "nodeName", newJString(nodeName))
  add(query_569058, "ServiceManifestName", newJString(ServiceManifestName))
  add(path_569057, "applicationId", newJString(applicationId))
  result = call_569056.call(path_569057, query_569058, nil, nil, nil)

var getDeployedServiceTypeInfoByName* = Call_GetDeployedServiceTypeInfoByName_569046(
    name: "getDeployedServiceTypeInfoByName", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServiceTypes/{serviceTypeName}",
    validator: validate_GetDeployedServiceTypeInfoByName_569047, base: "",
    url: url_GetDeployedServiceTypeInfoByName_569048,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportDeployedApplicationHealth_569059 = ref object of OpenApiRestCall_567666
proc url_ReportDeployedApplicationHealth_569061(protocol: Scheme; host: string;
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

proc validate_ReportDeployedApplicationHealth_569060(path: JsonNode;
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
  var valid_569062 = path.getOrDefault("nodeName")
  valid_569062 = validateParameter(valid_569062, JString, required = true,
                                 default = nil)
  if valid_569062 != nil:
    section.add "nodeName", valid_569062
  var valid_569063 = path.getOrDefault("applicationId")
  valid_569063 = validateParameter(valid_569063, JString, required = true,
                                 default = nil)
  if valid_569063 != nil:
    section.add "applicationId", valid_569063
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569064 = query.getOrDefault("timeout")
  valid_569064 = validateParameter(valid_569064, JInt, required = false,
                                 default = newJInt(60))
  if valid_569064 != nil:
    section.add "timeout", valid_569064
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569065 = query.getOrDefault("api-version")
  valid_569065 = validateParameter(valid_569065, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569065 != nil:
    section.add "api-version", valid_569065
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

proc call*(call_569067: Call_ReportDeployedApplicationHealth_569059;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reports health state of the application deployed on a Service Fabric node. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Service, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, get deployed application health and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_569067.validator(path, query, header, formData, body)
  let scheme = call_569067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569067.url(scheme.get, call_569067.host, call_569067.base,
                         call_569067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569067, url, valid)

proc call*(call_569068: Call_ReportDeployedApplicationHealth_569059;
          nodeName: string; HealthInformation: JsonNode; applicationId: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## reportDeployedApplicationHealth
  ## Reports health state of the application deployed on a Service Fabric node. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Service, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, get deployed application health and check that the report appears in the HealthEvents section.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_569069 = newJObject()
  var query_569070 = newJObject()
  var body_569071 = newJObject()
  add(query_569070, "timeout", newJInt(timeout))
  add(query_569070, "api-version", newJString(apiVersion))
  add(path_569069, "nodeName", newJString(nodeName))
  if HealthInformation != nil:
    body_569071 = HealthInformation
  add(path_569069, "applicationId", newJString(applicationId))
  result = call_569068.call(path_569069, query_569070, nil, nil, body_569071)

var reportDeployedApplicationHealth* = Call_ReportDeployedApplicationHealth_569059(
    name: "reportDeployedApplicationHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/ReportHealth",
    validator: validate_ReportDeployedApplicationHealth_569060, base: "",
    url: url_ReportDeployedApplicationHealth_569061,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetNodeHealthUsingPolicy_569083 = ref object of OpenApiRestCall_567666
proc url_GetNodeHealthUsingPolicy_569085(protocol: Scheme; host: string;
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

proc validate_GetNodeHealthUsingPolicy_569084(path: JsonNode; query: JsonNode;
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
  var valid_569086 = path.getOrDefault("nodeName")
  valid_569086 = validateParameter(valid_569086, JString, required = true,
                                 default = nil)
  if valid_569086 != nil:
    section.add "nodeName", valid_569086
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
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
  var valid_569087 = query.getOrDefault("timeout")
  valid_569087 = validateParameter(valid_569087, JInt, required = false,
                                 default = newJInt(60))
  if valid_569087 != nil:
    section.add "timeout", valid_569087
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569088 = query.getOrDefault("api-version")
  valid_569088 = validateParameter(valid_569088, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569088 != nil:
    section.add "api-version", valid_569088
  var valid_569089 = query.getOrDefault("EventsHealthStateFilter")
  valid_569089 = validateParameter(valid_569089, JInt, required = false,
                                 default = newJInt(0))
  if valid_569089 != nil:
    section.add "EventsHealthStateFilter", valid_569089
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

proc call*(call_569091: Call_GetNodeHealthUsingPolicy_569083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric node. Use EventsHealthStateFilter to filter the collection of health events reported on the node based on the health state. Use ClusterHealthPolicy in the POST body to override the health policies used to evaluate the health. If the node that you specify by name does not exist in the health store, this returns an error.
  ## 
  let valid = call_569091.validator(path, query, header, formData, body)
  let scheme = call_569091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569091.url(scheme.get, call_569091.host, call_569091.base,
                         call_569091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569091, url, valid)

proc call*(call_569092: Call_GetNodeHealthUsingPolicy_569083; nodeName: string;
          timeout: int = 60; apiVersion: string = "3.0";
          EventsHealthStateFilter: int = 0; ClusterHealthPolicy: JsonNode = nil): Recallable =
  ## getNodeHealthUsingPolicy
  ## Gets the health of a Service Fabric node. Use EventsHealthStateFilter to filter the collection of health events reported on the node based on the health state. Use ClusterHealthPolicy in the POST body to override the health policies used to evaluate the health. If the node that you specify by name does not exist in the health store, this returns an error.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
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
  ##   ClusterHealthPolicy: JObject
  ##                      : Describes the health policies used to evaluate the health of a cluster or node. If not present, the health evaluation uses the health policy from cluster manifest or the default health policy.
  var path_569093 = newJObject()
  var query_569094 = newJObject()
  var body_569095 = newJObject()
  add(query_569094, "timeout", newJInt(timeout))
  add(query_569094, "api-version", newJString(apiVersion))
  add(path_569093, "nodeName", newJString(nodeName))
  add(query_569094, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  if ClusterHealthPolicy != nil:
    body_569095 = ClusterHealthPolicy
  result = call_569092.call(path_569093, query_569094, nil, nil, body_569095)

var getNodeHealthUsingPolicy* = Call_GetNodeHealthUsingPolicy_569083(
    name: "getNodeHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetHealth",
    validator: validate_GetNodeHealthUsingPolicy_569084, base: "",
    url: url_GetNodeHealthUsingPolicy_569085, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetNodeHealth_569072 = ref object of OpenApiRestCall_567666
proc url_GetNodeHealth_569074(protocol: Scheme; host: string; base: string;
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

proc validate_GetNodeHealth_569073(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569075 = path.getOrDefault("nodeName")
  valid_569075 = validateParameter(valid_569075, JString, required = true,
                                 default = nil)
  if valid_569075 != nil:
    section.add "nodeName", valid_569075
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
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
  var valid_569076 = query.getOrDefault("timeout")
  valid_569076 = validateParameter(valid_569076, JInt, required = false,
                                 default = newJInt(60))
  if valid_569076 != nil:
    section.add "timeout", valid_569076
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569077 = query.getOrDefault("api-version")
  valid_569077 = validateParameter(valid_569077, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569077 != nil:
    section.add "api-version", valid_569077
  var valid_569078 = query.getOrDefault("EventsHealthStateFilter")
  valid_569078 = validateParameter(valid_569078, JInt, required = false,
                                 default = newJInt(0))
  if valid_569078 != nil:
    section.add "EventsHealthStateFilter", valid_569078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569079: Call_GetNodeHealth_569072; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric node. Use EventsHealthStateFilter to filter the collection of health events reported on the node based on the health state. If the node that you specify by name does not exist in the health store, this returns an error.
  ## 
  let valid = call_569079.validator(path, query, header, formData, body)
  let scheme = call_569079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569079.url(scheme.get, call_569079.host, call_569079.base,
                         call_569079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569079, url, valid)

proc call*(call_569080: Call_GetNodeHealth_569072; nodeName: string;
          timeout: int = 60; apiVersion: string = "3.0";
          EventsHealthStateFilter: int = 0): Recallable =
  ## getNodeHealth
  ## Gets the health of a Service Fabric node. Use EventsHealthStateFilter to filter the collection of health events reported on the node based on the health state. If the node that you specify by name does not exist in the health store, this returns an error.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
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
  var path_569081 = newJObject()
  var query_569082 = newJObject()
  add(query_569082, "timeout", newJInt(timeout))
  add(query_569082, "api-version", newJString(apiVersion))
  add(path_569081, "nodeName", newJString(nodeName))
  add(query_569082, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  result = call_569080.call(path_569081, query_569082, nil, nil, nil)

var getNodeHealth* = Call_GetNodeHealth_569072(name: "getNodeHealth",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetHealth", validator: validate_GetNodeHealth_569073,
    base: "", url: url_GetNodeHealth_569074, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetNodeLoadInfo_569096 = ref object of OpenApiRestCall_567666
proc url_GetNodeLoadInfo_569098(protocol: Scheme; host: string; base: string;
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

proc validate_GetNodeLoadInfo_569097(path: JsonNode; query: JsonNode;
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
  var valid_569099 = path.getOrDefault("nodeName")
  valid_569099 = validateParameter(valid_569099, JString, required = true,
                                 default = nil)
  if valid_569099 != nil:
    section.add "nodeName", valid_569099
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569100 = query.getOrDefault("timeout")
  valid_569100 = validateParameter(valid_569100, JInt, required = false,
                                 default = newJInt(60))
  if valid_569100 != nil:
    section.add "timeout", valid_569100
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569101 = query.getOrDefault("api-version")
  valid_569101 = validateParameter(valid_569101, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569101 != nil:
    section.add "api-version", valid_569101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569102: Call_GetNodeLoadInfo_569096; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the load information of a Service Fabric node.
  ## 
  let valid = call_569102.validator(path, query, header, formData, body)
  let scheme = call_569102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569102.url(scheme.get, call_569102.host, call_569102.base,
                         call_569102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569102, url, valid)

proc call*(call_569103: Call_GetNodeLoadInfo_569096; nodeName: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getNodeLoadInfo
  ## Gets the load information of a Service Fabric node.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_569104 = newJObject()
  var query_569105 = newJObject()
  add(query_569105, "timeout", newJInt(timeout))
  add(query_569105, "api-version", newJString(apiVersion))
  add(path_569104, "nodeName", newJString(nodeName))
  result = call_569103.call(path_569104, query_569105, nil, nil, nil)

var getNodeLoadInfo* = Call_GetNodeLoadInfo_569096(name: "getNodeLoadInfo",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetLoadInformation",
    validator: validate_GetNodeLoadInfo_569097, base: "", url: url_GetNodeLoadInfo_569098,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_RemoveReplica_569106 = ref object of OpenApiRestCall_567666
proc url_RemoveReplica_569108(protocol: Scheme; host: string; base: string;
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

proc validate_RemoveReplica_569107(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569109 = path.getOrDefault("replicaId")
  valid_569109 = validateParameter(valid_569109, JString, required = true,
                                 default = nil)
  if valid_569109 != nil:
    section.add "replicaId", valid_569109
  var valid_569110 = path.getOrDefault("nodeName")
  valid_569110 = validateParameter(valid_569110, JString, required = true,
                                 default = nil)
  if valid_569110 != nil:
    section.add "nodeName", valid_569110
  var valid_569111 = path.getOrDefault("partitionId")
  valid_569111 = validateParameter(valid_569111, JString, required = true,
                                 default = nil)
  if valid_569111 != nil:
    section.add "partitionId", valid_569111
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ForceRemove: JBool
  ##              : Remove a Service Fabric application or service forcefully without going through the graceful shutdown sequence. This parameter can be used to forcefully delete an application or service for which delete is timing out due to issues in the service code that prevents graceful close of replicas.
  section = newJObject()
  var valid_569112 = query.getOrDefault("timeout")
  valid_569112 = validateParameter(valid_569112, JInt, required = false,
                                 default = newJInt(60))
  if valid_569112 != nil:
    section.add "timeout", valid_569112
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569113 = query.getOrDefault("api-version")
  valid_569113 = validateParameter(valid_569113, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569113 != nil:
    section.add "api-version", valid_569113
  var valid_569114 = query.getOrDefault("ForceRemove")
  valid_569114 = validateParameter(valid_569114, JBool, required = false, default = nil)
  if valid_569114 != nil:
    section.add "ForceRemove", valid_569114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569115: Call_RemoveReplica_569106; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This API simulates a Service Fabric replica failure by removing a replica from a Service Fabric cluster. The removal closes the replica, transitions the replica to the role None, and then removes all of the state information of the replica from the cluster. This API tests the replica state removal path, and simulates the report fault permanent path through client APIs. Warning - There are no safety checks performed when this API is used. Incorrect use of this API can lead to data loss for stateful services.In addition, the forceRemove flag impacts all other replicas hosted in the same process.
  ## 
  let valid = call_569115.validator(path, query, header, formData, body)
  let scheme = call_569115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569115.url(scheme.get, call_569115.host, call_569115.base,
                         call_569115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569115, url, valid)

proc call*(call_569116: Call_RemoveReplica_569106; replicaId: string;
          nodeName: string; partitionId: string; timeout: int = 60;
          apiVersion: string = "3.0"; ForceRemove: bool = false): Recallable =
  ## removeReplica
  ## This API simulates a Service Fabric replica failure by removing a replica from a Service Fabric cluster. The removal closes the replica, transitions the replica to the role None, and then removes all of the state information of the replica from the cluster. This API tests the replica state removal path, and simulates the report fault permanent path through client APIs. Warning - There are no safety checks performed when this API is used. Incorrect use of this API can lead to data loss for stateful services.In addition, the forceRemove flag impacts all other replicas hosted in the same process.
  ##   replicaId: string (required)
  ##            : The identifier of the replica.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ForceRemove: bool
  ##              : Remove a Service Fabric application or service forcefully without going through the graceful shutdown sequence. This parameter can be used to forcefully delete an application or service for which delete is timing out due to issues in the service code that prevents graceful close of replicas.
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_569117 = newJObject()
  var query_569118 = newJObject()
  add(path_569117, "replicaId", newJString(replicaId))
  add(query_569118, "timeout", newJInt(timeout))
  add(query_569118, "api-version", newJString(apiVersion))
  add(query_569118, "ForceRemove", newJBool(ForceRemove))
  add(path_569117, "nodeName", newJString(nodeName))
  add(path_569117, "partitionId", newJString(partitionId))
  result = call_569116.call(path_569117, query_569118, nil, nil, nil)

var removeReplica* = Call_RemoveReplica_569106(name: "removeReplica",
    meth: HttpMethod.HttpPost, host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetPartitions/{partitionId}/$/GetReplicas/{replicaId}/$/Delete",
    validator: validate_RemoveReplica_569107, base: "", url: url_RemoveReplica_569108,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServiceReplicaDetailInfo_569119 = ref object of OpenApiRestCall_567666
proc url_GetDeployedServiceReplicaDetailInfo_569121(protocol: Scheme; host: string;
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

proc validate_GetDeployedServiceReplicaDetailInfo_569120(path: JsonNode;
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
  var valid_569122 = path.getOrDefault("replicaId")
  valid_569122 = validateParameter(valid_569122, JString, required = true,
                                 default = nil)
  if valid_569122 != nil:
    section.add "replicaId", valid_569122
  var valid_569123 = path.getOrDefault("nodeName")
  valid_569123 = validateParameter(valid_569123, JString, required = true,
                                 default = nil)
  if valid_569123 != nil:
    section.add "nodeName", valid_569123
  var valid_569124 = path.getOrDefault("partitionId")
  valid_569124 = validateParameter(valid_569124, JString, required = true,
                                 default = nil)
  if valid_569124 != nil:
    section.add "partitionId", valid_569124
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569125 = query.getOrDefault("timeout")
  valid_569125 = validateParameter(valid_569125, JInt, required = false,
                                 default = newJInt(60))
  if valid_569125 != nil:
    section.add "timeout", valid_569125
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569126 = query.getOrDefault("api-version")
  valid_569126 = validateParameter(valid_569126, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569126 != nil:
    section.add "api-version", valid_569126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569127: Call_GetDeployedServiceReplicaDetailInfo_569119;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the replica deployed on a Service Fabric node. The information include service kind, service name, current service operation, current service operation start date time, partition id, replica/instance id, reported load and other information.
  ## 
  let valid = call_569127.validator(path, query, header, formData, body)
  let scheme = call_569127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569127.url(scheme.get, call_569127.host, call_569127.base,
                         call_569127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569127, url, valid)

proc call*(call_569128: Call_GetDeployedServiceReplicaDetailInfo_569119;
          replicaId: string; nodeName: string; partitionId: string; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## getDeployedServiceReplicaDetailInfo
  ## Gets the details of the replica deployed on a Service Fabric node. The information include service kind, service name, current service operation, current service operation start date time, partition id, replica/instance id, reported load and other information.
  ##   replicaId: string (required)
  ##            : The identifier of the replica.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_569129 = newJObject()
  var query_569130 = newJObject()
  add(path_569129, "replicaId", newJString(replicaId))
  add(query_569130, "timeout", newJInt(timeout))
  add(query_569130, "api-version", newJString(apiVersion))
  add(path_569129, "nodeName", newJString(nodeName))
  add(path_569129, "partitionId", newJString(partitionId))
  result = call_569128.call(path_569129, query_569130, nil, nil, nil)

var getDeployedServiceReplicaDetailInfo* = Call_GetDeployedServiceReplicaDetailInfo_569119(
    name: "getDeployedServiceReplicaDetailInfo", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetPartitions/{partitionId}/$/GetReplicas/{replicaId}/$/GetDetail",
    validator: validate_GetDeployedServiceReplicaDetailInfo_569120, base: "",
    url: url_GetDeployedServiceReplicaDetailInfo_569121,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_RestartReplica_569131 = ref object of OpenApiRestCall_567666
proc url_RestartReplica_569133(protocol: Scheme; host: string; base: string;
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

proc validate_RestartReplica_569132(path: JsonNode; query: JsonNode;
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
  var valid_569134 = path.getOrDefault("replicaId")
  valid_569134 = validateParameter(valid_569134, JString, required = true,
                                 default = nil)
  if valid_569134 != nil:
    section.add "replicaId", valid_569134
  var valid_569135 = path.getOrDefault("nodeName")
  valid_569135 = validateParameter(valid_569135, JString, required = true,
                                 default = nil)
  if valid_569135 != nil:
    section.add "nodeName", valid_569135
  var valid_569136 = path.getOrDefault("partitionId")
  valid_569136 = validateParameter(valid_569136, JString, required = true,
                                 default = nil)
  if valid_569136 != nil:
    section.add "partitionId", valid_569136
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569137 = query.getOrDefault("timeout")
  valid_569137 = validateParameter(valid_569137, JInt, required = false,
                                 default = newJInt(60))
  if valid_569137 != nil:
    section.add "timeout", valid_569137
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569138 = query.getOrDefault("api-version")
  valid_569138 = validateParameter(valid_569138, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569138 != nil:
    section.add "api-version", valid_569138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569139: Call_RestartReplica_569131; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a service replica of a persisted service running on a node. Warning - There are no safety checks performed when this API is used. Incorrect use of this API can lead to availability loss for stateful services.
  ## 
  let valid = call_569139.validator(path, query, header, formData, body)
  let scheme = call_569139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569139.url(scheme.get, call_569139.host, call_569139.base,
                         call_569139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569139, url, valid)

proc call*(call_569140: Call_RestartReplica_569131; replicaId: string;
          nodeName: string; partitionId: string; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## restartReplica
  ## Restarts a service replica of a persisted service running on a node. Warning - There are no safety checks performed when this API is used. Incorrect use of this API can lead to availability loss for stateful services.
  ##   replicaId: string (required)
  ##            : The identifier of the replica.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_569141 = newJObject()
  var query_569142 = newJObject()
  add(path_569141, "replicaId", newJString(replicaId))
  add(query_569142, "timeout", newJInt(timeout))
  add(query_569142, "api-version", newJString(apiVersion))
  add(path_569141, "nodeName", newJString(nodeName))
  add(path_569141, "partitionId", newJString(partitionId))
  result = call_569140.call(path_569141, query_569142, nil, nil, nil)

var restartReplica* = Call_RestartReplica_569131(name: "restartReplica",
    meth: HttpMethod.HttpPost, host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetPartitions/{partitionId}/$/GetReplicas/{replicaId}/$/Restart",
    validator: validate_RestartReplica_569132, base: "", url: url_RestartReplica_569133,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_RemoveNodeState_569143 = ref object of OpenApiRestCall_567666
proc url_RemoveNodeState_569145(protocol: Scheme; host: string; base: string;
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

proc validate_RemoveNodeState_569144(path: JsonNode; query: JsonNode;
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
  var valid_569146 = path.getOrDefault("nodeName")
  valid_569146 = validateParameter(valid_569146, JString, required = true,
                                 default = nil)
  if valid_569146 != nil:
    section.add "nodeName", valid_569146
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569147 = query.getOrDefault("timeout")
  valid_569147 = validateParameter(valid_569147, JInt, required = false,
                                 default = newJInt(60))
  if valid_569147 != nil:
    section.add "timeout", valid_569147
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569148 = query.getOrDefault("api-version")
  valid_569148 = validateParameter(valid_569148, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569148 != nil:
    section.add "api-version", valid_569148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569149: Call_RemoveNodeState_569143; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Notifies Service Fabric that the persisted state on a node has been permanently removed or lost.  This implies that it is not possible to recover the persisted state of that node. This generally happens if a hard disk has been wiped clean, or if a hard disk crashes. The node has to be down for this operation to be successful. This operation lets Service Fabric know that the replicas on that node no longer exist, and that Service Fabric should stop waiting for those replicas to come back up. Do not run this cmdlet if the state on the node has not been removed and the node can comes back up with its state intact.
  ## 
  let valid = call_569149.validator(path, query, header, formData, body)
  let scheme = call_569149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569149.url(scheme.get, call_569149.host, call_569149.base,
                         call_569149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569149, url, valid)

proc call*(call_569150: Call_RemoveNodeState_569143; nodeName: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## removeNodeState
  ## Notifies Service Fabric that the persisted state on a node has been permanently removed or lost.  This implies that it is not possible to recover the persisted state of that node. This generally happens if a hard disk has been wiped clean, or if a hard disk crashes. The node has to be down for this operation to be successful. This operation lets Service Fabric know that the replicas on that node no longer exist, and that Service Fabric should stop waiting for those replicas to come back up. Do not run this cmdlet if the state on the node has not been removed and the node can comes back up with its state intact.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_569151 = newJObject()
  var query_569152 = newJObject()
  add(query_569152, "timeout", newJInt(timeout))
  add(query_569152, "api-version", newJString(apiVersion))
  add(path_569151, "nodeName", newJString(nodeName))
  result = call_569150.call(path_569151, query_569152, nil, nil, nil)

var removeNodeState* = Call_RemoveNodeState_569143(name: "removeNodeState",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/RemoveNodeState",
    validator: validate_RemoveNodeState_569144, base: "", url: url_RemoveNodeState_569145,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportNodeHealth_569153 = ref object of OpenApiRestCall_567666
proc url_ReportNodeHealth_569155(protocol: Scheme; host: string; base: string;
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

proc validate_ReportNodeHealth_569154(path: JsonNode; query: JsonNode;
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
  var valid_569156 = path.getOrDefault("nodeName")
  valid_569156 = validateParameter(valid_569156, JString, required = true,
                                 default = nil)
  if valid_569156 != nil:
    section.add "nodeName", valid_569156
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569157 = query.getOrDefault("timeout")
  valid_569157 = validateParameter(valid_569157, JInt, required = false,
                                 default = newJInt(60))
  if valid_569157 != nil:
    section.add "timeout", valid_569157
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569158 = query.getOrDefault("api-version")
  valid_569158 = validateParameter(valid_569158, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569158 != nil:
    section.add "api-version", valid_569158
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

proc call*(call_569160: Call_ReportNodeHealth_569153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reports health state of the specified Service Fabric node. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway node, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetNodeHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_569160.validator(path, query, header, formData, body)
  let scheme = call_569160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569160.url(scheme.get, call_569160.host, call_569160.base,
                         call_569160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569160, url, valid)

proc call*(call_569161: Call_ReportNodeHealth_569153; nodeName: string;
          HealthInformation: JsonNode; timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## reportNodeHealth
  ## Reports health state of the specified Service Fabric node. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway node, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetNodeHealth and check that the report appears in the HealthEvents section.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  var path_569162 = newJObject()
  var query_569163 = newJObject()
  var body_569164 = newJObject()
  add(query_569163, "timeout", newJInt(timeout))
  add(query_569163, "api-version", newJString(apiVersion))
  add(path_569162, "nodeName", newJString(nodeName))
  if HealthInformation != nil:
    body_569164 = HealthInformation
  result = call_569161.call(path_569162, query_569163, nil, nil, body_569164)

var reportNodeHealth* = Call_ReportNodeHealth_569153(name: "reportNodeHealth",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/ReportHealth",
    validator: validate_ReportNodeHealth_569154, base: "",
    url: url_ReportNodeHealth_569155, schemes: {Scheme.Https, Scheme.Http})
type
  Call_RestartNode_569165 = ref object of OpenApiRestCall_567666
proc url_RestartNode_569167(protocol: Scheme; host: string; base: string;
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

proc validate_RestartNode_569166(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569168 = path.getOrDefault("nodeName")
  valid_569168 = validateParameter(valid_569168, JString, required = true,
                                 default = nil)
  if valid_569168 != nil:
    section.add "nodeName", valid_569168
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569169 = query.getOrDefault("timeout")
  valid_569169 = validateParameter(valid_569169, JInt, required = false,
                                 default = newJInt(60))
  if valid_569169 != nil:
    section.add "timeout", valid_569169
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569170 = query.getOrDefault("api-version")
  valid_569170 = validateParameter(valid_569170, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569170 != nil:
    section.add "api-version", valid_569170
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

proc call*(call_569172: Call_RestartNode_569165; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a Service Fabric cluster node that is already started.
  ## 
  let valid = call_569172.validator(path, query, header, formData, body)
  let scheme = call_569172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569172.url(scheme.get, call_569172.host, call_569172.base,
                         call_569172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569172, url, valid)

proc call*(call_569173: Call_RestartNode_569165; nodeName: string;
          RestartNodeDescription: JsonNode; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## restartNode
  ## Restarts a Service Fabric cluster node that is already started.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   RestartNodeDescription: JObject (required)
  ##                         : The instance of the node to be restarted and a flag indicating the need to take dump of the fabric process.
  var path_569174 = newJObject()
  var query_569175 = newJObject()
  var body_569176 = newJObject()
  add(query_569175, "timeout", newJInt(timeout))
  add(query_569175, "api-version", newJString(apiVersion))
  add(path_569174, "nodeName", newJString(nodeName))
  if RestartNodeDescription != nil:
    body_569176 = RestartNodeDescription
  result = call_569173.call(path_569174, query_569175, nil, nil, body_569176)

var restartNode* = Call_RestartNode_569165(name: "restartNode",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local:19080",
                                        route: "/Nodes/{nodeName}/$/Restart",
                                        validator: validate_RestartNode_569166,
                                        base: "", url: url_RestartNode_569167,
                                        schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartNode_569177 = ref object of OpenApiRestCall_567666
proc url_StartNode_569179(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_StartNode_569178(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569180 = path.getOrDefault("nodeName")
  valid_569180 = validateParameter(valid_569180, JString, required = true,
                                 default = nil)
  if valid_569180 != nil:
    section.add "nodeName", valid_569180
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569181 = query.getOrDefault("timeout")
  valid_569181 = validateParameter(valid_569181, JInt, required = false,
                                 default = newJInt(60))
  if valid_569181 != nil:
    section.add "timeout", valid_569181
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569182 = query.getOrDefault("api-version")
  valid_569182 = validateParameter(valid_569182, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569182 != nil:
    section.add "api-version", valid_569182
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

proc call*(call_569184: Call_StartNode_569177; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a Service Fabric cluster node that is already stopped.
  ## 
  let valid = call_569184.validator(path, query, header, formData, body)
  let scheme = call_569184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569184.url(scheme.get, call_569184.host, call_569184.base,
                         call_569184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569184, url, valid)

proc call*(call_569185: Call_StartNode_569177; nodeName: string;
          StartNodeDescription: JsonNode; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## startNode
  ## Starts a Service Fabric cluster node that is already stopped.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   StartNodeDescription: JObject (required)
  ##                       : The instance id of the stopped node that needs to be started.
  var path_569186 = newJObject()
  var query_569187 = newJObject()
  var body_569188 = newJObject()
  add(query_569187, "timeout", newJInt(timeout))
  add(query_569187, "api-version", newJString(apiVersion))
  add(path_569186, "nodeName", newJString(nodeName))
  if StartNodeDescription != nil:
    body_569188 = StartNodeDescription
  result = call_569185.call(path_569186, query_569187, nil, nil, body_569188)

var startNode* = Call_StartNode_569177(name: "startNode", meth: HttpMethod.HttpPost,
                                    host: "azure.local:19080",
                                    route: "/Nodes/{nodeName}/$/Start",
                                    validator: validate_StartNode_569178,
                                    base: "", url: url_StartNode_569179,
                                    schemes: {Scheme.Https, Scheme.Http})
type
  Call_StopNode_569189 = ref object of OpenApiRestCall_567666
proc url_StopNode_569191(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_StopNode_569190(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569192 = path.getOrDefault("nodeName")
  valid_569192 = validateParameter(valid_569192, JString, required = true,
                                 default = nil)
  if valid_569192 != nil:
    section.add "nodeName", valid_569192
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569193 = query.getOrDefault("timeout")
  valid_569193 = validateParameter(valid_569193, JInt, required = false,
                                 default = newJInt(60))
  if valid_569193 != nil:
    section.add "timeout", valid_569193
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569194 = query.getOrDefault("api-version")
  valid_569194 = validateParameter(valid_569194, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569194 != nil:
    section.add "api-version", valid_569194
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

proc call*(call_569196: Call_StopNode_569189; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a Service Fabric cluster node that is in a started state. The node will stay down until start node is called.
  ## 
  let valid = call_569196.validator(path, query, header, formData, body)
  let scheme = call_569196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569196.url(scheme.get, call_569196.host, call_569196.base,
                         call_569196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569196, url, valid)

proc call*(call_569197: Call_StopNode_569189; nodeName: string;
          StopNodeDescription: JsonNode; timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## stopNode
  ## Stops a Service Fabric cluster node that is in a started state. The node will stay down until start node is called.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  ##   StopNodeDescription: JObject (required)
  ##                      : The instance id of the stopped node that needs to be stopped.
  var path_569198 = newJObject()
  var query_569199 = newJObject()
  var body_569200 = newJObject()
  add(query_569199, "timeout", newJInt(timeout))
  add(query_569199, "api-version", newJString(apiVersion))
  add(path_569198, "nodeName", newJString(nodeName))
  if StopNodeDescription != nil:
    body_569200 = StopNodeDescription
  result = call_569197.call(path_569198, query_569199, nil, nil, body_569200)

var stopNode* = Call_StopNode_569189(name: "stopNode", meth: HttpMethod.HttpPost,
                                  host: "azure.local:19080",
                                  route: "/Nodes/{nodeName}/$/Stop",
                                  validator: validate_StopNode_569190, base: "",
                                  url: url_StopNode_569191,
                                  schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetPartitionInfo_569201 = ref object of OpenApiRestCall_567666
proc url_GetPartitionInfo_569203(protocol: Scheme; host: string; base: string;
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

proc validate_GetPartitionInfo_569202(path: JsonNode; query: JsonNode;
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
  var valid_569204 = path.getOrDefault("partitionId")
  valid_569204 = validateParameter(valid_569204, JString, required = true,
                                 default = nil)
  if valid_569204 != nil:
    section.add "partitionId", valid_569204
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569205 = query.getOrDefault("timeout")
  valid_569205 = validateParameter(valid_569205, JInt, required = false,
                                 default = newJInt(60))
  if valid_569205 != nil:
    section.add "timeout", valid_569205
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569206 = query.getOrDefault("api-version")
  valid_569206 = validateParameter(valid_569206, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569206 != nil:
    section.add "api-version", valid_569206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569207: Call_GetPartitionInfo_569201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Partitions endpoint returns information about the specified partition. The response include the partition id, partitioning scheme information, keys supported by the partition, status, health and other details about the partition.
  ## 
  let valid = call_569207.validator(path, query, header, formData, body)
  let scheme = call_569207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569207.url(scheme.get, call_569207.host, call_569207.base,
                         call_569207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569207, url, valid)

proc call*(call_569208: Call_GetPartitionInfo_569201; partitionId: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getPartitionInfo
  ## The Partitions endpoint returns information about the specified partition. The response include the partition id, partitioning scheme information, keys supported by the partition, status, health and other details about the partition.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_569209 = newJObject()
  var query_569210 = newJObject()
  add(query_569210, "timeout", newJInt(timeout))
  add(query_569210, "api-version", newJString(apiVersion))
  add(path_569209, "partitionId", newJString(partitionId))
  result = call_569208.call(path_569209, query_569210, nil, nil, nil)

var getPartitionInfo* = Call_GetPartitionInfo_569201(name: "getPartitionInfo",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}", validator: validate_GetPartitionInfo_569202,
    base: "", url: url_GetPartitionInfo_569203, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetPartitionHealthUsingPolicy_569223 = ref object of OpenApiRestCall_567666
proc url_GetPartitionHealthUsingPolicy_569225(protocol: Scheme; host: string;
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

proc validate_GetPartitionHealthUsingPolicy_569224(path: JsonNode; query: JsonNode;
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
  var valid_569226 = path.getOrDefault("partitionId")
  valid_569226 = validateParameter(valid_569226, JString, required = true,
                                 default = nil)
  if valid_569226 != nil:
    section.add "partitionId", valid_569226
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
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
  var valid_569227 = query.getOrDefault("timeout")
  valid_569227 = validateParameter(valid_569227, JInt, required = false,
                                 default = newJInt(60))
  if valid_569227 != nil:
    section.add "timeout", valid_569227
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569228 = query.getOrDefault("api-version")
  valid_569228 = validateParameter(valid_569228, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569228 != nil:
    section.add "api-version", valid_569228
  var valid_569229 = query.getOrDefault("ReplicasHealthStateFilter")
  valid_569229 = validateParameter(valid_569229, JInt, required = false,
                                 default = newJInt(0))
  if valid_569229 != nil:
    section.add "ReplicasHealthStateFilter", valid_569229
  var valid_569230 = query.getOrDefault("EventsHealthStateFilter")
  valid_569230 = validateParameter(valid_569230, JInt, required = false,
                                 default = newJInt(0))
  if valid_569230 != nil:
    section.add "EventsHealthStateFilter", valid_569230
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

proc call*(call_569232: Call_GetPartitionHealthUsingPolicy_569223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health information of the specified partition.
  ## If the application health policy is specified, the health evaluation uses it to get the aggregated health state.
  ## If the policy is not specified, the health evaluation uses the application health policy defined in the application manifest, or the default health policy, if no policy is defined in the manifest.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the partition based on the health state.
  ## Use ReplicasHealthStateFilter to filter the collection of ReplicaHealthState objects on the partition. Use ApplicationHealthPolicy in the POST body to override the health policies used to evaluate the health.
  ## If you specify a partition that does not exist in the health store, this cmdlet returns an error.
  ## 
  ## 
  let valid = call_569232.validator(path, query, header, formData, body)
  let scheme = call_569232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569232.url(scheme.get, call_569232.host, call_569232.base,
                         call_569232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569232, url, valid)

proc call*(call_569233: Call_GetPartitionHealthUsingPolicy_569223;
          partitionId: string; timeout: int = 60; apiVersion: string = "3.0";
          ReplicasHealthStateFilter: int = 0;
          ApplicationHealthPolicy: JsonNode = nil; EventsHealthStateFilter: int = 0): Recallable =
  ## getPartitionHealthUsingPolicy
  ## Gets the health information of the specified partition.
  ## If the application health policy is specified, the health evaluation uses it to get the aggregated health state.
  ## If the policy is not specified, the health evaluation uses the application health policy defined in the application manifest, or the default health policy, if no policy is defined in the manifest.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the partition based on the health state.
  ## Use ReplicasHealthStateFilter to filter the collection of ReplicaHealthState objects on the partition. Use ApplicationHealthPolicy in the POST body to override the health policies used to evaluate the health.
  ## If you specify a partition that does not exist in the health store, this cmdlet returns an error.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
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
  ##   ApplicationHealthPolicy: JObject
  ##                          : Describes the health policies used to evaluate the health of an application or one of its children.
  ## If not present, the health evaluation uses the health policy from application manifest or the default health policy.
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
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_569234 = newJObject()
  var query_569235 = newJObject()
  var body_569236 = newJObject()
  add(query_569235, "timeout", newJInt(timeout))
  add(query_569235, "api-version", newJString(apiVersion))
  add(query_569235, "ReplicasHealthStateFilter",
      newJInt(ReplicasHealthStateFilter))
  if ApplicationHealthPolicy != nil:
    body_569236 = ApplicationHealthPolicy
  add(query_569235, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_569234, "partitionId", newJString(partitionId))
  result = call_569233.call(path_569234, query_569235, nil, nil, body_569236)

var getPartitionHealthUsingPolicy* = Call_GetPartitionHealthUsingPolicy_569223(
    name: "getPartitionHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/GetHealth",
    validator: validate_GetPartitionHealthUsingPolicy_569224, base: "",
    url: url_GetPartitionHealthUsingPolicy_569225,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetPartitionHealth_569211 = ref object of OpenApiRestCall_567666
proc url_GetPartitionHealth_569213(protocol: Scheme; host: string; base: string;
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

proc validate_GetPartitionHealth_569212(path: JsonNode; query: JsonNode;
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
  var valid_569214 = path.getOrDefault("partitionId")
  valid_569214 = validateParameter(valid_569214, JString, required = true,
                                 default = nil)
  if valid_569214 != nil:
    section.add "partitionId", valid_569214
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
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
  var valid_569215 = query.getOrDefault("timeout")
  valid_569215 = validateParameter(valid_569215, JInt, required = false,
                                 default = newJInt(60))
  if valid_569215 != nil:
    section.add "timeout", valid_569215
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569216 = query.getOrDefault("api-version")
  valid_569216 = validateParameter(valid_569216, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569216 != nil:
    section.add "api-version", valid_569216
  var valid_569217 = query.getOrDefault("ReplicasHealthStateFilter")
  valid_569217 = validateParameter(valid_569217, JInt, required = false,
                                 default = newJInt(0))
  if valid_569217 != nil:
    section.add "ReplicasHealthStateFilter", valid_569217
  var valid_569218 = query.getOrDefault("EventsHealthStateFilter")
  valid_569218 = validateParameter(valid_569218, JInt, required = false,
                                 default = newJInt(0))
  if valid_569218 != nil:
    section.add "EventsHealthStateFilter", valid_569218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569219: Call_GetPartitionHealth_569211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health information of the specified partition.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the service based on the health state.
  ## Use ReplicasHealthStateFilter to filter the collection of ReplicaHealthState objects on the partition.
  ## If you specify a partition that does not exist in the health store, this cmdlet returns an error.
  ## 
  ## 
  let valid = call_569219.validator(path, query, header, formData, body)
  let scheme = call_569219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569219.url(scheme.get, call_569219.host, call_569219.base,
                         call_569219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569219, url, valid)

proc call*(call_569220: Call_GetPartitionHealth_569211; partitionId: string;
          timeout: int = 60; apiVersion: string = "3.0";
          ReplicasHealthStateFilter: int = 0; EventsHealthStateFilter: int = 0): Recallable =
  ## getPartitionHealth
  ## Gets the health information of the specified partition.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the service based on the health state.
  ## Use ReplicasHealthStateFilter to filter the collection of ReplicaHealthState objects on the partition.
  ## If you specify a partition that does not exist in the health store, this cmdlet returns an error.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
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
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_569221 = newJObject()
  var query_569222 = newJObject()
  add(query_569222, "timeout", newJInt(timeout))
  add(query_569222, "api-version", newJString(apiVersion))
  add(query_569222, "ReplicasHealthStateFilter",
      newJInt(ReplicasHealthStateFilter))
  add(query_569222, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_569221, "partitionId", newJString(partitionId))
  result = call_569220.call(path_569221, query_569222, nil, nil, nil)

var getPartitionHealth* = Call_GetPartitionHealth_569211(
    name: "getPartitionHealth", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetHealth",
    validator: validate_GetPartitionHealth_569212, base: "",
    url: url_GetPartitionHealth_569213, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetPartitionLoadInformation_569237 = ref object of OpenApiRestCall_567666
proc url_GetPartitionLoadInformation_569239(protocol: Scheme; host: string;
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

proc validate_GetPartitionLoadInformation_569238(path: JsonNode; query: JsonNode;
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
  var valid_569240 = path.getOrDefault("partitionId")
  valid_569240 = validateParameter(valid_569240, JString, required = true,
                                 default = nil)
  if valid_569240 != nil:
    section.add "partitionId", valid_569240
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569241 = query.getOrDefault("timeout")
  valid_569241 = validateParameter(valid_569241, JInt, required = false,
                                 default = newJInt(60))
  if valid_569241 != nil:
    section.add "timeout", valid_569241
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569242 = query.getOrDefault("api-version")
  valid_569242 = validateParameter(valid_569242, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569242 != nil:
    section.add "api-version", valid_569242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569243: Call_GetPartitionLoadInformation_569237; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the specified partition.
  ## The response includes a list of load information.
  ## Each information includes load metric name, value and last reported time in UTC.
  ## 
  ## 
  let valid = call_569243.validator(path, query, header, formData, body)
  let scheme = call_569243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569243.url(scheme.get, call_569243.host, call_569243.base,
                         call_569243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569243, url, valid)

proc call*(call_569244: Call_GetPartitionLoadInformation_569237;
          partitionId: string; timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getPartitionLoadInformation
  ## Returns information about the specified partition.
  ## The response includes a list of load information.
  ## Each information includes load metric name, value and last reported time in UTC.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_569245 = newJObject()
  var query_569246 = newJObject()
  add(query_569246, "timeout", newJInt(timeout))
  add(query_569246, "api-version", newJString(apiVersion))
  add(path_569245, "partitionId", newJString(partitionId))
  result = call_569244.call(path_569245, query_569246, nil, nil, nil)

var getPartitionLoadInformation* = Call_GetPartitionLoadInformation_569237(
    name: "getPartitionLoadInformation", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetLoadInformation",
    validator: validate_GetPartitionLoadInformation_569238, base: "",
    url: url_GetPartitionLoadInformation_569239,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetReplicaInfoList_569247 = ref object of OpenApiRestCall_567666
proc url_GetReplicaInfoList_569249(protocol: Scheme; host: string; base: string;
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

proc validate_GetReplicaInfoList_569248(path: JsonNode; query: JsonNode;
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
  var valid_569250 = path.getOrDefault("partitionId")
  valid_569250 = validateParameter(valid_569250, JString, required = true,
                                 default = nil)
  if valid_569250 != nil:
    section.add "partitionId", valid_569250
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  section = newJObject()
  var valid_569251 = query.getOrDefault("timeout")
  valid_569251 = validateParameter(valid_569251, JInt, required = false,
                                 default = newJInt(60))
  if valid_569251 != nil:
    section.add "timeout", valid_569251
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569252 = query.getOrDefault("api-version")
  valid_569252 = validateParameter(valid_569252, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569252 != nil:
    section.add "api-version", valid_569252
  var valid_569253 = query.getOrDefault("ContinuationToken")
  valid_569253 = validateParameter(valid_569253, JString, required = false,
                                 default = nil)
  if valid_569253 != nil:
    section.add "ContinuationToken", valid_569253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569254: Call_GetReplicaInfoList_569247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetReplicas endpoint returns information about the replicas of the specified partition. The respons include the id, role, status, health, node name, uptime, and other details about the replica.
  ## 
  let valid = call_569254.validator(path, query, header, formData, body)
  let scheme = call_569254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569254.url(scheme.get, call_569254.host, call_569254.base,
                         call_569254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569254, url, valid)

proc call*(call_569255: Call_GetReplicaInfoList_569247; partitionId: string;
          timeout: int = 60; apiVersion: string = "3.0"; ContinuationToken: string = ""): Recallable =
  ## getReplicaInfoList
  ## The GetReplicas endpoint returns information about the replicas of the specified partition. The respons include the id, role, status, health, node name, uptime, and other details about the replica.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  ##   ContinuationToken: string
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  var path_569256 = newJObject()
  var query_569257 = newJObject()
  add(query_569257, "timeout", newJInt(timeout))
  add(query_569257, "api-version", newJString(apiVersion))
  add(path_569256, "partitionId", newJString(partitionId))
  add(query_569257, "ContinuationToken", newJString(ContinuationToken))
  result = call_569255.call(path_569256, query_569257, nil, nil, nil)

var getReplicaInfoList* = Call_GetReplicaInfoList_569247(
    name: "getReplicaInfoList", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetReplicas",
    validator: validate_GetReplicaInfoList_569248, base: "",
    url: url_GetReplicaInfoList_569249, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetReplicaInfo_569258 = ref object of OpenApiRestCall_567666
proc url_GetReplicaInfo_569260(protocol: Scheme; host: string; base: string;
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

proc validate_GetReplicaInfo_569259(path: JsonNode; query: JsonNode;
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
  var valid_569261 = path.getOrDefault("replicaId")
  valid_569261 = validateParameter(valid_569261, JString, required = true,
                                 default = nil)
  if valid_569261 != nil:
    section.add "replicaId", valid_569261
  var valid_569262 = path.getOrDefault("partitionId")
  valid_569262 = validateParameter(valid_569262, JString, required = true,
                                 default = nil)
  if valid_569262 != nil:
    section.add "partitionId", valid_569262
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  section = newJObject()
  var valid_569263 = query.getOrDefault("timeout")
  valid_569263 = validateParameter(valid_569263, JInt, required = false,
                                 default = newJInt(60))
  if valid_569263 != nil:
    section.add "timeout", valid_569263
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569264 = query.getOrDefault("api-version")
  valid_569264 = validateParameter(valid_569264, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569264 != nil:
    section.add "api-version", valid_569264
  var valid_569265 = query.getOrDefault("ContinuationToken")
  valid_569265 = validateParameter(valid_569265, JString, required = false,
                                 default = nil)
  if valid_569265 != nil:
    section.add "ContinuationToken", valid_569265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569266: Call_GetReplicaInfo_569258; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The respons include the id, role, status, health, node name, uptime, and other details about the replica.
  ## 
  let valid = call_569266.validator(path, query, header, formData, body)
  let scheme = call_569266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569266.url(scheme.get, call_569266.host, call_569266.base,
                         call_569266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569266, url, valid)

proc call*(call_569267: Call_GetReplicaInfo_569258; replicaId: string;
          partitionId: string; timeout: int = 60; apiVersion: string = "3.0";
          ContinuationToken: string = ""): Recallable =
  ## getReplicaInfo
  ## The respons include the id, role, status, health, node name, uptime, and other details about the replica.
  ##   replicaId: string (required)
  ##            : The identifier of the replica.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  ##   ContinuationToken: string
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  var path_569268 = newJObject()
  var query_569269 = newJObject()
  add(path_569268, "replicaId", newJString(replicaId))
  add(query_569269, "timeout", newJInt(timeout))
  add(query_569269, "api-version", newJString(apiVersion))
  add(path_569268, "partitionId", newJString(partitionId))
  add(query_569269, "ContinuationToken", newJString(ContinuationToken))
  result = call_569267.call(path_569268, query_569269, nil, nil, nil)

var getReplicaInfo* = Call_GetReplicaInfo_569258(name: "getReplicaInfo",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}",
    validator: validate_GetReplicaInfo_569259, base: "", url: url_GetReplicaInfo_569260,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetReplicaHealthUsingPolicy_569282 = ref object of OpenApiRestCall_567666
proc url_GetReplicaHealthUsingPolicy_569284(protocol: Scheme; host: string;
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

proc validate_GetReplicaHealthUsingPolicy_569283(path: JsonNode; query: JsonNode;
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
  var valid_569285 = path.getOrDefault("replicaId")
  valid_569285 = validateParameter(valid_569285, JString, required = true,
                                 default = nil)
  if valid_569285 != nil:
    section.add "replicaId", valid_569285
  var valid_569286 = path.getOrDefault("partitionId")
  valid_569286 = validateParameter(valid_569286, JString, required = true,
                                 default = nil)
  if valid_569286 != nil:
    section.add "partitionId", valid_569286
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
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
  var valid_569287 = query.getOrDefault("timeout")
  valid_569287 = validateParameter(valid_569287, JInt, required = false,
                                 default = newJInt(60))
  if valid_569287 != nil:
    section.add "timeout", valid_569287
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569288 = query.getOrDefault("api-version")
  valid_569288 = validateParameter(valid_569288, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569288 != nil:
    section.add "api-version", valid_569288
  var valid_569289 = query.getOrDefault("EventsHealthStateFilter")
  valid_569289 = validateParameter(valid_569289, JInt, required = false,
                                 default = newJInt(0))
  if valid_569289 != nil:
    section.add "EventsHealthStateFilter", valid_569289
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

proc call*(call_569291: Call_GetReplicaHealthUsingPolicy_569282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric stateful service replica or stateless service instance.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the cluster based on the health state.
  ## Use ApplicationHealthPolicy to optionally override the health policies used to evaluate the health. This API only uses 'ConsiderWarningAsError' field of the ApplicationHealthPolicy. The rest of the fields are ignored while evaluating the health of the replica.
  ## 
  ## 
  let valid = call_569291.validator(path, query, header, formData, body)
  let scheme = call_569291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569291.url(scheme.get, call_569291.host, call_569291.base,
                         call_569291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569291, url, valid)

proc call*(call_569292: Call_GetReplicaHealthUsingPolicy_569282; replicaId: string;
          partitionId: string; timeout: int = 60; apiVersion: string = "3.0";
          ApplicationHealthPolicy: JsonNode = nil; EventsHealthStateFilter: int = 0): Recallable =
  ## getReplicaHealthUsingPolicy
  ## Gets the health of a Service Fabric stateful service replica or stateless service instance.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the cluster based on the health state.
  ## Use ApplicationHealthPolicy to optionally override the health policies used to evaluate the health. This API only uses 'ConsiderWarningAsError' field of the ApplicationHealthPolicy. The rest of the fields are ignored while evaluating the health of the replica.
  ## 
  ##   replicaId: string (required)
  ##            : The identifier of the replica.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationHealthPolicy: JObject
  ##                          : Describes the health policies used to evaluate the health of an application or one of its children.
  ## If not present, the health evaluation uses the health policy from application manifest or the default health policy.
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
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_569293 = newJObject()
  var query_569294 = newJObject()
  var body_569295 = newJObject()
  add(path_569293, "replicaId", newJString(replicaId))
  add(query_569294, "timeout", newJInt(timeout))
  add(query_569294, "api-version", newJString(apiVersion))
  if ApplicationHealthPolicy != nil:
    body_569295 = ApplicationHealthPolicy
  add(query_569294, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_569293, "partitionId", newJString(partitionId))
  result = call_569292.call(path_569293, query_569294, nil, nil, body_569295)

var getReplicaHealthUsingPolicy* = Call_GetReplicaHealthUsingPolicy_569282(
    name: "getReplicaHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}/$/GetHealth",
    validator: validate_GetReplicaHealthUsingPolicy_569283, base: "",
    url: url_GetReplicaHealthUsingPolicy_569284,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetReplicaHealth_569270 = ref object of OpenApiRestCall_567666
proc url_GetReplicaHealth_569272(protocol: Scheme; host: string; base: string;
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

proc validate_GetReplicaHealth_569271(path: JsonNode; query: JsonNode;
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
  var valid_569273 = path.getOrDefault("replicaId")
  valid_569273 = validateParameter(valid_569273, JString, required = true,
                                 default = nil)
  if valid_569273 != nil:
    section.add "replicaId", valid_569273
  var valid_569274 = path.getOrDefault("partitionId")
  valid_569274 = validateParameter(valid_569274, JString, required = true,
                                 default = nil)
  if valid_569274 != nil:
    section.add "partitionId", valid_569274
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
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
  var valid_569275 = query.getOrDefault("timeout")
  valid_569275 = validateParameter(valid_569275, JInt, required = false,
                                 default = newJInt(60))
  if valid_569275 != nil:
    section.add "timeout", valid_569275
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569276 = query.getOrDefault("api-version")
  valid_569276 = validateParameter(valid_569276, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569276 != nil:
    section.add "api-version", valid_569276
  var valid_569277 = query.getOrDefault("EventsHealthStateFilter")
  valid_569277 = validateParameter(valid_569277, JInt, required = false,
                                 default = newJInt(0))
  if valid_569277 != nil:
    section.add "EventsHealthStateFilter", valid_569277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569278: Call_GetReplicaHealth_569270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric replica.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the replica based on the health state.
  ## 
  ## 
  let valid = call_569278.validator(path, query, header, formData, body)
  let scheme = call_569278.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569278.url(scheme.get, call_569278.host, call_569278.base,
                         call_569278.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569278, url, valid)

proc call*(call_569279: Call_GetReplicaHealth_569270; replicaId: string;
          partitionId: string; timeout: int = 60; apiVersion: string = "3.0";
          EventsHealthStateFilter: int = 0): Recallable =
  ## getReplicaHealth
  ## Gets the health of a Service Fabric replica.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the replica based on the health state.
  ## 
  ##   replicaId: string (required)
  ##            : The identifier of the replica.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
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
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_569280 = newJObject()
  var query_569281 = newJObject()
  add(path_569280, "replicaId", newJString(replicaId))
  add(query_569281, "timeout", newJInt(timeout))
  add(query_569281, "api-version", newJString(apiVersion))
  add(query_569281, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_569280, "partitionId", newJString(partitionId))
  result = call_569279.call(path_569280, query_569281, nil, nil, nil)

var getReplicaHealth* = Call_GetReplicaHealth_569270(name: "getReplicaHealth",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}/$/GetHealth",
    validator: validate_GetReplicaHealth_569271, base: "",
    url: url_GetReplicaHealth_569272, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportReplicaHealth_569296 = ref object of OpenApiRestCall_567666
proc url_ReportReplicaHealth_569298(protocol: Scheme; host: string; base: string;
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

proc validate_ReportReplicaHealth_569297(path: JsonNode; query: JsonNode;
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
  var valid_569299 = path.getOrDefault("replicaId")
  valid_569299 = validateParameter(valid_569299, JString, required = true,
                                 default = nil)
  if valid_569299 != nil:
    section.add "replicaId", valid_569299
  var valid_569300 = path.getOrDefault("partitionId")
  valid_569300 = validateParameter(valid_569300, JString, required = true,
                                 default = nil)
  if valid_569300 != nil:
    section.add "partitionId", valid_569300
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ServiceKind: JString (required)
  ##              : The kind of service replica (Stateless or Stateful) for which the health is being reported. Following are the possible values.
  ## - Stateless - Does not use Service Fabric to make its state highly available or reliable. The value is 1
  ## - Stateful - Uses Service Fabric to make its state or part of its state highly available and reliable. The value is 2.
  ## 
  section = newJObject()
  var valid_569301 = query.getOrDefault("timeout")
  valid_569301 = validateParameter(valid_569301, JInt, required = false,
                                 default = newJInt(60))
  if valid_569301 != nil:
    section.add "timeout", valid_569301
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569302 = query.getOrDefault("api-version")
  valid_569302 = validateParameter(valid_569302, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569302 != nil:
    section.add "api-version", valid_569302
  var valid_569303 = query.getOrDefault("ServiceKind")
  valid_569303 = validateParameter(valid_569303, JString, required = true,
                                 default = newJString("Stateful"))
  if valid_569303 != nil:
    section.add "ServiceKind", valid_569303
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

proc call*(call_569305: Call_ReportReplicaHealth_569296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reports health state of the specified Service Fabric replica. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Replica, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetReplicaHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_569305.validator(path, query, header, formData, body)
  let scheme = call_569305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569305.url(scheme.get, call_569305.host, call_569305.base,
                         call_569305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569305, url, valid)

proc call*(call_569306: Call_ReportReplicaHealth_569296; replicaId: string;
          HealthInformation: JsonNode; partitionId: string; timeout: int = 60;
          apiVersion: string = "3.0"; ServiceKind: string = "Stateful"): Recallable =
  ## reportReplicaHealth
  ## Reports health state of the specified Service Fabric replica. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Replica, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetReplicaHealth and check that the report appears in the HealthEvents section.
  ## 
  ##   replicaId: string (required)
  ##            : The identifier of the replica.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  ##   ServiceKind: string (required)
  ##              : The kind of service replica (Stateless or Stateful) for which the health is being reported. Following are the possible values.
  ## - Stateless - Does not use Service Fabric to make its state highly available or reliable. The value is 1
  ## - Stateful - Uses Service Fabric to make its state or part of its state highly available and reliable. The value is 2.
  ## 
  var path_569307 = newJObject()
  var query_569308 = newJObject()
  var body_569309 = newJObject()
  add(path_569307, "replicaId", newJString(replicaId))
  add(query_569308, "timeout", newJInt(timeout))
  add(query_569308, "api-version", newJString(apiVersion))
  if HealthInformation != nil:
    body_569309 = HealthInformation
  add(path_569307, "partitionId", newJString(partitionId))
  add(query_569308, "ServiceKind", newJString(ServiceKind))
  result = call_569306.call(path_569307, query_569308, nil, nil, body_569309)

var reportReplicaHealth* = Call_ReportReplicaHealth_569296(
    name: "reportReplicaHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}/$/ReportHealth",
    validator: validate_ReportReplicaHealth_569297, base: "",
    url: url_ReportReplicaHealth_569298, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceNameInfo_569310 = ref object of OpenApiRestCall_567666
proc url_GetServiceNameInfo_569312(protocol: Scheme; host: string; base: string;
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

proc validate_GetServiceNameInfo_569311(path: JsonNode; query: JsonNode;
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
  var valid_569313 = path.getOrDefault("partitionId")
  valid_569313 = validateParameter(valid_569313, JString, required = true,
                                 default = nil)
  if valid_569313 != nil:
    section.add "partitionId", valid_569313
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569314 = query.getOrDefault("timeout")
  valid_569314 = validateParameter(valid_569314, JInt, required = false,
                                 default = newJInt(60))
  if valid_569314 != nil:
    section.add "timeout", valid_569314
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569315 = query.getOrDefault("api-version")
  valid_569315 = validateParameter(valid_569315, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569315 != nil:
    section.add "api-version", valid_569315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569316: Call_GetServiceNameInfo_569310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetServiceName endpoint returns the name of the service for the specified partition.
  ## 
  let valid = call_569316.validator(path, query, header, formData, body)
  let scheme = call_569316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569316.url(scheme.get, call_569316.host, call_569316.base,
                         call_569316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569316, url, valid)

proc call*(call_569317: Call_GetServiceNameInfo_569310; partitionId: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getServiceNameInfo
  ## The GetServiceName endpoint returns the name of the service for the specified partition.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_569318 = newJObject()
  var query_569319 = newJObject()
  add(query_569319, "timeout", newJInt(timeout))
  add(query_569319, "api-version", newJString(apiVersion))
  add(path_569318, "partitionId", newJString(partitionId))
  result = call_569317.call(path_569318, query_569319, nil, nil, nil)

var getServiceNameInfo* = Call_GetServiceNameInfo_569310(
    name: "getServiceNameInfo", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetServiceName",
    validator: validate_GetServiceNameInfo_569311, base: "",
    url: url_GetServiceNameInfo_569312, schemes: {Scheme.Https, Scheme.Http})
type
  Call_RecoverPartition_569320 = ref object of OpenApiRestCall_567666
proc url_RecoverPartition_569322(protocol: Scheme; host: string; base: string;
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

proc validate_RecoverPartition_569321(path: JsonNode; query: JsonNode;
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
  var valid_569323 = path.getOrDefault("partitionId")
  valid_569323 = validateParameter(valid_569323, JString, required = true,
                                 default = nil)
  if valid_569323 != nil:
    section.add "partitionId", valid_569323
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569324 = query.getOrDefault("timeout")
  valid_569324 = validateParameter(valid_569324, JInt, required = false,
                                 default = newJInt(60))
  if valid_569324 != nil:
    section.add "timeout", valid_569324
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569325 = query.getOrDefault("api-version")
  valid_569325 = validateParameter(valid_569325, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569325 != nil:
    section.add "api-version", valid_569325
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569326: Call_RecoverPartition_569320; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicates to the Service Fabric cluster that it should attempt to recover a specific partition which is currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ## 
  let valid = call_569326.validator(path, query, header, formData, body)
  let scheme = call_569326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569326.url(scheme.get, call_569326.host, call_569326.base,
                         call_569326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569326, url, valid)

proc call*(call_569327: Call_RecoverPartition_569320; partitionId: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## recoverPartition
  ## Indicates to the Service Fabric cluster that it should attempt to recover a specific partition which is currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_569328 = newJObject()
  var query_569329 = newJObject()
  add(query_569329, "timeout", newJInt(timeout))
  add(query_569329, "api-version", newJString(apiVersion))
  add(path_569328, "partitionId", newJString(partitionId))
  result = call_569327.call(path_569328, query_569329, nil, nil, nil)

var recoverPartition* = Call_RecoverPartition_569320(name: "recoverPartition",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/Recover",
    validator: validate_RecoverPartition_569321, base: "",
    url: url_RecoverPartition_569322, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportPartitionHealth_569330 = ref object of OpenApiRestCall_567666
proc url_ReportPartitionHealth_569332(protocol: Scheme; host: string; base: string;
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

proc validate_ReportPartitionHealth_569331(path: JsonNode; query: JsonNode;
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
  var valid_569333 = path.getOrDefault("partitionId")
  valid_569333 = validateParameter(valid_569333, JString, required = true,
                                 default = nil)
  if valid_569333 != nil:
    section.add "partitionId", valid_569333
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569334 = query.getOrDefault("timeout")
  valid_569334 = validateParameter(valid_569334, JInt, required = false,
                                 default = newJInt(60))
  if valid_569334 != nil:
    section.add "timeout", valid_569334
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569335 = query.getOrDefault("api-version")
  valid_569335 = validateParameter(valid_569335, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569335 != nil:
    section.add "api-version", valid_569335
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

proc call*(call_569337: Call_ReportPartitionHealth_569330; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reports health state of the specified Service Fabric partition. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Partition, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetPartitionHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_569337.validator(path, query, header, formData, body)
  let scheme = call_569337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569337.url(scheme.get, call_569337.host, call_569337.base,
                         call_569337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569337, url, valid)

proc call*(call_569338: Call_ReportPartitionHealth_569330;
          HealthInformation: JsonNode; partitionId: string; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## reportPartitionHealth
  ## Reports health state of the specified Service Fabric partition. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Partition, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetPartitionHealth and check that the report appears in the HealthEvents section.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_569339 = newJObject()
  var query_569340 = newJObject()
  var body_569341 = newJObject()
  add(query_569340, "timeout", newJInt(timeout))
  add(query_569340, "api-version", newJString(apiVersion))
  if HealthInformation != nil:
    body_569341 = HealthInformation
  add(path_569339, "partitionId", newJString(partitionId))
  result = call_569338.call(path_569339, query_569340, nil, nil, body_569341)

var reportPartitionHealth* = Call_ReportPartitionHealth_569330(
    name: "reportPartitionHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/ReportHealth",
    validator: validate_ReportPartitionHealth_569331, base: "",
    url: url_ReportPartitionHealth_569332, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ResetPartitionLoad_569342 = ref object of OpenApiRestCall_567666
proc url_ResetPartitionLoad_569344(protocol: Scheme; host: string; base: string;
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

proc validate_ResetPartitionLoad_569343(path: JsonNode; query: JsonNode;
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
  var valid_569345 = path.getOrDefault("partitionId")
  valid_569345 = validateParameter(valid_569345, JString, required = true,
                                 default = nil)
  if valid_569345 != nil:
    section.add "partitionId", valid_569345
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569346 = query.getOrDefault("timeout")
  valid_569346 = validateParameter(valid_569346, JInt, required = false,
                                 default = newJInt(60))
  if valid_569346 != nil:
    section.add "timeout", valid_569346
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569347 = query.getOrDefault("api-version")
  valid_569347 = validateParameter(valid_569347, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569347 != nil:
    section.add "api-version", valid_569347
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569348: Call_ResetPartitionLoad_569342; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the current load of a Service Fabric partition to the default load for the service.
  ## 
  let valid = call_569348.validator(path, query, header, formData, body)
  let scheme = call_569348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569348.url(scheme.get, call_569348.host, call_569348.base,
                         call_569348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569348, url, valid)

proc call*(call_569349: Call_ResetPartitionLoad_569342; partitionId: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## resetPartitionLoad
  ## Resets the current load of a Service Fabric partition to the default load for the service.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_569350 = newJObject()
  var query_569351 = newJObject()
  add(query_569351, "timeout", newJInt(timeout))
  add(query_569351, "api-version", newJString(apiVersion))
  add(path_569350, "partitionId", newJString(partitionId))
  result = call_569349.call(path_569350, query_569351, nil, nil, nil)

var resetPartitionLoad* = Call_ResetPartitionLoad_569342(
    name: "resetPartitionLoad", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/ResetLoad",
    validator: validate_ResetPartitionLoad_569343, base: "",
    url: url_ResetPartitionLoad_569344, schemes: {Scheme.Https, Scheme.Http})
type
  Call_RecoverServicePartitions_569352 = ref object of OpenApiRestCall_567666
proc url_RecoverServicePartitions_569354(protocol: Scheme; host: string;
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

proc validate_RecoverServicePartitions_569353(path: JsonNode; query: JsonNode;
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
  var valid_569355 = path.getOrDefault("serviceId")
  valid_569355 = validateParameter(valid_569355, JString, required = true,
                                 default = nil)
  if valid_569355 != nil:
    section.add "serviceId", valid_569355
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569356 = query.getOrDefault("timeout")
  valid_569356 = validateParameter(valid_569356, JInt, required = false,
                                 default = newJInt(60))
  if valid_569356 != nil:
    section.add "timeout", valid_569356
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569357 = query.getOrDefault("api-version")
  valid_569357 = validateParameter(valid_569357, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569357 != nil:
    section.add "api-version", valid_569357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569358: Call_RecoverServicePartitions_569352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicates to the Service Fabric cluster that it should attempt to recover the specified service which is currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ## 
  let valid = call_569358.validator(path, query, header, formData, body)
  let scheme = call_569358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569358.url(scheme.get, call_569358.host, call_569358.base,
                         call_569358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569358, url, valid)

proc call*(call_569359: Call_RecoverServicePartitions_569352; serviceId: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## recoverServicePartitions
  ## Indicates to the Service Fabric cluster that it should attempt to recover the specified service which is currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_569360 = newJObject()
  var query_569361 = newJObject()
  add(query_569361, "timeout", newJInt(timeout))
  add(query_569361, "api-version", newJString(apiVersion))
  add(path_569360, "serviceId", newJString(serviceId))
  result = call_569359.call(path_569360, query_569361, nil, nil, nil)

var recoverServicePartitions* = Call_RecoverServicePartitions_569352(
    name: "recoverServicePartitions", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Services/$/{serviceId}/$/GetPartitions/$/Recover",
    validator: validate_RecoverServicePartitions_569353, base: "",
    url: url_RecoverServicePartitions_569354, schemes: {Scheme.Https, Scheme.Http})
type
  Call_DeleteService_569362 = ref object of OpenApiRestCall_567666
proc url_DeleteService_569364(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteService_569363(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569365 = path.getOrDefault("serviceId")
  valid_569365 = validateParameter(valid_569365, JString, required = true,
                                 default = nil)
  if valid_569365 != nil:
    section.add "serviceId", valid_569365
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ForceRemove: JBool
  ##              : Remove a Service Fabric application or service forcefully without going through the graceful shutdown sequence. This parameter can be used to forcefully delete an application or service for which delete is timing out due to issues in the service code that prevents graceful close of replicas.
  section = newJObject()
  var valid_569366 = query.getOrDefault("timeout")
  valid_569366 = validateParameter(valid_569366, JInt, required = false,
                                 default = newJInt(60))
  if valid_569366 != nil:
    section.add "timeout", valid_569366
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569367 = query.getOrDefault("api-version")
  valid_569367 = validateParameter(valid_569367, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569367 != nil:
    section.add "api-version", valid_569367
  var valid_569368 = query.getOrDefault("ForceRemove")
  valid_569368 = validateParameter(valid_569368, JBool, required = false, default = nil)
  if valid_569368 != nil:
    section.add "ForceRemove", valid_569368
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569369: Call_DeleteService_569362; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Service Fabric service. A service must be created before it can be deleted. By default Service Fabric will try to close service replicas in a graceful manner and then delete the service. However if service is having issues closing the replica gracefully, the delete operation may take a long time or get stuck. Use the optional ForceRemove flag to skip the graceful close sequence and forcefully delete the service.
  ## 
  let valid = call_569369.validator(path, query, header, formData, body)
  let scheme = call_569369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569369.url(scheme.get, call_569369.host, call_569369.base,
                         call_569369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569369, url, valid)

proc call*(call_569370: Call_DeleteService_569362; serviceId: string;
          timeout: int = 60; apiVersion: string = "3.0"; ForceRemove: bool = false): Recallable =
  ## deleteService
  ## Deletes an existing Service Fabric service. A service must be created before it can be deleted. By default Service Fabric will try to close service replicas in a graceful manner and then delete the service. However if service is having issues closing the replica gracefully, the delete operation may take a long time or get stuck. Use the optional ForceRemove flag to skip the graceful close sequence and forcefully delete the service.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ForceRemove: bool
  ##              : Remove a Service Fabric application or service forcefully without going through the graceful shutdown sequence. This parameter can be used to forcefully delete an application or service for which delete is timing out due to issues in the service code that prevents graceful close of replicas.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_569371 = newJObject()
  var query_569372 = newJObject()
  add(query_569372, "timeout", newJInt(timeout))
  add(query_569372, "api-version", newJString(apiVersion))
  add(query_569372, "ForceRemove", newJBool(ForceRemove))
  add(path_569371, "serviceId", newJString(serviceId))
  result = call_569370.call(path_569371, query_569372, nil, nil, nil)

var deleteService* = Call_DeleteService_569362(name: "deleteService",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Services/{serviceId}/$/Delete", validator: validate_DeleteService_569363,
    base: "", url: url_DeleteService_569364, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationNameInfo_569373 = ref object of OpenApiRestCall_567666
proc url_GetApplicationNameInfo_569375(protocol: Scheme; host: string; base: string;
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

proc validate_GetApplicationNameInfo_569374(path: JsonNode; query: JsonNode;
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
  var valid_569376 = path.getOrDefault("serviceId")
  valid_569376 = validateParameter(valid_569376, JString, required = true,
                                 default = nil)
  if valid_569376 != nil:
    section.add "serviceId", valid_569376
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569377 = query.getOrDefault("timeout")
  valid_569377 = validateParameter(valid_569377, JInt, required = false,
                                 default = newJInt(60))
  if valid_569377 != nil:
    section.add "timeout", valid_569377
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569378 = query.getOrDefault("api-version")
  valid_569378 = validateParameter(valid_569378, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569378 != nil:
    section.add "api-version", valid_569378
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569379: Call_GetApplicationNameInfo_569373; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetApplicationName endpoint returns the name of the application for the specified service.
  ## 
  let valid = call_569379.validator(path, query, header, formData, body)
  let scheme = call_569379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569379.url(scheme.get, call_569379.host, call_569379.base,
                         call_569379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569379, url, valid)

proc call*(call_569380: Call_GetApplicationNameInfo_569373; serviceId: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getApplicationNameInfo
  ## The GetApplicationName endpoint returns the name of the application for the specified service.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_569381 = newJObject()
  var query_569382 = newJObject()
  add(query_569382, "timeout", newJInt(timeout))
  add(query_569382, "api-version", newJString(apiVersion))
  add(path_569381, "serviceId", newJString(serviceId))
  result = call_569380.call(path_569381, query_569382, nil, nil, nil)

var getApplicationNameInfo* = Call_GetApplicationNameInfo_569373(
    name: "getApplicationNameInfo", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Services/{serviceId}/$/GetApplicationName",
    validator: validate_GetApplicationNameInfo_569374, base: "",
    url: url_GetApplicationNameInfo_569375, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceDescription_569383 = ref object of OpenApiRestCall_567666
proc url_GetServiceDescription_569385(protocol: Scheme; host: string; base: string;
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

proc validate_GetServiceDescription_569384(path: JsonNode; query: JsonNode;
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
  var valid_569386 = path.getOrDefault("serviceId")
  valid_569386 = validateParameter(valid_569386, JString, required = true,
                                 default = nil)
  if valid_569386 != nil:
    section.add "serviceId", valid_569386
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569387 = query.getOrDefault("timeout")
  valid_569387 = validateParameter(valid_569387, JInt, required = false,
                                 default = newJInt(60))
  if valid_569387 != nil:
    section.add "timeout", valid_569387
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569388 = query.getOrDefault("api-version")
  valid_569388 = validateParameter(valid_569388, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569388 != nil:
    section.add "api-version", valid_569388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569389: Call_GetServiceDescription_569383; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the description of an existing Service Fabric service. A service must be created before its description can be obtained.
  ## 
  let valid = call_569389.validator(path, query, header, formData, body)
  let scheme = call_569389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569389.url(scheme.get, call_569389.host, call_569389.base,
                         call_569389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569389, url, valid)

proc call*(call_569390: Call_GetServiceDescription_569383; serviceId: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getServiceDescription
  ## Gets the description of an existing Service Fabric service. A service must be created before its description can be obtained.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_569391 = newJObject()
  var query_569392 = newJObject()
  add(query_569392, "timeout", newJInt(timeout))
  add(query_569392, "api-version", newJString(apiVersion))
  add(path_569391, "serviceId", newJString(serviceId))
  result = call_569390.call(path_569391, query_569392, nil, nil, nil)

var getServiceDescription* = Call_GetServiceDescription_569383(
    name: "getServiceDescription", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Services/{serviceId}/$/GetDescription",
    validator: validate_GetServiceDescription_569384, base: "",
    url: url_GetServiceDescription_569385, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceHealthUsingPolicy_569405 = ref object of OpenApiRestCall_567666
proc url_GetServiceHealthUsingPolicy_569407(protocol: Scheme; host: string;
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

proc validate_GetServiceHealthUsingPolicy_569406(path: JsonNode; query: JsonNode;
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
  var valid_569408 = path.getOrDefault("serviceId")
  valid_569408 = validateParameter(valid_569408, JString, required = true,
                                 default = nil)
  if valid_569408 != nil:
    section.add "serviceId", valid_569408
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
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
  section = newJObject()
  var valid_569409 = query.getOrDefault("timeout")
  valid_569409 = validateParameter(valid_569409, JInt, required = false,
                                 default = newJInt(60))
  if valid_569409 != nil:
    section.add "timeout", valid_569409
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569410 = query.getOrDefault("api-version")
  valid_569410 = validateParameter(valid_569410, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569410 != nil:
    section.add "api-version", valid_569410
  var valid_569411 = query.getOrDefault("EventsHealthStateFilter")
  valid_569411 = validateParameter(valid_569411, JInt, required = false,
                                 default = newJInt(0))
  if valid_569411 != nil:
    section.add "EventsHealthStateFilter", valid_569411
  var valid_569412 = query.getOrDefault("PartitionsHealthStateFilter")
  valid_569412 = validateParameter(valid_569412, JInt, required = false,
                                 default = newJInt(0))
  if valid_569412 != nil:
    section.add "PartitionsHealthStateFilter", valid_569412
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

proc call*(call_569414: Call_GetServiceHealthUsingPolicy_569405; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health information of the specified service.
  ## If the application health policy is specified, the health evaluation uses it to get the aggregated health state.
  ## If the policy is not specified, the health evaluation uses the application health policy defined in the application manifest, or the default health policy, if no policy is defined in the manifest.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the service based on the health state.
  ## Use PartitionsHealthStateFilter to filter the collection of partitions returned.
  ## If you specify a service that does not exist in the health store, this cmdlet returns an error.
  ## 
  ## 
  let valid = call_569414.validator(path, query, header, formData, body)
  let scheme = call_569414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569414.url(scheme.get, call_569414.host, call_569414.base,
                         call_569414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569414, url, valid)

proc call*(call_569415: Call_GetServiceHealthUsingPolicy_569405; serviceId: string;
          timeout: int = 60; apiVersion: string = "3.0";
          ApplicationHealthPolicy: JsonNode = nil; EventsHealthStateFilter: int = 0;
          PartitionsHealthStateFilter: int = 0): Recallable =
  ## getServiceHealthUsingPolicy
  ## Gets the health information of the specified service.
  ## If the application health policy is specified, the health evaluation uses it to get the aggregated health state.
  ## If the policy is not specified, the health evaluation uses the application health policy defined in the application manifest, or the default health policy, if no policy is defined in the manifest.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the service based on the health state.
  ## Use PartitionsHealthStateFilter to filter the collection of partitions returned.
  ## If you specify a service that does not exist in the health store, this cmdlet returns an error.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationHealthPolicy: JObject
  ##                          : Describes the health policies used to evaluate the health of an application or one of its children.
  ## If not present, the health evaluation uses the health policy from application manifest or the default health policy.
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
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
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
  var path_569416 = newJObject()
  var query_569417 = newJObject()
  var body_569418 = newJObject()
  add(query_569417, "timeout", newJInt(timeout))
  add(query_569417, "api-version", newJString(apiVersion))
  if ApplicationHealthPolicy != nil:
    body_569418 = ApplicationHealthPolicy
  add(query_569417, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_569416, "serviceId", newJString(serviceId))
  add(query_569417, "PartitionsHealthStateFilter",
      newJInt(PartitionsHealthStateFilter))
  result = call_569415.call(path_569416, query_569417, nil, nil, body_569418)

var getServiceHealthUsingPolicy* = Call_GetServiceHealthUsingPolicy_569405(
    name: "getServiceHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Services/{serviceId}/$/GetHealth",
    validator: validate_GetServiceHealthUsingPolicy_569406, base: "",
    url: url_GetServiceHealthUsingPolicy_569407,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceHealth_569393 = ref object of OpenApiRestCall_567666
proc url_GetServiceHealth_569395(protocol: Scheme; host: string; base: string;
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

proc validate_GetServiceHealth_569394(path: JsonNode; query: JsonNode;
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
  var valid_569396 = path.getOrDefault("serviceId")
  valid_569396 = validateParameter(valid_569396, JString, required = true,
                                 default = nil)
  if valid_569396 != nil:
    section.add "serviceId", valid_569396
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
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
  section = newJObject()
  var valid_569397 = query.getOrDefault("timeout")
  valid_569397 = validateParameter(valid_569397, JInt, required = false,
                                 default = newJInt(60))
  if valid_569397 != nil:
    section.add "timeout", valid_569397
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569398 = query.getOrDefault("api-version")
  valid_569398 = validateParameter(valid_569398, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569398 != nil:
    section.add "api-version", valid_569398
  var valid_569399 = query.getOrDefault("EventsHealthStateFilter")
  valid_569399 = validateParameter(valid_569399, JInt, required = false,
                                 default = newJInt(0))
  if valid_569399 != nil:
    section.add "EventsHealthStateFilter", valid_569399
  var valid_569400 = query.getOrDefault("PartitionsHealthStateFilter")
  valid_569400 = validateParameter(valid_569400, JInt, required = false,
                                 default = newJInt(0))
  if valid_569400 != nil:
    section.add "PartitionsHealthStateFilter", valid_569400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569401: Call_GetServiceHealth_569393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health information of the specified service.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the service based on the health state.
  ## Use PartitionsHealthStateFilter to filter the collection of partitions returned.
  ## If you specify a service that does not exist in the health store, this cmdlet returns an error.
  ## 
  ## 
  let valid = call_569401.validator(path, query, header, formData, body)
  let scheme = call_569401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569401.url(scheme.get, call_569401.host, call_569401.base,
                         call_569401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569401, url, valid)

proc call*(call_569402: Call_GetServiceHealth_569393; serviceId: string;
          timeout: int = 60; apiVersion: string = "3.0";
          EventsHealthStateFilter: int = 0; PartitionsHealthStateFilter: int = 0): Recallable =
  ## getServiceHealth
  ## Gets the health information of the specified service.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the service based on the health state.
  ## Use PartitionsHealthStateFilter to filter the collection of partitions returned.
  ## If you specify a service that does not exist in the health store, this cmdlet returns an error.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
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
  var path_569403 = newJObject()
  var query_569404 = newJObject()
  add(query_569404, "timeout", newJInt(timeout))
  add(query_569404, "api-version", newJString(apiVersion))
  add(query_569404, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_569403, "serviceId", newJString(serviceId))
  add(query_569404, "PartitionsHealthStateFilter",
      newJInt(PartitionsHealthStateFilter))
  result = call_569402.call(path_569403, query_569404, nil, nil, nil)

var getServiceHealth* = Call_GetServiceHealth_569393(name: "getServiceHealth",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Services/{serviceId}/$/GetHealth",
    validator: validate_GetServiceHealth_569394, base: "",
    url: url_GetServiceHealth_569395, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetPartitionInfoList_569419 = ref object of OpenApiRestCall_567666
proc url_GetPartitionInfoList_569421(protocol: Scheme; host: string; base: string;
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

proc validate_GetPartitionInfoList_569420(path: JsonNode; query: JsonNode;
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
  var valid_569422 = path.getOrDefault("serviceId")
  valid_569422 = validateParameter(valid_569422, JString, required = true,
                                 default = nil)
  if valid_569422 != nil:
    section.add "serviceId", valid_569422
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  section = newJObject()
  var valid_569423 = query.getOrDefault("timeout")
  valid_569423 = validateParameter(valid_569423, JInt, required = false,
                                 default = newJInt(60))
  if valid_569423 != nil:
    section.add "timeout", valid_569423
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569424 = query.getOrDefault("api-version")
  valid_569424 = validateParameter(valid_569424, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569424 != nil:
    section.add "api-version", valid_569424
  var valid_569425 = query.getOrDefault("ContinuationToken")
  valid_569425 = validateParameter(valid_569425, JString, required = false,
                                 default = nil)
  if valid_569425 != nil:
    section.add "ContinuationToken", valid_569425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569426: Call_GetPartitionInfoList_569419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of partitions of a Service Fabric service. The response include the partition id, partitioning scheme information, keys supported by the partition, status, health and other details about the partition.
  ## 
  let valid = call_569426.validator(path, query, header, formData, body)
  let scheme = call_569426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569426.url(scheme.get, call_569426.host, call_569426.base,
                         call_569426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569426, url, valid)

proc call*(call_569427: Call_GetPartitionInfoList_569419; serviceId: string;
          timeout: int = 60; apiVersion: string = "3.0"; ContinuationToken: string = ""): Recallable =
  ## getPartitionInfoList
  ## Gets the list of partitions of a Service Fabric service. The response include the partition id, partitioning scheme information, keys supported by the partition, status, health and other details about the partition.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  ##   ContinuationToken: string
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  var path_569428 = newJObject()
  var query_569429 = newJObject()
  add(query_569429, "timeout", newJInt(timeout))
  add(query_569429, "api-version", newJString(apiVersion))
  add(path_569428, "serviceId", newJString(serviceId))
  add(query_569429, "ContinuationToken", newJString(ContinuationToken))
  result = call_569427.call(path_569428, query_569429, nil, nil, nil)

var getPartitionInfoList* = Call_GetPartitionInfoList_569419(
    name: "getPartitionInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Services/{serviceId}/$/GetPartitions",
    validator: validate_GetPartitionInfoList_569420, base: "",
    url: url_GetPartitionInfoList_569421, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportServiceHealth_569430 = ref object of OpenApiRestCall_567666
proc url_ReportServiceHealth_569432(protocol: Scheme; host: string; base: string;
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

proc validate_ReportServiceHealth_569431(path: JsonNode; query: JsonNode;
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
  var valid_569433 = path.getOrDefault("serviceId")
  valid_569433 = validateParameter(valid_569433, JString, required = true,
                                 default = nil)
  if valid_569433 != nil:
    section.add "serviceId", valid_569433
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569434 = query.getOrDefault("timeout")
  valid_569434 = validateParameter(valid_569434, JInt, required = false,
                                 default = newJInt(60))
  if valid_569434 != nil:
    section.add "timeout", valid_569434
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569435 = query.getOrDefault("api-version")
  valid_569435 = validateParameter(valid_569435, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569435 != nil:
    section.add "api-version", valid_569435
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

proc call*(call_569437: Call_ReportServiceHealth_569430; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reports health state of the specified Service Fabric service. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Service, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetServiceHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_569437.validator(path, query, header, formData, body)
  let scheme = call_569437.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569437.url(scheme.get, call_569437.host, call_569437.base,
                         call_569437.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569437, url, valid)

proc call*(call_569438: Call_ReportServiceHealth_569430;
          HealthInformation: JsonNode; serviceId: string; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## reportServiceHealth
  ## Reports health state of the specified Service Fabric service. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Service, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetServiceHealth and check that the report appears in the HealthEvents section.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   HealthInformation: JObject (required)
  ##                    : Describes the health information for the health report. This information needs to be present in all of the health reports sent to the health manager.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_569439 = newJObject()
  var query_569440 = newJObject()
  var body_569441 = newJObject()
  add(query_569440, "timeout", newJInt(timeout))
  add(query_569440, "api-version", newJString(apiVersion))
  if HealthInformation != nil:
    body_569441 = HealthInformation
  add(path_569439, "serviceId", newJString(serviceId))
  result = call_569438.call(path_569439, query_569440, nil, nil, body_569441)

var reportServiceHealth* = Call_ReportServiceHealth_569430(
    name: "reportServiceHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Services/{serviceId}/$/ReportHealth",
    validator: validate_ReportServiceHealth_569431, base: "",
    url: url_ReportServiceHealth_569432, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ResolveService_569442 = ref object of OpenApiRestCall_567666
proc url_ResolveService_569444(protocol: Scheme; host: string; base: string;
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

proc validate_ResolveService_569443(path: JsonNode; query: JsonNode;
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
  var valid_569445 = path.getOrDefault("serviceId")
  valid_569445 = validateParameter(valid_569445, JString, required = true,
                                 default = nil)
  if valid_569445 != nil:
    section.add "serviceId", valid_569445
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   PartitionKeyValue: JString
  ##                    : Partition key. This is required if the partition scheme for the service is Int64Range or Named.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   PartitionKeyType: JInt
  ##                   : Key type for the partition. This parameter is required if the partition scheme for the service is Int64Range or Named. The possible values are following.
  ## - None (1) - Indicates that the the PartitionKeyValue parameter is not specified. This is valid for the partitions with partitioning scheme as Singleton. This is the default value. The value is 1.
  ## - Int64Range (2) - Indicates that the the PartitionKeyValue parameter is an int64 partition key. This is valid for the partitions with partitioning scheme as Int64Range. The value is 2.
  ## - Named (3) - Indicates that the the PartitionKeyValue parameter is a name of the partition. This is valid for the partitions with partitioning scheme as Named. The value is 3.
  ## 
  ##   PreviousRspVersion: JString
  ##                     : The value in the Version field of the response that was received previously. This is required if the user knows that the result that was got previously is stale.
  section = newJObject()
  var valid_569446 = query.getOrDefault("timeout")
  valid_569446 = validateParameter(valid_569446, JInt, required = false,
                                 default = newJInt(60))
  if valid_569446 != nil:
    section.add "timeout", valid_569446
  var valid_569447 = query.getOrDefault("PartitionKeyValue")
  valid_569447 = validateParameter(valid_569447, JString, required = false,
                                 default = nil)
  if valid_569447 != nil:
    section.add "PartitionKeyValue", valid_569447
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569448 = query.getOrDefault("api-version")
  valid_569448 = validateParameter(valid_569448, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569448 != nil:
    section.add "api-version", valid_569448
  var valid_569449 = query.getOrDefault("PartitionKeyType")
  valid_569449 = validateParameter(valid_569449, JInt, required = false, default = nil)
  if valid_569449 != nil:
    section.add "PartitionKeyType", valid_569449
  var valid_569450 = query.getOrDefault("PreviousRspVersion")
  valid_569450 = validateParameter(valid_569450, JString, required = false,
                                 default = nil)
  if valid_569450 != nil:
    section.add "PreviousRspVersion", valid_569450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569451: Call_ResolveService_569442; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resolve a Service Fabric service partition, to get the endpoints of the service replicas.
  ## 
  let valid = call_569451.validator(path, query, header, formData, body)
  let scheme = call_569451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569451.url(scheme.get, call_569451.host, call_569451.base,
                         call_569451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569451, url, valid)

proc call*(call_569452: Call_ResolveService_569442; serviceId: string;
          timeout: int = 60; PartitionKeyValue: string = ""; apiVersion: string = "3.0";
          PartitionKeyType: int = 0; PreviousRspVersion: string = ""): Recallable =
  ## resolveService
  ## Resolve a Service Fabric service partition, to get the endpoints of the service replicas.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   PartitionKeyValue: string
  ##                    : Partition key. This is required if the partition scheme for the service is Int64Range or Named.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
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
  var path_569453 = newJObject()
  var query_569454 = newJObject()
  add(query_569454, "timeout", newJInt(timeout))
  add(query_569454, "PartitionKeyValue", newJString(PartitionKeyValue))
  add(query_569454, "api-version", newJString(apiVersion))
  add(query_569454, "PartitionKeyType", newJInt(PartitionKeyType))
  add(path_569453, "serviceId", newJString(serviceId))
  add(query_569454, "PreviousRspVersion", newJString(PreviousRspVersion))
  result = call_569452.call(path_569453, query_569454, nil, nil, nil)

var resolveService* = Call_ResolveService_569442(name: "resolveService",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Services/{serviceId}/$/ResolvePartition",
    validator: validate_ResolveService_569443, base: "", url: url_ResolveService_569444,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_UpdateService_569455 = ref object of OpenApiRestCall_567666
proc url_UpdateService_569457(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateService_569456(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_569458 = path.getOrDefault("serviceId")
  valid_569458 = validateParameter(valid_569458, JString, required = true,
                                 default = nil)
  if valid_569458 != nil:
    section.add "serviceId", valid_569458
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569459 = query.getOrDefault("timeout")
  valid_569459 = validateParameter(valid_569459, JInt, required = false,
                                 default = newJInt(60))
  if valid_569459 != nil:
    section.add "timeout", valid_569459
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569460 = query.getOrDefault("api-version")
  valid_569460 = validateParameter(valid_569460, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569460 != nil:
    section.add "api-version", valid_569460
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

proc call*(call_569462: Call_UpdateService_569455; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified service using the given update description.
  ## 
  let valid = call_569462.validator(path, query, header, formData, body)
  let scheme = call_569462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569462.url(scheme.get, call_569462.host, call_569462.base,
                         call_569462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569462, url, valid)

proc call*(call_569463: Call_UpdateService_569455;
          ServiceUpdateDescription: JsonNode; serviceId: string; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## updateService
  ## Updates the specified service using the given update description.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ServiceUpdateDescription: JObject (required)
  ##                           : The updated configuration for the service.
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_569464 = newJObject()
  var query_569465 = newJObject()
  var body_569466 = newJObject()
  add(query_569465, "timeout", newJInt(timeout))
  add(query_569465, "api-version", newJString(apiVersion))
  if ServiceUpdateDescription != nil:
    body_569466 = ServiceUpdateDescription
  add(path_569464, "serviceId", newJString(serviceId))
  result = call_569463.call(path_569464, query_569465, nil, nil, body_569466)

var updateService* = Call_UpdateService_569455(name: "updateService",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Services/{serviceId}/$/Update", validator: validate_UpdateService_569456,
    base: "", url: url_UpdateService_569457, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetChaosReport_569467 = ref object of OpenApiRestCall_567666
proc url_GetChaosReport_569469(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetChaosReport_569468(path: JsonNode; query: JsonNode;
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
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   EndTimeUtc: JString
  ##             : The count of ticks representing the end time of the time range for which a Chaos report is to be generated. Please consult [DateTime.Ticks 
  ## Property](https://msdn.microsoft.com/en-us/library/system.datetime.ticks%28v=vs.110%29) for details about tick.
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   StartTimeUtc: JString
  ##               : The count of ticks representing the start time of the time range for which a Chaos report is to be generated. Please consult [DateTime.Ticks 
  ## Property](https://msdn.microsoft.com/en-us/library/system.datetime.ticks%28v=vs.110%29) for details about tick.
  section = newJObject()
  var valid_569470 = query.getOrDefault("timeout")
  valid_569470 = validateParameter(valid_569470, JInt, required = false,
                                 default = newJInt(60))
  if valid_569470 != nil:
    section.add "timeout", valid_569470
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569471 = query.getOrDefault("api-version")
  valid_569471 = validateParameter(valid_569471, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569471 != nil:
    section.add "api-version", valid_569471
  var valid_569472 = query.getOrDefault("EndTimeUtc")
  valid_569472 = validateParameter(valid_569472, JString, required = false,
                                 default = nil)
  if valid_569472 != nil:
    section.add "EndTimeUtc", valid_569472
  var valid_569473 = query.getOrDefault("ContinuationToken")
  valid_569473 = validateParameter(valid_569473, JString, required = false,
                                 default = nil)
  if valid_569473 != nil:
    section.add "ContinuationToken", valid_569473
  var valid_569474 = query.getOrDefault("StartTimeUtc")
  valid_569474 = validateParameter(valid_569474, JString, required = false,
                                 default = nil)
  if valid_569474 != nil:
    section.add "StartTimeUtc", valid_569474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569475: Call_GetChaosReport_569467; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can either specify the ContinuationToken to get the next segment of the Chaos report or you can specify the time-range
  ## through StartTimeUtc and EndTimeUtc, but you cannot specify both the ContinuationToken and the time-range in the same call.
  ## When there are more than 100 Chaos events, the Chaos report is returned in segments where a segment contains no more than 100 Chaos events.
  ## 
  ## 
  let valid = call_569475.validator(path, query, header, formData, body)
  let scheme = call_569475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569475.url(scheme.get, call_569475.host, call_569475.base,
                         call_569475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569475, url, valid)

proc call*(call_569476: Call_GetChaosReport_569467; timeout: int = 60;
          apiVersion: string = "3.0"; EndTimeUtc: string = "";
          ContinuationToken: string = ""; StartTimeUtc: string = ""): Recallable =
  ## getChaosReport
  ## You can either specify the ContinuationToken to get the next segment of the Chaos report or you can specify the time-range
  ## through StartTimeUtc and EndTimeUtc, but you cannot specify both the ContinuationToken and the time-range in the same call.
  ## When there are more than 100 Chaos events, the Chaos report is returned in segments where a segment contains no more than 100 Chaos events.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   EndTimeUtc: string
  ##             : The count of ticks representing the end time of the time range for which a Chaos report is to be generated. Please consult [DateTime.Ticks 
  ## Property](https://msdn.microsoft.com/en-us/library/system.datetime.ticks%28v=vs.110%29) for details about tick.
  ##   ContinuationToken: string
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  ##   StartTimeUtc: string
  ##               : The count of ticks representing the start time of the time range for which a Chaos report is to be generated. Please consult [DateTime.Ticks 
  ## Property](https://msdn.microsoft.com/en-us/library/system.datetime.ticks%28v=vs.110%29) for details about tick.
  var query_569477 = newJObject()
  add(query_569477, "timeout", newJInt(timeout))
  add(query_569477, "api-version", newJString(apiVersion))
  add(query_569477, "EndTimeUtc", newJString(EndTimeUtc))
  add(query_569477, "ContinuationToken", newJString(ContinuationToken))
  add(query_569477, "StartTimeUtc", newJString(StartTimeUtc))
  result = call_569476.call(nil, query_569477, nil, nil, nil)

var getChaosReport* = Call_GetChaosReport_569467(name: "getChaosReport",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Tools/Chaos/$/Report", validator: validate_GetChaosReport_569468,
    base: "", url: url_GetChaosReport_569469, schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartChaos_569478 = ref object of OpenApiRestCall_567666
proc url_StartChaos_569480(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StartChaos_569479(path: JsonNode; query: JsonNode; header: JsonNode;
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
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569481 = query.getOrDefault("timeout")
  valid_569481 = validateParameter(valid_569481, JInt, required = false,
                                 default = newJInt(60))
  if valid_569481 != nil:
    section.add "timeout", valid_569481
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569482 = query.getOrDefault("api-version")
  valid_569482 = validateParameter(valid_569482, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569482 != nil:
    section.add "api-version", valid_569482
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

proc call*(call_569484: Call_StartChaos_569478; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If Chaos is not already running in the cluster, it starts Chaos with the passed in Chaos parameters.
  ## If Chaos is already running when this call is made, the call fails with the error code FABRIC_E_CHAOS_ALREADY_RUNNING.
  ## Please refer to the article [Induce controlled Chaos in Service Fabric clusters](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-controlled-chaos) for more details.
  ## 
  ## 
  let valid = call_569484.validator(path, query, header, formData, body)
  let scheme = call_569484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569484.url(scheme.get, call_569484.host, call_569484.base,
                         call_569484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569484, url, valid)

proc call*(call_569485: Call_StartChaos_569478; ChaosParameters: JsonNode;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## startChaos
  ## If Chaos is not already running in the cluster, it starts Chaos with the passed in Chaos parameters.
  ## If Chaos is already running when this call is made, the call fails with the error code FABRIC_E_CHAOS_ALREADY_RUNNING.
  ## Please refer to the article [Induce controlled Chaos in Service Fabric clusters](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-controlled-chaos) for more details.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ChaosParameters: JObject (required)
  ##                  : Describes all the parameters to configure a Chaos run.
  var query_569486 = newJObject()
  var body_569487 = newJObject()
  add(query_569486, "timeout", newJInt(timeout))
  add(query_569486, "api-version", newJString(apiVersion))
  if ChaosParameters != nil:
    body_569487 = ChaosParameters
  result = call_569485.call(nil, query_569486, nil, nil, body_569487)

var startChaos* = Call_StartChaos_569478(name: "startChaos",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local:19080",
                                      route: "/Tools/Chaos/$/Start",
                                      validator: validate_StartChaos_569479,
                                      base: "", url: url_StartChaos_569480,
                                      schemes: {Scheme.Https, Scheme.Http})
type
  Call_StopChaos_569488 = ref object of OpenApiRestCall_567666
proc url_StopChaos_569490(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StopChaos_569489(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops Chaos from scheduling further faults; but, the in-flight faults are not affected.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_569491 = query.getOrDefault("timeout")
  valid_569491 = validateParameter(valid_569491, JInt, required = false,
                                 default = newJInt(60))
  if valid_569491 != nil:
    section.add "timeout", valid_569491
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_569492 = query.getOrDefault("api-version")
  valid_569492 = validateParameter(valid_569492, JString, required = true,
                                 default = newJString("3.0"))
  if valid_569492 != nil:
    section.add "api-version", valid_569492
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_569493: Call_StopChaos_569488; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops Chaos from scheduling further faults; but, the in-flight faults are not affected.
  ## 
  let valid = call_569493.validator(path, query, header, formData, body)
  let scheme = call_569493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_569493.url(scheme.get, call_569493.host, call_569493.base,
                         call_569493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_569493, url, valid)

proc call*(call_569494: Call_StopChaos_569488; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## stopChaos
  ## Stops Chaos from scheduling further faults; but, the in-flight faults are not affected.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  var query_569495 = newJObject()
  add(query_569495, "timeout", newJInt(timeout))
  add(query_569495, "api-version", newJString(apiVersion))
  result = call_569494.call(nil, query_569495, nil, nil, nil)

var stopChaos* = Call_StopChaos_569488(name: "stopChaos", meth: HttpMethod.HttpPost,
                                    host: "azure.local:19080",
                                    route: "/Tools/Chaos/$/Stop",
                                    validator: validate_StopChaos_569489,
                                    base: "", url: url_StopChaos_569490,
                                    schemes: {Scheme.Https, Scheme.Http})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
