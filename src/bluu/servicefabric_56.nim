
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593437): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_GetAadMetadata_593659 = ref object of OpenApiRestCall_593437
proc url_GetAadMetadata_593661(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetAadMetadata_593660(path: JsonNode; query: JsonNode;
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
  var valid_593834 = query.getOrDefault("timeout")
  valid_593834 = validateParameter(valid_593834, JInt, required = false,
                                 default = newJInt(60))
  if valid_593834 != nil:
    section.add "timeout", valid_593834
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593835 = query.getOrDefault("api-version")
  valid_593835 = validateParameter(valid_593835, JString, required = true,
                                 default = newJString("1.0"))
  if valid_593835 != nil:
    section.add "api-version", valid_593835
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593858: Call_GetAadMetadata_593659; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the Azure Active Directory metadata used for secured connection to cluster.
  ## This API is not supposed to be called separately. It provides information needed to set up an Azure Active Directory secured connection with a Service Fabric cluster.
  ## 
  ## 
  let valid = call_593858.validator(path, query, header, formData, body)
  let scheme = call_593858.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593858.url(scheme.get, call_593858.host, call_593858.base,
                         call_593858.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593858, url, valid)

proc call*(call_593929: Call_GetAadMetadata_593659; timeout: int = 60;
          apiVersion: string = "1.0"): Recallable =
  ## getAadMetadata
  ## Gets the Azure Active Directory metadata used for secured connection to cluster.
  ## This API is not supposed to be called separately. It provides information needed to set up an Azure Active Directory secured connection with a Service Fabric cluster.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "1.0".
  var query_593930 = newJObject()
  add(query_593930, "timeout", newJInt(timeout))
  add(query_593930, "api-version", newJString(apiVersion))
  result = call_593929.call(nil, query_593930, nil, nil, nil)

var getAadMetadata* = Call_GetAadMetadata_593659(name: "getAadMetadata",
    meth: HttpMethod.HttpGet, host: "azure.local:19080", route: "/$/GetAadMetadata",
    validator: validate_GetAadMetadata_593660, base: "", url: url_GetAadMetadata_593661,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetClusterHealthUsingPolicy_593981 = ref object of OpenApiRestCall_593437
proc url_GetClusterHealthUsingPolicy_593983(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetClusterHealthUsingPolicy_593982(path: JsonNode; query: JsonNode;
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
  var valid_594001 = query.getOrDefault("timeout")
  valid_594001 = validateParameter(valid_594001, JInt, required = false,
                                 default = newJInt(60))
  if valid_594001 != nil:
    section.add "timeout", valid_594001
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594002 = query.getOrDefault("api-version")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594002 != nil:
    section.add "api-version", valid_594002
  var valid_594003 = query.getOrDefault("ApplicationsHealthStateFilter")
  valid_594003 = validateParameter(valid_594003, JInt, required = false,
                                 default = newJInt(0))
  if valid_594003 != nil:
    section.add "ApplicationsHealthStateFilter", valid_594003
  var valid_594004 = query.getOrDefault("EventsHealthStateFilter")
  valid_594004 = validateParameter(valid_594004, JInt, required = false,
                                 default = newJInt(0))
  if valid_594004 != nil:
    section.add "EventsHealthStateFilter", valid_594004
  var valid_594005 = query.getOrDefault("NodesHealthStateFilter")
  valid_594005 = validateParameter(valid_594005, JInt, required = false,
                                 default = newJInt(0))
  if valid_594005 != nil:
    section.add "NodesHealthStateFilter", valid_594005
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

proc call*(call_594007: Call_GetClusterHealthUsingPolicy_593981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric cluster.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the cluster based on the health state.
  ## Similarly, use NodesHealthStateFilter and ApplicationsHealthStateFilter to filter the collection of nodes and applications returned based on their aggregated health state.
  ## Use ClusterHealthPolicies to override the health policies used to evaluate the health.
  ## 
  ## 
  let valid = call_594007.validator(path, query, header, formData, body)
  let scheme = call_594007.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594007.url(scheme.get, call_594007.host, call_594007.base,
                         call_594007.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594007, url, valid)

proc call*(call_594008: Call_GetClusterHealthUsingPolicy_593981; timeout: int = 60;
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
  var query_594009 = newJObject()
  var body_594010 = newJObject()
  add(query_594009, "timeout", newJInt(timeout))
  add(query_594009, "api-version", newJString(apiVersion))
  add(query_594009, "ApplicationsHealthStateFilter",
      newJInt(ApplicationsHealthStateFilter))
  if ClusterHealthPolicies != nil:
    body_594010 = ClusterHealthPolicies
  add(query_594009, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(query_594009, "NodesHealthStateFilter", newJInt(NodesHealthStateFilter))
  result = call_594008.call(nil, query_594009, nil, nil, body_594010)

var getClusterHealthUsingPolicy* = Call_GetClusterHealthUsingPolicy_593981(
    name: "getClusterHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/GetClusterHealth",
    validator: validate_GetClusterHealthUsingPolicy_593982, base: "",
    url: url_GetClusterHealthUsingPolicy_593983,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetClusterHealth_593970 = ref object of OpenApiRestCall_593437
proc url_GetClusterHealth_593972(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetClusterHealth_593971(path: JsonNode; query: JsonNode;
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
  var valid_593973 = query.getOrDefault("timeout")
  valid_593973 = validateParameter(valid_593973, JInt, required = false,
                                 default = newJInt(60))
  if valid_593973 != nil:
    section.add "timeout", valid_593973
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593974 = query.getOrDefault("api-version")
  valid_593974 = validateParameter(valid_593974, JString, required = true,
                                 default = newJString("3.0"))
  if valid_593974 != nil:
    section.add "api-version", valid_593974
  var valid_593975 = query.getOrDefault("ApplicationsHealthStateFilter")
  valid_593975 = validateParameter(valid_593975, JInt, required = false,
                                 default = newJInt(0))
  if valid_593975 != nil:
    section.add "ApplicationsHealthStateFilter", valid_593975
  var valid_593976 = query.getOrDefault("EventsHealthStateFilter")
  valid_593976 = validateParameter(valid_593976, JInt, required = false,
                                 default = newJInt(0))
  if valid_593976 != nil:
    section.add "EventsHealthStateFilter", valid_593976
  var valid_593977 = query.getOrDefault("NodesHealthStateFilter")
  valid_593977 = validateParameter(valid_593977, JInt, required = false,
                                 default = newJInt(0))
  if valid_593977 != nil:
    section.add "NodesHealthStateFilter", valid_593977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593978: Call_GetClusterHealth_593970; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric cluster.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the cluster based on the health state.
  ## Similarly, use NodesHealthStateFilter and ApplicationsHealthStateFilter to filter the collection of nodes and applications returned based on their aggregated health state.
  ## 
  ## 
  let valid = call_593978.validator(path, query, header, formData, body)
  let scheme = call_593978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593978.url(scheme.get, call_593978.host, call_593978.base,
                         call_593978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593978, url, valid)

proc call*(call_593979: Call_GetClusterHealth_593970; timeout: int = 60;
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
  var query_593980 = newJObject()
  add(query_593980, "timeout", newJInt(timeout))
  add(query_593980, "api-version", newJString(apiVersion))
  add(query_593980, "ApplicationsHealthStateFilter",
      newJInt(ApplicationsHealthStateFilter))
  add(query_593980, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(query_593980, "NodesHealthStateFilter", newJInt(NodesHealthStateFilter))
  result = call_593979.call(nil, query_593980, nil, nil, nil)

var getClusterHealth* = Call_GetClusterHealth_593970(name: "getClusterHealth",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/$/GetClusterHealth", validator: validate_GetClusterHealth_593971,
    base: "", url: url_GetClusterHealth_593972, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_594019 = ref object of OpenApiRestCall_593437
proc url_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_594021(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_594020(
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
  var valid_594022 = query.getOrDefault("timeout")
  valid_594022 = validateParameter(valid_594022, JInt, required = false,
                                 default = newJInt(60))
  if valid_594022 != nil:
    section.add "timeout", valid_594022
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594023 = query.getOrDefault("api-version")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594023 != nil:
    section.add "api-version", valid_594023
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

proc call*(call_594025: Call_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_594019;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric cluster using health chunks. The health evaluation is done based on the input cluster health chunk query description.
  ## The query description allows users to specify health policies for evaluating the cluster and its children.
  ## Users can specify very flexible filters to select which cluster entities to return. The selection can be done based on the entities health state and based on the hierarchy.
  ## The query can return multi-level children of the entities based on the specified filters. For example, it can return one application with a specified name, and for this application, return
  ## only services that are in Error or Warning, and all partitions and replicas for one of these services.
  ## 
  ## 
  let valid = call_594025.validator(path, query, header, formData, body)
  let scheme = call_594025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594025.url(scheme.get, call_594025.host, call_594025.base,
                         call_594025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594025, url, valid)

proc call*(call_594026: Call_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_594019;
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
  var query_594027 = newJObject()
  var body_594028 = newJObject()
  add(query_594027, "timeout", newJInt(timeout))
  add(query_594027, "api-version", newJString(apiVersion))
  if ClusterHealthChunkQueryDescription != nil:
    body_594028 = ClusterHealthChunkQueryDescription
  result = call_594026.call(nil, query_594027, nil, nil, body_594028)

var getClusterHealthChunkUsingPolicyAndAdvancedFilters* = Call_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_594019(
    name: "getClusterHealthChunkUsingPolicyAndAdvancedFilters",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/$/GetClusterHealthChunk",
    validator: validate_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_594020,
    base: "", url: url_GetClusterHealthChunkUsingPolicyAndAdvancedFilters_594021,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetClusterHealthChunk_594011 = ref object of OpenApiRestCall_593437
proc url_GetClusterHealthChunk_594013(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetClusterHealthChunk_594012(path: JsonNode; query: JsonNode;
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
  var valid_594014 = query.getOrDefault("timeout")
  valid_594014 = validateParameter(valid_594014, JInt, required = false,
                                 default = newJInt(60))
  if valid_594014 != nil:
    section.add "timeout", valid_594014
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594015 = query.getOrDefault("api-version")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594015 != nil:
    section.add "api-version", valid_594015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594016: Call_GetClusterHealthChunk_594011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric cluster using health chunks. Includes the aggregated health state of the cluster, but none of the cluster entities.
  ## To expand the cluster health and get the health state of all or some of the entities, use the POST URI and specify the cluster health chunk query description.
  ## 
  ## 
  let valid = call_594016.validator(path, query, header, formData, body)
  let scheme = call_594016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594016.url(scheme.get, call_594016.host, call_594016.base,
                         call_594016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594016, url, valid)

proc call*(call_594017: Call_GetClusterHealthChunk_594011; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## getClusterHealthChunk
  ## Gets the health of a Service Fabric cluster using health chunks. Includes the aggregated health state of the cluster, but none of the cluster entities.
  ## To expand the cluster health and get the health state of all or some of the entities, use the POST URI and specify the cluster health chunk query description.
  ## 
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  var query_594018 = newJObject()
  add(query_594018, "timeout", newJInt(timeout))
  add(query_594018, "api-version", newJString(apiVersion))
  result = call_594017.call(nil, query_594018, nil, nil, nil)

var getClusterHealthChunk* = Call_GetClusterHealthChunk_594011(
    name: "getClusterHealthChunk", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetClusterHealthChunk",
    validator: validate_GetClusterHealthChunk_594012, base: "",
    url: url_GetClusterHealthChunk_594013, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetClusterManifest_594029 = ref object of OpenApiRestCall_593437
proc url_GetClusterManifest_594031(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetClusterManifest_594030(path: JsonNode; query: JsonNode;
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
  var valid_594032 = query.getOrDefault("timeout")
  valid_594032 = validateParameter(valid_594032, JInt, required = false,
                                 default = newJInt(60))
  if valid_594032 != nil:
    section.add "timeout", valid_594032
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594033 = query.getOrDefault("api-version")
  valid_594033 = validateParameter(valid_594033, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594033 != nil:
    section.add "api-version", valid_594033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594034: Call_GetClusterManifest_594029; path: JsonNode;
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
  let valid = call_594034.validator(path, query, header, formData, body)
  let scheme = call_594034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594034.url(scheme.get, call_594034.host, call_594034.base,
                         call_594034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594034, url, valid)

proc call*(call_594035: Call_GetClusterManifest_594029; timeout: int = 60;
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
  var query_594036 = newJObject()
  add(query_594036, "timeout", newJInt(timeout))
  add(query_594036, "api-version", newJString(apiVersion))
  result = call_594035.call(nil, query_594036, nil, nil, nil)

var getClusterManifest* = Call_GetClusterManifest_594029(
    name: "getClusterManifest", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/$/GetClusterManifest", validator: validate_GetClusterManifest_594030,
    base: "", url: url_GetClusterManifest_594031,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetProvisionedFabricCodeVersionInfoList_594037 = ref object of OpenApiRestCall_593437
proc url_GetProvisionedFabricCodeVersionInfoList_594039(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetProvisionedFabricCodeVersionInfoList_594038(path: JsonNode;
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
  var valid_594040 = query.getOrDefault("timeout")
  valid_594040 = validateParameter(valid_594040, JInt, required = false,
                                 default = newJInt(60))
  if valid_594040 != nil:
    section.add "timeout", valid_594040
  var valid_594041 = query.getOrDefault("CodeVersion")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "CodeVersion", valid_594041
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594042 = query.getOrDefault("api-version")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594042 != nil:
    section.add "api-version", valid_594042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594043: Call_GetProvisionedFabricCodeVersionInfoList_594037;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of information about fabric code versions that are provisioned in the cluster. The parameter CodeVersion can be used to optionally filter the output to only that particular version.
  ## 
  let valid = call_594043.validator(path, query, header, formData, body)
  let scheme = call_594043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594043.url(scheme.get, call_594043.host, call_594043.base,
                         call_594043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594043, url, valid)

proc call*(call_594044: Call_GetProvisionedFabricCodeVersionInfoList_594037;
          timeout: int = 60; CodeVersion: string = ""; apiVersion: string = "3.0"): Recallable =
  ## getProvisionedFabricCodeVersionInfoList
  ## Gets a list of information about fabric code versions that are provisioned in the cluster. The parameter CodeVersion can be used to optionally filter the output to only that particular version.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   CodeVersion: string
  ##              : The product version of Service Fabric.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  var query_594045 = newJObject()
  add(query_594045, "timeout", newJInt(timeout))
  add(query_594045, "CodeVersion", newJString(CodeVersion))
  add(query_594045, "api-version", newJString(apiVersion))
  result = call_594044.call(nil, query_594045, nil, nil, nil)

var getProvisionedFabricCodeVersionInfoList* = Call_GetProvisionedFabricCodeVersionInfoList_594037(
    name: "getProvisionedFabricCodeVersionInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetProvisionedCodeVersions",
    validator: validate_GetProvisionedFabricCodeVersionInfoList_594038, base: "",
    url: url_GetProvisionedFabricCodeVersionInfoList_594039,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetProvisionedFabricConfigVersionInfoList_594046 = ref object of OpenApiRestCall_593437
proc url_GetProvisionedFabricConfigVersionInfoList_594048(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetProvisionedFabricConfigVersionInfoList_594047(path: JsonNode;
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
  var valid_594049 = query.getOrDefault("timeout")
  valid_594049 = validateParameter(valid_594049, JInt, required = false,
                                 default = newJInt(60))
  if valid_594049 != nil:
    section.add "timeout", valid_594049
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594050 = query.getOrDefault("api-version")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594050 != nil:
    section.add "api-version", valid_594050
  var valid_594051 = query.getOrDefault("ConfigVersion")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "ConfigVersion", valid_594051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594052: Call_GetProvisionedFabricConfigVersionInfoList_594046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of information about fabric config versions that are provisioned in the cluster. The parameter ConfigVersion can be used to optionally filter the output to only that particular version.
  ## 
  let valid = call_594052.validator(path, query, header, formData, body)
  let scheme = call_594052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594052.url(scheme.get, call_594052.host, call_594052.base,
                         call_594052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594052, url, valid)

proc call*(call_594053: Call_GetProvisionedFabricConfigVersionInfoList_594046;
          timeout: int = 60; apiVersion: string = "3.0"; ConfigVersion: string = ""): Recallable =
  ## getProvisionedFabricConfigVersionInfoList
  ## Gets a list of information about fabric config versions that are provisioned in the cluster. The parameter ConfigVersion can be used to optionally filter the output to only that particular version.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ConfigVersion: string
  ##                : The config version of Service Fabric.
  var query_594054 = newJObject()
  add(query_594054, "timeout", newJInt(timeout))
  add(query_594054, "api-version", newJString(apiVersion))
  add(query_594054, "ConfigVersion", newJString(ConfigVersion))
  result = call_594053.call(nil, query_594054, nil, nil, nil)

var getProvisionedFabricConfigVersionInfoList* = Call_GetProvisionedFabricConfigVersionInfoList_594046(
    name: "getProvisionedFabricConfigVersionInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetProvisionedConfigVersions",
    validator: validate_GetProvisionedFabricConfigVersionInfoList_594047,
    base: "", url: url_GetProvisionedFabricConfigVersionInfoList_594048,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetClusterUpgradeProgress_594055 = ref object of OpenApiRestCall_593437
proc url_GetClusterUpgradeProgress_594057(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetClusterUpgradeProgress_594056(path: JsonNode; query: JsonNode;
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
  var valid_594058 = query.getOrDefault("timeout")
  valid_594058 = validateParameter(valid_594058, JInt, required = false,
                                 default = newJInt(60))
  if valid_594058 != nil:
    section.add "timeout", valid_594058
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594059 = query.getOrDefault("api-version")
  valid_594059 = validateParameter(valid_594059, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594059 != nil:
    section.add "api-version", valid_594059
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594060: Call_GetClusterUpgradeProgress_594055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the current progress of the ongoing cluster upgrade. If no upgrade is currently in progress, gets the last state of the previous cluster upgrade.
  ## 
  let valid = call_594060.validator(path, query, header, formData, body)
  let scheme = call_594060.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594060.url(scheme.get, call_594060.host, call_594060.base,
                         call_594060.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594060, url, valid)

proc call*(call_594061: Call_GetClusterUpgradeProgress_594055; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## getClusterUpgradeProgress
  ## Gets the current progress of the ongoing cluster upgrade. If no upgrade is currently in progress, gets the last state of the previous cluster upgrade.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  var query_594062 = newJObject()
  add(query_594062, "timeout", newJInt(timeout))
  add(query_594062, "api-version", newJString(apiVersion))
  result = call_594061.call(nil, query_594062, nil, nil, nil)

var getClusterUpgradeProgress* = Call_GetClusterUpgradeProgress_594055(
    name: "getClusterUpgradeProgress", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/GetUpgradeProgress",
    validator: validate_GetClusterUpgradeProgress_594056, base: "",
    url: url_GetClusterUpgradeProgress_594057,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_InvokeInfrastructureCommand_594063 = ref object of OpenApiRestCall_593437
proc url_InvokeInfrastructureCommand_594065(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_InvokeInfrastructureCommand_594064(path: JsonNode; query: JsonNode;
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
  var valid_594066 = query.getOrDefault("timeout")
  valid_594066 = validateParameter(valid_594066, JInt, required = false,
                                 default = newJInt(60))
  if valid_594066 != nil:
    section.add "timeout", valid_594066
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594067 = query.getOrDefault("api-version")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594067 != nil:
    section.add "api-version", valid_594067
  var valid_594068 = query.getOrDefault("ServiceId")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = nil)
  if valid_594068 != nil:
    section.add "ServiceId", valid_594068
  var valid_594069 = query.getOrDefault("Command")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "Command", valid_594069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594070: Call_InvokeInfrastructureCommand_594063; path: JsonNode;
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
  let valid = call_594070.validator(path, query, header, formData, body)
  let scheme = call_594070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594070.url(scheme.get, call_594070.host, call_594070.base,
                         call_594070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594070, url, valid)

proc call*(call_594071: Call_InvokeInfrastructureCommand_594063; Command: string;
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
  var query_594072 = newJObject()
  add(query_594072, "timeout", newJInt(timeout))
  add(query_594072, "api-version", newJString(apiVersion))
  add(query_594072, "ServiceId", newJString(ServiceId))
  add(query_594072, "Command", newJString(Command))
  result = call_594071.call(nil, query_594072, nil, nil, nil)

var invokeInfrastructureCommand* = Call_InvokeInfrastructureCommand_594063(
    name: "invokeInfrastructureCommand", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/InvokeInfrastructureCommand",
    validator: validate_InvokeInfrastructureCommand_594064, base: "",
    url: url_InvokeInfrastructureCommand_594065,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_InvokeInfrastructureQuery_594073 = ref object of OpenApiRestCall_593437
proc url_InvokeInfrastructureQuery_594075(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_InvokeInfrastructureQuery_594074(path: JsonNode; query: JsonNode;
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
  var valid_594076 = query.getOrDefault("timeout")
  valid_594076 = validateParameter(valid_594076, JInt, required = false,
                                 default = newJInt(60))
  if valid_594076 != nil:
    section.add "timeout", valid_594076
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594077 = query.getOrDefault("api-version")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594077 != nil:
    section.add "api-version", valid_594077
  var valid_594078 = query.getOrDefault("ServiceId")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "ServiceId", valid_594078
  var valid_594079 = query.getOrDefault("Command")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "Command", valid_594079
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594080: Call_InvokeInfrastructureQuery_594073; path: JsonNode;
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
  let valid = call_594080.validator(path, query, header, formData, body)
  let scheme = call_594080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594080.url(scheme.get, call_594080.host, call_594080.base,
                         call_594080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594080, url, valid)

proc call*(call_594081: Call_InvokeInfrastructureQuery_594073; Command: string;
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
  var query_594082 = newJObject()
  add(query_594082, "timeout", newJInt(timeout))
  add(query_594082, "api-version", newJString(apiVersion))
  add(query_594082, "ServiceId", newJString(ServiceId))
  add(query_594082, "Command", newJString(Command))
  result = call_594081.call(nil, query_594082, nil, nil, nil)

var invokeInfrastructureQuery* = Call_InvokeInfrastructureQuery_594073(
    name: "invokeInfrastructureQuery", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/$/InvokeInfrastructureQuery",
    validator: validate_InvokeInfrastructureQuery_594074, base: "",
    url: url_InvokeInfrastructureQuery_594075,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_RecoverAllPartitions_594083 = ref object of OpenApiRestCall_593437
proc url_RecoverAllPartitions_594085(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecoverAllPartitions_594084(path: JsonNode; query: JsonNode;
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
  var valid_594086 = query.getOrDefault("timeout")
  valid_594086 = validateParameter(valid_594086, JInt, required = false,
                                 default = newJInt(60))
  if valid_594086 != nil:
    section.add "timeout", valid_594086
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594087 = query.getOrDefault("api-version")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594087 != nil:
    section.add "api-version", valid_594087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594088: Call_RecoverAllPartitions_594083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicates to the Service Fabric cluster that it should attempt to recover any services (including system services) which are currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ## 
  let valid = call_594088.validator(path, query, header, formData, body)
  let scheme = call_594088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594088.url(scheme.get, call_594088.host, call_594088.base,
                         call_594088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594088, url, valid)

proc call*(call_594089: Call_RecoverAllPartitions_594083; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## recoverAllPartitions
  ## Indicates to the Service Fabric cluster that it should attempt to recover any services (including system services) which are currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  var query_594090 = newJObject()
  add(query_594090, "timeout", newJInt(timeout))
  add(query_594090, "api-version", newJString(apiVersion))
  result = call_594089.call(nil, query_594090, nil, nil, nil)

var recoverAllPartitions* = Call_RecoverAllPartitions_594083(
    name: "recoverAllPartitions", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/RecoverAllPartitions",
    validator: validate_RecoverAllPartitions_594084, base: "",
    url: url_RecoverAllPartitions_594085, schemes: {Scheme.Https, Scheme.Http})
type
  Call_RecoverSystemPartitions_594091 = ref object of OpenApiRestCall_593437
proc url_RecoverSystemPartitions_594093(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_RecoverSystemPartitions_594092(path: JsonNode; query: JsonNode;
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
  var valid_594094 = query.getOrDefault("timeout")
  valid_594094 = validateParameter(valid_594094, JInt, required = false,
                                 default = newJInt(60))
  if valid_594094 != nil:
    section.add "timeout", valid_594094
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594095 = query.getOrDefault("api-version")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594095 != nil:
    section.add "api-version", valid_594095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594096: Call_RecoverSystemPartitions_594091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicates to the Service Fabric cluster that it should attempt to recover the system services which are currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ## 
  let valid = call_594096.validator(path, query, header, formData, body)
  let scheme = call_594096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594096.url(scheme.get, call_594096.host, call_594096.base,
                         call_594096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594096, url, valid)

proc call*(call_594097: Call_RecoverSystemPartitions_594091; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## recoverSystemPartitions
  ## Indicates to the Service Fabric cluster that it should attempt to recover the system services which are currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  var query_594098 = newJObject()
  add(query_594098, "timeout", newJInt(timeout))
  add(query_594098, "api-version", newJString(apiVersion))
  result = call_594097.call(nil, query_594098, nil, nil, nil)

var recoverSystemPartitions* = Call_RecoverSystemPartitions_594091(
    name: "recoverSystemPartitions", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/RecoverSystemPartitions",
    validator: validate_RecoverSystemPartitions_594092, base: "",
    url: url_RecoverSystemPartitions_594093, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportClusterHealth_594099 = ref object of OpenApiRestCall_593437
proc url_ReportClusterHealth_594101(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ReportClusterHealth_594100(path: JsonNode; query: JsonNode;
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
  var valid_594102 = query.getOrDefault("timeout")
  valid_594102 = validateParameter(valid_594102, JInt, required = false,
                                 default = newJInt(60))
  if valid_594102 != nil:
    section.add "timeout", valid_594102
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594103 = query.getOrDefault("api-version")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594103 != nil:
    section.add "api-version", valid_594103
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

proc call*(call_594105: Call_ReportClusterHealth_594099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends a health report on a Service Fabric cluster. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway node, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetClusterHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_594105.validator(path, query, header, formData, body)
  let scheme = call_594105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594105.url(scheme.get, call_594105.host, call_594105.base,
                         call_594105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594105, url, valid)

proc call*(call_594106: Call_ReportClusterHealth_594099;
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
  var query_594107 = newJObject()
  var body_594108 = newJObject()
  add(query_594107, "timeout", newJInt(timeout))
  add(query_594107, "api-version", newJString(apiVersion))
  if HealthInformation != nil:
    body_594108 = HealthInformation
  result = call_594106.call(nil, query_594107, nil, nil, body_594108)

var reportClusterHealth* = Call_ReportClusterHealth_594099(
    name: "reportClusterHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/$/ReportClusterHealth",
    validator: validate_ReportClusterHealth_594100, base: "",
    url: url_ReportClusterHealth_594101, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationTypeInfoList_594109 = ref object of OpenApiRestCall_593437
proc url_GetApplicationTypeInfoList_594111(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetApplicationTypeInfoList_594110(path: JsonNode; query: JsonNode;
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
  var valid_594112 = query.getOrDefault("timeout")
  valid_594112 = validateParameter(valid_594112, JInt, required = false,
                                 default = newJInt(60))
  if valid_594112 != nil:
    section.add "timeout", valid_594112
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594113 = query.getOrDefault("api-version")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = newJString("4.0"))
  if valid_594113 != nil:
    section.add "api-version", valid_594113
  var valid_594114 = query.getOrDefault("ContinuationToken")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "ContinuationToken", valid_594114
  var valid_594115 = query.getOrDefault("MaxResults")
  valid_594115 = validateParameter(valid_594115, JInt, required = false,
                                 default = newJInt(0))
  if valid_594115 != nil:
    section.add "MaxResults", valid_594115
  var valid_594116 = query.getOrDefault("ExcludeApplicationParameters")
  valid_594116 = validateParameter(valid_594116, JBool, required = false,
                                 default = newJBool(false))
  if valid_594116 != nil:
    section.add "ExcludeApplicationParameters", valid_594116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594117: Call_GetApplicationTypeInfoList_594109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the information about the application types that are provisioned or in the process of being provisioned in the Service Fabric cluster. Each version of an application type is returned as one application type. The response includes the name, version, status and other details about the application type. This is a paged query, meaning that if not all of the application types fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page. For example, if there are 10 application types but a page only fits the first 3 application types, or if max results is set to 3, then 3 is returned. To access the rest of the results, retrieve subsequent pages by using the returned continuation token in the next query. An empty continuation token is returned if there are no subsequent pages.
  ## 
  let valid = call_594117.validator(path, query, header, formData, body)
  let scheme = call_594117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594117.url(scheme.get, call_594117.host, call_594117.base,
                         call_594117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594117, url, valid)

proc call*(call_594118: Call_GetApplicationTypeInfoList_594109; timeout: int = 60;
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
  var query_594119 = newJObject()
  add(query_594119, "timeout", newJInt(timeout))
  add(query_594119, "api-version", newJString(apiVersion))
  add(query_594119, "ContinuationToken", newJString(ContinuationToken))
  add(query_594119, "MaxResults", newJInt(MaxResults))
  add(query_594119, "ExcludeApplicationParameters",
      newJBool(ExcludeApplicationParameters))
  result = call_594118.call(nil, query_594119, nil, nil, nil)

var getApplicationTypeInfoList* = Call_GetApplicationTypeInfoList_594109(
    name: "getApplicationTypeInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ApplicationTypes",
    validator: validate_GetApplicationTypeInfoList_594110, base: "",
    url: url_GetApplicationTypeInfoList_594111,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_ProvisionApplicationType_594120 = ref object of OpenApiRestCall_593437
proc url_ProvisionApplicationType_594122(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_ProvisionApplicationType_594121(path: JsonNode; query: JsonNode;
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
  var valid_594123 = query.getOrDefault("timeout")
  valid_594123 = validateParameter(valid_594123, JInt, required = false,
                                 default = newJInt(60))
  if valid_594123 != nil:
    section.add "timeout", valid_594123
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594124 = query.getOrDefault("api-version")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594124 != nil:
    section.add "api-version", valid_594124
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

proc call*(call_594126: Call_ProvisionApplicationType_594120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Provisions or registers a Service Fabric application type with the cluster. This is required before any new applications can be instantiated.
  ## 
  let valid = call_594126.validator(path, query, header, formData, body)
  let scheme = call_594126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594126.url(scheme.get, call_594126.host, call_594126.base,
                         call_594126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594126, url, valid)

proc call*(call_594127: Call_ProvisionApplicationType_594120;
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
  var query_594128 = newJObject()
  var body_594129 = newJObject()
  add(query_594128, "timeout", newJInt(timeout))
  add(query_594128, "api-version", newJString(apiVersion))
  if ApplicationTypeImageStorePath != nil:
    body_594129 = ApplicationTypeImageStorePath
  result = call_594127.call(nil, query_594128, nil, nil, body_594129)

var provisionApplicationType* = Call_ProvisionApplicationType_594120(
    name: "provisionApplicationType", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/ApplicationTypes/$/Provision",
    validator: validate_ProvisionApplicationType_594121, base: "",
    url: url_ProvisionApplicationType_594122, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationTypeInfoListByName_594130 = ref object of OpenApiRestCall_593437
proc url_GetApplicationTypeInfoListByName_594132(protocol: Scheme; host: string;
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

proc validate_GetApplicationTypeInfoListByName_594131(path: JsonNode;
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
  var valid_594147 = path.getOrDefault("applicationTypeName")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "applicationTypeName", valid_594147
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
  var valid_594148 = query.getOrDefault("timeout")
  valid_594148 = validateParameter(valid_594148, JInt, required = false,
                                 default = newJInt(60))
  if valid_594148 != nil:
    section.add "timeout", valid_594148
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594149 = query.getOrDefault("api-version")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = newJString("4.0"))
  if valid_594149 != nil:
    section.add "api-version", valid_594149
  var valid_594150 = query.getOrDefault("ContinuationToken")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "ContinuationToken", valid_594150
  var valid_594151 = query.getOrDefault("MaxResults")
  valid_594151 = validateParameter(valid_594151, JInt, required = false,
                                 default = newJInt(0))
  if valid_594151 != nil:
    section.add "MaxResults", valid_594151
  var valid_594152 = query.getOrDefault("ExcludeApplicationParameters")
  valid_594152 = validateParameter(valid_594152, JBool, required = false,
                                 default = newJBool(false))
  if valid_594152 != nil:
    section.add "ExcludeApplicationParameters", valid_594152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594153: Call_GetApplicationTypeInfoListByName_594130;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the information about the application types that are provisioned or in the process of being provisioned in the Service Fabric cluster. These results are of application types whose name match exactly the one specified as the parameter, and which comply with the given query parameters. All versions of the application type matching the application type name are returned, with each version returned as one application type. The response includes the name, version, status and other details about the application type. This is a paged query, meaning that if not all of the application types fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page. For example, if there are 10 application types but a page only fits the first 3 application types, or if max results is set to 3, then 3 is returned. To access the rest of the results, retrieve subsequent pages by using the returned continuation token in the next query. An empty continuation token is returned if there are no subsequent pages.
  ## 
  let valid = call_594153.validator(path, query, header, formData, body)
  let scheme = call_594153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594153.url(scheme.get, call_594153.host, call_594153.base,
                         call_594153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594153, url, valid)

proc call*(call_594154: Call_GetApplicationTypeInfoListByName_594130;
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
  var path_594155 = newJObject()
  var query_594156 = newJObject()
  add(query_594156, "timeout", newJInt(timeout))
  add(query_594156, "api-version", newJString(apiVersion))
  add(path_594155, "applicationTypeName", newJString(applicationTypeName))
  add(query_594156, "ContinuationToken", newJString(ContinuationToken))
  add(query_594156, "MaxResults", newJInt(MaxResults))
  add(query_594156, "ExcludeApplicationParameters",
      newJBool(ExcludeApplicationParameters))
  result = call_594154.call(path_594155, query_594156, nil, nil, nil)

var getApplicationTypeInfoListByName* = Call_GetApplicationTypeInfoListByName_594130(
    name: "getApplicationTypeInfoListByName", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ApplicationTypes/{applicationTypeName}",
    validator: validate_GetApplicationTypeInfoListByName_594131, base: "",
    url: url_GetApplicationTypeInfoListByName_594132,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationManifest_594157 = ref object of OpenApiRestCall_593437
proc url_GetApplicationManifest_594159(protocol: Scheme; host: string; base: string;
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

proc validate_GetApplicationManifest_594158(path: JsonNode; query: JsonNode;
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
  var valid_594160 = path.getOrDefault("applicationTypeName")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "applicationTypeName", valid_594160
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationTypeVersion: JString (required)
  ##                         : The version of the application type.
  section = newJObject()
  var valid_594161 = query.getOrDefault("timeout")
  valid_594161 = validateParameter(valid_594161, JInt, required = false,
                                 default = newJInt(60))
  if valid_594161 != nil:
    section.add "timeout", valid_594161
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594162 = query.getOrDefault("api-version")
  valid_594162 = validateParameter(valid_594162, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594162 != nil:
    section.add "api-version", valid_594162
  var valid_594163 = query.getOrDefault("ApplicationTypeVersion")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "ApplicationTypeVersion", valid_594163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594164: Call_GetApplicationManifest_594157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the manifest describing an application type. The response contains the application manifest XML as a string.
  ## 
  let valid = call_594164.validator(path, query, header, formData, body)
  let scheme = call_594164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594164.url(scheme.get, call_594164.host, call_594164.base,
                         call_594164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594164, url, valid)

proc call*(call_594165: Call_GetApplicationManifest_594157;
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
  var path_594166 = newJObject()
  var query_594167 = newJObject()
  add(query_594167, "timeout", newJInt(timeout))
  add(query_594167, "api-version", newJString(apiVersion))
  add(path_594166, "applicationTypeName", newJString(applicationTypeName))
  add(query_594167, "ApplicationTypeVersion", newJString(ApplicationTypeVersion))
  result = call_594165.call(path_594166, query_594167, nil, nil, nil)

var getApplicationManifest* = Call_GetApplicationManifest_594157(
    name: "getApplicationManifest", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/GetApplicationManifest",
    validator: validate_GetApplicationManifest_594158, base: "",
    url: url_GetApplicationManifest_594159, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceManifest_594168 = ref object of OpenApiRestCall_593437
proc url_GetServiceManifest_594170(protocol: Scheme; host: string; base: string;
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

proc validate_GetServiceManifest_594169(path: JsonNode; query: JsonNode;
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
  var valid_594171 = path.getOrDefault("applicationTypeName")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "applicationTypeName", valid_594171
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
  var valid_594172 = query.getOrDefault("timeout")
  valid_594172 = validateParameter(valid_594172, JInt, required = false,
                                 default = newJInt(60))
  if valid_594172 != nil:
    section.add "timeout", valid_594172
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594173 = query.getOrDefault("api-version")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594173 != nil:
    section.add "api-version", valid_594173
  var valid_594174 = query.getOrDefault("ApplicationTypeVersion")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = nil)
  if valid_594174 != nil:
    section.add "ApplicationTypeVersion", valid_594174
  var valid_594175 = query.getOrDefault("ServiceManifestName")
  valid_594175 = validateParameter(valid_594175, JString, required = true,
                                 default = nil)
  if valid_594175 != nil:
    section.add "ServiceManifestName", valid_594175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594176: Call_GetServiceManifest_594168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the manifest describing a service type. The response contains the service manifest XML as a string.
  ## 
  let valid = call_594176.validator(path, query, header, formData, body)
  let scheme = call_594176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594176.url(scheme.get, call_594176.host, call_594176.base,
                         call_594176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594176, url, valid)

proc call*(call_594177: Call_GetServiceManifest_594168;
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
  var path_594178 = newJObject()
  var query_594179 = newJObject()
  add(query_594179, "timeout", newJInt(timeout))
  add(query_594179, "api-version", newJString(apiVersion))
  add(path_594178, "applicationTypeName", newJString(applicationTypeName))
  add(query_594179, "ApplicationTypeVersion", newJString(ApplicationTypeVersion))
  add(query_594179, "ServiceManifestName", newJString(ServiceManifestName))
  result = call_594177.call(path_594178, query_594179, nil, nil, nil)

var getServiceManifest* = Call_GetServiceManifest_594168(
    name: "getServiceManifest", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/GetServiceManifest",
    validator: validate_GetServiceManifest_594169, base: "",
    url: url_GetServiceManifest_594170, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceTypeInfoList_594180 = ref object of OpenApiRestCall_593437
proc url_GetServiceTypeInfoList_594182(protocol: Scheme; host: string; base: string;
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

proc validate_GetServiceTypeInfoList_594181(path: JsonNode; query: JsonNode;
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
  var valid_594183 = path.getOrDefault("applicationTypeName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "applicationTypeName", valid_594183
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ApplicationTypeVersion: JString (required)
  ##                         : The version of the application type.
  section = newJObject()
  var valid_594184 = query.getOrDefault("timeout")
  valid_594184 = validateParameter(valid_594184, JInt, required = false,
                                 default = newJInt(60))
  if valid_594184 != nil:
    section.add "timeout", valid_594184
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594185 = query.getOrDefault("api-version")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594185 != nil:
    section.add "api-version", valid_594185
  var valid_594186 = query.getOrDefault("ApplicationTypeVersion")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "ApplicationTypeVersion", valid_594186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594187: Call_GetServiceTypeInfoList_594180; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list containing the information about service types that are supported by a provisioned application type in a Service Fabric cluster. The response includes the name of the service type, the name and version of the service manifest the type is defined in, kind (stateless or stateless) of the service type and other information about it.
  ## 
  let valid = call_594187.validator(path, query, header, formData, body)
  let scheme = call_594187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594187.url(scheme.get, call_594187.host, call_594187.base,
                         call_594187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594187, url, valid)

proc call*(call_594188: Call_GetServiceTypeInfoList_594180;
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
  var path_594189 = newJObject()
  var query_594190 = newJObject()
  add(query_594190, "timeout", newJInt(timeout))
  add(query_594190, "api-version", newJString(apiVersion))
  add(path_594189, "applicationTypeName", newJString(applicationTypeName))
  add(query_594190, "ApplicationTypeVersion", newJString(ApplicationTypeVersion))
  result = call_594188.call(path_594189, query_594190, nil, nil, nil)

var getServiceTypeInfoList* = Call_GetServiceTypeInfoList_594180(
    name: "getServiceTypeInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/GetServiceTypes",
    validator: validate_GetServiceTypeInfoList_594181, base: "",
    url: url_GetServiceTypeInfoList_594182, schemes: {Scheme.Https, Scheme.Http})
type
  Call_UnprovisionApplicationType_594191 = ref object of OpenApiRestCall_593437
proc url_UnprovisionApplicationType_594193(protocol: Scheme; host: string;
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

proc validate_UnprovisionApplicationType_594192(path: JsonNode; query: JsonNode;
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
  var valid_594194 = path.getOrDefault("applicationTypeName")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "applicationTypeName", valid_594194
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594195 = query.getOrDefault("timeout")
  valid_594195 = validateParameter(valid_594195, JInt, required = false,
                                 default = newJInt(60))
  if valid_594195 != nil:
    section.add "timeout", valid_594195
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594196 = query.getOrDefault("api-version")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594196 != nil:
    section.add "api-version", valid_594196
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

proc call*(call_594198: Call_UnprovisionApplicationType_594191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes or unregisters a Service Fabric application type from the cluster. This operation can only be performed if all application instance of the application type has been deleted. Once the application type is unregistered, no new application instance can be created for this particular application type.
  ## 
  let valid = call_594198.validator(path, query, header, formData, body)
  let scheme = call_594198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594198.url(scheme.get, call_594198.host, call_594198.base,
                         call_594198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594198, url, valid)

proc call*(call_594199: Call_UnprovisionApplicationType_594191;
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
  var path_594200 = newJObject()
  var query_594201 = newJObject()
  var body_594202 = newJObject()
  if ApplicationTypeImageStoreVersion != nil:
    body_594202 = ApplicationTypeImageStoreVersion
  add(query_594201, "timeout", newJInt(timeout))
  add(query_594201, "api-version", newJString(apiVersion))
  add(path_594200, "applicationTypeName", newJString(applicationTypeName))
  result = call_594199.call(path_594200, query_594201, nil, nil, body_594202)

var unprovisionApplicationType* = Call_UnprovisionApplicationType_594191(
    name: "unprovisionApplicationType", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/ApplicationTypes/{applicationTypeName}/$/Unprovision",
    validator: validate_UnprovisionApplicationType_594192, base: "",
    url: url_UnprovisionApplicationType_594193,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationInfoList_594203 = ref object of OpenApiRestCall_593437
proc url_GetApplicationInfoList_594205(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetApplicationInfoList_594204(path: JsonNode; query: JsonNode;
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
  var valid_594206 = query.getOrDefault("timeout")
  valid_594206 = validateParameter(valid_594206, JInt, required = false,
                                 default = newJInt(60))
  if valid_594206 != nil:
    section.add "timeout", valid_594206
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594207 = query.getOrDefault("api-version")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594207 != nil:
    section.add "api-version", valid_594207
  var valid_594208 = query.getOrDefault("ApplicationTypeName")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "ApplicationTypeName", valid_594208
  var valid_594209 = query.getOrDefault("ContinuationToken")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "ContinuationToken", valid_594209
  var valid_594210 = query.getOrDefault("ExcludeApplicationParameters")
  valid_594210 = validateParameter(valid_594210, JBool, required = false,
                                 default = newJBool(false))
  if valid_594210 != nil:
    section.add "ExcludeApplicationParameters", valid_594210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594211: Call_GetApplicationInfoList_594203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the applications that were created or in the process of being created in the Service Fabric cluster and match filters specified as the parameter. The response includes the name, type, status, parameters and other details about the application. If the applications do not fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page.
  ## 
  let valid = call_594211.validator(path, query, header, formData, body)
  let scheme = call_594211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594211.url(scheme.get, call_594211.host, call_594211.base,
                         call_594211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594211, url, valid)

proc call*(call_594212: Call_GetApplicationInfoList_594203; timeout: int = 60;
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
  var query_594213 = newJObject()
  add(query_594213, "timeout", newJInt(timeout))
  add(query_594213, "api-version", newJString(apiVersion))
  add(query_594213, "ApplicationTypeName", newJString(ApplicationTypeName))
  add(query_594213, "ContinuationToken", newJString(ContinuationToken))
  add(query_594213, "ExcludeApplicationParameters",
      newJBool(ExcludeApplicationParameters))
  result = call_594212.call(nil, query_594213, nil, nil, nil)

var getApplicationInfoList* = Call_GetApplicationInfoList_594203(
    name: "getApplicationInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Applications",
    validator: validate_GetApplicationInfoList_594204, base: "",
    url: url_GetApplicationInfoList_594205, schemes: {Scheme.Https, Scheme.Http})
type
  Call_CreateApplication_594214 = ref object of OpenApiRestCall_593437
proc url_CreateApplication_594216(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CreateApplication_594215(path: JsonNode; query: JsonNode;
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
  var valid_594217 = query.getOrDefault("timeout")
  valid_594217 = validateParameter(valid_594217, JInt, required = false,
                                 default = newJInt(60))
  if valid_594217 != nil:
    section.add "timeout", valid_594217
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594218 = query.getOrDefault("api-version")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594218 != nil:
    section.add "api-version", valid_594218
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

proc call*(call_594220: Call_CreateApplication_594214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Service Fabric application using the specified description.
  ## 
  let valid = call_594220.validator(path, query, header, formData, body)
  let scheme = call_594220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594220.url(scheme.get, call_594220.host, call_594220.base,
                         call_594220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594220, url, valid)

proc call*(call_594221: Call_CreateApplication_594214;
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
  var query_594222 = newJObject()
  var body_594223 = newJObject()
  add(query_594222, "timeout", newJInt(timeout))
  add(query_594222, "api-version", newJString(apiVersion))
  if ApplicationDescription != nil:
    body_594223 = ApplicationDescription
  result = call_594221.call(nil, query_594222, nil, nil, body_594223)

var createApplication* = Call_CreateApplication_594214(name: "createApplication",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Applications/$/Create", validator: validate_CreateApplication_594215,
    base: "", url: url_CreateApplication_594216,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationInfo_594224 = ref object of OpenApiRestCall_593437
proc url_GetApplicationInfo_594226(protocol: Scheme; host: string; base: string;
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

proc validate_GetApplicationInfo_594225(path: JsonNode; query: JsonNode;
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
  var valid_594227 = path.getOrDefault("applicationId")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "applicationId", valid_594227
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ExcludeApplicationParameters: JBool
  ##                               : The flag that specifies whether application parameters will be excluded from the result.
  section = newJObject()
  var valid_594228 = query.getOrDefault("timeout")
  valid_594228 = validateParameter(valid_594228, JInt, required = false,
                                 default = newJInt(60))
  if valid_594228 != nil:
    section.add "timeout", valid_594228
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594229 = query.getOrDefault("api-version")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594229 != nil:
    section.add "api-version", valid_594229
  var valid_594230 = query.getOrDefault("ExcludeApplicationParameters")
  valid_594230 = validateParameter(valid_594230, JBool, required = false,
                                 default = newJBool(false))
  if valid_594230 != nil:
    section.add "ExcludeApplicationParameters", valid_594230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594231: Call_GetApplicationInfo_594224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the information about the application that was created or in the process of being created in the Service Fabric cluster and whose name matches the one specified as the parameter. The response includes the name, type, status, parameters and other details about the application.
  ## 
  let valid = call_594231.validator(path, query, header, formData, body)
  let scheme = call_594231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594231.url(scheme.get, call_594231.host, call_594231.base,
                         call_594231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594231, url, valid)

proc call*(call_594232: Call_GetApplicationInfo_594224; applicationId: string;
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
  var path_594233 = newJObject()
  var query_594234 = newJObject()
  add(query_594234, "timeout", newJInt(timeout))
  add(query_594234, "api-version", newJString(apiVersion))
  add(path_594233, "applicationId", newJString(applicationId))
  add(query_594234, "ExcludeApplicationParameters",
      newJBool(ExcludeApplicationParameters))
  result = call_594232.call(path_594233, query_594234, nil, nil, nil)

var getApplicationInfo* = Call_GetApplicationInfo_594224(
    name: "getApplicationInfo", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Applications/{applicationId}",
    validator: validate_GetApplicationInfo_594225, base: "",
    url: url_GetApplicationInfo_594226, schemes: {Scheme.Https, Scheme.Http})
type
  Call_DeleteApplication_594235 = ref object of OpenApiRestCall_593437
proc url_DeleteApplication_594237(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteApplication_594236(path: JsonNode; query: JsonNode;
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
  var valid_594238 = path.getOrDefault("applicationId")
  valid_594238 = validateParameter(valid_594238, JString, required = true,
                                 default = nil)
  if valid_594238 != nil:
    section.add "applicationId", valid_594238
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ForceRemove: JBool
  ##              : Remove a Service Fabric application or service forcefully without going through the graceful shutdown sequence. This parameter can be used to forcefully delete an application or service for which delete is timing out due to issues in the service code that prevents graceful close of replicas.
  section = newJObject()
  var valid_594239 = query.getOrDefault("timeout")
  valid_594239 = validateParameter(valid_594239, JInt, required = false,
                                 default = newJInt(60))
  if valid_594239 != nil:
    section.add "timeout", valid_594239
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594240 = query.getOrDefault("api-version")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594240 != nil:
    section.add "api-version", valid_594240
  var valid_594241 = query.getOrDefault("ForceRemove")
  valid_594241 = validateParameter(valid_594241, JBool, required = false, default = nil)
  if valid_594241 != nil:
    section.add "ForceRemove", valid_594241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594242: Call_DeleteApplication_594235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Service Fabric application. An application must be created before it can be deleted. Deleting an application will delete all services that are part of that application. By default Service Fabric will try to close service replicas in a graceful manner and then delete the service. However if service is having issues closing the replica gracefully, the delete operation may take a long time or get stuck. Use the optional ForceRemove flag to skip the graceful close sequence and forcefully delete the application and all of the its services.
  ## 
  let valid = call_594242.validator(path, query, header, formData, body)
  let scheme = call_594242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594242.url(scheme.get, call_594242.host, call_594242.base,
                         call_594242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594242, url, valid)

proc call*(call_594243: Call_DeleteApplication_594235; applicationId: string;
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
  var path_594244 = newJObject()
  var query_594245 = newJObject()
  add(query_594245, "timeout", newJInt(timeout))
  add(query_594245, "api-version", newJString(apiVersion))
  add(query_594245, "ForceRemove", newJBool(ForceRemove))
  add(path_594244, "applicationId", newJString(applicationId))
  result = call_594243.call(path_594244, query_594245, nil, nil, nil)

var deleteApplication* = Call_DeleteApplication_594235(name: "deleteApplication",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/Delete",
    validator: validate_DeleteApplication_594236, base: "",
    url: url_DeleteApplication_594237, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationHealthUsingPolicy_594259 = ref object of OpenApiRestCall_593437
proc url_GetApplicationHealthUsingPolicy_594261(protocol: Scheme; host: string;
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

proc validate_GetApplicationHealthUsingPolicy_594260(path: JsonNode;
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
  var valid_594262 = path.getOrDefault("applicationId")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "applicationId", valid_594262
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
  var valid_594263 = query.getOrDefault("timeout")
  valid_594263 = validateParameter(valid_594263, JInt, required = false,
                                 default = newJInt(60))
  if valid_594263 != nil:
    section.add "timeout", valid_594263
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594264 = query.getOrDefault("api-version")
  valid_594264 = validateParameter(valid_594264, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594264 != nil:
    section.add "api-version", valid_594264
  var valid_594265 = query.getOrDefault("EventsHealthStateFilter")
  valid_594265 = validateParameter(valid_594265, JInt, required = false,
                                 default = newJInt(0))
  if valid_594265 != nil:
    section.add "EventsHealthStateFilter", valid_594265
  var valid_594266 = query.getOrDefault("ServicesHealthStateFilter")
  valid_594266 = validateParameter(valid_594266, JInt, required = false,
                                 default = newJInt(0))
  if valid_594266 != nil:
    section.add "ServicesHealthStateFilter", valid_594266
  var valid_594267 = query.getOrDefault("DeployedApplicationsHealthStateFilter")
  valid_594267 = validateParameter(valid_594267, JInt, required = false,
                                 default = newJInt(0))
  if valid_594267 != nil:
    section.add "DeployedApplicationsHealthStateFilter", valid_594267
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

proc call*(call_594269: Call_GetApplicationHealthUsingPolicy_594259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric application. Use EventsHealthStateFilter to filter the collection of health events reported on the node based on the health state. Use ClusterHealthPolicies to override the health policies used to evaluate the health.
  ## 
  let valid = call_594269.validator(path, query, header, formData, body)
  let scheme = call_594269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594269.url(scheme.get, call_594269.host, call_594269.base,
                         call_594269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594269, url, valid)

proc call*(call_594270: Call_GetApplicationHealthUsingPolicy_594259;
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
  var path_594271 = newJObject()
  var query_594272 = newJObject()
  var body_594273 = newJObject()
  add(query_594272, "timeout", newJInt(timeout))
  add(query_594272, "api-version", newJString(apiVersion))
  if ApplicationHealthPolicy != nil:
    body_594273 = ApplicationHealthPolicy
  add(query_594272, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_594271, "applicationId", newJString(applicationId))
  add(query_594272, "ServicesHealthStateFilter",
      newJInt(ServicesHealthStateFilter))
  add(query_594272, "DeployedApplicationsHealthStateFilter",
      newJInt(DeployedApplicationsHealthStateFilter))
  result = call_594270.call(path_594271, query_594272, nil, nil, body_594273)

var getApplicationHealthUsingPolicy* = Call_GetApplicationHealthUsingPolicy_594259(
    name: "getApplicationHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationId}/$/GetHealth",
    validator: validate_GetApplicationHealthUsingPolicy_594260, base: "",
    url: url_GetApplicationHealthUsingPolicy_594261,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationHealth_594246 = ref object of OpenApiRestCall_593437
proc url_GetApplicationHealth_594248(protocol: Scheme; host: string; base: string;
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

proc validate_GetApplicationHealth_594247(path: JsonNode; query: JsonNode;
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
  var valid_594249 = path.getOrDefault("applicationId")
  valid_594249 = validateParameter(valid_594249, JString, required = true,
                                 default = nil)
  if valid_594249 != nil:
    section.add "applicationId", valid_594249
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
  var valid_594250 = query.getOrDefault("timeout")
  valid_594250 = validateParameter(valid_594250, JInt, required = false,
                                 default = newJInt(60))
  if valid_594250 != nil:
    section.add "timeout", valid_594250
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594251 = query.getOrDefault("api-version")
  valid_594251 = validateParameter(valid_594251, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594251 != nil:
    section.add "api-version", valid_594251
  var valid_594252 = query.getOrDefault("EventsHealthStateFilter")
  valid_594252 = validateParameter(valid_594252, JInt, required = false,
                                 default = newJInt(0))
  if valid_594252 != nil:
    section.add "EventsHealthStateFilter", valid_594252
  var valid_594253 = query.getOrDefault("ServicesHealthStateFilter")
  valid_594253 = validateParameter(valid_594253, JInt, required = false,
                                 default = newJInt(0))
  if valid_594253 != nil:
    section.add "ServicesHealthStateFilter", valid_594253
  var valid_594254 = query.getOrDefault("DeployedApplicationsHealthStateFilter")
  valid_594254 = validateParameter(valid_594254, JInt, required = false,
                                 default = newJInt(0))
  if valid_594254 != nil:
    section.add "DeployedApplicationsHealthStateFilter", valid_594254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594255: Call_GetApplicationHealth_594246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the heath state of the service fabric application. The response reports either Ok, Error or Warning health state. If the entity is not found in the helath store, it will return Error.
  ## 
  let valid = call_594255.validator(path, query, header, formData, body)
  let scheme = call_594255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594255.url(scheme.get, call_594255.host, call_594255.base,
                         call_594255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594255, url, valid)

proc call*(call_594256: Call_GetApplicationHealth_594246; applicationId: string;
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
  var path_594257 = newJObject()
  var query_594258 = newJObject()
  add(query_594258, "timeout", newJInt(timeout))
  add(query_594258, "api-version", newJString(apiVersion))
  add(query_594258, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_594257, "applicationId", newJString(applicationId))
  add(query_594258, "ServicesHealthStateFilter",
      newJInt(ServicesHealthStateFilter))
  add(query_594258, "DeployedApplicationsHealthStateFilter",
      newJInt(DeployedApplicationsHealthStateFilter))
  result = call_594256.call(path_594257, query_594258, nil, nil, nil)

var getApplicationHealth* = Call_GetApplicationHealth_594246(
    name: "getApplicationHealth", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Applications/{applicationId}/$/GetHealth",
    validator: validate_GetApplicationHealth_594247, base: "",
    url: url_GetApplicationHealth_594248, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceInfoList_594274 = ref object of OpenApiRestCall_593437
proc url_GetServiceInfoList_594276(protocol: Scheme; host: string; base: string;
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

proc validate_GetServiceInfoList_594275(path: JsonNode; query: JsonNode;
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
  var valid_594277 = path.getOrDefault("applicationId")
  valid_594277 = validateParameter(valid_594277, JString, required = true,
                                 default = nil)
  if valid_594277 != nil:
    section.add "applicationId", valid_594277
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
  var valid_594278 = query.getOrDefault("timeout")
  valid_594278 = validateParameter(valid_594278, JInt, required = false,
                                 default = newJInt(60))
  if valid_594278 != nil:
    section.add "timeout", valid_594278
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594279 = query.getOrDefault("api-version")
  valid_594279 = validateParameter(valid_594279, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594279 != nil:
    section.add "api-version", valid_594279
  var valid_594280 = query.getOrDefault("ContinuationToken")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = nil)
  if valid_594280 != nil:
    section.add "ContinuationToken", valid_594280
  var valid_594281 = query.getOrDefault("ServiceTypeName")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = nil)
  if valid_594281 != nil:
    section.add "ServiceTypeName", valid_594281
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594282: Call_GetServiceInfoList_594274; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the information about all services belonging to the application specified by the application id.
  ## 
  let valid = call_594282.validator(path, query, header, formData, body)
  let scheme = call_594282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594282.url(scheme.get, call_594282.host, call_594282.base,
                         call_594282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594282, url, valid)

proc call*(call_594283: Call_GetServiceInfoList_594274; applicationId: string;
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
  var path_594284 = newJObject()
  var query_594285 = newJObject()
  add(query_594285, "timeout", newJInt(timeout))
  add(query_594285, "api-version", newJString(apiVersion))
  add(path_594284, "applicationId", newJString(applicationId))
  add(query_594285, "ContinuationToken", newJString(ContinuationToken))
  add(query_594285, "ServiceTypeName", newJString(ServiceTypeName))
  result = call_594283.call(path_594284, query_594285, nil, nil, nil)

var getServiceInfoList* = Call_GetServiceInfoList_594274(
    name: "getServiceInfoList", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/GetServices",
    validator: validate_GetServiceInfoList_594275, base: "",
    url: url_GetServiceInfoList_594276, schemes: {Scheme.Https, Scheme.Http})
type
  Call_CreateService_594286 = ref object of OpenApiRestCall_593437
proc url_CreateService_594288(protocol: Scheme; host: string; base: string;
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

proc validate_CreateService_594287(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594289 = path.getOrDefault("applicationId")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "applicationId", valid_594289
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594290 = query.getOrDefault("timeout")
  valid_594290 = validateParameter(valid_594290, JInt, required = false,
                                 default = newJInt(60))
  if valid_594290 != nil:
    section.add "timeout", valid_594290
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594291 = query.getOrDefault("api-version")
  valid_594291 = validateParameter(valid_594291, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594291 != nil:
    section.add "api-version", valid_594291
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

proc call*(call_594293: Call_CreateService_594286; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the specified service.
  ## 
  let valid = call_594293.validator(path, query, header, formData, body)
  let scheme = call_594293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594293.url(scheme.get, call_594293.host, call_594293.base,
                         call_594293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594293, url, valid)

proc call*(call_594294: Call_CreateService_594286; applicationId: string;
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
  var path_594295 = newJObject()
  var query_594296 = newJObject()
  var body_594297 = newJObject()
  add(query_594296, "timeout", newJInt(timeout))
  add(query_594296, "api-version", newJString(apiVersion))
  add(path_594295, "applicationId", newJString(applicationId))
  if ServiceDescription != nil:
    body_594297 = ServiceDescription
  result = call_594294.call(path_594295, query_594296, nil, nil, body_594297)

var createService* = Call_CreateService_594286(name: "createService",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/GetServices/$/Create",
    validator: validate_CreateService_594287, base: "", url: url_CreateService_594288,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_CreateServiceFromTemplate_594298 = ref object of OpenApiRestCall_593437
proc url_CreateServiceFromTemplate_594300(protocol: Scheme; host: string;
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

proc validate_CreateServiceFromTemplate_594299(path: JsonNode; query: JsonNode;
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
  var valid_594301 = path.getOrDefault("applicationId")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "applicationId", valid_594301
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594302 = query.getOrDefault("timeout")
  valid_594302 = validateParameter(valid_594302, JInt, required = false,
                                 default = newJInt(60))
  if valid_594302 != nil:
    section.add "timeout", valid_594302
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594303 = query.getOrDefault("api-version")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594303 != nil:
    section.add "api-version", valid_594303
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

proc call*(call_594305: Call_CreateServiceFromTemplate_594298; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Service Fabric service from the service template defined in the application manifest.
  ## 
  let valid = call_594305.validator(path, query, header, formData, body)
  let scheme = call_594305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594305.url(scheme.get, call_594305.host, call_594305.base,
                         call_594305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594305, url, valid)

proc call*(call_594306: Call_CreateServiceFromTemplate_594298;
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
  var path_594307 = newJObject()
  var query_594308 = newJObject()
  var body_594309 = newJObject()
  add(query_594308, "timeout", newJInt(timeout))
  add(query_594308, "api-version", newJString(apiVersion))
  if ServiceFromTemplateDescription != nil:
    body_594309 = ServiceFromTemplateDescription
  add(path_594307, "applicationId", newJString(applicationId))
  result = call_594306.call(path_594307, query_594308, nil, nil, body_594309)

var createServiceFromTemplate* = Call_CreateServiceFromTemplate_594298(
    name: "createServiceFromTemplate", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/GetServices/$/CreateFromTemplate",
    validator: validate_CreateServiceFromTemplate_594299, base: "",
    url: url_CreateServiceFromTemplate_594300,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceInfo_594310 = ref object of OpenApiRestCall_593437
proc url_GetServiceInfo_594312(protocol: Scheme; host: string; base: string;
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

proc validate_GetServiceInfo_594311(path: JsonNode; query: JsonNode;
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
  var valid_594313 = path.getOrDefault("applicationId")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "applicationId", valid_594313
  var valid_594314 = path.getOrDefault("serviceId")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "serviceId", valid_594314
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594315 = query.getOrDefault("timeout")
  valid_594315 = validateParameter(valid_594315, JInt, required = false,
                                 default = newJInt(60))
  if valid_594315 != nil:
    section.add "timeout", valid_594315
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594316 = query.getOrDefault("api-version")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594316 != nil:
    section.add "api-version", valid_594316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594317: Call_GetServiceInfo_594310; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the information about specified service belonging to the specified Service Fabric application.
  ## 
  let valid = call_594317.validator(path, query, header, formData, body)
  let scheme = call_594317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594317.url(scheme.get, call_594317.host, call_594317.base,
                         call_594317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594317, url, valid)

proc call*(call_594318: Call_GetServiceInfo_594310; applicationId: string;
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
  var path_594319 = newJObject()
  var query_594320 = newJObject()
  add(query_594320, "timeout", newJInt(timeout))
  add(query_594320, "api-version", newJString(apiVersion))
  add(path_594319, "applicationId", newJString(applicationId))
  add(path_594319, "serviceId", newJString(serviceId))
  result = call_594318.call(path_594319, query_594320, nil, nil, nil)

var getServiceInfo* = Call_GetServiceInfo_594310(name: "getServiceInfo",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/GetServices/{serviceId}",
    validator: validate_GetServiceInfo_594311, base: "", url: url_GetServiceInfo_594312,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationUpgrade_594321 = ref object of OpenApiRestCall_593437
proc url_GetApplicationUpgrade_594323(protocol: Scheme; host: string; base: string;
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

proc validate_GetApplicationUpgrade_594322(path: JsonNode; query: JsonNode;
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
  var valid_594324 = path.getOrDefault("applicationId")
  valid_594324 = validateParameter(valid_594324, JString, required = true,
                                 default = nil)
  if valid_594324 != nil:
    section.add "applicationId", valid_594324
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594325 = query.getOrDefault("timeout")
  valid_594325 = validateParameter(valid_594325, JInt, required = false,
                                 default = newJInt(60))
  if valid_594325 != nil:
    section.add "timeout", valid_594325
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594326 = query.getOrDefault("api-version")
  valid_594326 = validateParameter(valid_594326, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594326 != nil:
    section.add "api-version", valid_594326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594327: Call_GetApplicationUpgrade_594321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the state of the latest application upgrade along with details to aid debugging application health issues.
  ## 
  let valid = call_594327.validator(path, query, header, formData, body)
  let scheme = call_594327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594327.url(scheme.get, call_594327.host, call_594327.base,
                         call_594327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594327, url, valid)

proc call*(call_594328: Call_GetApplicationUpgrade_594321; applicationId: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getApplicationUpgrade
  ## Returns information about the state of the latest application upgrade along with details to aid debugging application health issues.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_594329 = newJObject()
  var query_594330 = newJObject()
  add(query_594330, "timeout", newJInt(timeout))
  add(query_594330, "api-version", newJString(apiVersion))
  add(path_594329, "applicationId", newJString(applicationId))
  result = call_594328.call(path_594329, query_594330, nil, nil, nil)

var getApplicationUpgrade* = Call_GetApplicationUpgrade_594321(
    name: "getApplicationUpgrade", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/GetUpgradeProgress",
    validator: validate_GetApplicationUpgrade_594322, base: "",
    url: url_GetApplicationUpgrade_594323, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ResumeApplicationUpgrade_594331 = ref object of OpenApiRestCall_593437
proc url_ResumeApplicationUpgrade_594333(protocol: Scheme; host: string;
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

proc validate_ResumeApplicationUpgrade_594332(path: JsonNode; query: JsonNode;
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
  var valid_594334 = path.getOrDefault("applicationId")
  valid_594334 = validateParameter(valid_594334, JString, required = true,
                                 default = nil)
  if valid_594334 != nil:
    section.add "applicationId", valid_594334
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594335 = query.getOrDefault("timeout")
  valid_594335 = validateParameter(valid_594335, JInt, required = false,
                                 default = newJInt(60))
  if valid_594335 != nil:
    section.add "timeout", valid_594335
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594336 = query.getOrDefault("api-version")
  valid_594336 = validateParameter(valid_594336, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594336 != nil:
    section.add "api-version", valid_594336
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

proc call*(call_594338: Call_ResumeApplicationUpgrade_594331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resumes an unmonitored manual Service Fabric application upgrade. Service Fabric upgrades one upgrade domain at a time. For unmonitored manual upgrades, after Service Fabric finishes an upgrade domain, it waits for you to call this API before proceeding to the next upgrade domain.
  ## 
  let valid = call_594338.validator(path, query, header, formData, body)
  let scheme = call_594338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594338.url(scheme.get, call_594338.host, call_594338.base,
                         call_594338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594338, url, valid)

proc call*(call_594339: Call_ResumeApplicationUpgrade_594331;
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
  var path_594340 = newJObject()
  var query_594341 = newJObject()
  var body_594342 = newJObject()
  add(query_594341, "timeout", newJInt(timeout))
  if ResumeApplicationUpgradeDescription != nil:
    body_594342 = ResumeApplicationUpgradeDescription
  add(query_594341, "api-version", newJString(apiVersion))
  add(path_594340, "applicationId", newJString(applicationId))
  result = call_594339.call(path_594340, query_594341, nil, nil, body_594342)

var resumeApplicationUpgrade* = Call_ResumeApplicationUpgrade_594331(
    name: "resumeApplicationUpgrade", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/MoveToNextUpgradeDomain",
    validator: validate_ResumeApplicationUpgrade_594332, base: "",
    url: url_ResumeApplicationUpgrade_594333, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportApplicationHealth_594343 = ref object of OpenApiRestCall_593437
proc url_ReportApplicationHealth_594345(protocol: Scheme; host: string; base: string;
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

proc validate_ReportApplicationHealth_594344(path: JsonNode; query: JsonNode;
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
  var valid_594346 = path.getOrDefault("applicationId")
  valid_594346 = validateParameter(valid_594346, JString, required = true,
                                 default = nil)
  if valid_594346 != nil:
    section.add "applicationId", valid_594346
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594347 = query.getOrDefault("timeout")
  valid_594347 = validateParameter(valid_594347, JInt, required = false,
                                 default = newJInt(60))
  if valid_594347 != nil:
    section.add "timeout", valid_594347
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594348 = query.getOrDefault("api-version")
  valid_594348 = validateParameter(valid_594348, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594348 != nil:
    section.add "api-version", valid_594348
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

proc call*(call_594350: Call_ReportApplicationHealth_594343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reports health state of the specified Service Fabric application. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Application, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetApplicationHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_594350.validator(path, query, header, formData, body)
  let scheme = call_594350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594350.url(scheme.get, call_594350.host, call_594350.base,
                         call_594350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594350, url, valid)

proc call*(call_594351: Call_ReportApplicationHealth_594343;
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
  var path_594352 = newJObject()
  var query_594353 = newJObject()
  var body_594354 = newJObject()
  add(query_594353, "timeout", newJInt(timeout))
  add(query_594353, "api-version", newJString(apiVersion))
  if HealthInformation != nil:
    body_594354 = HealthInformation
  add(path_594352, "applicationId", newJString(applicationId))
  result = call_594351.call(path_594352, query_594353, nil, nil, body_594354)

var reportApplicationHealth* = Call_ReportApplicationHealth_594343(
    name: "reportApplicationHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/ReportHealth",
    validator: validate_ReportApplicationHealth_594344, base: "",
    url: url_ReportApplicationHealth_594345, schemes: {Scheme.Https, Scheme.Http})
type
  Call_RollbackApplicationUpgrade_594355 = ref object of OpenApiRestCall_593437
proc url_RollbackApplicationUpgrade_594357(protocol: Scheme; host: string;
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

proc validate_RollbackApplicationUpgrade_594356(path: JsonNode; query: JsonNode;
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
  var valid_594358 = path.getOrDefault("applicationId")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "applicationId", valid_594358
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594359 = query.getOrDefault("timeout")
  valid_594359 = validateParameter(valid_594359, JInt, required = false,
                                 default = newJInt(60))
  if valid_594359 != nil:
    section.add "timeout", valid_594359
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594360 = query.getOrDefault("api-version")
  valid_594360 = validateParameter(valid_594360, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594360 != nil:
    section.add "api-version", valid_594360
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594361: Call_RollbackApplicationUpgrade_594355; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts rolling back the current application upgrade to the previous version. This API can only be used to rollback the current in-progress upgrade that is rolling forward to new version. If the application is not currently being upgraded use StartApplicationUpgrade API to upgrade it to desired version including rolling back to a previous version.
  ## 
  let valid = call_594361.validator(path, query, header, formData, body)
  let scheme = call_594361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594361.url(scheme.get, call_594361.host, call_594361.base,
                         call_594361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594361, url, valid)

proc call*(call_594362: Call_RollbackApplicationUpgrade_594355;
          applicationId: string; timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## rollbackApplicationUpgrade
  ## Starts rolling back the current application upgrade to the previous version. This API can only be used to rollback the current in-progress upgrade that is rolling forward to new version. If the application is not currently being upgraded use StartApplicationUpgrade API to upgrade it to desired version including rolling back to a previous version.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_594363 = newJObject()
  var query_594364 = newJObject()
  add(query_594364, "timeout", newJInt(timeout))
  add(query_594364, "api-version", newJString(apiVersion))
  add(path_594363, "applicationId", newJString(applicationId))
  result = call_594362.call(path_594363, query_594364, nil, nil, nil)

var rollbackApplicationUpgrade* = Call_RollbackApplicationUpgrade_594355(
    name: "rollbackApplicationUpgrade", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/RollbackUpgrade",
    validator: validate_RollbackApplicationUpgrade_594356, base: "",
    url: url_RollbackApplicationUpgrade_594357,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_UpdateApplicationUpgrade_594365 = ref object of OpenApiRestCall_593437
proc url_UpdateApplicationUpgrade_594367(protocol: Scheme; host: string;
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

proc validate_UpdateApplicationUpgrade_594366(path: JsonNode; query: JsonNode;
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
  var valid_594368 = path.getOrDefault("applicationId")
  valid_594368 = validateParameter(valid_594368, JString, required = true,
                                 default = nil)
  if valid_594368 != nil:
    section.add "applicationId", valid_594368
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594369 = query.getOrDefault("timeout")
  valid_594369 = validateParameter(valid_594369, JInt, required = false,
                                 default = newJInt(60))
  if valid_594369 != nil:
    section.add "timeout", valid_594369
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594370 = query.getOrDefault("api-version")
  valid_594370 = validateParameter(valid_594370, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594370 != nil:
    section.add "api-version", valid_594370
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

proc call*(call_594372: Call_UpdateApplicationUpgrade_594365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the parameters of an ongoing application upgrade from the ones specified at the time of starting the application upgrade. This may be required to mitigate stuck application upgrades due to incorrect parameters or issues in the application to make progress.
  ## 
  let valid = call_594372.validator(path, query, header, formData, body)
  let scheme = call_594372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594372.url(scheme.get, call_594372.host, call_594372.base,
                         call_594372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594372, url, valid)

proc call*(call_594373: Call_UpdateApplicationUpgrade_594365;
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
  var path_594374 = newJObject()
  var query_594375 = newJObject()
  var body_594376 = newJObject()
  add(query_594375, "timeout", newJInt(timeout))
  add(query_594375, "api-version", newJString(apiVersion))
  add(path_594374, "applicationId", newJString(applicationId))
  if ApplicationUpgradeUpdateDescription != nil:
    body_594376 = ApplicationUpgradeUpdateDescription
  result = call_594373.call(path_594374, query_594375, nil, nil, body_594376)

var updateApplicationUpgrade* = Call_UpdateApplicationUpgrade_594365(
    name: "updateApplicationUpgrade", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Applications/{applicationId}/$/UpdateUpgrade",
    validator: validate_UpdateApplicationUpgrade_594366, base: "",
    url: url_UpdateApplicationUpgrade_594367, schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartApplicationUpgrade_594377 = ref object of OpenApiRestCall_593437
proc url_StartApplicationUpgrade_594379(protocol: Scheme; host: string; base: string;
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

proc validate_StartApplicationUpgrade_594378(path: JsonNode; query: JsonNode;
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
  var valid_594380 = path.getOrDefault("applicationId")
  valid_594380 = validateParameter(valid_594380, JString, required = true,
                                 default = nil)
  if valid_594380 != nil:
    section.add "applicationId", valid_594380
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594381 = query.getOrDefault("timeout")
  valid_594381 = validateParameter(valid_594381, JInt, required = false,
                                 default = newJInt(60))
  if valid_594381 != nil:
    section.add "timeout", valid_594381
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594382 = query.getOrDefault("api-version")
  valid_594382 = validateParameter(valid_594382, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594382 != nil:
    section.add "api-version", valid_594382
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

proc call*(call_594384: Call_StartApplicationUpgrade_594377; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the supplied application upgrade parameters and starts upgrading the application if the parameters are valid.
  ## 
  let valid = call_594384.validator(path, query, header, formData, body)
  let scheme = call_594384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594384.url(scheme.get, call_594384.host, call_594384.base,
                         call_594384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594384, url, valid)

proc call*(call_594385: Call_StartApplicationUpgrade_594377; applicationId: string;
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
  var path_594386 = newJObject()
  var query_594387 = newJObject()
  var body_594388 = newJObject()
  add(query_594387, "timeout", newJInt(timeout))
  add(query_594387, "api-version", newJString(apiVersion))
  add(path_594386, "applicationId", newJString(applicationId))
  if ApplicationUpgradeDescription != nil:
    body_594388 = ApplicationUpgradeDescription
  result = call_594385.call(path_594386, query_594387, nil, nil, body_594388)

var startApplicationUpgrade* = Call_StartApplicationUpgrade_594377(
    name: "startApplicationUpgrade", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Applications/{applicationId}/$/Upgrade",
    validator: validate_StartApplicationUpgrade_594378, base: "",
    url: url_StartApplicationUpgrade_594379, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetComposeApplicationStatusList_594389 = ref object of OpenApiRestCall_593437
proc url_GetComposeApplicationStatusList_594391(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetComposeApplicationStatusList_594390(path: JsonNode;
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
  var valid_594392 = query.getOrDefault("timeout")
  valid_594392 = validateParameter(valid_594392, JInt, required = false,
                                 default = newJInt(60))
  if valid_594392 != nil:
    section.add "timeout", valid_594392
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594393 = query.getOrDefault("api-version")
  valid_594393 = validateParameter(valid_594393, JString, required = true,
                                 default = newJString("4.0-preview"))
  if valid_594393 != nil:
    section.add "api-version", valid_594393
  var valid_594394 = query.getOrDefault("ContinuationToken")
  valid_594394 = validateParameter(valid_594394, JString, required = false,
                                 default = nil)
  if valid_594394 != nil:
    section.add "ContinuationToken", valid_594394
  var valid_594395 = query.getOrDefault("MaxResults")
  valid_594395 = validateParameter(valid_594395, JInt, required = false,
                                 default = newJInt(0))
  if valid_594395 != nil:
    section.add "MaxResults", valid_594395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594396: Call_GetComposeApplicationStatusList_594389;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the status about the compose applications that were created or in the process of being created in the Service Fabric cluster. The response includes the name, status and other details about the compose application. If the applications do not fit in a page, one page of results is returned as well as a continuation token which can be used to get the next page.
  ## 
  let valid = call_594396.validator(path, query, header, formData, body)
  let scheme = call_594396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594396.url(scheme.get, call_594396.host, call_594396.base,
                         call_594396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594396, url, valid)

proc call*(call_594397: Call_GetComposeApplicationStatusList_594389;
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
  var query_594398 = newJObject()
  add(query_594398, "timeout", newJInt(timeout))
  add(query_594398, "api-version", newJString(apiVersion))
  add(query_594398, "ContinuationToken", newJString(ContinuationToken))
  add(query_594398, "MaxResults", newJInt(MaxResults))
  result = call_594397.call(nil, query_594398, nil, nil, nil)

var getComposeApplicationStatusList* = Call_GetComposeApplicationStatusList_594389(
    name: "getComposeApplicationStatusList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ComposeDeployments",
    validator: validate_GetComposeApplicationStatusList_594390, base: "",
    url: url_GetComposeApplicationStatusList_594391,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_CreateComposeApplication_594399 = ref object of OpenApiRestCall_593437
proc url_CreateComposeApplication_594401(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CreateComposeApplication_594400(path: JsonNode; query: JsonNode;
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
  var valid_594402 = query.getOrDefault("timeout")
  valid_594402 = validateParameter(valid_594402, JInt, required = false,
                                 default = newJInt(60))
  if valid_594402 != nil:
    section.add "timeout", valid_594402
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594403 = query.getOrDefault("api-version")
  valid_594403 = validateParameter(valid_594403, JString, required = true,
                                 default = newJString("4.0-preview"))
  if valid_594403 != nil:
    section.add "api-version", valid_594403
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

proc call*(call_594405: Call_CreateComposeApplication_594399; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a Service Fabric compose application.
  ## 
  let valid = call_594405.validator(path, query, header, formData, body)
  let scheme = call_594405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594405.url(scheme.get, call_594405.host, call_594405.base,
                         call_594405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594405, url, valid)

proc call*(call_594406: Call_CreateComposeApplication_594399;
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
  var query_594407 = newJObject()
  var body_594408 = newJObject()
  add(query_594407, "timeout", newJInt(timeout))
  add(query_594407, "api-version", newJString(apiVersion))
  if CreateComposeApplicationDescription != nil:
    body_594408 = CreateComposeApplicationDescription
  result = call_594406.call(nil, query_594407, nil, nil, body_594408)

var createComposeApplication* = Call_CreateComposeApplication_594399(
    name: "createComposeApplication", meth: HttpMethod.HttpPut,
    host: "azure.local:19080", route: "/ComposeDeployments/$/Create",
    validator: validate_CreateComposeApplication_594400, base: "",
    url: url_CreateComposeApplication_594401, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetComposeApplicationStatus_594409 = ref object of OpenApiRestCall_593437
proc url_GetComposeApplicationStatus_594411(protocol: Scheme; host: string;
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

proc validate_GetComposeApplicationStatus_594410(path: JsonNode; query: JsonNode;
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
  var valid_594412 = path.getOrDefault("applicationId")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "applicationId", valid_594412
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "4.0-preview".
  section = newJObject()
  var valid_594413 = query.getOrDefault("timeout")
  valid_594413 = validateParameter(valid_594413, JInt, required = false,
                                 default = newJInt(60))
  if valid_594413 != nil:
    section.add "timeout", valid_594413
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594414 = query.getOrDefault("api-version")
  valid_594414 = validateParameter(valid_594414, JString, required = true,
                                 default = newJString("4.0-preview"))
  if valid_594414 != nil:
    section.add "api-version", valid_594414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594415: Call_GetComposeApplicationStatus_594409; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the status of compose application that was created or in the process of being created in the Service Fabric cluster and whose name matches the one specified as the parameter. The response includes the name, status and other details about the application.
  ## 
  let valid = call_594415.validator(path, query, header, formData, body)
  let scheme = call_594415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594415.url(scheme.get, call_594415.host, call_594415.base,
                         call_594415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594415, url, valid)

proc call*(call_594416: Call_GetComposeApplicationStatus_594409;
          applicationId: string; timeout: int = 60; apiVersion: string = "4.0-preview"): Recallable =
  ## getComposeApplicationStatus
  ## Returns the status of compose application that was created or in the process of being created in the Service Fabric cluster and whose name matches the one specified as the parameter. The response includes the name, status and other details about the application.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "4.0-preview".
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_594417 = newJObject()
  var query_594418 = newJObject()
  add(query_594418, "timeout", newJInt(timeout))
  add(query_594418, "api-version", newJString(apiVersion))
  add(path_594417, "applicationId", newJString(applicationId))
  result = call_594416.call(path_594417, query_594418, nil, nil, nil)

var getComposeApplicationStatus* = Call_GetComposeApplicationStatus_594409(
    name: "getComposeApplicationStatus", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ComposeDeployments/{applicationId}",
    validator: validate_GetComposeApplicationStatus_594410, base: "",
    url: url_GetComposeApplicationStatus_594411,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_RemoveComposeApplication_594419 = ref object of OpenApiRestCall_593437
proc url_RemoveComposeApplication_594421(protocol: Scheme; host: string;
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

proc validate_RemoveComposeApplication_594420(path: JsonNode; query: JsonNode;
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
  var valid_594422 = path.getOrDefault("applicationId")
  valid_594422 = validateParameter(valid_594422, JString, required = true,
                                 default = nil)
  if valid_594422 != nil:
    section.add "applicationId", valid_594422
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "4.0-preview".
  section = newJObject()
  var valid_594423 = query.getOrDefault("timeout")
  valid_594423 = validateParameter(valid_594423, JInt, required = false,
                                 default = newJInt(60))
  if valid_594423 != nil:
    section.add "timeout", valid_594423
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594424 = query.getOrDefault("api-version")
  valid_594424 = validateParameter(valid_594424, JString, required = true,
                                 default = newJString("4.0-preview"))
  if valid_594424 != nil:
    section.add "api-version", valid_594424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594425: Call_RemoveComposeApplication_594419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Service Fabric compose application. An application must be created before it can be deleted.
  ## 
  let valid = call_594425.validator(path, query, header, formData, body)
  let scheme = call_594425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594425.url(scheme.get, call_594425.host, call_594425.base,
                         call_594425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594425, url, valid)

proc call*(call_594426: Call_RemoveComposeApplication_594419;
          applicationId: string; timeout: int = 60; apiVersion: string = "4.0-preview"): Recallable =
  ## removeComposeApplication
  ## Deletes an existing Service Fabric compose application. An application must be created before it can be deleted.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "4.0-preview".
  ##   applicationId: string (required)
  ##                : The identity of the application. This is typically the full name of the application without the 'fabric:' URI scheme.
  var path_594427 = newJObject()
  var query_594428 = newJObject()
  add(query_594428, "timeout", newJInt(timeout))
  add(query_594428, "api-version", newJString(apiVersion))
  add(path_594427, "applicationId", newJString(applicationId))
  result = call_594426.call(path_594427, query_594428, nil, nil, nil)

var removeComposeApplication* = Call_RemoveComposeApplication_594419(
    name: "removeComposeApplication", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/ComposeDeployments/{applicationId}/$/Delete",
    validator: validate_RemoveComposeApplication_594420, base: "",
    url: url_RemoveComposeApplication_594421, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetFaultOperationList_594429 = ref object of OpenApiRestCall_593437
proc url_GetFaultOperationList_594431(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetFaultOperationList_594430(path: JsonNode; query: JsonNode;
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
  var valid_594432 = query.getOrDefault("timeout")
  valid_594432 = validateParameter(valid_594432, JInt, required = false,
                                 default = newJInt(60))
  if valid_594432 != nil:
    section.add "timeout", valid_594432
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594433 = query.getOrDefault("api-version")
  valid_594433 = validateParameter(valid_594433, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594433 != nil:
    section.add "api-version", valid_594433
  var valid_594434 = query.getOrDefault("TypeFilter")
  valid_594434 = validateParameter(valid_594434, JInt, required = true,
                                 default = newJInt(65535))
  if valid_594434 != nil:
    section.add "TypeFilter", valid_594434
  var valid_594435 = query.getOrDefault("StateFilter")
  valid_594435 = validateParameter(valid_594435, JInt, required = true,
                                 default = newJInt(65535))
  if valid_594435 != nil:
    section.add "StateFilter", valid_594435
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594436: Call_GetFaultOperationList_594429; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the a list of user-induced fault operations filtered by provided input.
  ## 
  let valid = call_594436.validator(path, query, header, formData, body)
  let scheme = call_594436.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594436.url(scheme.get, call_594436.host, call_594436.base,
                         call_594436.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594436, url, valid)

proc call*(call_594437: Call_GetFaultOperationList_594429; timeout: int = 60;
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
  var query_594438 = newJObject()
  add(query_594438, "timeout", newJInt(timeout))
  add(query_594438, "api-version", newJString(apiVersion))
  add(query_594438, "TypeFilter", newJInt(TypeFilter))
  add(query_594438, "StateFilter", newJInt(StateFilter))
  result = call_594437.call(nil, query_594438, nil, nil, nil)

var getFaultOperationList* = Call_GetFaultOperationList_594429(
    name: "getFaultOperationList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Faults/",
    validator: validate_GetFaultOperationList_594430, base: "",
    url: url_GetFaultOperationList_594431, schemes: {Scheme.Https, Scheme.Http})
type
  Call_CancelOperation_594439 = ref object of OpenApiRestCall_593437
proc url_CancelOperation_594441(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CancelOperation_594440(path: JsonNode; query: JsonNode;
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
  var valid_594442 = query.getOrDefault("timeout")
  valid_594442 = validateParameter(valid_594442, JInt, required = false,
                                 default = newJInt(60))
  if valid_594442 != nil:
    section.add "timeout", valid_594442
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594443 = query.getOrDefault("api-version")
  valid_594443 = validateParameter(valid_594443, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594443 != nil:
    section.add "api-version", valid_594443
  var valid_594444 = query.getOrDefault("OperationId")
  valid_594444 = validateParameter(valid_594444, JString, required = true,
                                 default = nil)
  if valid_594444 != nil:
    section.add "OperationId", valid_594444
  var valid_594445 = query.getOrDefault("Force")
  valid_594445 = validateParameter(valid_594445, JBool, required = true,
                                 default = newJBool(false))
  if valid_594445 != nil:
    section.add "Force", valid_594445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594446: Call_CancelOperation_594439; path: JsonNode; query: JsonNode;
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
  let valid = call_594446.validator(path, query, header, formData, body)
  let scheme = call_594446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594446.url(scheme.get, call_594446.host, call_594446.base,
                         call_594446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594446, url, valid)

proc call*(call_594447: Call_CancelOperation_594439; OperationId: string;
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
  var query_594448 = newJObject()
  add(query_594448, "timeout", newJInt(timeout))
  add(query_594448, "api-version", newJString(apiVersion))
  add(query_594448, "OperationId", newJString(OperationId))
  add(query_594448, "Force", newJBool(Force))
  result = call_594447.call(nil, query_594448, nil, nil, nil)

var cancelOperation* = Call_CancelOperation_594439(name: "cancelOperation",
    meth: HttpMethod.HttpPost, host: "azure.local:19080", route: "/Faults/$/Cancel",
    validator: validate_CancelOperation_594440, base: "", url: url_CancelOperation_594441,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetNodeTransitionProgress_594449 = ref object of OpenApiRestCall_593437
proc url_GetNodeTransitionProgress_594451(protocol: Scheme; host: string;
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

proc validate_GetNodeTransitionProgress_594450(path: JsonNode; query: JsonNode;
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
  var valid_594452 = path.getOrDefault("nodeName")
  valid_594452 = validateParameter(valid_594452, JString, required = true,
                                 default = nil)
  if valid_594452 != nil:
    section.add "nodeName", valid_594452
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  section = newJObject()
  var valid_594453 = query.getOrDefault("timeout")
  valid_594453 = validateParameter(valid_594453, JInt, required = false,
                                 default = newJInt(60))
  if valid_594453 != nil:
    section.add "timeout", valid_594453
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594454 = query.getOrDefault("api-version")
  valid_594454 = validateParameter(valid_594454, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594454 != nil:
    section.add "api-version", valid_594454
  var valid_594455 = query.getOrDefault("OperationId")
  valid_594455 = validateParameter(valid_594455, JString, required = true,
                                 default = nil)
  if valid_594455 != nil:
    section.add "OperationId", valid_594455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594456: Call_GetNodeTransitionProgress_594449; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the progress of an operation started with StartNodeTransition using the provided OperationId.
  ## 
  ## 
  let valid = call_594456.validator(path, query, header, formData, body)
  let scheme = call_594456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594456.url(scheme.get, call_594456.host, call_594456.base,
                         call_594456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594456, url, valid)

proc call*(call_594457: Call_GetNodeTransitionProgress_594449; nodeName: string;
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
  var path_594458 = newJObject()
  var query_594459 = newJObject()
  add(query_594459, "timeout", newJInt(timeout))
  add(query_594459, "api-version", newJString(apiVersion))
  add(path_594458, "nodeName", newJString(nodeName))
  add(query_594459, "OperationId", newJString(OperationId))
  result = call_594457.call(path_594458, query_594459, nil, nil, nil)

var getNodeTransitionProgress* = Call_GetNodeTransitionProgress_594449(
    name: "getNodeTransitionProgress", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Faults/Nodes/{nodeName}/$/GetTransitionProgress",
    validator: validate_GetNodeTransitionProgress_594450, base: "",
    url: url_GetNodeTransitionProgress_594451,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartNodeTransition_594460 = ref object of OpenApiRestCall_593437
proc url_StartNodeTransition_594462(protocol: Scheme; host: string; base: string;
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

proc validate_StartNodeTransition_594461(path: JsonNode; query: JsonNode;
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
  var valid_594463 = path.getOrDefault("nodeName")
  valid_594463 = validateParameter(valid_594463, JString, required = true,
                                 default = nil)
  if valid_594463 != nil:
    section.add "nodeName", valid_594463
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
  var valid_594464 = query.getOrDefault("timeout")
  valid_594464 = validateParameter(valid_594464, JInt, required = false,
                                 default = newJInt(60))
  if valid_594464 != nil:
    section.add "timeout", valid_594464
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594465 = query.getOrDefault("api-version")
  valid_594465 = validateParameter(valid_594465, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594465 != nil:
    section.add "api-version", valid_594465
  var valid_594466 = query.getOrDefault("NodeInstanceId")
  valid_594466 = validateParameter(valid_594466, JString, required = true,
                                 default = nil)
  if valid_594466 != nil:
    section.add "NodeInstanceId", valid_594466
  var valid_594467 = query.getOrDefault("StopDurationInSeconds")
  valid_594467 = validateParameter(valid_594467, JInt, required = true, default = nil)
  if valid_594467 != nil:
    section.add "StopDurationInSeconds", valid_594467
  var valid_594468 = query.getOrDefault("NodeTransitionType")
  valid_594468 = validateParameter(valid_594468, JString, required = true,
                                 default = newJString("Invalid"))
  if valid_594468 != nil:
    section.add "NodeTransitionType", valid_594468
  var valid_594469 = query.getOrDefault("OperationId")
  valid_594469 = validateParameter(valid_594469, JString, required = true,
                                 default = nil)
  if valid_594469 != nil:
    section.add "OperationId", valid_594469
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594470: Call_StartNodeTransition_594460; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts or stops a cluster node.  A cluster node is a process, not the OS instance itself.  To start a node, pass in "Start" for the NodeTransitionType parameter.
  ## To stop a node, pass in "Stop" for the NodeTransitionType parameter.  This API starts the operation - when the API returns the node may not have finished transitioning yet.
  ## Call GetNodeTransitionProgress with the same OperationId to get the progress of the operation.
  ## 
  ## 
  let valid = call_594470.validator(path, query, header, formData, body)
  let scheme = call_594470.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594470.url(scheme.get, call_594470.host, call_594470.base,
                         call_594470.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594470, url, valid)

proc call*(call_594471: Call_StartNodeTransition_594460; nodeName: string;
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
  var path_594472 = newJObject()
  var query_594473 = newJObject()
  add(query_594473, "timeout", newJInt(timeout))
  add(query_594473, "api-version", newJString(apiVersion))
  add(path_594472, "nodeName", newJString(nodeName))
  add(query_594473, "NodeInstanceId", newJString(NodeInstanceId))
  add(query_594473, "StopDurationInSeconds", newJInt(StopDurationInSeconds))
  add(query_594473, "NodeTransitionType", newJString(NodeTransitionType))
  add(query_594473, "OperationId", newJString(OperationId))
  result = call_594471.call(path_594472, query_594473, nil, nil, nil)

var startNodeTransition* = Call_StartNodeTransition_594460(
    name: "startNodeTransition", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Faults/Nodes/{nodeName}/$/StartTransition/",
    validator: validate_StartNodeTransition_594461, base: "",
    url: url_StartNodeTransition_594462, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDataLossProgress_594474 = ref object of OpenApiRestCall_593437
proc url_GetDataLossProgress_594476(protocol: Scheme; host: string; base: string;
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

proc validate_GetDataLossProgress_594475(path: JsonNode; query: JsonNode;
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
  var valid_594477 = path.getOrDefault("partitionId")
  valid_594477 = validateParameter(valid_594477, JString, required = true,
                                 default = nil)
  if valid_594477 != nil:
    section.add "partitionId", valid_594477
  var valid_594478 = path.getOrDefault("serviceId")
  valid_594478 = validateParameter(valid_594478, JString, required = true,
                                 default = nil)
  if valid_594478 != nil:
    section.add "serviceId", valid_594478
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  section = newJObject()
  var valid_594479 = query.getOrDefault("timeout")
  valid_594479 = validateParameter(valid_594479, JInt, required = false,
                                 default = newJInt(60))
  if valid_594479 != nil:
    section.add "timeout", valid_594479
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594480 = query.getOrDefault("api-version")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594480 != nil:
    section.add "api-version", valid_594480
  var valid_594481 = query.getOrDefault("OperationId")
  valid_594481 = validateParameter(valid_594481, JString, required = true,
                                 default = nil)
  if valid_594481 != nil:
    section.add "OperationId", valid_594481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594482: Call_GetDataLossProgress_594474; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the progress of a data loss operation started with StartDataLoss, using the OperationId.
  ## 
  ## 
  let valid = call_594482.validator(path, query, header, formData, body)
  let scheme = call_594482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594482.url(scheme.get, call_594482.host, call_594482.base,
                         call_594482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594482, url, valid)

proc call*(call_594483: Call_GetDataLossProgress_594474; partitionId: string;
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
  var path_594484 = newJObject()
  var query_594485 = newJObject()
  add(query_594485, "timeout", newJInt(timeout))
  add(query_594485, "api-version", newJString(apiVersion))
  add(path_594484, "partitionId", newJString(partitionId))
  add(path_594484, "serviceId", newJString(serviceId))
  add(query_594485, "OperationId", newJString(OperationId))
  result = call_594483.call(path_594484, query_594485, nil, nil, nil)

var getDataLossProgress* = Call_GetDataLossProgress_594474(
    name: "getDataLossProgress", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Faults/Services/{serviceId}/$/GetPartitions/{partitionId}/$/GetDataLossProgress",
    validator: validate_GetDataLossProgress_594475, base: "",
    url: url_GetDataLossProgress_594476, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetQuorumLossProgress_594486 = ref object of OpenApiRestCall_593437
proc url_GetQuorumLossProgress_594488(protocol: Scheme; host: string; base: string;
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

proc validate_GetQuorumLossProgress_594487(path: JsonNode; query: JsonNode;
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
  var valid_594489 = path.getOrDefault("partitionId")
  valid_594489 = validateParameter(valid_594489, JString, required = true,
                                 default = nil)
  if valid_594489 != nil:
    section.add "partitionId", valid_594489
  var valid_594490 = path.getOrDefault("serviceId")
  valid_594490 = validateParameter(valid_594490, JString, required = true,
                                 default = nil)
  if valid_594490 != nil:
    section.add "serviceId", valid_594490
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  section = newJObject()
  var valid_594491 = query.getOrDefault("timeout")
  valid_594491 = validateParameter(valid_594491, JInt, required = false,
                                 default = newJInt(60))
  if valid_594491 != nil:
    section.add "timeout", valid_594491
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594492 = query.getOrDefault("api-version")
  valid_594492 = validateParameter(valid_594492, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594492 != nil:
    section.add "api-version", valid_594492
  var valid_594493 = query.getOrDefault("OperationId")
  valid_594493 = validateParameter(valid_594493, JString, required = true,
                                 default = nil)
  if valid_594493 != nil:
    section.add "OperationId", valid_594493
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594494: Call_GetQuorumLossProgress_594486; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the progress of a quorum loss operation started with StartQuorumLoss, using the provided OperationId.
  ## 
  ## 
  let valid = call_594494.validator(path, query, header, formData, body)
  let scheme = call_594494.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594494.url(scheme.get, call_594494.host, call_594494.base,
                         call_594494.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594494, url, valid)

proc call*(call_594495: Call_GetQuorumLossProgress_594486; partitionId: string;
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
  var path_594496 = newJObject()
  var query_594497 = newJObject()
  add(query_594497, "timeout", newJInt(timeout))
  add(query_594497, "api-version", newJString(apiVersion))
  add(path_594496, "partitionId", newJString(partitionId))
  add(path_594496, "serviceId", newJString(serviceId))
  add(query_594497, "OperationId", newJString(OperationId))
  result = call_594495.call(path_594496, query_594497, nil, nil, nil)

var getQuorumLossProgress* = Call_GetQuorumLossProgress_594486(
    name: "getQuorumLossProgress", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Faults/Services/{serviceId}/$/GetPartitions/{partitionId}/$/GetQuorumLossProgress",
    validator: validate_GetQuorumLossProgress_594487, base: "",
    url: url_GetQuorumLossProgress_594488, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetPartitionRestartProgress_594498 = ref object of OpenApiRestCall_593437
proc url_GetPartitionRestartProgress_594500(protocol: Scheme; host: string;
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

proc validate_GetPartitionRestartProgress_594499(path: JsonNode; query: JsonNode;
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
  var valid_594501 = path.getOrDefault("partitionId")
  valid_594501 = validateParameter(valid_594501, JString, required = true,
                                 default = nil)
  if valid_594501 != nil:
    section.add "partitionId", valid_594501
  var valid_594502 = path.getOrDefault("serviceId")
  valid_594502 = validateParameter(valid_594502, JString, required = true,
                                 default = nil)
  if valid_594502 != nil:
    section.add "serviceId", valid_594502
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   OperationId: JString (required)
  ##              : A GUID that identifies a call of this API.  This is passed into the corresponding GetProgress API
  section = newJObject()
  var valid_594503 = query.getOrDefault("timeout")
  valid_594503 = validateParameter(valid_594503, JInt, required = false,
                                 default = newJInt(60))
  if valid_594503 != nil:
    section.add "timeout", valid_594503
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594504 = query.getOrDefault("api-version")
  valid_594504 = validateParameter(valid_594504, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594504 != nil:
    section.add "api-version", valid_594504
  var valid_594505 = query.getOrDefault("OperationId")
  valid_594505 = validateParameter(valid_594505, JString, required = true,
                                 default = nil)
  if valid_594505 != nil:
    section.add "OperationId", valid_594505
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594506: Call_GetPartitionRestartProgress_594498; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the progress of a PartitionRestart started with StartPartitionRestart using the provided OperationId.
  ## 
  ## 
  let valid = call_594506.validator(path, query, header, formData, body)
  let scheme = call_594506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594506.url(scheme.get, call_594506.host, call_594506.base,
                         call_594506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594506, url, valid)

proc call*(call_594507: Call_GetPartitionRestartProgress_594498;
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
  var path_594508 = newJObject()
  var query_594509 = newJObject()
  add(query_594509, "timeout", newJInt(timeout))
  add(query_594509, "api-version", newJString(apiVersion))
  add(path_594508, "partitionId", newJString(partitionId))
  add(path_594508, "serviceId", newJString(serviceId))
  add(query_594509, "OperationId", newJString(OperationId))
  result = call_594507.call(path_594508, query_594509, nil, nil, nil)

var getPartitionRestartProgress* = Call_GetPartitionRestartProgress_594498(
    name: "getPartitionRestartProgress", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Faults/Services/{serviceId}/$/GetPartitions/{partitionId}/$/GetRestartProgress",
    validator: validate_GetPartitionRestartProgress_594499, base: "",
    url: url_GetPartitionRestartProgress_594500,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartDataLoss_594510 = ref object of OpenApiRestCall_593437
proc url_StartDataLoss_594512(protocol: Scheme; host: string; base: string;
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

proc validate_StartDataLoss_594511(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594513 = path.getOrDefault("partitionId")
  valid_594513 = validateParameter(valid_594513, JString, required = true,
                                 default = nil)
  if valid_594513 != nil:
    section.add "partitionId", valid_594513
  var valid_594514 = path.getOrDefault("serviceId")
  valid_594514 = validateParameter(valid_594514, JString, required = true,
                                 default = nil)
  if valid_594514 != nil:
    section.add "serviceId", valid_594514
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
  var valid_594515 = query.getOrDefault("timeout")
  valid_594515 = validateParameter(valid_594515, JInt, required = false,
                                 default = newJInt(60))
  if valid_594515 != nil:
    section.add "timeout", valid_594515
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594516 = query.getOrDefault("api-version")
  valid_594516 = validateParameter(valid_594516, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594516 != nil:
    section.add "api-version", valid_594516
  var valid_594517 = query.getOrDefault("DataLossMode")
  valid_594517 = validateParameter(valid_594517, JString, required = true,
                                 default = newJString("Invalid"))
  if valid_594517 != nil:
    section.add "DataLossMode", valid_594517
  var valid_594518 = query.getOrDefault("OperationId")
  valid_594518 = validateParameter(valid_594518, JString, required = true,
                                 default = nil)
  if valid_594518 != nil:
    section.add "OperationId", valid_594518
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594519: Call_StartDataLoss_594510; path: JsonNode; query: JsonNode;
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
  let valid = call_594519.validator(path, query, header, formData, body)
  let scheme = call_594519.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594519.url(scheme.get, call_594519.host, call_594519.base,
                         call_594519.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594519, url, valid)

proc call*(call_594520: Call_StartDataLoss_594510; partitionId: string;
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
  var path_594521 = newJObject()
  var query_594522 = newJObject()
  add(query_594522, "timeout", newJInt(timeout))
  add(query_594522, "api-version", newJString(apiVersion))
  add(path_594521, "partitionId", newJString(partitionId))
  add(query_594522, "DataLossMode", newJString(DataLossMode))
  add(path_594521, "serviceId", newJString(serviceId))
  add(query_594522, "OperationId", newJString(OperationId))
  result = call_594520.call(path_594521, query_594522, nil, nil, nil)

var startDataLoss* = Call_StartDataLoss_594510(name: "startDataLoss",
    meth: HttpMethod.HttpPost, host: "azure.local:19080", route: "/Faults/Services/{serviceId}/$/GetPartitions/{partitionId}/$/StartDataLoss",
    validator: validate_StartDataLoss_594511, base: "", url: url_StartDataLoss_594512,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartQuorumLoss_594523 = ref object of OpenApiRestCall_593437
proc url_StartQuorumLoss_594525(protocol: Scheme; host: string; base: string;
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

proc validate_StartQuorumLoss_594524(path: JsonNode; query: JsonNode;
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
  var valid_594526 = path.getOrDefault("partitionId")
  valid_594526 = validateParameter(valid_594526, JString, required = true,
                                 default = nil)
  if valid_594526 != nil:
    section.add "partitionId", valid_594526
  var valid_594527 = path.getOrDefault("serviceId")
  valid_594527 = validateParameter(valid_594527, JString, required = true,
                                 default = nil)
  if valid_594527 != nil:
    section.add "serviceId", valid_594527
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
  var valid_594528 = query.getOrDefault("timeout")
  valid_594528 = validateParameter(valid_594528, JInt, required = false,
                                 default = newJInt(60))
  if valid_594528 != nil:
    section.add "timeout", valid_594528
  assert query != nil,
        "query argument is necessary due to required `QuorumLossMode` field"
  var valid_594529 = query.getOrDefault("QuorumLossMode")
  valid_594529 = validateParameter(valid_594529, JString, required = true,
                                 default = newJString("Invalid"))
  if valid_594529 != nil:
    section.add "QuorumLossMode", valid_594529
  var valid_594530 = query.getOrDefault("api-version")
  valid_594530 = validateParameter(valid_594530, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594530 != nil:
    section.add "api-version", valid_594530
  var valid_594531 = query.getOrDefault("QuorumLossDuration")
  valid_594531 = validateParameter(valid_594531, JInt, required = true, default = nil)
  if valid_594531 != nil:
    section.add "QuorumLossDuration", valid_594531
  var valid_594532 = query.getOrDefault("OperationId")
  valid_594532 = validateParameter(valid_594532, JString, required = true,
                                 default = nil)
  if valid_594532 != nil:
    section.add "OperationId", valid_594532
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594533: Call_StartQuorumLoss_594523; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Induces quorum loss for a given stateful service partition.  This API is useful for a temporary quorum loss situation on your service.
  ## 
  ## Call the GetQuorumLossProgress API with the same OperationId to return information on the operation started with this API.
  ## 
  ## This can only be called on stateful persisted (HasPersistedState==true) services.  Do not use this API on stateless services or stateful in-memory only services.
  ## 
  ## 
  let valid = call_594533.validator(path, query, header, formData, body)
  let scheme = call_594533.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594533.url(scheme.get, call_594533.host, call_594533.base,
                         call_594533.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594533, url, valid)

proc call*(call_594534: Call_StartQuorumLoss_594523; partitionId: string;
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
  var path_594535 = newJObject()
  var query_594536 = newJObject()
  add(query_594536, "timeout", newJInt(timeout))
  add(query_594536, "QuorumLossMode", newJString(QuorumLossMode))
  add(query_594536, "api-version", newJString(apiVersion))
  add(path_594535, "partitionId", newJString(partitionId))
  add(query_594536, "QuorumLossDuration", newJInt(QuorumLossDuration))
  add(path_594535, "serviceId", newJString(serviceId))
  add(query_594536, "OperationId", newJString(OperationId))
  result = call_594534.call(path_594535, query_594536, nil, nil, nil)

var startQuorumLoss* = Call_StartQuorumLoss_594523(name: "startQuorumLoss",
    meth: HttpMethod.HttpPost, host: "azure.local:19080", route: "/Faults/Services/{serviceId}/$/GetPartitions/{partitionId}/$/StartQuorumLoss",
    validator: validate_StartQuorumLoss_594524, base: "", url: url_StartQuorumLoss_594525,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartPartitionRestart_594537 = ref object of OpenApiRestCall_593437
proc url_StartPartitionRestart_594539(protocol: Scheme; host: string; base: string;
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

proc validate_StartPartitionRestart_594538(path: JsonNode; query: JsonNode;
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
  var valid_594540 = path.getOrDefault("partitionId")
  valid_594540 = validateParameter(valid_594540, JString, required = true,
                                 default = nil)
  if valid_594540 != nil:
    section.add "partitionId", valid_594540
  var valid_594541 = path.getOrDefault("serviceId")
  valid_594541 = validateParameter(valid_594541, JString, required = true,
                                 default = nil)
  if valid_594541 != nil:
    section.add "serviceId", valid_594541
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
  var valid_594542 = query.getOrDefault("timeout")
  valid_594542 = validateParameter(valid_594542, JInt, required = false,
                                 default = newJInt(60))
  if valid_594542 != nil:
    section.add "timeout", valid_594542
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594543 = query.getOrDefault("api-version")
  valid_594543 = validateParameter(valid_594543, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594543 != nil:
    section.add "api-version", valid_594543
  var valid_594544 = query.getOrDefault("RestartPartitionMode")
  valid_594544 = validateParameter(valid_594544, JString, required = true,
                                 default = newJString("Invalid"))
  if valid_594544 != nil:
    section.add "RestartPartitionMode", valid_594544
  var valid_594545 = query.getOrDefault("OperationId")
  valid_594545 = validateParameter(valid_594545, JString, required = true,
                                 default = nil)
  if valid_594545 != nil:
    section.add "OperationId", valid_594545
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594546: Call_StartPartitionRestart_594537; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This API is useful for testing failover.
  ## 
  ## If used to target a stateless service partition, RestartPartitionMode must be AllReplicasOrInstances.
  ## 
  ## Call the GetPartitionRestartProgress API using the same OperationId to get the progress.
  ## 
  ## 
  let valid = call_594546.validator(path, query, header, formData, body)
  let scheme = call_594546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594546.url(scheme.get, call_594546.host, call_594546.base,
                         call_594546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594546, url, valid)

proc call*(call_594547: Call_StartPartitionRestart_594537; partitionId: string;
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
  var path_594548 = newJObject()
  var query_594549 = newJObject()
  add(query_594549, "timeout", newJInt(timeout))
  add(query_594549, "api-version", newJString(apiVersion))
  add(query_594549, "RestartPartitionMode", newJString(RestartPartitionMode))
  add(path_594548, "partitionId", newJString(partitionId))
  add(path_594548, "serviceId", newJString(serviceId))
  add(query_594549, "OperationId", newJString(OperationId))
  result = call_594547.call(path_594548, query_594549, nil, nil, nil)

var startPartitionRestart* = Call_StartPartitionRestart_594537(
    name: "startPartitionRestart", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Faults/Services/{serviceId}/$/GetPartitions/{partitionId}/$/StartRestart",
    validator: validate_StartPartitionRestart_594538, base: "",
    url: url_StartPartitionRestart_594539, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetImageStoreRootContent_594550 = ref object of OpenApiRestCall_593437
proc url_GetImageStoreRootContent_594552(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetImageStoreRootContent_594551(path: JsonNode; query: JsonNode;
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
  var valid_594553 = query.getOrDefault("timeout")
  valid_594553 = validateParameter(valid_594553, JInt, required = false,
                                 default = newJInt(60))
  if valid_594553 != nil:
    section.add "timeout", valid_594553
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594554 = query.getOrDefault("api-version")
  valid_594554 = validateParameter(valid_594554, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594554 != nil:
    section.add "api-version", valid_594554
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594555: Call_GetImageStoreRootContent_594550; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the information about the image store content at the root of the image store.
  ## 
  let valid = call_594555.validator(path, query, header, formData, body)
  let scheme = call_594555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594555.url(scheme.get, call_594555.host, call_594555.base,
                         call_594555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594555, url, valid)

proc call*(call_594556: Call_GetImageStoreRootContent_594550; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## getImageStoreRootContent
  ## Returns the information about the image store content at the root of the image store.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  var query_594557 = newJObject()
  add(query_594557, "timeout", newJInt(timeout))
  add(query_594557, "api-version", newJString(apiVersion))
  result = call_594556.call(nil, query_594557, nil, nil, nil)

var getImageStoreRootContent* = Call_GetImageStoreRootContent_594550(
    name: "getImageStoreRootContent", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ImageStore",
    validator: validate_GetImageStoreRootContent_594551, base: "",
    url: url_GetImageStoreRootContent_594552, schemes: {Scheme.Https, Scheme.Http})
type
  Call_CopyImageStoreContent_594558 = ref object of OpenApiRestCall_593437
proc url_CopyImageStoreContent_594560(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CopyImageStoreContent_594559(path: JsonNode; query: JsonNode;
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
  var valid_594561 = query.getOrDefault("timeout")
  valid_594561 = validateParameter(valid_594561, JInt, required = false,
                                 default = newJInt(60))
  if valid_594561 != nil:
    section.add "timeout", valid_594561
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594562 = query.getOrDefault("api-version")
  valid_594562 = validateParameter(valid_594562, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594562 != nil:
    section.add "api-version", valid_594562
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

proc call*(call_594564: Call_CopyImageStoreContent_594558; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies the image store content from the source image store relative path to the destination image store relative path.
  ## 
  let valid = call_594564.validator(path, query, header, formData, body)
  let scheme = call_594564.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594564.url(scheme.get, call_594564.host, call_594564.base,
                         call_594564.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594564, url, valid)

proc call*(call_594565: Call_CopyImageStoreContent_594558;
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
  var query_594566 = newJObject()
  var body_594567 = newJObject()
  add(query_594566, "timeout", newJInt(timeout))
  add(query_594566, "api-version", newJString(apiVersion))
  if ImageStoreCopyDescription != nil:
    body_594567 = ImageStoreCopyDescription
  result = call_594565.call(nil, query_594566, nil, nil, body_594567)

var copyImageStoreContent* = Call_CopyImageStoreContent_594558(
    name: "copyImageStoreContent", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/ImageStore/$/Copy",
    validator: validate_CopyImageStoreContent_594559, base: "",
    url: url_CopyImageStoreContent_594560, schemes: {Scheme.Https, Scheme.Http})
type
  Call_UploadFile_594578 = ref object of OpenApiRestCall_593437
proc url_UploadFile_594580(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_UploadFile_594579(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594581 = path.getOrDefault("contentPath")
  valid_594581 = validateParameter(valid_594581, JString, required = true,
                                 default = nil)
  if valid_594581 != nil:
    section.add "contentPath", valid_594581
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594582 = query.getOrDefault("timeout")
  valid_594582 = validateParameter(valid_594582, JInt, required = false,
                                 default = newJInt(60))
  if valid_594582 != nil:
    section.add "timeout", valid_594582
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594583 = query.getOrDefault("api-version")
  valid_594583 = validateParameter(valid_594583, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594583 != nil:
    section.add "api-version", valid_594583
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594584: Call_UploadFile_594578; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Uploads contents of the file to the image store. Use this API if the file is small enough to upload again if the connection fails. The file's data needs to be added to the request body. The contents will be uploaded to the specified path.
  ## 
  let valid = call_594584.validator(path, query, header, formData, body)
  let scheme = call_594584.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594584.url(scheme.get, call_594584.host, call_594584.base,
                         call_594584.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594584, url, valid)

proc call*(call_594585: Call_UploadFile_594578; contentPath: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## uploadFile
  ## Uploads contents of the file to the image store. Use this API if the file is small enough to upload again if the connection fails. The file's data needs to be added to the request body. The contents will be uploaded to the specified path.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   contentPath: string (required)
  ##              : Relative path to file or folder in the image store from its root.
  var path_594586 = newJObject()
  var query_594587 = newJObject()
  add(query_594587, "timeout", newJInt(timeout))
  add(query_594587, "api-version", newJString(apiVersion))
  add(path_594586, "contentPath", newJString(contentPath))
  result = call_594585.call(path_594586, query_594587, nil, nil, nil)

var uploadFile* = Call_UploadFile_594578(name: "uploadFile",
                                      meth: HttpMethod.HttpPut,
                                      host: "azure.local:19080",
                                      route: "/ImageStore/{contentPath}",
                                      validator: validate_UploadFile_594579,
                                      base: "", url: url_UploadFile_594580,
                                      schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetImageStoreContent_594568 = ref object of OpenApiRestCall_593437
proc url_GetImageStoreContent_594570(protocol: Scheme; host: string; base: string;
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

proc validate_GetImageStoreContent_594569(path: JsonNode; query: JsonNode;
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
  var valid_594571 = path.getOrDefault("contentPath")
  valid_594571 = validateParameter(valid_594571, JString, required = true,
                                 default = nil)
  if valid_594571 != nil:
    section.add "contentPath", valid_594571
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594572 = query.getOrDefault("timeout")
  valid_594572 = validateParameter(valid_594572, JInt, required = false,
                                 default = newJInt(60))
  if valid_594572 != nil:
    section.add "timeout", valid_594572
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594573 = query.getOrDefault("api-version")
  valid_594573 = validateParameter(valid_594573, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594573 != nil:
    section.add "api-version", valid_594573
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594574: Call_GetImageStoreContent_594568; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the information about the image store content at the specified contentPath relative to the root of the image store.
  ## 
  let valid = call_594574.validator(path, query, header, formData, body)
  let scheme = call_594574.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594574.url(scheme.get, call_594574.host, call_594574.base,
                         call_594574.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594574, url, valid)

proc call*(call_594575: Call_GetImageStoreContent_594568; contentPath: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getImageStoreContent
  ## Returns the information about the image store content at the specified contentPath relative to the root of the image store.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   contentPath: string (required)
  ##              : Relative path to file or folder in the image store from its root.
  var path_594576 = newJObject()
  var query_594577 = newJObject()
  add(query_594577, "timeout", newJInt(timeout))
  add(query_594577, "api-version", newJString(apiVersion))
  add(path_594576, "contentPath", newJString(contentPath))
  result = call_594575.call(path_594576, query_594577, nil, nil, nil)

var getImageStoreContent* = Call_GetImageStoreContent_594568(
    name: "getImageStoreContent", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/ImageStore/{contentPath}",
    validator: validate_GetImageStoreContent_594569, base: "",
    url: url_GetImageStoreContent_594570, schemes: {Scheme.Https, Scheme.Http})
type
  Call_DeleteImageStoreContent_594588 = ref object of OpenApiRestCall_593437
proc url_DeleteImageStoreContent_594590(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteImageStoreContent_594589(path: JsonNode; query: JsonNode;
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
  var valid_594591 = path.getOrDefault("contentPath")
  valid_594591 = validateParameter(valid_594591, JString, required = true,
                                 default = nil)
  if valid_594591 != nil:
    section.add "contentPath", valid_594591
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594592 = query.getOrDefault("timeout")
  valid_594592 = validateParameter(valid_594592, JInt, required = false,
                                 default = newJInt(60))
  if valid_594592 != nil:
    section.add "timeout", valid_594592
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594593 = query.getOrDefault("api-version")
  valid_594593 = validateParameter(valid_594593, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594593 != nil:
    section.add "api-version", valid_594593
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594594: Call_DeleteImageStoreContent_594588; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes existing image store content being found within the given image store relative path. This can be used to delete uploaded application packages once they are provisioned.
  ## 
  let valid = call_594594.validator(path, query, header, formData, body)
  let scheme = call_594594.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594594.url(scheme.get, call_594594.host, call_594594.base,
                         call_594594.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594594, url, valid)

proc call*(call_594595: Call_DeleteImageStoreContent_594588; contentPath: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## deleteImageStoreContent
  ## Deletes existing image store content being found within the given image store relative path. This can be used to delete uploaded application packages once they are provisioned.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   contentPath: string (required)
  ##              : Relative path to file or folder in the image store from its root.
  var path_594596 = newJObject()
  var query_594597 = newJObject()
  add(query_594597, "timeout", newJInt(timeout))
  add(query_594597, "api-version", newJString(apiVersion))
  add(path_594596, "contentPath", newJString(contentPath))
  result = call_594595.call(path_594596, query_594597, nil, nil, nil)

var deleteImageStoreContent* = Call_DeleteImageStoreContent_594588(
    name: "deleteImageStoreContent", meth: HttpMethod.HttpDelete,
    host: "azure.local:19080", route: "/ImageStore/{contentPath}",
    validator: validate_DeleteImageStoreContent_594589, base: "",
    url: url_DeleteImageStoreContent_594590, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetNodeInfoList_594598 = ref object of OpenApiRestCall_593437
proc url_GetNodeInfoList_594600(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetNodeInfoList_594599(path: JsonNode; query: JsonNode;
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
  var valid_594601 = query.getOrDefault("timeout")
  valid_594601 = validateParameter(valid_594601, JInt, required = false,
                                 default = newJInt(60))
  if valid_594601 != nil:
    section.add "timeout", valid_594601
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594602 = query.getOrDefault("api-version")
  valid_594602 = validateParameter(valid_594602, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594602 != nil:
    section.add "api-version", valid_594602
  var valid_594603 = query.getOrDefault("NodeStatusFilter")
  valid_594603 = validateParameter(valid_594603, JString, required = false,
                                 default = newJString("default"))
  if valid_594603 != nil:
    section.add "NodeStatusFilter", valid_594603
  var valid_594604 = query.getOrDefault("ContinuationToken")
  valid_594604 = validateParameter(valid_594604, JString, required = false,
                                 default = nil)
  if valid_594604 != nil:
    section.add "ContinuationToken", valid_594604
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594605: Call_GetNodeInfoList_594598; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Nodes endpoint returns information about the nodes in the Service Fabric Cluster. The respons include the name, status, id, health, uptime and other details about the node.
  ## 
  let valid = call_594605.validator(path, query, header, formData, body)
  let scheme = call_594605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594605.url(scheme.get, call_594605.host, call_594605.base,
                         call_594605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594605, url, valid)

proc call*(call_594606: Call_GetNodeInfoList_594598; timeout: int = 60;
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
  var query_594607 = newJObject()
  add(query_594607, "timeout", newJInt(timeout))
  add(query_594607, "api-version", newJString(apiVersion))
  add(query_594607, "NodeStatusFilter", newJString(NodeStatusFilter))
  add(query_594607, "ContinuationToken", newJString(ContinuationToken))
  result = call_594606.call(nil, query_594607, nil, nil, nil)

var getNodeInfoList* = Call_GetNodeInfoList_594598(name: "getNodeInfoList",
    meth: HttpMethod.HttpGet, host: "azure.local:19080", route: "/Nodes",
    validator: validate_GetNodeInfoList_594599, base: "", url: url_GetNodeInfoList_594600,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetNodeInfo_594608 = ref object of OpenApiRestCall_593437
proc url_GetNodeInfo_594610(protocol: Scheme; host: string; base: string;
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

proc validate_GetNodeInfo_594609(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594611 = path.getOrDefault("nodeName")
  valid_594611 = validateParameter(valid_594611, JString, required = true,
                                 default = nil)
  if valid_594611 != nil:
    section.add "nodeName", valid_594611
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594612 = query.getOrDefault("timeout")
  valid_594612 = validateParameter(valid_594612, JInt, required = false,
                                 default = newJInt(60))
  if valid_594612 != nil:
    section.add "timeout", valid_594612
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594613 = query.getOrDefault("api-version")
  valid_594613 = validateParameter(valid_594613, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594613 != nil:
    section.add "api-version", valid_594613
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594614: Call_GetNodeInfo_594608; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about a specific node in the Service Fabric Cluster.The respons include the name, status, id, health, uptime and other details about the node.
  ## 
  let valid = call_594614.validator(path, query, header, formData, body)
  let scheme = call_594614.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594614.url(scheme.get, call_594614.host, call_594614.base,
                         call_594614.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594614, url, valid)

proc call*(call_594615: Call_GetNodeInfo_594608; nodeName: string; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## getNodeInfo
  ## Gets the information about a specific node in the Service Fabric Cluster.The respons include the name, status, id, health, uptime and other details about the node.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_594616 = newJObject()
  var query_594617 = newJObject()
  add(query_594617, "timeout", newJInt(timeout))
  add(query_594617, "api-version", newJString(apiVersion))
  add(path_594616, "nodeName", newJString(nodeName))
  result = call_594615.call(path_594616, query_594617, nil, nil, nil)

var getNodeInfo* = Call_GetNodeInfo_594608(name: "getNodeInfo",
                                        meth: HttpMethod.HttpGet,
                                        host: "azure.local:19080",
                                        route: "/Nodes/{nodeName}",
                                        validator: validate_GetNodeInfo_594609,
                                        base: "", url: url_GetNodeInfo_594610,
                                        schemes: {Scheme.Https, Scheme.Http})
type
  Call_EnableNode_594618 = ref object of OpenApiRestCall_593437
proc url_EnableNode_594620(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_EnableNode_594619(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594621 = path.getOrDefault("nodeName")
  valid_594621 = validateParameter(valid_594621, JString, required = true,
                                 default = nil)
  if valid_594621 != nil:
    section.add "nodeName", valid_594621
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594622 = query.getOrDefault("timeout")
  valid_594622 = validateParameter(valid_594622, JInt, required = false,
                                 default = newJInt(60))
  if valid_594622 != nil:
    section.add "timeout", valid_594622
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594623 = query.getOrDefault("api-version")
  valid_594623 = validateParameter(valid_594623, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594623 != nil:
    section.add "api-version", valid_594623
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594624: Call_EnableNode_594618; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activates a Service Fabric cluster node which is currently deactivated. Once activated, the node will again become a viable target for placing new replicas, and any deactivated replicas remaining on the node will be reactivated.
  ## 
  let valid = call_594624.validator(path, query, header, formData, body)
  let scheme = call_594624.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594624.url(scheme.get, call_594624.host, call_594624.base,
                         call_594624.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594624, url, valid)

proc call*(call_594625: Call_EnableNode_594618; nodeName: string; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## enableNode
  ## Activates a Service Fabric cluster node which is currently deactivated. Once activated, the node will again become a viable target for placing new replicas, and any deactivated replicas remaining on the node will be reactivated.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_594626 = newJObject()
  var query_594627 = newJObject()
  add(query_594627, "timeout", newJInt(timeout))
  add(query_594627, "api-version", newJString(apiVersion))
  add(path_594626, "nodeName", newJString(nodeName))
  result = call_594625.call(path_594626, query_594627, nil, nil, nil)

var enableNode* = Call_EnableNode_594618(name: "enableNode",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local:19080",
                                      route: "/Nodes/{nodeName}/$/Activate",
                                      validator: validate_EnableNode_594619,
                                      base: "", url: url_EnableNode_594620,
                                      schemes: {Scheme.Https, Scheme.Http})
type
  Call_DisableNode_594628 = ref object of OpenApiRestCall_593437
proc url_DisableNode_594630(protocol: Scheme; host: string; base: string;
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

proc validate_DisableNode_594629(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594631 = path.getOrDefault("nodeName")
  valid_594631 = validateParameter(valid_594631, JString, required = true,
                                 default = nil)
  if valid_594631 != nil:
    section.add "nodeName", valid_594631
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594632 = query.getOrDefault("timeout")
  valid_594632 = validateParameter(valid_594632, JInt, required = false,
                                 default = newJInt(60))
  if valid_594632 != nil:
    section.add "timeout", valid_594632
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594633 = query.getOrDefault("api-version")
  valid_594633 = validateParameter(valid_594633, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594633 != nil:
    section.add "api-version", valid_594633
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

proc call*(call_594635: Call_DisableNode_594628; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deactivate a Service Fabric cluster node with the specified deactivation intent. Once the deactivation is in progress, the deactivation intent can be increased, but not decreased (for example, a node which is was deactivated with the Pause intent can be deactivated further with Restart, but not the other way around. Nodes may be reactivated using the Activate a node operation any time after they are deactivated. If the deactivation is not complete this will cancel the deactivation. A node which goes down and comes back up while deactivated will still need to be reactivated before services will be placed on that node.
  ## 
  let valid = call_594635.validator(path, query, header, formData, body)
  let scheme = call_594635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594635.url(scheme.get, call_594635.host, call_594635.base,
                         call_594635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594635, url, valid)

proc call*(call_594636: Call_DisableNode_594628; nodeName: string;
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
  var path_594637 = newJObject()
  var query_594638 = newJObject()
  var body_594639 = newJObject()
  add(query_594638, "timeout", newJInt(timeout))
  add(query_594638, "api-version", newJString(apiVersion))
  add(path_594637, "nodeName", newJString(nodeName))
  if DeactivationIntentDescription != nil:
    body_594639 = DeactivationIntentDescription
  result = call_594636.call(path_594637, query_594638, nil, nil, body_594639)

var disableNode* = Call_DisableNode_594628(name: "disableNode",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local:19080", route: "/Nodes/{nodeName}/$/Deactivate",
                                        validator: validate_DisableNode_594629,
                                        base: "", url: url_DisableNode_594630,
                                        schemes: {Scheme.Https, Scheme.Http})
type
  Call_DeployedServicePackageToNode_594640 = ref object of OpenApiRestCall_593437
proc url_DeployedServicePackageToNode_594642(protocol: Scheme; host: string;
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

proc validate_DeployedServicePackageToNode_594641(path: JsonNode; query: JsonNode;
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
  var valid_594643 = path.getOrDefault("nodeName")
  valid_594643 = validateParameter(valid_594643, JString, required = true,
                                 default = nil)
  if valid_594643 != nil:
    section.add "nodeName", valid_594643
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594644 = query.getOrDefault("timeout")
  valid_594644 = validateParameter(valid_594644, JInt, required = false,
                                 default = newJInt(60))
  if valid_594644 != nil:
    section.add "timeout", valid_594644
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594645 = query.getOrDefault("api-version")
  valid_594645 = validateParameter(valid_594645, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594645 != nil:
    section.add "api-version", valid_594645
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

proc call*(call_594647: Call_DeployedServicePackageToNode_594640; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Downloads packages associated with specified service manifest to image cache on specified node.
  ## 
  ## 
  let valid = call_594647.validator(path, query, header, formData, body)
  let scheme = call_594647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594647.url(scheme.get, call_594647.host, call_594647.base,
                         call_594647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594647, url, valid)

proc call*(call_594648: Call_DeployedServicePackageToNode_594640; nodeName: string;
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
  var path_594649 = newJObject()
  var query_594650 = newJObject()
  var body_594651 = newJObject()
  add(query_594650, "timeout", newJInt(timeout))
  add(query_594650, "api-version", newJString(apiVersion))
  add(path_594649, "nodeName", newJString(nodeName))
  if DeployServicePackageToNodeDescription != nil:
    body_594651 = DeployServicePackageToNodeDescription
  result = call_594648.call(path_594649, query_594650, nil, nil, body_594651)

var deployedServicePackageToNode* = Call_DeployedServicePackageToNode_594640(
    name: "deployedServicePackageToNode", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/DeployServicePackage",
    validator: validate_DeployedServicePackageToNode_594641, base: "",
    url: url_DeployedServicePackageToNode_594642,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedApplicationInfoList_594652 = ref object of OpenApiRestCall_593437
proc url_GetDeployedApplicationInfoList_594654(protocol: Scheme; host: string;
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

proc validate_GetDeployedApplicationInfoList_594653(path: JsonNode;
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
  var valid_594655 = path.getOrDefault("nodeName")
  valid_594655 = validateParameter(valid_594655, JString, required = true,
                                 default = nil)
  if valid_594655 != nil:
    section.add "nodeName", valid_594655
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594656 = query.getOrDefault("timeout")
  valid_594656 = validateParameter(valid_594656, JInt, required = false,
                                 default = newJInt(60))
  if valid_594656 != nil:
    section.add "timeout", valid_594656
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594657 = query.getOrDefault("api-version")
  valid_594657 = validateParameter(valid_594657, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594657 != nil:
    section.add "api-version", valid_594657
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594658: Call_GetDeployedApplicationInfoList_594652; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of applications deployed on a Service Fabric node.
  ## 
  let valid = call_594658.validator(path, query, header, formData, body)
  let scheme = call_594658.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594658.url(scheme.get, call_594658.host, call_594658.base,
                         call_594658.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594658, url, valid)

proc call*(call_594659: Call_GetDeployedApplicationInfoList_594652;
          nodeName: string; timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getDeployedApplicationInfoList
  ## Gets the list of applications deployed on a Service Fabric node.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_594660 = newJObject()
  var query_594661 = newJObject()
  add(query_594661, "timeout", newJInt(timeout))
  add(query_594661, "api-version", newJString(apiVersion))
  add(path_594660, "nodeName", newJString(nodeName))
  result = call_594659.call(path_594660, query_594661, nil, nil, nil)

var getDeployedApplicationInfoList* = Call_GetDeployedApplicationInfoList_594652(
    name: "getDeployedApplicationInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications",
    validator: validate_GetDeployedApplicationInfoList_594653, base: "",
    url: url_GetDeployedApplicationInfoList_594654,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedApplicationInfo_594662 = ref object of OpenApiRestCall_593437
proc url_GetDeployedApplicationInfo_594664(protocol: Scheme; host: string;
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

proc validate_GetDeployedApplicationInfo_594663(path: JsonNode; query: JsonNode;
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
  var valid_594665 = path.getOrDefault("nodeName")
  valid_594665 = validateParameter(valid_594665, JString, required = true,
                                 default = nil)
  if valid_594665 != nil:
    section.add "nodeName", valid_594665
  var valid_594666 = path.getOrDefault("applicationId")
  valid_594666 = validateParameter(valid_594666, JString, required = true,
                                 default = nil)
  if valid_594666 != nil:
    section.add "applicationId", valid_594666
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594667 = query.getOrDefault("timeout")
  valid_594667 = validateParameter(valid_594667, JInt, required = false,
                                 default = newJInt(60))
  if valid_594667 != nil:
    section.add "timeout", valid_594667
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594668 = query.getOrDefault("api-version")
  valid_594668 = validateParameter(valid_594668, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594668 != nil:
    section.add "api-version", valid_594668
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594669: Call_GetDeployedApplicationInfo_594662; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about an application deployed on a Service Fabric node.
  ## 
  let valid = call_594669.validator(path, query, header, formData, body)
  let scheme = call_594669.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594669.url(scheme.get, call_594669.host, call_594669.base,
                         call_594669.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594669, url, valid)

proc call*(call_594670: Call_GetDeployedApplicationInfo_594662; nodeName: string;
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
  var path_594671 = newJObject()
  var query_594672 = newJObject()
  add(query_594672, "timeout", newJInt(timeout))
  add(query_594672, "api-version", newJString(apiVersion))
  add(path_594671, "nodeName", newJString(nodeName))
  add(path_594671, "applicationId", newJString(applicationId))
  result = call_594670.call(path_594671, query_594672, nil, nil, nil)

var getDeployedApplicationInfo* = Call_GetDeployedApplicationInfo_594662(
    name: "getDeployedApplicationInfo", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}",
    validator: validate_GetDeployedApplicationInfo_594663, base: "",
    url: url_GetDeployedApplicationInfo_594664,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedCodePackageInfoList_594673 = ref object of OpenApiRestCall_593437
proc url_GetDeployedCodePackageInfoList_594675(protocol: Scheme; host: string;
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

proc validate_GetDeployedCodePackageInfoList_594674(path: JsonNode;
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
  var valid_594676 = path.getOrDefault("nodeName")
  valid_594676 = validateParameter(valid_594676, JString, required = true,
                                 default = nil)
  if valid_594676 != nil:
    section.add "nodeName", valid_594676
  var valid_594677 = path.getOrDefault("applicationId")
  valid_594677 = validateParameter(valid_594677, JString, required = true,
                                 default = nil)
  if valid_594677 != nil:
    section.add "applicationId", valid_594677
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
  var valid_594678 = query.getOrDefault("timeout")
  valid_594678 = validateParameter(valid_594678, JInt, required = false,
                                 default = newJInt(60))
  if valid_594678 != nil:
    section.add "timeout", valid_594678
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594679 = query.getOrDefault("api-version")
  valid_594679 = validateParameter(valid_594679, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594679 != nil:
    section.add "api-version", valid_594679
  var valid_594680 = query.getOrDefault("ServiceManifestName")
  valid_594680 = validateParameter(valid_594680, JString, required = false,
                                 default = nil)
  if valid_594680 != nil:
    section.add "ServiceManifestName", valid_594680
  var valid_594681 = query.getOrDefault("CodePackageName")
  valid_594681 = validateParameter(valid_594681, JString, required = false,
                                 default = nil)
  if valid_594681 != nil:
    section.add "CodePackageName", valid_594681
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594682: Call_GetDeployedCodePackageInfoList_594673; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of code packages deployed on a Service Fabric node for the given application.
  ## 
  let valid = call_594682.validator(path, query, header, formData, body)
  let scheme = call_594682.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594682.url(scheme.get, call_594682.host, call_594682.base,
                         call_594682.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594682, url, valid)

proc call*(call_594683: Call_GetDeployedCodePackageInfoList_594673;
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
  var path_594684 = newJObject()
  var query_594685 = newJObject()
  add(query_594685, "timeout", newJInt(timeout))
  add(query_594685, "api-version", newJString(apiVersion))
  add(path_594684, "nodeName", newJString(nodeName))
  add(query_594685, "ServiceManifestName", newJString(ServiceManifestName))
  add(path_594684, "applicationId", newJString(applicationId))
  add(query_594685, "CodePackageName", newJString(CodePackageName))
  result = call_594683.call(path_594684, query_594685, nil, nil, nil)

var getDeployedCodePackageInfoList* = Call_GetDeployedCodePackageInfoList_594673(
    name: "getDeployedCodePackageInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetCodePackages",
    validator: validate_GetDeployedCodePackageInfoList_594674, base: "",
    url: url_GetDeployedCodePackageInfoList_594675,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_RestartDeployedCodePackage_594686 = ref object of OpenApiRestCall_593437
proc url_RestartDeployedCodePackage_594688(protocol: Scheme; host: string;
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

proc validate_RestartDeployedCodePackage_594687(path: JsonNode; query: JsonNode;
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
  var valid_594689 = path.getOrDefault("nodeName")
  valid_594689 = validateParameter(valid_594689, JString, required = true,
                                 default = nil)
  if valid_594689 != nil:
    section.add "nodeName", valid_594689
  var valid_594690 = path.getOrDefault("applicationId")
  valid_594690 = validateParameter(valid_594690, JString, required = true,
                                 default = nil)
  if valid_594690 != nil:
    section.add "applicationId", valid_594690
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594691 = query.getOrDefault("timeout")
  valid_594691 = validateParameter(valid_594691, JInt, required = false,
                                 default = newJInt(60))
  if valid_594691 != nil:
    section.add "timeout", valid_594691
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594692 = query.getOrDefault("api-version")
  valid_594692 = validateParameter(valid_594692, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594692 != nil:
    section.add "api-version", valid_594692
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

proc call*(call_594694: Call_RestartDeployedCodePackage_594686; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a code package deployed on a Service Fabric node in a cluster. This aborts the code package process, which will restart all the user service replicas hosted in that process.
  ## 
  let valid = call_594694.validator(path, query, header, formData, body)
  let scheme = call_594694.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594694.url(scheme.get, call_594694.host, call_594694.base,
                         call_594694.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594694, url, valid)

proc call*(call_594695: Call_RestartDeployedCodePackage_594686; nodeName: string;
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
  var path_594696 = newJObject()
  var query_594697 = newJObject()
  var body_594698 = newJObject()
  add(query_594697, "timeout", newJInt(timeout))
  add(query_594697, "api-version", newJString(apiVersion))
  add(path_594696, "nodeName", newJString(nodeName))
  add(path_594696, "applicationId", newJString(applicationId))
  if RestartDeployedCodePackageDescription != nil:
    body_594698 = RestartDeployedCodePackageDescription
  result = call_594695.call(path_594696, query_594697, nil, nil, body_594698)

var restartDeployedCodePackage* = Call_RestartDeployedCodePackage_594686(
    name: "restartDeployedCodePackage", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetCodePackages/$/Restart",
    validator: validate_RestartDeployedCodePackage_594687, base: "",
    url: url_RestartDeployedCodePackage_594688,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedApplicationHealthUsingPolicy_594712 = ref object of OpenApiRestCall_593437
proc url_GetDeployedApplicationHealthUsingPolicy_594714(protocol: Scheme;
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

proc validate_GetDeployedApplicationHealthUsingPolicy_594713(path: JsonNode;
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
  var valid_594715 = path.getOrDefault("nodeName")
  valid_594715 = validateParameter(valid_594715, JString, required = true,
                                 default = nil)
  if valid_594715 != nil:
    section.add "nodeName", valid_594715
  var valid_594716 = path.getOrDefault("applicationId")
  valid_594716 = validateParameter(valid_594716, JString, required = true,
                                 default = nil)
  if valid_594716 != nil:
    section.add "applicationId", valid_594716
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
  var valid_594717 = query.getOrDefault("timeout")
  valid_594717 = validateParameter(valid_594717, JInt, required = false,
                                 default = newJInt(60))
  if valid_594717 != nil:
    section.add "timeout", valid_594717
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594718 = query.getOrDefault("api-version")
  valid_594718 = validateParameter(valid_594718, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594718 != nil:
    section.add "api-version", valid_594718
  var valid_594719 = query.getOrDefault("DeployedServicePackagesHealthStateFilter")
  valid_594719 = validateParameter(valid_594719, JInt, required = false,
                                 default = newJInt(0))
  if valid_594719 != nil:
    section.add "DeployedServicePackagesHealthStateFilter", valid_594719
  var valid_594720 = query.getOrDefault("EventsHealthStateFilter")
  valid_594720 = validateParameter(valid_594720, JInt, required = false,
                                 default = newJInt(0))
  if valid_594720 != nil:
    section.add "EventsHealthStateFilter", valid_594720
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

proc call*(call_594722: Call_GetDeployedApplicationHealthUsingPolicy_594712;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the information about health of an application deployed on a Service Fabric node using the specified policy. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed application based on health state. Use DeployedServicePackagesHealthStateFilter to optionally filter for DeployedServicePackageHealth children based on health state. Use ApplicationHealthPolicy to optionally override the health policies used to evaluate the health. This API only uses 'ConsiderWarningAsError' field of the ApplicationHealthPolicy. The rest of the fields are ignored while evaluating the health of the deployed application.
  ## 
  ## 
  let valid = call_594722.validator(path, query, header, formData, body)
  let scheme = call_594722.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594722.url(scheme.get, call_594722.host, call_594722.base,
                         call_594722.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594722, url, valid)

proc call*(call_594723: Call_GetDeployedApplicationHealthUsingPolicy_594712;
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
  var path_594724 = newJObject()
  var query_594725 = newJObject()
  var body_594726 = newJObject()
  add(query_594725, "timeout", newJInt(timeout))
  add(query_594725, "api-version", newJString(apiVersion))
  add(path_594724, "nodeName", newJString(nodeName))
  if ApplicationHealthPolicy != nil:
    body_594726 = ApplicationHealthPolicy
  add(query_594725, "DeployedServicePackagesHealthStateFilter",
      newJInt(DeployedServicePackagesHealthStateFilter))
  add(query_594725, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_594724, "applicationId", newJString(applicationId))
  result = call_594723.call(path_594724, query_594725, nil, nil, body_594726)

var getDeployedApplicationHealthUsingPolicy* = Call_GetDeployedApplicationHealthUsingPolicy_594712(
    name: "getDeployedApplicationHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetHealth",
    validator: validate_GetDeployedApplicationHealthUsingPolicy_594713, base: "",
    url: url_GetDeployedApplicationHealthUsingPolicy_594714,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedApplicationHealth_594699 = ref object of OpenApiRestCall_593437
proc url_GetDeployedApplicationHealth_594701(protocol: Scheme; host: string;
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

proc validate_GetDeployedApplicationHealth_594700(path: JsonNode; query: JsonNode;
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
  var valid_594702 = path.getOrDefault("nodeName")
  valid_594702 = validateParameter(valid_594702, JString, required = true,
                                 default = nil)
  if valid_594702 != nil:
    section.add "nodeName", valid_594702
  var valid_594703 = path.getOrDefault("applicationId")
  valid_594703 = validateParameter(valid_594703, JString, required = true,
                                 default = nil)
  if valid_594703 != nil:
    section.add "applicationId", valid_594703
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
  var valid_594704 = query.getOrDefault("timeout")
  valid_594704 = validateParameter(valid_594704, JInt, required = false,
                                 default = newJInt(60))
  if valid_594704 != nil:
    section.add "timeout", valid_594704
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594705 = query.getOrDefault("api-version")
  valid_594705 = validateParameter(valid_594705, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594705 != nil:
    section.add "api-version", valid_594705
  var valid_594706 = query.getOrDefault("DeployedServicePackagesHealthStateFilter")
  valid_594706 = validateParameter(valid_594706, JInt, required = false,
                                 default = newJInt(0))
  if valid_594706 != nil:
    section.add "DeployedServicePackagesHealthStateFilter", valid_594706
  var valid_594707 = query.getOrDefault("EventsHealthStateFilter")
  valid_594707 = validateParameter(valid_594707, JInt, required = false,
                                 default = newJInt(0))
  if valid_594707 != nil:
    section.add "EventsHealthStateFilter", valid_594707
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594708: Call_GetDeployedApplicationHealth_594699; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about health of an application deployed on a Service Fabric node. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed application based on health state. Use DeployedServicePackagesHealthStateFilter to optionally filter for DeployedServicePackageHealth children based on health state.
  ## 
  let valid = call_594708.validator(path, query, header, formData, body)
  let scheme = call_594708.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594708.url(scheme.get, call_594708.host, call_594708.base,
                         call_594708.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594708, url, valid)

proc call*(call_594709: Call_GetDeployedApplicationHealth_594699; nodeName: string;
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
  var path_594710 = newJObject()
  var query_594711 = newJObject()
  add(query_594711, "timeout", newJInt(timeout))
  add(query_594711, "api-version", newJString(apiVersion))
  add(path_594710, "nodeName", newJString(nodeName))
  add(query_594711, "DeployedServicePackagesHealthStateFilter",
      newJInt(DeployedServicePackagesHealthStateFilter))
  add(query_594711, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_594710, "applicationId", newJString(applicationId))
  result = call_594709.call(path_594710, query_594711, nil, nil, nil)

var getDeployedApplicationHealth* = Call_GetDeployedApplicationHealth_594699(
    name: "getDeployedApplicationHealth", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetHealth",
    validator: validate_GetDeployedApplicationHealth_594700, base: "",
    url: url_GetDeployedApplicationHealth_594701,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServiceReplicaInfoList_594727 = ref object of OpenApiRestCall_593437
proc url_GetDeployedServiceReplicaInfoList_594729(protocol: Scheme; host: string;
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

proc validate_GetDeployedServiceReplicaInfoList_594728(path: JsonNode;
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
  var valid_594730 = path.getOrDefault("nodeName")
  valid_594730 = validateParameter(valid_594730, JString, required = true,
                                 default = nil)
  if valid_594730 != nil:
    section.add "nodeName", valid_594730
  var valid_594731 = path.getOrDefault("applicationId")
  valid_594731 = validateParameter(valid_594731, JString, required = true,
                                 default = nil)
  if valid_594731 != nil:
    section.add "applicationId", valid_594731
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
  var valid_594732 = query.getOrDefault("timeout")
  valid_594732 = validateParameter(valid_594732, JInt, required = false,
                                 default = newJInt(60))
  if valid_594732 != nil:
    section.add "timeout", valid_594732
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594733 = query.getOrDefault("api-version")
  valid_594733 = validateParameter(valid_594733, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594733 != nil:
    section.add "api-version", valid_594733
  var valid_594734 = query.getOrDefault("ServiceManifestName")
  valid_594734 = validateParameter(valid_594734, JString, required = false,
                                 default = nil)
  if valid_594734 != nil:
    section.add "ServiceManifestName", valid_594734
  var valid_594735 = query.getOrDefault("PartitionId")
  valid_594735 = validateParameter(valid_594735, JString, required = false,
                                 default = nil)
  if valid_594735 != nil:
    section.add "PartitionId", valid_594735
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594736: Call_GetDeployedServiceReplicaInfoList_594727;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the list containing the information about replicas deployed on a Service Fabric node. The information include partition id, replica id, status of the replica, name of the service, name of the service type and other information. Use PartitionId or ServiceManifestName query parameters to return information about the deployed replicas matching the specified values for those parameters.
  ## 
  let valid = call_594736.validator(path, query, header, formData, body)
  let scheme = call_594736.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594736.url(scheme.get, call_594736.host, call_594736.base,
                         call_594736.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594736, url, valid)

proc call*(call_594737: Call_GetDeployedServiceReplicaInfoList_594727;
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
  var path_594738 = newJObject()
  var query_594739 = newJObject()
  add(query_594739, "timeout", newJInt(timeout))
  add(query_594739, "api-version", newJString(apiVersion))
  add(path_594738, "nodeName", newJString(nodeName))
  add(query_594739, "ServiceManifestName", newJString(ServiceManifestName))
  add(path_594738, "applicationId", newJString(applicationId))
  add(query_594739, "PartitionId", newJString(PartitionId))
  result = call_594737.call(path_594738, query_594739, nil, nil, nil)

var getDeployedServiceReplicaInfoList* = Call_GetDeployedServiceReplicaInfoList_594727(
    name: "getDeployedServiceReplicaInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetReplicas",
    validator: validate_GetDeployedServiceReplicaInfoList_594728, base: "",
    url: url_GetDeployedServiceReplicaInfoList_594729,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServicePackageInfoList_594740 = ref object of OpenApiRestCall_593437
proc url_GetDeployedServicePackageInfoList_594742(protocol: Scheme; host: string;
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

proc validate_GetDeployedServicePackageInfoList_594741(path: JsonNode;
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
  var valid_594743 = path.getOrDefault("nodeName")
  valid_594743 = validateParameter(valid_594743, JString, required = true,
                                 default = nil)
  if valid_594743 != nil:
    section.add "nodeName", valid_594743
  var valid_594744 = path.getOrDefault("applicationId")
  valid_594744 = validateParameter(valid_594744, JString, required = true,
                                 default = nil)
  if valid_594744 != nil:
    section.add "applicationId", valid_594744
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594745 = query.getOrDefault("timeout")
  valid_594745 = validateParameter(valid_594745, JInt, required = false,
                                 default = newJInt(60))
  if valid_594745 != nil:
    section.add "timeout", valid_594745
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594746 = query.getOrDefault("api-version")
  valid_594746 = validateParameter(valid_594746, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594746 != nil:
    section.add "api-version", valid_594746
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594747: Call_GetDeployedServicePackageInfoList_594740;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the information about the service packages deployed on a Service Fabric node for the given application.
  ## 
  let valid = call_594747.validator(path, query, header, formData, body)
  let scheme = call_594747.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594747.url(scheme.get, call_594747.host, call_594747.base,
                         call_594747.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594747, url, valid)

proc call*(call_594748: Call_GetDeployedServicePackageInfoList_594740;
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
  var path_594749 = newJObject()
  var query_594750 = newJObject()
  add(query_594750, "timeout", newJInt(timeout))
  add(query_594750, "api-version", newJString(apiVersion))
  add(path_594749, "nodeName", newJString(nodeName))
  add(path_594749, "applicationId", newJString(applicationId))
  result = call_594748.call(path_594749, query_594750, nil, nil, nil)

var getDeployedServicePackageInfoList* = Call_GetDeployedServicePackageInfoList_594740(
    name: "getDeployedServicePackageInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServicePackages",
    validator: validate_GetDeployedServicePackageInfoList_594741, base: "",
    url: url_GetDeployedServicePackageInfoList_594742,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServicePackageInfoListByName_594751 = ref object of OpenApiRestCall_593437
proc url_GetDeployedServicePackageInfoListByName_594753(protocol: Scheme;
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

proc validate_GetDeployedServicePackageInfoListByName_594752(path: JsonNode;
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
  var valid_594754 = path.getOrDefault("nodeName")
  valid_594754 = validateParameter(valid_594754, JString, required = true,
                                 default = nil)
  if valid_594754 != nil:
    section.add "nodeName", valid_594754
  var valid_594755 = path.getOrDefault("applicationId")
  valid_594755 = validateParameter(valid_594755, JString, required = true,
                                 default = nil)
  if valid_594755 != nil:
    section.add "applicationId", valid_594755
  var valid_594756 = path.getOrDefault("servicePackageName")
  valid_594756 = validateParameter(valid_594756, JString, required = true,
                                 default = nil)
  if valid_594756 != nil:
    section.add "servicePackageName", valid_594756
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594757 = query.getOrDefault("timeout")
  valid_594757 = validateParameter(valid_594757, JInt, required = false,
                                 default = newJInt(60))
  if valid_594757 != nil:
    section.add "timeout", valid_594757
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594758 = query.getOrDefault("api-version")
  valid_594758 = validateParameter(valid_594758, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594758 != nil:
    section.add "api-version", valid_594758
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594759: Call_GetDeployedServicePackageInfoListByName_594751;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the information about the service packages deployed on a Service Fabric node for the given application. These results are of service packages whose name match exactly the service package name specified as the parameter.
  ## 
  let valid = call_594759.validator(path, query, header, formData, body)
  let scheme = call_594759.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594759.url(scheme.get, call_594759.host, call_594759.base,
                         call_594759.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594759, url, valid)

proc call*(call_594760: Call_GetDeployedServicePackageInfoListByName_594751;
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
  var path_594761 = newJObject()
  var query_594762 = newJObject()
  add(query_594762, "timeout", newJInt(timeout))
  add(query_594762, "api-version", newJString(apiVersion))
  add(path_594761, "nodeName", newJString(nodeName))
  add(path_594761, "applicationId", newJString(applicationId))
  add(path_594761, "servicePackageName", newJString(servicePackageName))
  result = call_594760.call(path_594761, query_594762, nil, nil, nil)

var getDeployedServicePackageInfoListByName* = Call_GetDeployedServicePackageInfoListByName_594751(
    name: "getDeployedServicePackageInfoListByName", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServicePackages/{servicePackageName}",
    validator: validate_GetDeployedServicePackageInfoListByName_594752, base: "",
    url: url_GetDeployedServicePackageInfoListByName_594753,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServicePackageHealthUsingPolicy_594776 = ref object of OpenApiRestCall_593437
proc url_GetDeployedServicePackageHealthUsingPolicy_594778(protocol: Scheme;
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

proc validate_GetDeployedServicePackageHealthUsingPolicy_594777(path: JsonNode;
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
  var valid_594779 = path.getOrDefault("nodeName")
  valid_594779 = validateParameter(valid_594779, JString, required = true,
                                 default = nil)
  if valid_594779 != nil:
    section.add "nodeName", valid_594779
  var valid_594780 = path.getOrDefault("applicationId")
  valid_594780 = validateParameter(valid_594780, JString, required = true,
                                 default = nil)
  if valid_594780 != nil:
    section.add "applicationId", valid_594780
  var valid_594781 = path.getOrDefault("servicePackageName")
  valid_594781 = validateParameter(valid_594781, JString, required = true,
                                 default = nil)
  if valid_594781 != nil:
    section.add "servicePackageName", valid_594781
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
  var valid_594782 = query.getOrDefault("timeout")
  valid_594782 = validateParameter(valid_594782, JInt, required = false,
                                 default = newJInt(60))
  if valid_594782 != nil:
    section.add "timeout", valid_594782
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594783 = query.getOrDefault("api-version")
  valid_594783 = validateParameter(valid_594783, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594783 != nil:
    section.add "api-version", valid_594783
  var valid_594784 = query.getOrDefault("EventsHealthStateFilter")
  valid_594784 = validateParameter(valid_594784, JInt, required = false,
                                 default = newJInt(0))
  if valid_594784 != nil:
    section.add "EventsHealthStateFilter", valid_594784
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

proc call*(call_594786: Call_GetDeployedServicePackageHealthUsingPolicy_594776;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the information about health of an service package for a specific application deployed on a Service Fabric node. using the specified policy. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed service package based on health state. Use ApplicationHealthPolicy to optionally override the health policies used to evaluate the health. This API only uses 'ConsiderWarningAsError' field of the ApplicationHealthPolicy. The rest of the fields are ignored while evaluating the health of the deployed service package.
  ## 
  ## 
  let valid = call_594786.validator(path, query, header, formData, body)
  let scheme = call_594786.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594786.url(scheme.get, call_594786.host, call_594786.base,
                         call_594786.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594786, url, valid)

proc call*(call_594787: Call_GetDeployedServicePackageHealthUsingPolicy_594776;
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
  var path_594788 = newJObject()
  var query_594789 = newJObject()
  var body_594790 = newJObject()
  add(query_594789, "timeout", newJInt(timeout))
  add(query_594789, "api-version", newJString(apiVersion))
  add(path_594788, "nodeName", newJString(nodeName))
  if ApplicationHealthPolicy != nil:
    body_594790 = ApplicationHealthPolicy
  add(query_594789, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_594788, "applicationId", newJString(applicationId))
  add(path_594788, "servicePackageName", newJString(servicePackageName))
  result = call_594787.call(path_594788, query_594789, nil, nil, body_594790)

var getDeployedServicePackageHealthUsingPolicy* = Call_GetDeployedServicePackageHealthUsingPolicy_594776(
    name: "getDeployedServicePackageHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServicePackages/{servicePackageName}/$/GetHealth",
    validator: validate_GetDeployedServicePackageHealthUsingPolicy_594777,
    base: "", url: url_GetDeployedServicePackageHealthUsingPolicy_594778,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServicePackageHealth_594763 = ref object of OpenApiRestCall_593437
proc url_GetDeployedServicePackageHealth_594765(protocol: Scheme; host: string;
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

proc validate_GetDeployedServicePackageHealth_594764(path: JsonNode;
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
  var valid_594766 = path.getOrDefault("nodeName")
  valid_594766 = validateParameter(valid_594766, JString, required = true,
                                 default = nil)
  if valid_594766 != nil:
    section.add "nodeName", valid_594766
  var valid_594767 = path.getOrDefault("applicationId")
  valid_594767 = validateParameter(valid_594767, JString, required = true,
                                 default = nil)
  if valid_594767 != nil:
    section.add "applicationId", valid_594767
  var valid_594768 = path.getOrDefault("servicePackageName")
  valid_594768 = validateParameter(valid_594768, JString, required = true,
                                 default = nil)
  if valid_594768 != nil:
    section.add "servicePackageName", valid_594768
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
  var valid_594769 = query.getOrDefault("timeout")
  valid_594769 = validateParameter(valid_594769, JInt, required = false,
                                 default = newJInt(60))
  if valid_594769 != nil:
    section.add "timeout", valid_594769
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594770 = query.getOrDefault("api-version")
  valid_594770 = validateParameter(valid_594770, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594770 != nil:
    section.add "api-version", valid_594770
  var valid_594771 = query.getOrDefault("EventsHealthStateFilter")
  valid_594771 = validateParameter(valid_594771, JInt, required = false,
                                 default = newJInt(0))
  if valid_594771 != nil:
    section.add "EventsHealthStateFilter", valid_594771
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594772: Call_GetDeployedServicePackageHealth_594763;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the information about health of service package for a specific application deployed on a Service Fabric node. Use EventsHealthStateFilter to optionally filter for the collection of HealthEvent objects reported on the deployed service package based on health state.
  ## 
  let valid = call_594772.validator(path, query, header, formData, body)
  let scheme = call_594772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594772.url(scheme.get, call_594772.host, call_594772.base,
                         call_594772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594772, url, valid)

proc call*(call_594773: Call_GetDeployedServicePackageHealth_594763;
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
  var path_594774 = newJObject()
  var query_594775 = newJObject()
  add(query_594775, "timeout", newJInt(timeout))
  add(query_594775, "api-version", newJString(apiVersion))
  add(path_594774, "nodeName", newJString(nodeName))
  add(query_594775, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_594774, "applicationId", newJString(applicationId))
  add(path_594774, "servicePackageName", newJString(servicePackageName))
  result = call_594773.call(path_594774, query_594775, nil, nil, nil)

var getDeployedServicePackageHealth* = Call_GetDeployedServicePackageHealth_594763(
    name: "getDeployedServicePackageHealth", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServicePackages/{servicePackageName}/$/GetHealth",
    validator: validate_GetDeployedServicePackageHealth_594764, base: "",
    url: url_GetDeployedServicePackageHealth_594765,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportDeployedServicePackageHealth_594791 = ref object of OpenApiRestCall_593437
proc url_ReportDeployedServicePackageHealth_594793(protocol: Scheme; host: string;
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

proc validate_ReportDeployedServicePackageHealth_594792(path: JsonNode;
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
  var valid_594794 = path.getOrDefault("nodeName")
  valid_594794 = validateParameter(valid_594794, JString, required = true,
                                 default = nil)
  if valid_594794 != nil:
    section.add "nodeName", valid_594794
  var valid_594795 = path.getOrDefault("applicationId")
  valid_594795 = validateParameter(valid_594795, JString, required = true,
                                 default = nil)
  if valid_594795 != nil:
    section.add "applicationId", valid_594795
  var valid_594796 = path.getOrDefault("servicePackageName")
  valid_594796 = validateParameter(valid_594796, JString, required = true,
                                 default = nil)
  if valid_594796 != nil:
    section.add "servicePackageName", valid_594796
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594797 = query.getOrDefault("timeout")
  valid_594797 = validateParameter(valid_594797, JInt, required = false,
                                 default = newJInt(60))
  if valid_594797 != nil:
    section.add "timeout", valid_594797
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594798 = query.getOrDefault("api-version")
  valid_594798 = validateParameter(valid_594798, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594798 != nil:
    section.add "api-version", valid_594798
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

proc call*(call_594800: Call_ReportDeployedServicePackageHealth_594791;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reports health state of the service package of the application deployed on a Service Fabric node. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Service, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, get deployed service package health and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_594800.validator(path, query, header, formData, body)
  let scheme = call_594800.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594800.url(scheme.get, call_594800.host, call_594800.base,
                         call_594800.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594800, url, valid)

proc call*(call_594801: Call_ReportDeployedServicePackageHealth_594791;
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
  var path_594802 = newJObject()
  var query_594803 = newJObject()
  var body_594804 = newJObject()
  add(query_594803, "timeout", newJInt(timeout))
  add(query_594803, "api-version", newJString(apiVersion))
  add(path_594802, "nodeName", newJString(nodeName))
  if HealthInformation != nil:
    body_594804 = HealthInformation
  add(path_594802, "applicationId", newJString(applicationId))
  add(path_594802, "servicePackageName", newJString(servicePackageName))
  result = call_594801.call(path_594802, query_594803, nil, nil, body_594804)

var reportDeployedServicePackageHealth* = Call_ReportDeployedServicePackageHealth_594791(
    name: "reportDeployedServicePackageHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServicePackages/{servicePackageName}/$/ReportHealth",
    validator: validate_ReportDeployedServicePackageHealth_594792, base: "",
    url: url_ReportDeployedServicePackageHealth_594793,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServiceTypeInfoList_594805 = ref object of OpenApiRestCall_593437
proc url_GetDeployedServiceTypeInfoList_594807(protocol: Scheme; host: string;
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

proc validate_GetDeployedServiceTypeInfoList_594806(path: JsonNode;
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
  var valid_594808 = path.getOrDefault("nodeName")
  valid_594808 = validateParameter(valid_594808, JString, required = true,
                                 default = nil)
  if valid_594808 != nil:
    section.add "nodeName", valid_594808
  var valid_594809 = path.getOrDefault("applicationId")
  valid_594809 = validateParameter(valid_594809, JString, required = true,
                                 default = nil)
  if valid_594809 != nil:
    section.add "applicationId", valid_594809
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ServiceManifestName: JString
  ##                      : The name of the service manifest to filter the list of deployed service type information. If specified, the response will only contain the information about service types that are defined in this service manifest.
  section = newJObject()
  var valid_594810 = query.getOrDefault("timeout")
  valid_594810 = validateParameter(valid_594810, JInt, required = false,
                                 default = newJInt(60))
  if valid_594810 != nil:
    section.add "timeout", valid_594810
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594811 = query.getOrDefault("api-version")
  valid_594811 = validateParameter(valid_594811, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594811 != nil:
    section.add "api-version", valid_594811
  var valid_594812 = query.getOrDefault("ServiceManifestName")
  valid_594812 = validateParameter(valid_594812, JString, required = false,
                                 default = nil)
  if valid_594812 != nil:
    section.add "ServiceManifestName", valid_594812
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594813: Call_GetDeployedServiceTypeInfoList_594805; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list containing the information about service types from the applications deployed on a node in a Service Fabric cluster. The response includes the name of the service type, its registration status, the code package that registered it and activation id of the service package.
  ## 
  let valid = call_594813.validator(path, query, header, formData, body)
  let scheme = call_594813.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594813.url(scheme.get, call_594813.host, call_594813.base,
                         call_594813.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594813, url, valid)

proc call*(call_594814: Call_GetDeployedServiceTypeInfoList_594805;
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
  var path_594815 = newJObject()
  var query_594816 = newJObject()
  add(query_594816, "timeout", newJInt(timeout))
  add(query_594816, "api-version", newJString(apiVersion))
  add(path_594815, "nodeName", newJString(nodeName))
  add(query_594816, "ServiceManifestName", newJString(ServiceManifestName))
  add(path_594815, "applicationId", newJString(applicationId))
  result = call_594814.call(path_594815, query_594816, nil, nil, nil)

var getDeployedServiceTypeInfoList* = Call_GetDeployedServiceTypeInfoList_594805(
    name: "getDeployedServiceTypeInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServiceTypes",
    validator: validate_GetDeployedServiceTypeInfoList_594806, base: "",
    url: url_GetDeployedServiceTypeInfoList_594807,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServiceTypeInfoByName_594817 = ref object of OpenApiRestCall_593437
proc url_GetDeployedServiceTypeInfoByName_594819(protocol: Scheme; host: string;
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

proc validate_GetDeployedServiceTypeInfoByName_594818(path: JsonNode;
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
  var valid_594820 = path.getOrDefault("serviceTypeName")
  valid_594820 = validateParameter(valid_594820, JString, required = true,
                                 default = nil)
  if valid_594820 != nil:
    section.add "serviceTypeName", valid_594820
  var valid_594821 = path.getOrDefault("nodeName")
  valid_594821 = validateParameter(valid_594821, JString, required = true,
                                 default = nil)
  if valid_594821 != nil:
    section.add "nodeName", valid_594821
  var valid_594822 = path.getOrDefault("applicationId")
  valid_594822 = validateParameter(valid_594822, JString, required = true,
                                 default = nil)
  if valid_594822 != nil:
    section.add "applicationId", valid_594822
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ServiceManifestName: JString
  ##                      : The name of the service manifest to filter the list of deployed service type information. If specified, the response will only contain the information about service types that are defined in this service manifest.
  section = newJObject()
  var valid_594823 = query.getOrDefault("timeout")
  valid_594823 = validateParameter(valid_594823, JInt, required = false,
                                 default = newJInt(60))
  if valid_594823 != nil:
    section.add "timeout", valid_594823
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594824 = query.getOrDefault("api-version")
  valid_594824 = validateParameter(valid_594824, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594824 != nil:
    section.add "api-version", valid_594824
  var valid_594825 = query.getOrDefault("ServiceManifestName")
  valid_594825 = validateParameter(valid_594825, JString, required = false,
                                 default = nil)
  if valid_594825 != nil:
    section.add "ServiceManifestName", valid_594825
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594826: Call_GetDeployedServiceTypeInfoByName_594817;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the information about a specified service type of the application deployed on a node in a Service Fabric cluster. The response includes the name of the service type, its registration status, the code package that registered it and activation id of the service package.
  ## 
  let valid = call_594826.validator(path, query, header, formData, body)
  let scheme = call_594826.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594826.url(scheme.get, call_594826.host, call_594826.base,
                         call_594826.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594826, url, valid)

proc call*(call_594827: Call_GetDeployedServiceTypeInfoByName_594817;
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
  var path_594828 = newJObject()
  var query_594829 = newJObject()
  add(query_594829, "timeout", newJInt(timeout))
  add(path_594828, "serviceTypeName", newJString(serviceTypeName))
  add(query_594829, "api-version", newJString(apiVersion))
  add(path_594828, "nodeName", newJString(nodeName))
  add(query_594829, "ServiceManifestName", newJString(ServiceManifestName))
  add(path_594828, "applicationId", newJString(applicationId))
  result = call_594827.call(path_594828, query_594829, nil, nil, nil)

var getDeployedServiceTypeInfoByName* = Call_GetDeployedServiceTypeInfoByName_594817(
    name: "getDeployedServiceTypeInfoByName", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/GetServiceTypes/{serviceTypeName}",
    validator: validate_GetDeployedServiceTypeInfoByName_594818, base: "",
    url: url_GetDeployedServiceTypeInfoByName_594819,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportDeployedApplicationHealth_594830 = ref object of OpenApiRestCall_593437
proc url_ReportDeployedApplicationHealth_594832(protocol: Scheme; host: string;
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

proc validate_ReportDeployedApplicationHealth_594831(path: JsonNode;
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
  var valid_594833 = path.getOrDefault("nodeName")
  valid_594833 = validateParameter(valid_594833, JString, required = true,
                                 default = nil)
  if valid_594833 != nil:
    section.add "nodeName", valid_594833
  var valid_594834 = path.getOrDefault("applicationId")
  valid_594834 = validateParameter(valid_594834, JString, required = true,
                                 default = nil)
  if valid_594834 != nil:
    section.add "applicationId", valid_594834
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594835 = query.getOrDefault("timeout")
  valid_594835 = validateParameter(valid_594835, JInt, required = false,
                                 default = newJInt(60))
  if valid_594835 != nil:
    section.add "timeout", valid_594835
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594836 = query.getOrDefault("api-version")
  valid_594836 = validateParameter(valid_594836, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594836 != nil:
    section.add "api-version", valid_594836
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

proc call*(call_594838: Call_ReportDeployedApplicationHealth_594830;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reports health state of the application deployed on a Service Fabric node. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Service, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, get deployed application health and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_594838.validator(path, query, header, formData, body)
  let scheme = call_594838.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594838.url(scheme.get, call_594838.host, call_594838.base,
                         call_594838.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594838, url, valid)

proc call*(call_594839: Call_ReportDeployedApplicationHealth_594830;
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
  var path_594840 = newJObject()
  var query_594841 = newJObject()
  var body_594842 = newJObject()
  add(query_594841, "timeout", newJInt(timeout))
  add(query_594841, "api-version", newJString(apiVersion))
  add(path_594840, "nodeName", newJString(nodeName))
  if HealthInformation != nil:
    body_594842 = HealthInformation
  add(path_594840, "applicationId", newJString(applicationId))
  result = call_594839.call(path_594840, query_594841, nil, nil, body_594842)

var reportDeployedApplicationHealth* = Call_ReportDeployedApplicationHealth_594830(
    name: "reportDeployedApplicationHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetApplications/{applicationId}/$/ReportHealth",
    validator: validate_ReportDeployedApplicationHealth_594831, base: "",
    url: url_ReportDeployedApplicationHealth_594832,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetNodeHealthUsingPolicy_594854 = ref object of OpenApiRestCall_593437
proc url_GetNodeHealthUsingPolicy_594856(protocol: Scheme; host: string;
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

proc validate_GetNodeHealthUsingPolicy_594855(path: JsonNode; query: JsonNode;
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
  var valid_594857 = path.getOrDefault("nodeName")
  valid_594857 = validateParameter(valid_594857, JString, required = true,
                                 default = nil)
  if valid_594857 != nil:
    section.add "nodeName", valid_594857
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
  var valid_594858 = query.getOrDefault("timeout")
  valid_594858 = validateParameter(valid_594858, JInt, required = false,
                                 default = newJInt(60))
  if valid_594858 != nil:
    section.add "timeout", valid_594858
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594859 = query.getOrDefault("api-version")
  valid_594859 = validateParameter(valid_594859, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594859 != nil:
    section.add "api-version", valid_594859
  var valid_594860 = query.getOrDefault("EventsHealthStateFilter")
  valid_594860 = validateParameter(valid_594860, JInt, required = false,
                                 default = newJInt(0))
  if valid_594860 != nil:
    section.add "EventsHealthStateFilter", valid_594860
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

proc call*(call_594862: Call_GetNodeHealthUsingPolicy_594854; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric node. Use EventsHealthStateFilter to filter the collection of health events reported on the node based on the health state. Use ClusterHealthPolicy in the POST body to override the health policies used to evaluate the health. If the node that you specify by name does not exist in the health store, this returns an error.
  ## 
  let valid = call_594862.validator(path, query, header, formData, body)
  let scheme = call_594862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594862.url(scheme.get, call_594862.host, call_594862.base,
                         call_594862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594862, url, valid)

proc call*(call_594863: Call_GetNodeHealthUsingPolicy_594854; nodeName: string;
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
  var path_594864 = newJObject()
  var query_594865 = newJObject()
  var body_594866 = newJObject()
  add(query_594865, "timeout", newJInt(timeout))
  add(query_594865, "api-version", newJString(apiVersion))
  add(path_594864, "nodeName", newJString(nodeName))
  add(query_594865, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  if ClusterHealthPolicy != nil:
    body_594866 = ClusterHealthPolicy
  result = call_594863.call(path_594864, query_594865, nil, nil, body_594866)

var getNodeHealthUsingPolicy* = Call_GetNodeHealthUsingPolicy_594854(
    name: "getNodeHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetHealth",
    validator: validate_GetNodeHealthUsingPolicy_594855, base: "",
    url: url_GetNodeHealthUsingPolicy_594856, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetNodeHealth_594843 = ref object of OpenApiRestCall_593437
proc url_GetNodeHealth_594845(protocol: Scheme; host: string; base: string;
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

proc validate_GetNodeHealth_594844(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594846 = path.getOrDefault("nodeName")
  valid_594846 = validateParameter(valid_594846, JString, required = true,
                                 default = nil)
  if valid_594846 != nil:
    section.add "nodeName", valid_594846
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
  var valid_594847 = query.getOrDefault("timeout")
  valid_594847 = validateParameter(valid_594847, JInt, required = false,
                                 default = newJInt(60))
  if valid_594847 != nil:
    section.add "timeout", valid_594847
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594848 = query.getOrDefault("api-version")
  valid_594848 = validateParameter(valid_594848, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594848 != nil:
    section.add "api-version", valid_594848
  var valid_594849 = query.getOrDefault("EventsHealthStateFilter")
  valid_594849 = validateParameter(valid_594849, JInt, required = false,
                                 default = newJInt(0))
  if valid_594849 != nil:
    section.add "EventsHealthStateFilter", valid_594849
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594850: Call_GetNodeHealth_594843; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric node. Use EventsHealthStateFilter to filter the collection of health events reported on the node based on the health state. If the node that you specify by name does not exist in the health store, this returns an error.
  ## 
  let valid = call_594850.validator(path, query, header, formData, body)
  let scheme = call_594850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594850.url(scheme.get, call_594850.host, call_594850.base,
                         call_594850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594850, url, valid)

proc call*(call_594851: Call_GetNodeHealth_594843; nodeName: string;
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
  var path_594852 = newJObject()
  var query_594853 = newJObject()
  add(query_594853, "timeout", newJInt(timeout))
  add(query_594853, "api-version", newJString(apiVersion))
  add(path_594852, "nodeName", newJString(nodeName))
  add(query_594853, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  result = call_594851.call(path_594852, query_594853, nil, nil, nil)

var getNodeHealth* = Call_GetNodeHealth_594843(name: "getNodeHealth",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetHealth", validator: validate_GetNodeHealth_594844,
    base: "", url: url_GetNodeHealth_594845, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetNodeLoadInfo_594867 = ref object of OpenApiRestCall_593437
proc url_GetNodeLoadInfo_594869(protocol: Scheme; host: string; base: string;
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

proc validate_GetNodeLoadInfo_594868(path: JsonNode; query: JsonNode;
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
  var valid_594870 = path.getOrDefault("nodeName")
  valid_594870 = validateParameter(valid_594870, JString, required = true,
                                 default = nil)
  if valid_594870 != nil:
    section.add "nodeName", valid_594870
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594871 = query.getOrDefault("timeout")
  valid_594871 = validateParameter(valid_594871, JInt, required = false,
                                 default = newJInt(60))
  if valid_594871 != nil:
    section.add "timeout", valid_594871
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594872 = query.getOrDefault("api-version")
  valid_594872 = validateParameter(valid_594872, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594872 != nil:
    section.add "api-version", valid_594872
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594873: Call_GetNodeLoadInfo_594867; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the load information of a Service Fabric node.
  ## 
  let valid = call_594873.validator(path, query, header, formData, body)
  let scheme = call_594873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594873.url(scheme.get, call_594873.host, call_594873.base,
                         call_594873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594873, url, valid)

proc call*(call_594874: Call_GetNodeLoadInfo_594867; nodeName: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getNodeLoadInfo
  ## Gets the load information of a Service Fabric node.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_594875 = newJObject()
  var query_594876 = newJObject()
  add(query_594876, "timeout", newJInt(timeout))
  add(query_594876, "api-version", newJString(apiVersion))
  add(path_594875, "nodeName", newJString(nodeName))
  result = call_594874.call(path_594875, query_594876, nil, nil, nil)

var getNodeLoadInfo* = Call_GetNodeLoadInfo_594867(name: "getNodeLoadInfo",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/GetLoadInformation",
    validator: validate_GetNodeLoadInfo_594868, base: "", url: url_GetNodeLoadInfo_594869,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_RemoveReplica_594877 = ref object of OpenApiRestCall_593437
proc url_RemoveReplica_594879(protocol: Scheme; host: string; base: string;
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

proc validate_RemoveReplica_594878(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594880 = path.getOrDefault("replicaId")
  valid_594880 = validateParameter(valid_594880, JString, required = true,
                                 default = nil)
  if valid_594880 != nil:
    section.add "replicaId", valid_594880
  var valid_594881 = path.getOrDefault("nodeName")
  valid_594881 = validateParameter(valid_594881, JString, required = true,
                                 default = nil)
  if valid_594881 != nil:
    section.add "nodeName", valid_594881
  var valid_594882 = path.getOrDefault("partitionId")
  valid_594882 = validateParameter(valid_594882, JString, required = true,
                                 default = nil)
  if valid_594882 != nil:
    section.add "partitionId", valid_594882
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ForceRemove: JBool
  ##              : Remove a Service Fabric application or service forcefully without going through the graceful shutdown sequence. This parameter can be used to forcefully delete an application or service for which delete is timing out due to issues in the service code that prevents graceful close of replicas.
  section = newJObject()
  var valid_594883 = query.getOrDefault("timeout")
  valid_594883 = validateParameter(valid_594883, JInt, required = false,
                                 default = newJInt(60))
  if valid_594883 != nil:
    section.add "timeout", valid_594883
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594884 = query.getOrDefault("api-version")
  valid_594884 = validateParameter(valid_594884, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594884 != nil:
    section.add "api-version", valid_594884
  var valid_594885 = query.getOrDefault("ForceRemove")
  valid_594885 = validateParameter(valid_594885, JBool, required = false, default = nil)
  if valid_594885 != nil:
    section.add "ForceRemove", valid_594885
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594886: Call_RemoveReplica_594877; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## This API simulates a Service Fabric replica failure by removing a replica from a Service Fabric cluster. The removal closes the replica, transitions the replica to the role None, and then removes all of the state information of the replica from the cluster. This API tests the replica state removal path, and simulates the report fault permanent path through client APIs. Warning - There are no safety checks performed when this API is used. Incorrect use of this API can lead to data loss for stateful services.In addition, the forceRemove flag impacts all other replicas hosted in the same process.
  ## 
  let valid = call_594886.validator(path, query, header, formData, body)
  let scheme = call_594886.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594886.url(scheme.get, call_594886.host, call_594886.base,
                         call_594886.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594886, url, valid)

proc call*(call_594887: Call_RemoveReplica_594877; replicaId: string;
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
  var path_594888 = newJObject()
  var query_594889 = newJObject()
  add(path_594888, "replicaId", newJString(replicaId))
  add(query_594889, "timeout", newJInt(timeout))
  add(query_594889, "api-version", newJString(apiVersion))
  add(query_594889, "ForceRemove", newJBool(ForceRemove))
  add(path_594888, "nodeName", newJString(nodeName))
  add(path_594888, "partitionId", newJString(partitionId))
  result = call_594887.call(path_594888, query_594889, nil, nil, nil)

var removeReplica* = Call_RemoveReplica_594877(name: "removeReplica",
    meth: HttpMethod.HttpPost, host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetPartitions/{partitionId}/$/GetReplicas/{replicaId}/$/Delete",
    validator: validate_RemoveReplica_594878, base: "", url: url_RemoveReplica_594879,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetDeployedServiceReplicaDetailInfo_594890 = ref object of OpenApiRestCall_593437
proc url_GetDeployedServiceReplicaDetailInfo_594892(protocol: Scheme; host: string;
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

proc validate_GetDeployedServiceReplicaDetailInfo_594891(path: JsonNode;
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
  var valid_594893 = path.getOrDefault("replicaId")
  valid_594893 = validateParameter(valid_594893, JString, required = true,
                                 default = nil)
  if valid_594893 != nil:
    section.add "replicaId", valid_594893
  var valid_594894 = path.getOrDefault("nodeName")
  valid_594894 = validateParameter(valid_594894, JString, required = true,
                                 default = nil)
  if valid_594894 != nil:
    section.add "nodeName", valid_594894
  var valid_594895 = path.getOrDefault("partitionId")
  valid_594895 = validateParameter(valid_594895, JString, required = true,
                                 default = nil)
  if valid_594895 != nil:
    section.add "partitionId", valid_594895
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594896 = query.getOrDefault("timeout")
  valid_594896 = validateParameter(valid_594896, JInt, required = false,
                                 default = newJInt(60))
  if valid_594896 != nil:
    section.add "timeout", valid_594896
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594897 = query.getOrDefault("api-version")
  valid_594897 = validateParameter(valid_594897, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594897 != nil:
    section.add "api-version", valid_594897
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594898: Call_GetDeployedServiceReplicaDetailInfo_594890;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of the replica deployed on a Service Fabric node. The information include service kind, service name, current service operation, current service operation start date time, partition id, replica/instance id, reported load and other information.
  ## 
  let valid = call_594898.validator(path, query, header, formData, body)
  let scheme = call_594898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594898.url(scheme.get, call_594898.host, call_594898.base,
                         call_594898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594898, url, valid)

proc call*(call_594899: Call_GetDeployedServiceReplicaDetailInfo_594890;
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
  var path_594900 = newJObject()
  var query_594901 = newJObject()
  add(path_594900, "replicaId", newJString(replicaId))
  add(query_594901, "timeout", newJInt(timeout))
  add(query_594901, "api-version", newJString(apiVersion))
  add(path_594900, "nodeName", newJString(nodeName))
  add(path_594900, "partitionId", newJString(partitionId))
  result = call_594899.call(path_594900, query_594901, nil, nil, nil)

var getDeployedServiceReplicaDetailInfo* = Call_GetDeployedServiceReplicaDetailInfo_594890(
    name: "getDeployedServiceReplicaDetailInfo", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetPartitions/{partitionId}/$/GetReplicas/{replicaId}/$/GetDetail",
    validator: validate_GetDeployedServiceReplicaDetailInfo_594891, base: "",
    url: url_GetDeployedServiceReplicaDetailInfo_594892,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_RestartReplica_594902 = ref object of OpenApiRestCall_593437
proc url_RestartReplica_594904(protocol: Scheme; host: string; base: string;
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

proc validate_RestartReplica_594903(path: JsonNode; query: JsonNode;
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
  var valid_594905 = path.getOrDefault("replicaId")
  valid_594905 = validateParameter(valid_594905, JString, required = true,
                                 default = nil)
  if valid_594905 != nil:
    section.add "replicaId", valid_594905
  var valid_594906 = path.getOrDefault("nodeName")
  valid_594906 = validateParameter(valid_594906, JString, required = true,
                                 default = nil)
  if valid_594906 != nil:
    section.add "nodeName", valid_594906
  var valid_594907 = path.getOrDefault("partitionId")
  valid_594907 = validateParameter(valid_594907, JString, required = true,
                                 default = nil)
  if valid_594907 != nil:
    section.add "partitionId", valid_594907
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594908 = query.getOrDefault("timeout")
  valid_594908 = validateParameter(valid_594908, JInt, required = false,
                                 default = newJInt(60))
  if valid_594908 != nil:
    section.add "timeout", valid_594908
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594909 = query.getOrDefault("api-version")
  valid_594909 = validateParameter(valid_594909, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594909 != nil:
    section.add "api-version", valid_594909
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594910: Call_RestartReplica_594902; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a service replica of a persisted service running on a node. Warning - There are no safety checks performed when this API is used. Incorrect use of this API can lead to availability loss for stateful services.
  ## 
  let valid = call_594910.validator(path, query, header, formData, body)
  let scheme = call_594910.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594910.url(scheme.get, call_594910.host, call_594910.base,
                         call_594910.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594910, url, valid)

proc call*(call_594911: Call_RestartReplica_594902; replicaId: string;
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
  var path_594912 = newJObject()
  var query_594913 = newJObject()
  add(path_594912, "replicaId", newJString(replicaId))
  add(query_594913, "timeout", newJInt(timeout))
  add(query_594913, "api-version", newJString(apiVersion))
  add(path_594912, "nodeName", newJString(nodeName))
  add(path_594912, "partitionId", newJString(partitionId))
  result = call_594911.call(path_594912, query_594913, nil, nil, nil)

var restartReplica* = Call_RestartReplica_594902(name: "restartReplica",
    meth: HttpMethod.HttpPost, host: "azure.local:19080", route: "/Nodes/{nodeName}/$/GetPartitions/{partitionId}/$/GetReplicas/{replicaId}/$/Restart",
    validator: validate_RestartReplica_594903, base: "", url: url_RestartReplica_594904,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_RemoveNodeState_594914 = ref object of OpenApiRestCall_593437
proc url_RemoveNodeState_594916(protocol: Scheme; host: string; base: string;
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

proc validate_RemoveNodeState_594915(path: JsonNode; query: JsonNode;
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
  var valid_594917 = path.getOrDefault("nodeName")
  valid_594917 = validateParameter(valid_594917, JString, required = true,
                                 default = nil)
  if valid_594917 != nil:
    section.add "nodeName", valid_594917
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594918 = query.getOrDefault("timeout")
  valid_594918 = validateParameter(valid_594918, JInt, required = false,
                                 default = newJInt(60))
  if valid_594918 != nil:
    section.add "timeout", valid_594918
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594919 = query.getOrDefault("api-version")
  valid_594919 = validateParameter(valid_594919, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594919 != nil:
    section.add "api-version", valid_594919
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594920: Call_RemoveNodeState_594914; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Notifies Service Fabric that the persisted state on a node has been permanently removed or lost.  This implies that it is not possible to recover the persisted state of that node. This generally happens if a hard disk has been wiped clean, or if a hard disk crashes. The node has to be down for this operation to be successful. This operation lets Service Fabric know that the replicas on that node no longer exist, and that Service Fabric should stop waiting for those replicas to come back up. Do not run this cmdlet if the state on the node has not been removed and the node can comes back up with its state intact.
  ## 
  let valid = call_594920.validator(path, query, header, formData, body)
  let scheme = call_594920.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594920.url(scheme.get, call_594920.host, call_594920.base,
                         call_594920.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594920, url, valid)

proc call*(call_594921: Call_RemoveNodeState_594914; nodeName: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## removeNodeState
  ## Notifies Service Fabric that the persisted state on a node has been permanently removed or lost.  This implies that it is not possible to recover the persisted state of that node. This generally happens if a hard disk has been wiped clean, or if a hard disk crashes. The node has to be down for this operation to be successful. This operation lets Service Fabric know that the replicas on that node no longer exist, and that Service Fabric should stop waiting for those replicas to come back up. Do not run this cmdlet if the state on the node has not been removed and the node can comes back up with its state intact.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   nodeName: string (required)
  ##           : The name of the node.
  var path_594922 = newJObject()
  var query_594923 = newJObject()
  add(query_594923, "timeout", newJInt(timeout))
  add(query_594923, "api-version", newJString(apiVersion))
  add(path_594922, "nodeName", newJString(nodeName))
  result = call_594921.call(path_594922, query_594923, nil, nil, nil)

var removeNodeState* = Call_RemoveNodeState_594914(name: "removeNodeState",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/RemoveNodeState",
    validator: validate_RemoveNodeState_594915, base: "", url: url_RemoveNodeState_594916,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportNodeHealth_594924 = ref object of OpenApiRestCall_593437
proc url_ReportNodeHealth_594926(protocol: Scheme; host: string; base: string;
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

proc validate_ReportNodeHealth_594925(path: JsonNode; query: JsonNode;
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
  var valid_594927 = path.getOrDefault("nodeName")
  valid_594927 = validateParameter(valid_594927, JString, required = true,
                                 default = nil)
  if valid_594927 != nil:
    section.add "nodeName", valid_594927
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594928 = query.getOrDefault("timeout")
  valid_594928 = validateParameter(valid_594928, JInt, required = false,
                                 default = newJInt(60))
  if valid_594928 != nil:
    section.add "timeout", valid_594928
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594929 = query.getOrDefault("api-version")
  valid_594929 = validateParameter(valid_594929, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594929 != nil:
    section.add "api-version", valid_594929
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

proc call*(call_594931: Call_ReportNodeHealth_594924; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reports health state of the specified Service Fabric node. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway node, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetNodeHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_594931.validator(path, query, header, formData, body)
  let scheme = call_594931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594931.url(scheme.get, call_594931.host, call_594931.base,
                         call_594931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594931, url, valid)

proc call*(call_594932: Call_ReportNodeHealth_594924; nodeName: string;
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
  var path_594933 = newJObject()
  var query_594934 = newJObject()
  var body_594935 = newJObject()
  add(query_594934, "timeout", newJInt(timeout))
  add(query_594934, "api-version", newJString(apiVersion))
  add(path_594933, "nodeName", newJString(nodeName))
  if HealthInformation != nil:
    body_594935 = HealthInformation
  result = call_594932.call(path_594933, query_594934, nil, nil, body_594935)

var reportNodeHealth* = Call_ReportNodeHealth_594924(name: "reportNodeHealth",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Nodes/{nodeName}/$/ReportHealth",
    validator: validate_ReportNodeHealth_594925, base: "",
    url: url_ReportNodeHealth_594926, schemes: {Scheme.Https, Scheme.Http})
type
  Call_RestartNode_594936 = ref object of OpenApiRestCall_593437
proc url_RestartNode_594938(protocol: Scheme; host: string; base: string;
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

proc validate_RestartNode_594937(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594939 = path.getOrDefault("nodeName")
  valid_594939 = validateParameter(valid_594939, JString, required = true,
                                 default = nil)
  if valid_594939 != nil:
    section.add "nodeName", valid_594939
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594940 = query.getOrDefault("timeout")
  valid_594940 = validateParameter(valid_594940, JInt, required = false,
                                 default = newJInt(60))
  if valid_594940 != nil:
    section.add "timeout", valid_594940
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594941 = query.getOrDefault("api-version")
  valid_594941 = validateParameter(valid_594941, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594941 != nil:
    section.add "api-version", valid_594941
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

proc call*(call_594943: Call_RestartNode_594936; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Restarts a Service Fabric cluster node that is already started.
  ## 
  let valid = call_594943.validator(path, query, header, formData, body)
  let scheme = call_594943.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594943.url(scheme.get, call_594943.host, call_594943.base,
                         call_594943.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594943, url, valid)

proc call*(call_594944: Call_RestartNode_594936; nodeName: string;
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
  var path_594945 = newJObject()
  var query_594946 = newJObject()
  var body_594947 = newJObject()
  add(query_594946, "timeout", newJInt(timeout))
  add(query_594946, "api-version", newJString(apiVersion))
  add(path_594945, "nodeName", newJString(nodeName))
  if RestartNodeDescription != nil:
    body_594947 = RestartNodeDescription
  result = call_594944.call(path_594945, query_594946, nil, nil, body_594947)

var restartNode* = Call_RestartNode_594936(name: "restartNode",
                                        meth: HttpMethod.HttpPost,
                                        host: "azure.local:19080",
                                        route: "/Nodes/{nodeName}/$/Restart",
                                        validator: validate_RestartNode_594937,
                                        base: "", url: url_RestartNode_594938,
                                        schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartNode_594948 = ref object of OpenApiRestCall_593437
proc url_StartNode_594950(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_StartNode_594949(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594951 = path.getOrDefault("nodeName")
  valid_594951 = validateParameter(valid_594951, JString, required = true,
                                 default = nil)
  if valid_594951 != nil:
    section.add "nodeName", valid_594951
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594952 = query.getOrDefault("timeout")
  valid_594952 = validateParameter(valid_594952, JInt, required = false,
                                 default = newJInt(60))
  if valid_594952 != nil:
    section.add "timeout", valid_594952
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594953 = query.getOrDefault("api-version")
  valid_594953 = validateParameter(valid_594953, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594953 != nil:
    section.add "api-version", valid_594953
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

proc call*(call_594955: Call_StartNode_594948; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts a Service Fabric cluster node that is already stopped.
  ## 
  let valid = call_594955.validator(path, query, header, formData, body)
  let scheme = call_594955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594955.url(scheme.get, call_594955.host, call_594955.base,
                         call_594955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594955, url, valid)

proc call*(call_594956: Call_StartNode_594948; nodeName: string;
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
  var path_594957 = newJObject()
  var query_594958 = newJObject()
  var body_594959 = newJObject()
  add(query_594958, "timeout", newJInt(timeout))
  add(query_594958, "api-version", newJString(apiVersion))
  add(path_594957, "nodeName", newJString(nodeName))
  if StartNodeDescription != nil:
    body_594959 = StartNodeDescription
  result = call_594956.call(path_594957, query_594958, nil, nil, body_594959)

var startNode* = Call_StartNode_594948(name: "startNode", meth: HttpMethod.HttpPost,
                                    host: "azure.local:19080",
                                    route: "/Nodes/{nodeName}/$/Start",
                                    validator: validate_StartNode_594949,
                                    base: "", url: url_StartNode_594950,
                                    schemes: {Scheme.Https, Scheme.Http})
type
  Call_StopNode_594960 = ref object of OpenApiRestCall_593437
proc url_StopNode_594962(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_StopNode_594961(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594963 = path.getOrDefault("nodeName")
  valid_594963 = validateParameter(valid_594963, JString, required = true,
                                 default = nil)
  if valid_594963 != nil:
    section.add "nodeName", valid_594963
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594964 = query.getOrDefault("timeout")
  valid_594964 = validateParameter(valid_594964, JInt, required = false,
                                 default = newJInt(60))
  if valid_594964 != nil:
    section.add "timeout", valid_594964
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594965 = query.getOrDefault("api-version")
  valid_594965 = validateParameter(valid_594965, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594965 != nil:
    section.add "api-version", valid_594965
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

proc call*(call_594967: Call_StopNode_594960; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops a Service Fabric cluster node that is in a started state. The node will stay down until start node is called.
  ## 
  let valid = call_594967.validator(path, query, header, formData, body)
  let scheme = call_594967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594967.url(scheme.get, call_594967.host, call_594967.base,
                         call_594967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594967, url, valid)

proc call*(call_594968: Call_StopNode_594960; nodeName: string;
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
  var path_594969 = newJObject()
  var query_594970 = newJObject()
  var body_594971 = newJObject()
  add(query_594970, "timeout", newJInt(timeout))
  add(query_594970, "api-version", newJString(apiVersion))
  add(path_594969, "nodeName", newJString(nodeName))
  if StopNodeDescription != nil:
    body_594971 = StopNodeDescription
  result = call_594968.call(path_594969, query_594970, nil, nil, body_594971)

var stopNode* = Call_StopNode_594960(name: "stopNode", meth: HttpMethod.HttpPost,
                                  host: "azure.local:19080",
                                  route: "/Nodes/{nodeName}/$/Stop",
                                  validator: validate_StopNode_594961, base: "",
                                  url: url_StopNode_594962,
                                  schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetPartitionInfo_594972 = ref object of OpenApiRestCall_593437
proc url_GetPartitionInfo_594974(protocol: Scheme; host: string; base: string;
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

proc validate_GetPartitionInfo_594973(path: JsonNode; query: JsonNode;
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
  var valid_594975 = path.getOrDefault("partitionId")
  valid_594975 = validateParameter(valid_594975, JString, required = true,
                                 default = nil)
  if valid_594975 != nil:
    section.add "partitionId", valid_594975
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_594976 = query.getOrDefault("timeout")
  valid_594976 = validateParameter(valid_594976, JInt, required = false,
                                 default = newJInt(60))
  if valid_594976 != nil:
    section.add "timeout", valid_594976
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594977 = query.getOrDefault("api-version")
  valid_594977 = validateParameter(valid_594977, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594977 != nil:
    section.add "api-version", valid_594977
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594978: Call_GetPartitionInfo_594972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Partitions endpoint returns information about the specified partition. The response include the partition id, partitioning scheme information, keys supported by the partition, status, health and other details about the partition.
  ## 
  let valid = call_594978.validator(path, query, header, formData, body)
  let scheme = call_594978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594978.url(scheme.get, call_594978.host, call_594978.base,
                         call_594978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594978, url, valid)

proc call*(call_594979: Call_GetPartitionInfo_594972; partitionId: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getPartitionInfo
  ## The Partitions endpoint returns information about the specified partition. The response include the partition id, partitioning scheme information, keys supported by the partition, status, health and other details about the partition.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_594980 = newJObject()
  var query_594981 = newJObject()
  add(query_594981, "timeout", newJInt(timeout))
  add(query_594981, "api-version", newJString(apiVersion))
  add(path_594980, "partitionId", newJString(partitionId))
  result = call_594979.call(path_594980, query_594981, nil, nil, nil)

var getPartitionInfo* = Call_GetPartitionInfo_594972(name: "getPartitionInfo",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}", validator: validate_GetPartitionInfo_594973,
    base: "", url: url_GetPartitionInfo_594974, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetPartitionHealthUsingPolicy_594994 = ref object of OpenApiRestCall_593437
proc url_GetPartitionHealthUsingPolicy_594996(protocol: Scheme; host: string;
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

proc validate_GetPartitionHealthUsingPolicy_594995(path: JsonNode; query: JsonNode;
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
  var valid_594997 = path.getOrDefault("partitionId")
  valid_594997 = validateParameter(valid_594997, JString, required = true,
                                 default = nil)
  if valid_594997 != nil:
    section.add "partitionId", valid_594997
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
  var valid_594998 = query.getOrDefault("timeout")
  valid_594998 = validateParameter(valid_594998, JInt, required = false,
                                 default = newJInt(60))
  if valid_594998 != nil:
    section.add "timeout", valid_594998
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594999 = query.getOrDefault("api-version")
  valid_594999 = validateParameter(valid_594999, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594999 != nil:
    section.add "api-version", valid_594999
  var valid_595000 = query.getOrDefault("ReplicasHealthStateFilter")
  valid_595000 = validateParameter(valid_595000, JInt, required = false,
                                 default = newJInt(0))
  if valid_595000 != nil:
    section.add "ReplicasHealthStateFilter", valid_595000
  var valid_595001 = query.getOrDefault("EventsHealthStateFilter")
  valid_595001 = validateParameter(valid_595001, JInt, required = false,
                                 default = newJInt(0))
  if valid_595001 != nil:
    section.add "EventsHealthStateFilter", valid_595001
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

proc call*(call_595003: Call_GetPartitionHealthUsingPolicy_594994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health information of the specified partition.
  ## If the application health policy is specified, the health evaluation uses it to get the aggregated health state.
  ## If the policy is not specified, the health evaluation uses the application health policy defined in the application manifest, or the default health policy, if no policy is defined in the manifest.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the partition based on the health state.
  ## Use ReplicasHealthStateFilter to filter the collection of ReplicaHealthState objects on the partition. Use ApplicationHealthPolicy in the POST body to override the health policies used to evaluate the health.
  ## If you specify a partition that does not exist in the health store, this cmdlet returns an error.
  ## 
  ## 
  let valid = call_595003.validator(path, query, header, formData, body)
  let scheme = call_595003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595003.url(scheme.get, call_595003.host, call_595003.base,
                         call_595003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595003, url, valid)

proc call*(call_595004: Call_GetPartitionHealthUsingPolicy_594994;
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
  var path_595005 = newJObject()
  var query_595006 = newJObject()
  var body_595007 = newJObject()
  add(query_595006, "timeout", newJInt(timeout))
  add(query_595006, "api-version", newJString(apiVersion))
  add(query_595006, "ReplicasHealthStateFilter",
      newJInt(ReplicasHealthStateFilter))
  if ApplicationHealthPolicy != nil:
    body_595007 = ApplicationHealthPolicy
  add(query_595006, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_595005, "partitionId", newJString(partitionId))
  result = call_595004.call(path_595005, query_595006, nil, nil, body_595007)

var getPartitionHealthUsingPolicy* = Call_GetPartitionHealthUsingPolicy_594994(
    name: "getPartitionHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/GetHealth",
    validator: validate_GetPartitionHealthUsingPolicy_594995, base: "",
    url: url_GetPartitionHealthUsingPolicy_594996,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetPartitionHealth_594982 = ref object of OpenApiRestCall_593437
proc url_GetPartitionHealth_594984(protocol: Scheme; host: string; base: string;
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

proc validate_GetPartitionHealth_594983(path: JsonNode; query: JsonNode;
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
  var valid_594985 = path.getOrDefault("partitionId")
  valid_594985 = validateParameter(valid_594985, JString, required = true,
                                 default = nil)
  if valid_594985 != nil:
    section.add "partitionId", valid_594985
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
  var valid_594986 = query.getOrDefault("timeout")
  valid_594986 = validateParameter(valid_594986, JInt, required = false,
                                 default = newJInt(60))
  if valid_594986 != nil:
    section.add "timeout", valid_594986
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594987 = query.getOrDefault("api-version")
  valid_594987 = validateParameter(valid_594987, JString, required = true,
                                 default = newJString("3.0"))
  if valid_594987 != nil:
    section.add "api-version", valid_594987
  var valid_594988 = query.getOrDefault("ReplicasHealthStateFilter")
  valid_594988 = validateParameter(valid_594988, JInt, required = false,
                                 default = newJInt(0))
  if valid_594988 != nil:
    section.add "ReplicasHealthStateFilter", valid_594988
  var valid_594989 = query.getOrDefault("EventsHealthStateFilter")
  valid_594989 = validateParameter(valid_594989, JInt, required = false,
                                 default = newJInt(0))
  if valid_594989 != nil:
    section.add "EventsHealthStateFilter", valid_594989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594990: Call_GetPartitionHealth_594982; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health information of the specified partition.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the service based on the health state.
  ## Use ReplicasHealthStateFilter to filter the collection of ReplicaHealthState objects on the partition.
  ## If you specify a partition that does not exist in the health store, this cmdlet returns an error.
  ## 
  ## 
  let valid = call_594990.validator(path, query, header, formData, body)
  let scheme = call_594990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594990.url(scheme.get, call_594990.host, call_594990.base,
                         call_594990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594990, url, valid)

proc call*(call_594991: Call_GetPartitionHealth_594982; partitionId: string;
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
  var path_594992 = newJObject()
  var query_594993 = newJObject()
  add(query_594993, "timeout", newJInt(timeout))
  add(query_594993, "api-version", newJString(apiVersion))
  add(query_594993, "ReplicasHealthStateFilter",
      newJInt(ReplicasHealthStateFilter))
  add(query_594993, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_594992, "partitionId", newJString(partitionId))
  result = call_594991.call(path_594992, query_594993, nil, nil, nil)

var getPartitionHealth* = Call_GetPartitionHealth_594982(
    name: "getPartitionHealth", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetHealth",
    validator: validate_GetPartitionHealth_594983, base: "",
    url: url_GetPartitionHealth_594984, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetPartitionLoadInformation_595008 = ref object of OpenApiRestCall_593437
proc url_GetPartitionLoadInformation_595010(protocol: Scheme; host: string;
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

proc validate_GetPartitionLoadInformation_595009(path: JsonNode; query: JsonNode;
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
  var valid_595011 = path.getOrDefault("partitionId")
  valid_595011 = validateParameter(valid_595011, JString, required = true,
                                 default = nil)
  if valid_595011 != nil:
    section.add "partitionId", valid_595011
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_595012 = query.getOrDefault("timeout")
  valid_595012 = validateParameter(valid_595012, JInt, required = false,
                                 default = newJInt(60))
  if valid_595012 != nil:
    section.add "timeout", valid_595012
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595013 = query.getOrDefault("api-version")
  valid_595013 = validateParameter(valid_595013, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595013 != nil:
    section.add "api-version", valid_595013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595014: Call_GetPartitionLoadInformation_595008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns information about the specified partition.
  ## The response includes a list of load information.
  ## Each information includes load metric name, value and last reported time in UTC.
  ## 
  ## 
  let valid = call_595014.validator(path, query, header, formData, body)
  let scheme = call_595014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595014.url(scheme.get, call_595014.host, call_595014.base,
                         call_595014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595014, url, valid)

proc call*(call_595015: Call_GetPartitionLoadInformation_595008;
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
  var path_595016 = newJObject()
  var query_595017 = newJObject()
  add(query_595017, "timeout", newJInt(timeout))
  add(query_595017, "api-version", newJString(apiVersion))
  add(path_595016, "partitionId", newJString(partitionId))
  result = call_595015.call(path_595016, query_595017, nil, nil, nil)

var getPartitionLoadInformation* = Call_GetPartitionLoadInformation_595008(
    name: "getPartitionLoadInformation", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetLoadInformation",
    validator: validate_GetPartitionLoadInformation_595009, base: "",
    url: url_GetPartitionLoadInformation_595010,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetReplicaInfoList_595018 = ref object of OpenApiRestCall_593437
proc url_GetReplicaInfoList_595020(protocol: Scheme; host: string; base: string;
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

proc validate_GetReplicaInfoList_595019(path: JsonNode; query: JsonNode;
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
  var valid_595021 = path.getOrDefault("partitionId")
  valid_595021 = validateParameter(valid_595021, JString, required = true,
                                 default = nil)
  if valid_595021 != nil:
    section.add "partitionId", valid_595021
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  section = newJObject()
  var valid_595022 = query.getOrDefault("timeout")
  valid_595022 = validateParameter(valid_595022, JInt, required = false,
                                 default = newJInt(60))
  if valid_595022 != nil:
    section.add "timeout", valid_595022
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595023 = query.getOrDefault("api-version")
  valid_595023 = validateParameter(valid_595023, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595023 != nil:
    section.add "api-version", valid_595023
  var valid_595024 = query.getOrDefault("ContinuationToken")
  valid_595024 = validateParameter(valid_595024, JString, required = false,
                                 default = nil)
  if valid_595024 != nil:
    section.add "ContinuationToken", valid_595024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595025: Call_GetReplicaInfoList_595018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetReplicas endpoint returns information about the replicas of the specified partition. The respons include the id, role, status, health, node name, uptime, and other details about the replica.
  ## 
  let valid = call_595025.validator(path, query, header, formData, body)
  let scheme = call_595025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595025.url(scheme.get, call_595025.host, call_595025.base,
                         call_595025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595025, url, valid)

proc call*(call_595026: Call_GetReplicaInfoList_595018; partitionId: string;
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
  var path_595027 = newJObject()
  var query_595028 = newJObject()
  add(query_595028, "timeout", newJInt(timeout))
  add(query_595028, "api-version", newJString(apiVersion))
  add(path_595027, "partitionId", newJString(partitionId))
  add(query_595028, "ContinuationToken", newJString(ContinuationToken))
  result = call_595026.call(path_595027, query_595028, nil, nil, nil)

var getReplicaInfoList* = Call_GetReplicaInfoList_595018(
    name: "getReplicaInfoList", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetReplicas",
    validator: validate_GetReplicaInfoList_595019, base: "",
    url: url_GetReplicaInfoList_595020, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetReplicaInfo_595029 = ref object of OpenApiRestCall_593437
proc url_GetReplicaInfo_595031(protocol: Scheme; host: string; base: string;
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

proc validate_GetReplicaInfo_595030(path: JsonNode; query: JsonNode;
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
  var valid_595032 = path.getOrDefault("replicaId")
  valid_595032 = validateParameter(valid_595032, JString, required = true,
                                 default = nil)
  if valid_595032 != nil:
    section.add "replicaId", valid_595032
  var valid_595033 = path.getOrDefault("partitionId")
  valid_595033 = validateParameter(valid_595033, JString, required = true,
                                 default = nil)
  if valid_595033 != nil:
    section.add "partitionId", valid_595033
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  section = newJObject()
  var valid_595034 = query.getOrDefault("timeout")
  valid_595034 = validateParameter(valid_595034, JInt, required = false,
                                 default = newJInt(60))
  if valid_595034 != nil:
    section.add "timeout", valid_595034
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595035 = query.getOrDefault("api-version")
  valid_595035 = validateParameter(valid_595035, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595035 != nil:
    section.add "api-version", valid_595035
  var valid_595036 = query.getOrDefault("ContinuationToken")
  valid_595036 = validateParameter(valid_595036, JString, required = false,
                                 default = nil)
  if valid_595036 != nil:
    section.add "ContinuationToken", valid_595036
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595037: Call_GetReplicaInfo_595029; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The respons include the id, role, status, health, node name, uptime, and other details about the replica.
  ## 
  let valid = call_595037.validator(path, query, header, formData, body)
  let scheme = call_595037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595037.url(scheme.get, call_595037.host, call_595037.base,
                         call_595037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595037, url, valid)

proc call*(call_595038: Call_GetReplicaInfo_595029; replicaId: string;
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
  var path_595039 = newJObject()
  var query_595040 = newJObject()
  add(path_595039, "replicaId", newJString(replicaId))
  add(query_595040, "timeout", newJInt(timeout))
  add(query_595040, "api-version", newJString(apiVersion))
  add(path_595039, "partitionId", newJString(partitionId))
  add(query_595040, "ContinuationToken", newJString(ContinuationToken))
  result = call_595038.call(path_595039, query_595040, nil, nil, nil)

var getReplicaInfo* = Call_GetReplicaInfo_595029(name: "getReplicaInfo",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}",
    validator: validate_GetReplicaInfo_595030, base: "", url: url_GetReplicaInfo_595031,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetReplicaHealthUsingPolicy_595053 = ref object of OpenApiRestCall_593437
proc url_GetReplicaHealthUsingPolicy_595055(protocol: Scheme; host: string;
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

proc validate_GetReplicaHealthUsingPolicy_595054(path: JsonNode; query: JsonNode;
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
  var valid_595056 = path.getOrDefault("replicaId")
  valid_595056 = validateParameter(valid_595056, JString, required = true,
                                 default = nil)
  if valid_595056 != nil:
    section.add "replicaId", valid_595056
  var valid_595057 = path.getOrDefault("partitionId")
  valid_595057 = validateParameter(valid_595057, JString, required = true,
                                 default = nil)
  if valid_595057 != nil:
    section.add "partitionId", valid_595057
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
  var valid_595058 = query.getOrDefault("timeout")
  valid_595058 = validateParameter(valid_595058, JInt, required = false,
                                 default = newJInt(60))
  if valid_595058 != nil:
    section.add "timeout", valid_595058
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595059 = query.getOrDefault("api-version")
  valid_595059 = validateParameter(valid_595059, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595059 != nil:
    section.add "api-version", valid_595059
  var valid_595060 = query.getOrDefault("EventsHealthStateFilter")
  valid_595060 = validateParameter(valid_595060, JInt, required = false,
                                 default = newJInt(0))
  if valid_595060 != nil:
    section.add "EventsHealthStateFilter", valid_595060
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

proc call*(call_595062: Call_GetReplicaHealthUsingPolicy_595053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric stateful service replica or stateless service instance.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the cluster based on the health state.
  ## Use ApplicationHealthPolicy to optionally override the health policies used to evaluate the health. This API only uses 'ConsiderWarningAsError' field of the ApplicationHealthPolicy. The rest of the fields are ignored while evaluating the health of the replica.
  ## 
  ## 
  let valid = call_595062.validator(path, query, header, formData, body)
  let scheme = call_595062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595062.url(scheme.get, call_595062.host, call_595062.base,
                         call_595062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595062, url, valid)

proc call*(call_595063: Call_GetReplicaHealthUsingPolicy_595053; replicaId: string;
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
  var path_595064 = newJObject()
  var query_595065 = newJObject()
  var body_595066 = newJObject()
  add(path_595064, "replicaId", newJString(replicaId))
  add(query_595065, "timeout", newJInt(timeout))
  add(query_595065, "api-version", newJString(apiVersion))
  if ApplicationHealthPolicy != nil:
    body_595066 = ApplicationHealthPolicy
  add(query_595065, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_595064, "partitionId", newJString(partitionId))
  result = call_595063.call(path_595064, query_595065, nil, nil, body_595066)

var getReplicaHealthUsingPolicy* = Call_GetReplicaHealthUsingPolicy_595053(
    name: "getReplicaHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}/$/GetHealth",
    validator: validate_GetReplicaHealthUsingPolicy_595054, base: "",
    url: url_GetReplicaHealthUsingPolicy_595055,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetReplicaHealth_595041 = ref object of OpenApiRestCall_593437
proc url_GetReplicaHealth_595043(protocol: Scheme; host: string; base: string;
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

proc validate_GetReplicaHealth_595042(path: JsonNode; query: JsonNode;
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
  var valid_595044 = path.getOrDefault("replicaId")
  valid_595044 = validateParameter(valid_595044, JString, required = true,
                                 default = nil)
  if valid_595044 != nil:
    section.add "replicaId", valid_595044
  var valid_595045 = path.getOrDefault("partitionId")
  valid_595045 = validateParameter(valid_595045, JString, required = true,
                                 default = nil)
  if valid_595045 != nil:
    section.add "partitionId", valid_595045
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
  var valid_595046 = query.getOrDefault("timeout")
  valid_595046 = validateParameter(valid_595046, JInt, required = false,
                                 default = newJInt(60))
  if valid_595046 != nil:
    section.add "timeout", valid_595046
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595047 = query.getOrDefault("api-version")
  valid_595047 = validateParameter(valid_595047, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595047 != nil:
    section.add "api-version", valid_595047
  var valid_595048 = query.getOrDefault("EventsHealthStateFilter")
  valid_595048 = validateParameter(valid_595048, JInt, required = false,
                                 default = newJInt(0))
  if valid_595048 != nil:
    section.add "EventsHealthStateFilter", valid_595048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595049: Call_GetReplicaHealth_595041; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health of a Service Fabric replica.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the replica based on the health state.
  ## 
  ## 
  let valid = call_595049.validator(path, query, header, formData, body)
  let scheme = call_595049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595049.url(scheme.get, call_595049.host, call_595049.base,
                         call_595049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595049, url, valid)

proc call*(call_595050: Call_GetReplicaHealth_595041; replicaId: string;
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
  var path_595051 = newJObject()
  var query_595052 = newJObject()
  add(path_595051, "replicaId", newJString(replicaId))
  add(query_595052, "timeout", newJInt(timeout))
  add(query_595052, "api-version", newJString(apiVersion))
  add(query_595052, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_595051, "partitionId", newJString(partitionId))
  result = call_595050.call(path_595051, query_595052, nil, nil, nil)

var getReplicaHealth* = Call_GetReplicaHealth_595041(name: "getReplicaHealth",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}/$/GetHealth",
    validator: validate_GetReplicaHealth_595042, base: "",
    url: url_GetReplicaHealth_595043, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportReplicaHealth_595067 = ref object of OpenApiRestCall_593437
proc url_ReportReplicaHealth_595069(protocol: Scheme; host: string; base: string;
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

proc validate_ReportReplicaHealth_595068(path: JsonNode; query: JsonNode;
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
  var valid_595070 = path.getOrDefault("replicaId")
  valid_595070 = validateParameter(valid_595070, JString, required = true,
                                 default = nil)
  if valid_595070 != nil:
    section.add "replicaId", valid_595070
  var valid_595071 = path.getOrDefault("partitionId")
  valid_595071 = validateParameter(valid_595071, JString, required = true,
                                 default = nil)
  if valid_595071 != nil:
    section.add "partitionId", valid_595071
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
  var valid_595072 = query.getOrDefault("timeout")
  valid_595072 = validateParameter(valid_595072, JInt, required = false,
                                 default = newJInt(60))
  if valid_595072 != nil:
    section.add "timeout", valid_595072
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595073 = query.getOrDefault("api-version")
  valid_595073 = validateParameter(valid_595073, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595073 != nil:
    section.add "api-version", valid_595073
  var valid_595074 = query.getOrDefault("ServiceKind")
  valid_595074 = validateParameter(valid_595074, JString, required = true,
                                 default = newJString("Stateful"))
  if valid_595074 != nil:
    section.add "ServiceKind", valid_595074
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

proc call*(call_595076: Call_ReportReplicaHealth_595067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reports health state of the specified Service Fabric replica. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Replica, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetReplicaHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_595076.validator(path, query, header, formData, body)
  let scheme = call_595076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595076.url(scheme.get, call_595076.host, call_595076.base,
                         call_595076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595076, url, valid)

proc call*(call_595077: Call_ReportReplicaHealth_595067; replicaId: string;
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
  var path_595078 = newJObject()
  var query_595079 = newJObject()
  var body_595080 = newJObject()
  add(path_595078, "replicaId", newJString(replicaId))
  add(query_595079, "timeout", newJInt(timeout))
  add(query_595079, "api-version", newJString(apiVersion))
  if HealthInformation != nil:
    body_595080 = HealthInformation
  add(path_595078, "partitionId", newJString(partitionId))
  add(query_595079, "ServiceKind", newJString(ServiceKind))
  result = call_595077.call(path_595078, query_595079, nil, nil, body_595080)

var reportReplicaHealth* = Call_ReportReplicaHealth_595067(
    name: "reportReplicaHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/GetReplicas/{replicaId}/$/ReportHealth",
    validator: validate_ReportReplicaHealth_595068, base: "",
    url: url_ReportReplicaHealth_595069, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceNameInfo_595081 = ref object of OpenApiRestCall_593437
proc url_GetServiceNameInfo_595083(protocol: Scheme; host: string; base: string;
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

proc validate_GetServiceNameInfo_595082(path: JsonNode; query: JsonNode;
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
  var valid_595084 = path.getOrDefault("partitionId")
  valid_595084 = validateParameter(valid_595084, JString, required = true,
                                 default = nil)
  if valid_595084 != nil:
    section.add "partitionId", valid_595084
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_595085 = query.getOrDefault("timeout")
  valid_595085 = validateParameter(valid_595085, JInt, required = false,
                                 default = newJInt(60))
  if valid_595085 != nil:
    section.add "timeout", valid_595085
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595086 = query.getOrDefault("api-version")
  valid_595086 = validateParameter(valid_595086, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595086 != nil:
    section.add "api-version", valid_595086
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595087: Call_GetServiceNameInfo_595081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetServiceName endpoint returns the name of the service for the specified partition.
  ## 
  let valid = call_595087.validator(path, query, header, formData, body)
  let scheme = call_595087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595087.url(scheme.get, call_595087.host, call_595087.base,
                         call_595087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595087, url, valid)

proc call*(call_595088: Call_GetServiceNameInfo_595081; partitionId: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getServiceNameInfo
  ## The GetServiceName endpoint returns the name of the service for the specified partition.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_595089 = newJObject()
  var query_595090 = newJObject()
  add(query_595090, "timeout", newJInt(timeout))
  add(query_595090, "api-version", newJString(apiVersion))
  add(path_595089, "partitionId", newJString(partitionId))
  result = call_595088.call(path_595089, query_595090, nil, nil, nil)

var getServiceNameInfo* = Call_GetServiceNameInfo_595081(
    name: "getServiceNameInfo", meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/GetServiceName",
    validator: validate_GetServiceNameInfo_595082, base: "",
    url: url_GetServiceNameInfo_595083, schemes: {Scheme.Https, Scheme.Http})
type
  Call_RecoverPartition_595091 = ref object of OpenApiRestCall_593437
proc url_RecoverPartition_595093(protocol: Scheme; host: string; base: string;
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

proc validate_RecoverPartition_595092(path: JsonNode; query: JsonNode;
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
  var valid_595094 = path.getOrDefault("partitionId")
  valid_595094 = validateParameter(valid_595094, JString, required = true,
                                 default = nil)
  if valid_595094 != nil:
    section.add "partitionId", valid_595094
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_595095 = query.getOrDefault("timeout")
  valid_595095 = validateParameter(valid_595095, JInt, required = false,
                                 default = newJInt(60))
  if valid_595095 != nil:
    section.add "timeout", valid_595095
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595096 = query.getOrDefault("api-version")
  valid_595096 = validateParameter(valid_595096, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595096 != nil:
    section.add "api-version", valid_595096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595097: Call_RecoverPartition_595091; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicates to the Service Fabric cluster that it should attempt to recover a specific partition which is currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ## 
  let valid = call_595097.validator(path, query, header, formData, body)
  let scheme = call_595097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595097.url(scheme.get, call_595097.host, call_595097.base,
                         call_595097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595097, url, valid)

proc call*(call_595098: Call_RecoverPartition_595091; partitionId: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## recoverPartition
  ## Indicates to the Service Fabric cluster that it should attempt to recover a specific partition which is currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_595099 = newJObject()
  var query_595100 = newJObject()
  add(query_595100, "timeout", newJInt(timeout))
  add(query_595100, "api-version", newJString(apiVersion))
  add(path_595099, "partitionId", newJString(partitionId))
  result = call_595098.call(path_595099, query_595100, nil, nil, nil)

var recoverPartition* = Call_RecoverPartition_595091(name: "recoverPartition",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Partitions/{partitionId}/$/Recover",
    validator: validate_RecoverPartition_595092, base: "",
    url: url_RecoverPartition_595093, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportPartitionHealth_595101 = ref object of OpenApiRestCall_593437
proc url_ReportPartitionHealth_595103(protocol: Scheme; host: string; base: string;
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

proc validate_ReportPartitionHealth_595102(path: JsonNode; query: JsonNode;
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
  var valid_595104 = path.getOrDefault("partitionId")
  valid_595104 = validateParameter(valid_595104, JString, required = true,
                                 default = nil)
  if valid_595104 != nil:
    section.add "partitionId", valid_595104
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_595105 = query.getOrDefault("timeout")
  valid_595105 = validateParameter(valid_595105, JInt, required = false,
                                 default = newJInt(60))
  if valid_595105 != nil:
    section.add "timeout", valid_595105
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595106 = query.getOrDefault("api-version")
  valid_595106 = validateParameter(valid_595106, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595106 != nil:
    section.add "api-version", valid_595106
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

proc call*(call_595108: Call_ReportPartitionHealth_595101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reports health state of the specified Service Fabric partition. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Partition, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetPartitionHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_595108.validator(path, query, header, formData, body)
  let scheme = call_595108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595108.url(scheme.get, call_595108.host, call_595108.base,
                         call_595108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595108, url, valid)

proc call*(call_595109: Call_ReportPartitionHealth_595101;
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
  var path_595110 = newJObject()
  var query_595111 = newJObject()
  var body_595112 = newJObject()
  add(query_595111, "timeout", newJInt(timeout))
  add(query_595111, "api-version", newJString(apiVersion))
  if HealthInformation != nil:
    body_595112 = HealthInformation
  add(path_595110, "partitionId", newJString(partitionId))
  result = call_595109.call(path_595110, query_595111, nil, nil, body_595112)

var reportPartitionHealth* = Call_ReportPartitionHealth_595101(
    name: "reportPartitionHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/ReportHealth",
    validator: validate_ReportPartitionHealth_595102, base: "",
    url: url_ReportPartitionHealth_595103, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ResetPartitionLoad_595113 = ref object of OpenApiRestCall_593437
proc url_ResetPartitionLoad_595115(protocol: Scheme; host: string; base: string;
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

proc validate_ResetPartitionLoad_595114(path: JsonNode; query: JsonNode;
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
  var valid_595116 = path.getOrDefault("partitionId")
  valid_595116 = validateParameter(valid_595116, JString, required = true,
                                 default = nil)
  if valid_595116 != nil:
    section.add "partitionId", valid_595116
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_595117 = query.getOrDefault("timeout")
  valid_595117 = validateParameter(valid_595117, JInt, required = false,
                                 default = newJInt(60))
  if valid_595117 != nil:
    section.add "timeout", valid_595117
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595118 = query.getOrDefault("api-version")
  valid_595118 = validateParameter(valid_595118, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595118 != nil:
    section.add "api-version", valid_595118
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595119: Call_ResetPartitionLoad_595113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resets the current load of a Service Fabric partition to the default load for the service.
  ## 
  let valid = call_595119.validator(path, query, header, formData, body)
  let scheme = call_595119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595119.url(scheme.get, call_595119.host, call_595119.base,
                         call_595119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595119, url, valid)

proc call*(call_595120: Call_ResetPartitionLoad_595113; partitionId: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## resetPartitionLoad
  ## Resets the current load of a Service Fabric partition to the default load for the service.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   partitionId: string (required)
  ##              : The identity of the partition.
  var path_595121 = newJObject()
  var query_595122 = newJObject()
  add(query_595122, "timeout", newJInt(timeout))
  add(query_595122, "api-version", newJString(apiVersion))
  add(path_595121, "partitionId", newJString(partitionId))
  result = call_595120.call(path_595121, query_595122, nil, nil, nil)

var resetPartitionLoad* = Call_ResetPartitionLoad_595113(
    name: "resetPartitionLoad", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Partitions/{partitionId}/$/ResetLoad",
    validator: validate_ResetPartitionLoad_595114, base: "",
    url: url_ResetPartitionLoad_595115, schemes: {Scheme.Https, Scheme.Http})
type
  Call_RecoverServicePartitions_595123 = ref object of OpenApiRestCall_593437
proc url_RecoverServicePartitions_595125(protocol: Scheme; host: string;
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

proc validate_RecoverServicePartitions_595124(path: JsonNode; query: JsonNode;
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
  var valid_595126 = path.getOrDefault("serviceId")
  valid_595126 = validateParameter(valid_595126, JString, required = true,
                                 default = nil)
  if valid_595126 != nil:
    section.add "serviceId", valid_595126
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_595127 = query.getOrDefault("timeout")
  valid_595127 = validateParameter(valid_595127, JInt, required = false,
                                 default = newJInt(60))
  if valid_595127 != nil:
    section.add "timeout", valid_595127
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595128 = query.getOrDefault("api-version")
  valid_595128 = validateParameter(valid_595128, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595128 != nil:
    section.add "api-version", valid_595128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595129: Call_RecoverServicePartitions_595123; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicates to the Service Fabric cluster that it should attempt to recover the specified service which is currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ## 
  let valid = call_595129.validator(path, query, header, formData, body)
  let scheme = call_595129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595129.url(scheme.get, call_595129.host, call_595129.base,
                         call_595129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595129, url, valid)

proc call*(call_595130: Call_RecoverServicePartitions_595123; serviceId: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## recoverServicePartitions
  ## Indicates to the Service Fabric cluster that it should attempt to recover the specified service which is currently stuck in quorum loss. This operation should only be performed if it is known that the replicas that are down cannot be recovered. Incorrect use of this API can cause potential data loss.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_595131 = newJObject()
  var query_595132 = newJObject()
  add(query_595132, "timeout", newJInt(timeout))
  add(query_595132, "api-version", newJString(apiVersion))
  add(path_595131, "serviceId", newJString(serviceId))
  result = call_595130.call(path_595131, query_595132, nil, nil, nil)

var recoverServicePartitions* = Call_RecoverServicePartitions_595123(
    name: "recoverServicePartitions", meth: HttpMethod.HttpPost,
    host: "azure.local:19080",
    route: "/Services/$/{serviceId}/$/GetPartitions/$/Recover",
    validator: validate_RecoverServicePartitions_595124, base: "",
    url: url_RecoverServicePartitions_595125, schemes: {Scheme.Https, Scheme.Http})
type
  Call_DeleteService_595133 = ref object of OpenApiRestCall_593437
proc url_DeleteService_595135(protocol: Scheme; host: string; base: string;
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

proc validate_DeleteService_595134(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_595136 = path.getOrDefault("serviceId")
  valid_595136 = validateParameter(valid_595136, JString, required = true,
                                 default = nil)
  if valid_595136 != nil:
    section.add "serviceId", valid_595136
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ForceRemove: JBool
  ##              : Remove a Service Fabric application or service forcefully without going through the graceful shutdown sequence. This parameter can be used to forcefully delete an application or service for which delete is timing out due to issues in the service code that prevents graceful close of replicas.
  section = newJObject()
  var valid_595137 = query.getOrDefault("timeout")
  valid_595137 = validateParameter(valid_595137, JInt, required = false,
                                 default = newJInt(60))
  if valid_595137 != nil:
    section.add "timeout", valid_595137
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595138 = query.getOrDefault("api-version")
  valid_595138 = validateParameter(valid_595138, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595138 != nil:
    section.add "api-version", valid_595138
  var valid_595139 = query.getOrDefault("ForceRemove")
  valid_595139 = validateParameter(valid_595139, JBool, required = false, default = nil)
  if valid_595139 != nil:
    section.add "ForceRemove", valid_595139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595140: Call_DeleteService_595133; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing Service Fabric service. A service must be created before it can be deleted. By default Service Fabric will try to close service replicas in a graceful manner and then delete the service. However if service is having issues closing the replica gracefully, the delete operation may take a long time or get stuck. Use the optional ForceRemove flag to skip the graceful close sequence and forcefully delete the service.
  ## 
  let valid = call_595140.validator(path, query, header, formData, body)
  let scheme = call_595140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595140.url(scheme.get, call_595140.host, call_595140.base,
                         call_595140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595140, url, valid)

proc call*(call_595141: Call_DeleteService_595133; serviceId: string;
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
  var path_595142 = newJObject()
  var query_595143 = newJObject()
  add(query_595143, "timeout", newJInt(timeout))
  add(query_595143, "api-version", newJString(apiVersion))
  add(query_595143, "ForceRemove", newJBool(ForceRemove))
  add(path_595142, "serviceId", newJString(serviceId))
  result = call_595141.call(path_595142, query_595143, nil, nil, nil)

var deleteService* = Call_DeleteService_595133(name: "deleteService",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Services/{serviceId}/$/Delete", validator: validate_DeleteService_595134,
    base: "", url: url_DeleteService_595135, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetApplicationNameInfo_595144 = ref object of OpenApiRestCall_593437
proc url_GetApplicationNameInfo_595146(protocol: Scheme; host: string; base: string;
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

proc validate_GetApplicationNameInfo_595145(path: JsonNode; query: JsonNode;
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
  var valid_595147 = path.getOrDefault("serviceId")
  valid_595147 = validateParameter(valid_595147, JString, required = true,
                                 default = nil)
  if valid_595147 != nil:
    section.add "serviceId", valid_595147
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_595148 = query.getOrDefault("timeout")
  valid_595148 = validateParameter(valid_595148, JInt, required = false,
                                 default = newJInt(60))
  if valid_595148 != nil:
    section.add "timeout", valid_595148
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595149 = query.getOrDefault("api-version")
  valid_595149 = validateParameter(valid_595149, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595149 != nil:
    section.add "api-version", valid_595149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595150: Call_GetApplicationNameInfo_595144; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The GetApplicationName endpoint returns the name of the application for the specified service.
  ## 
  let valid = call_595150.validator(path, query, header, formData, body)
  let scheme = call_595150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595150.url(scheme.get, call_595150.host, call_595150.base,
                         call_595150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595150, url, valid)

proc call*(call_595151: Call_GetApplicationNameInfo_595144; serviceId: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getApplicationNameInfo
  ## The GetApplicationName endpoint returns the name of the application for the specified service.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_595152 = newJObject()
  var query_595153 = newJObject()
  add(query_595153, "timeout", newJInt(timeout))
  add(query_595153, "api-version", newJString(apiVersion))
  add(path_595152, "serviceId", newJString(serviceId))
  result = call_595151.call(path_595152, query_595153, nil, nil, nil)

var getApplicationNameInfo* = Call_GetApplicationNameInfo_595144(
    name: "getApplicationNameInfo", meth: HttpMethod.HttpGet,
    host: "azure.local:19080",
    route: "/Services/{serviceId}/$/GetApplicationName",
    validator: validate_GetApplicationNameInfo_595145, base: "",
    url: url_GetApplicationNameInfo_595146, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceDescription_595154 = ref object of OpenApiRestCall_593437
proc url_GetServiceDescription_595156(protocol: Scheme; host: string; base: string;
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

proc validate_GetServiceDescription_595155(path: JsonNode; query: JsonNode;
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
  var valid_595157 = path.getOrDefault("serviceId")
  valid_595157 = validateParameter(valid_595157, JString, required = true,
                                 default = nil)
  if valid_595157 != nil:
    section.add "serviceId", valid_595157
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_595158 = query.getOrDefault("timeout")
  valid_595158 = validateParameter(valid_595158, JInt, required = false,
                                 default = newJInt(60))
  if valid_595158 != nil:
    section.add "timeout", valid_595158
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595159 = query.getOrDefault("api-version")
  valid_595159 = validateParameter(valid_595159, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595159 != nil:
    section.add "api-version", valid_595159
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595160: Call_GetServiceDescription_595154; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the description of an existing Service Fabric service. A service must be created before its description can be obtained.
  ## 
  let valid = call_595160.validator(path, query, header, formData, body)
  let scheme = call_595160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595160.url(scheme.get, call_595160.host, call_595160.base,
                         call_595160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595160, url, valid)

proc call*(call_595161: Call_GetServiceDescription_595154; serviceId: string;
          timeout: int = 60; apiVersion: string = "3.0"): Recallable =
  ## getServiceDescription
  ## Gets the description of an existing Service Fabric service. A service must be created before its description can be obtained.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   serviceId: string (required)
  ##            : The identity of the service. This is typically the full name of the service without the 'fabric:' URI scheme.
  var path_595162 = newJObject()
  var query_595163 = newJObject()
  add(query_595163, "timeout", newJInt(timeout))
  add(query_595163, "api-version", newJString(apiVersion))
  add(path_595162, "serviceId", newJString(serviceId))
  result = call_595161.call(path_595162, query_595163, nil, nil, nil)

var getServiceDescription* = Call_GetServiceDescription_595154(
    name: "getServiceDescription", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Services/{serviceId}/$/GetDescription",
    validator: validate_GetServiceDescription_595155, base: "",
    url: url_GetServiceDescription_595156, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceHealthUsingPolicy_595176 = ref object of OpenApiRestCall_593437
proc url_GetServiceHealthUsingPolicy_595178(protocol: Scheme; host: string;
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

proc validate_GetServiceHealthUsingPolicy_595177(path: JsonNode; query: JsonNode;
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
  var valid_595179 = path.getOrDefault("serviceId")
  valid_595179 = validateParameter(valid_595179, JString, required = true,
                                 default = nil)
  if valid_595179 != nil:
    section.add "serviceId", valid_595179
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
  var valid_595180 = query.getOrDefault("timeout")
  valid_595180 = validateParameter(valid_595180, JInt, required = false,
                                 default = newJInt(60))
  if valid_595180 != nil:
    section.add "timeout", valid_595180
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595181 = query.getOrDefault("api-version")
  valid_595181 = validateParameter(valid_595181, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595181 != nil:
    section.add "api-version", valid_595181
  var valid_595182 = query.getOrDefault("EventsHealthStateFilter")
  valid_595182 = validateParameter(valid_595182, JInt, required = false,
                                 default = newJInt(0))
  if valid_595182 != nil:
    section.add "EventsHealthStateFilter", valid_595182
  var valid_595183 = query.getOrDefault("PartitionsHealthStateFilter")
  valid_595183 = validateParameter(valid_595183, JInt, required = false,
                                 default = newJInt(0))
  if valid_595183 != nil:
    section.add "PartitionsHealthStateFilter", valid_595183
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

proc call*(call_595185: Call_GetServiceHealthUsingPolicy_595176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health information of the specified service.
  ## If the application health policy is specified, the health evaluation uses it to get the aggregated health state.
  ## If the policy is not specified, the health evaluation uses the application health policy defined in the application manifest, or the default health policy, if no policy is defined in the manifest.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the service based on the health state.
  ## Use PartitionsHealthStateFilter to filter the collection of partitions returned.
  ## If you specify a service that does not exist in the health store, this cmdlet returns an error.
  ## 
  ## 
  let valid = call_595185.validator(path, query, header, formData, body)
  let scheme = call_595185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595185.url(scheme.get, call_595185.host, call_595185.base,
                         call_595185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595185, url, valid)

proc call*(call_595186: Call_GetServiceHealthUsingPolicy_595176; serviceId: string;
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
  var path_595187 = newJObject()
  var query_595188 = newJObject()
  var body_595189 = newJObject()
  add(query_595188, "timeout", newJInt(timeout))
  add(query_595188, "api-version", newJString(apiVersion))
  if ApplicationHealthPolicy != nil:
    body_595189 = ApplicationHealthPolicy
  add(query_595188, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_595187, "serviceId", newJString(serviceId))
  add(query_595188, "PartitionsHealthStateFilter",
      newJInt(PartitionsHealthStateFilter))
  result = call_595186.call(path_595187, query_595188, nil, nil, body_595189)

var getServiceHealthUsingPolicy* = Call_GetServiceHealthUsingPolicy_595176(
    name: "getServiceHealthUsingPolicy", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Services/{serviceId}/$/GetHealth",
    validator: validate_GetServiceHealthUsingPolicy_595177, base: "",
    url: url_GetServiceHealthUsingPolicy_595178,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetServiceHealth_595164 = ref object of OpenApiRestCall_593437
proc url_GetServiceHealth_595166(protocol: Scheme; host: string; base: string;
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

proc validate_GetServiceHealth_595165(path: JsonNode; query: JsonNode;
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
  var valid_595167 = path.getOrDefault("serviceId")
  valid_595167 = validateParameter(valid_595167, JString, required = true,
                                 default = nil)
  if valid_595167 != nil:
    section.add "serviceId", valid_595167
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
  var valid_595168 = query.getOrDefault("timeout")
  valid_595168 = validateParameter(valid_595168, JInt, required = false,
                                 default = newJInt(60))
  if valid_595168 != nil:
    section.add "timeout", valid_595168
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595169 = query.getOrDefault("api-version")
  valid_595169 = validateParameter(valid_595169, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595169 != nil:
    section.add "api-version", valid_595169
  var valid_595170 = query.getOrDefault("EventsHealthStateFilter")
  valid_595170 = validateParameter(valid_595170, JInt, required = false,
                                 default = newJInt(0))
  if valid_595170 != nil:
    section.add "EventsHealthStateFilter", valid_595170
  var valid_595171 = query.getOrDefault("PartitionsHealthStateFilter")
  valid_595171 = validateParameter(valid_595171, JInt, required = false,
                                 default = newJInt(0))
  if valid_595171 != nil:
    section.add "PartitionsHealthStateFilter", valid_595171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595172: Call_GetServiceHealth_595164; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the health information of the specified service.
  ## Use EventsHealthStateFilter to filter the collection of health events reported on the service based on the health state.
  ## Use PartitionsHealthStateFilter to filter the collection of partitions returned.
  ## If you specify a service that does not exist in the health store, this cmdlet returns an error.
  ## 
  ## 
  let valid = call_595172.validator(path, query, header, formData, body)
  let scheme = call_595172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595172.url(scheme.get, call_595172.host, call_595172.base,
                         call_595172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595172, url, valid)

proc call*(call_595173: Call_GetServiceHealth_595164; serviceId: string;
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
  var path_595174 = newJObject()
  var query_595175 = newJObject()
  add(query_595175, "timeout", newJInt(timeout))
  add(query_595175, "api-version", newJString(apiVersion))
  add(query_595175, "EventsHealthStateFilter", newJInt(EventsHealthStateFilter))
  add(path_595174, "serviceId", newJString(serviceId))
  add(query_595175, "PartitionsHealthStateFilter",
      newJInt(PartitionsHealthStateFilter))
  result = call_595173.call(path_595174, query_595175, nil, nil, nil)

var getServiceHealth* = Call_GetServiceHealth_595164(name: "getServiceHealth",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Services/{serviceId}/$/GetHealth",
    validator: validate_GetServiceHealth_595165, base: "",
    url: url_GetServiceHealth_595166, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetPartitionInfoList_595190 = ref object of OpenApiRestCall_593437
proc url_GetPartitionInfoList_595192(protocol: Scheme; host: string; base: string;
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

proc validate_GetPartitionInfoList_595191(path: JsonNode; query: JsonNode;
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
  var valid_595193 = path.getOrDefault("serviceId")
  valid_595193 = validateParameter(valid_595193, JString, required = true,
                                 default = nil)
  if valid_595193 != nil:
    section.add "serviceId", valid_595193
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  ##   ContinuationToken: JString
  ##                    : The continuation token parameter is used to obtain next set of results. A continuation token with a non empty value is included in the response of the API when the results from the system do not fit in a single response. When this value is passed to the next API call, the API returns next set of results. If there are no further results then the continuation token does not contain a value. The value of this parameter should not be URL encoded.
  section = newJObject()
  var valid_595194 = query.getOrDefault("timeout")
  valid_595194 = validateParameter(valid_595194, JInt, required = false,
                                 default = newJInt(60))
  if valid_595194 != nil:
    section.add "timeout", valid_595194
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595195 = query.getOrDefault("api-version")
  valid_595195 = validateParameter(valid_595195, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595195 != nil:
    section.add "api-version", valid_595195
  var valid_595196 = query.getOrDefault("ContinuationToken")
  valid_595196 = validateParameter(valid_595196, JString, required = false,
                                 default = nil)
  if valid_595196 != nil:
    section.add "ContinuationToken", valid_595196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595197: Call_GetPartitionInfoList_595190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the list of partitions of a Service Fabric service. The response include the partition id, partitioning scheme information, keys supported by the partition, status, health and other details about the partition.
  ## 
  let valid = call_595197.validator(path, query, header, formData, body)
  let scheme = call_595197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595197.url(scheme.get, call_595197.host, call_595197.base,
                         call_595197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595197, url, valid)

proc call*(call_595198: Call_GetPartitionInfoList_595190; serviceId: string;
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
  var path_595199 = newJObject()
  var query_595200 = newJObject()
  add(query_595200, "timeout", newJInt(timeout))
  add(query_595200, "api-version", newJString(apiVersion))
  add(path_595199, "serviceId", newJString(serviceId))
  add(query_595200, "ContinuationToken", newJString(ContinuationToken))
  result = call_595198.call(path_595199, query_595200, nil, nil, nil)

var getPartitionInfoList* = Call_GetPartitionInfoList_595190(
    name: "getPartitionInfoList", meth: HttpMethod.HttpGet,
    host: "azure.local:19080", route: "/Services/{serviceId}/$/GetPartitions",
    validator: validate_GetPartitionInfoList_595191, base: "",
    url: url_GetPartitionInfoList_595192, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ReportServiceHealth_595201 = ref object of OpenApiRestCall_593437
proc url_ReportServiceHealth_595203(protocol: Scheme; host: string; base: string;
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

proc validate_ReportServiceHealth_595202(path: JsonNode; query: JsonNode;
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
  var valid_595204 = path.getOrDefault("serviceId")
  valid_595204 = validateParameter(valid_595204, JString, required = true,
                                 default = nil)
  if valid_595204 != nil:
    section.add "serviceId", valid_595204
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_595205 = query.getOrDefault("timeout")
  valid_595205 = validateParameter(valid_595205, JInt, required = false,
                                 default = newJInt(60))
  if valid_595205 != nil:
    section.add "timeout", valid_595205
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595206 = query.getOrDefault("api-version")
  valid_595206 = validateParameter(valid_595206, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595206 != nil:
    section.add "api-version", valid_595206
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

proc call*(call_595208: Call_ReportServiceHealth_595201; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Reports health state of the specified Service Fabric service. The report must contain the information about the source of the health report and property on which it is reported.
  ## The report is sent to a Service Fabric gateway Service, which forwards to the health store.
  ## The report may be accepted by the gateway, but rejected by the health store after extra validation.
  ## For example, the health store may reject the report because of an invalid parameter, like a stale sequence number.
  ## To see whether the report was applied in the health store, run GetServiceHealth and check that the report appears in the HealthEvents section.
  ## 
  ## 
  let valid = call_595208.validator(path, query, header, formData, body)
  let scheme = call_595208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595208.url(scheme.get, call_595208.host, call_595208.base,
                         call_595208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595208, url, valid)

proc call*(call_595209: Call_ReportServiceHealth_595201;
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
  var path_595210 = newJObject()
  var query_595211 = newJObject()
  var body_595212 = newJObject()
  add(query_595211, "timeout", newJInt(timeout))
  add(query_595211, "api-version", newJString(apiVersion))
  if HealthInformation != nil:
    body_595212 = HealthInformation
  add(path_595210, "serviceId", newJString(serviceId))
  result = call_595209.call(path_595210, query_595211, nil, nil, body_595212)

var reportServiceHealth* = Call_ReportServiceHealth_595201(
    name: "reportServiceHealth", meth: HttpMethod.HttpPost,
    host: "azure.local:19080", route: "/Services/{serviceId}/$/ReportHealth",
    validator: validate_ReportServiceHealth_595202, base: "",
    url: url_ReportServiceHealth_595203, schemes: {Scheme.Https, Scheme.Http})
type
  Call_ResolveService_595213 = ref object of OpenApiRestCall_593437
proc url_ResolveService_595215(protocol: Scheme; host: string; base: string;
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

proc validate_ResolveService_595214(path: JsonNode; query: JsonNode;
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
  var valid_595216 = path.getOrDefault("serviceId")
  valid_595216 = validateParameter(valid_595216, JString, required = true,
                                 default = nil)
  if valid_595216 != nil:
    section.add "serviceId", valid_595216
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
  var valid_595217 = query.getOrDefault("timeout")
  valid_595217 = validateParameter(valid_595217, JInt, required = false,
                                 default = newJInt(60))
  if valid_595217 != nil:
    section.add "timeout", valid_595217
  var valid_595218 = query.getOrDefault("PartitionKeyValue")
  valid_595218 = validateParameter(valid_595218, JString, required = false,
                                 default = nil)
  if valid_595218 != nil:
    section.add "PartitionKeyValue", valid_595218
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595219 = query.getOrDefault("api-version")
  valid_595219 = validateParameter(valid_595219, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595219 != nil:
    section.add "api-version", valid_595219
  var valid_595220 = query.getOrDefault("PartitionKeyType")
  valid_595220 = validateParameter(valid_595220, JInt, required = false, default = nil)
  if valid_595220 != nil:
    section.add "PartitionKeyType", valid_595220
  var valid_595221 = query.getOrDefault("PreviousRspVersion")
  valid_595221 = validateParameter(valid_595221, JString, required = false,
                                 default = nil)
  if valid_595221 != nil:
    section.add "PreviousRspVersion", valid_595221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595222: Call_ResolveService_595213; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Resolve a Service Fabric service partition, to get the endpoints of the service replicas.
  ## 
  let valid = call_595222.validator(path, query, header, formData, body)
  let scheme = call_595222.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595222.url(scheme.get, call_595222.host, call_595222.base,
                         call_595222.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595222, url, valid)

proc call*(call_595223: Call_ResolveService_595213; serviceId: string;
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
  var path_595224 = newJObject()
  var query_595225 = newJObject()
  add(query_595225, "timeout", newJInt(timeout))
  add(query_595225, "PartitionKeyValue", newJString(PartitionKeyValue))
  add(query_595225, "api-version", newJString(apiVersion))
  add(query_595225, "PartitionKeyType", newJInt(PartitionKeyType))
  add(path_595224, "serviceId", newJString(serviceId))
  add(query_595225, "PreviousRspVersion", newJString(PreviousRspVersion))
  result = call_595223.call(path_595224, query_595225, nil, nil, nil)

var resolveService* = Call_ResolveService_595213(name: "resolveService",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Services/{serviceId}/$/ResolvePartition",
    validator: validate_ResolveService_595214, base: "", url: url_ResolveService_595215,
    schemes: {Scheme.Https, Scheme.Http})
type
  Call_UpdateService_595226 = ref object of OpenApiRestCall_593437
proc url_UpdateService_595228(protocol: Scheme; host: string; base: string;
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

proc validate_UpdateService_595227(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_595229 = path.getOrDefault("serviceId")
  valid_595229 = validateParameter(valid_595229, JString, required = true,
                                 default = nil)
  if valid_595229 != nil:
    section.add "serviceId", valid_595229
  result.add "path", section
  ## parameters in `query` object:
  ##   timeout: JInt
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   api-version: JString (required)
  ##              : The version of the API. This is a required parameter and it's value must be "3.0".
  section = newJObject()
  var valid_595230 = query.getOrDefault("timeout")
  valid_595230 = validateParameter(valid_595230, JInt, required = false,
                                 default = newJInt(60))
  if valid_595230 != nil:
    section.add "timeout", valid_595230
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595231 = query.getOrDefault("api-version")
  valid_595231 = validateParameter(valid_595231, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595231 != nil:
    section.add "api-version", valid_595231
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

proc call*(call_595233: Call_UpdateService_595226; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified service using the given update description.
  ## 
  let valid = call_595233.validator(path, query, header, formData, body)
  let scheme = call_595233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595233.url(scheme.get, call_595233.host, call_595233.base,
                         call_595233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595233, url, valid)

proc call*(call_595234: Call_UpdateService_595226;
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
  var path_595235 = newJObject()
  var query_595236 = newJObject()
  var body_595237 = newJObject()
  add(query_595236, "timeout", newJInt(timeout))
  add(query_595236, "api-version", newJString(apiVersion))
  if ServiceUpdateDescription != nil:
    body_595237 = ServiceUpdateDescription
  add(path_595235, "serviceId", newJString(serviceId))
  result = call_595234.call(path_595235, query_595236, nil, nil, body_595237)

var updateService* = Call_UpdateService_595226(name: "updateService",
    meth: HttpMethod.HttpPost, host: "azure.local:19080",
    route: "/Services/{serviceId}/$/Update", validator: validate_UpdateService_595227,
    base: "", url: url_UpdateService_595228, schemes: {Scheme.Https, Scheme.Http})
type
  Call_GetChaosReport_595238 = ref object of OpenApiRestCall_593437
proc url_GetChaosReport_595240(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetChaosReport_595239(path: JsonNode; query: JsonNode;
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
  var valid_595241 = query.getOrDefault("timeout")
  valid_595241 = validateParameter(valid_595241, JInt, required = false,
                                 default = newJInt(60))
  if valid_595241 != nil:
    section.add "timeout", valid_595241
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595242 = query.getOrDefault("api-version")
  valid_595242 = validateParameter(valid_595242, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595242 != nil:
    section.add "api-version", valid_595242
  var valid_595243 = query.getOrDefault("EndTimeUtc")
  valid_595243 = validateParameter(valid_595243, JString, required = false,
                                 default = nil)
  if valid_595243 != nil:
    section.add "EndTimeUtc", valid_595243
  var valid_595244 = query.getOrDefault("ContinuationToken")
  valid_595244 = validateParameter(valid_595244, JString, required = false,
                                 default = nil)
  if valid_595244 != nil:
    section.add "ContinuationToken", valid_595244
  var valid_595245 = query.getOrDefault("StartTimeUtc")
  valid_595245 = validateParameter(valid_595245, JString, required = false,
                                 default = nil)
  if valid_595245 != nil:
    section.add "StartTimeUtc", valid_595245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595246: Call_GetChaosReport_595238; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## You can either specify the ContinuationToken to get the next segment of the Chaos report or you can specify the time-range
  ## through StartTimeUtc and EndTimeUtc, but you cannot specify both the ContinuationToken and the time-range in the same call.
  ## When there are more than 100 Chaos events, the Chaos report is returned in segments where a segment contains no more than 100 Chaos events.
  ## 
  ## 
  let valid = call_595246.validator(path, query, header, formData, body)
  let scheme = call_595246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595246.url(scheme.get, call_595246.host, call_595246.base,
                         call_595246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595246, url, valid)

proc call*(call_595247: Call_GetChaosReport_595238; timeout: int = 60;
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
  var query_595248 = newJObject()
  add(query_595248, "timeout", newJInt(timeout))
  add(query_595248, "api-version", newJString(apiVersion))
  add(query_595248, "EndTimeUtc", newJString(EndTimeUtc))
  add(query_595248, "ContinuationToken", newJString(ContinuationToken))
  add(query_595248, "StartTimeUtc", newJString(StartTimeUtc))
  result = call_595247.call(nil, query_595248, nil, nil, nil)

var getChaosReport* = Call_GetChaosReport_595238(name: "getChaosReport",
    meth: HttpMethod.HttpGet, host: "azure.local:19080",
    route: "/Tools/Chaos/$/Report", validator: validate_GetChaosReport_595239,
    base: "", url: url_GetChaosReport_595240, schemes: {Scheme.Https, Scheme.Http})
type
  Call_StartChaos_595249 = ref object of OpenApiRestCall_593437
proc url_StartChaos_595251(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StartChaos_595250(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_595252 = query.getOrDefault("timeout")
  valid_595252 = validateParameter(valid_595252, JInt, required = false,
                                 default = newJInt(60))
  if valid_595252 != nil:
    section.add "timeout", valid_595252
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595253 = query.getOrDefault("api-version")
  valid_595253 = validateParameter(valid_595253, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595253 != nil:
    section.add "api-version", valid_595253
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

proc call*(call_595255: Call_StartChaos_595249; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## If Chaos is not already running in the cluster, it starts Chaos with the passed in Chaos parameters.
  ## If Chaos is already running when this call is made, the call fails with the error code FABRIC_E_CHAOS_ALREADY_RUNNING.
  ## Please refer to the article [Induce controlled Chaos in Service Fabric clusters](https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-controlled-chaos) for more details.
  ## 
  ## 
  let valid = call_595255.validator(path, query, header, formData, body)
  let scheme = call_595255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595255.url(scheme.get, call_595255.host, call_595255.base,
                         call_595255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595255, url, valid)

proc call*(call_595256: Call_StartChaos_595249; ChaosParameters: JsonNode;
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
  var query_595257 = newJObject()
  var body_595258 = newJObject()
  add(query_595257, "timeout", newJInt(timeout))
  add(query_595257, "api-version", newJString(apiVersion))
  if ChaosParameters != nil:
    body_595258 = ChaosParameters
  result = call_595256.call(nil, query_595257, nil, nil, body_595258)

var startChaos* = Call_StartChaos_595249(name: "startChaos",
                                      meth: HttpMethod.HttpPost,
                                      host: "azure.local:19080",
                                      route: "/Tools/Chaos/$/Start",
                                      validator: validate_StartChaos_595250,
                                      base: "", url: url_StartChaos_595251,
                                      schemes: {Scheme.Https, Scheme.Http})
type
  Call_StopChaos_595259 = ref object of OpenApiRestCall_593437
proc url_StopChaos_595261(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StopChaos_595260(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_595262 = query.getOrDefault("timeout")
  valid_595262 = validateParameter(valid_595262, JInt, required = false,
                                 default = newJInt(60))
  if valid_595262 != nil:
    section.add "timeout", valid_595262
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_595263 = query.getOrDefault("api-version")
  valid_595263 = validateParameter(valid_595263, JString, required = true,
                                 default = newJString("3.0"))
  if valid_595263 != nil:
    section.add "api-version", valid_595263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595264: Call_StopChaos_595259; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops Chaos from scheduling further faults; but, the in-flight faults are not affected.
  ## 
  let valid = call_595264.validator(path, query, header, formData, body)
  let scheme = call_595264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595264.url(scheme.get, call_595264.host, call_595264.base,
                         call_595264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595264, url, valid)

proc call*(call_595265: Call_StopChaos_595259; timeout: int = 60;
          apiVersion: string = "3.0"): Recallable =
  ## stopChaos
  ## Stops Chaos from scheduling further faults; but, the in-flight faults are not affected.
  ##   timeout: int
  ##          : The server timeout for performing the operation in seconds. This specifies the time duration that the client is willing to wait for the requested operation to complete. The default value for this parameter is 60 seconds.
  ##   apiVersion: string (required)
  ##             : The version of the API. This is a required parameter and it's value must be "3.0".
  var query_595266 = newJObject()
  add(query_595266, "timeout", newJInt(timeout))
  add(query_595266, "api-version", newJString(apiVersion))
  result = call_595265.call(nil, query_595266, nil, nil, nil)

var stopChaos* = Call_StopChaos_595259(name: "stopChaos", meth: HttpMethod.HttpPost,
                                    host: "azure.local:19080",
                                    route: "/Tools/Chaos/$/Stop",
                                    validator: validate_StopChaos_595260,
                                    base: "", url: url_StopChaos_595261,
                                    schemes: {Scheme.Https, Scheme.Http})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
