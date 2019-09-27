
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ServiceFabricManagementClient
## version: 2019-03-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure Service Fabric Resource Provider API Client
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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  macServiceName = "servicefabric-cluster"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593646 = ref object of OpenApiRestCall_593424
proc url_OperationsList_593648(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593647(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Get the list of available Service Fabric resource provider API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593794 = query.getOrDefault("api-version")
  valid_593794 = validateParameter(valid_593794, JString, required = true,
                                 default = nil)
  if valid_593794 != nil:
    section.add "api-version", valid_593794
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593821: Call_OperationsList_593646; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of available Service Fabric resource provider API operations.
  ## 
  let valid = call_593821.validator(path, query, header, formData, body)
  let scheme = call_593821.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593821.url(scheme.get, call_593821.host, call_593821.base,
                         call_593821.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593821, url, valid)

proc call*(call_593892: Call_OperationsList_593646; apiVersion: string): Recallable =
  ## operationsList
  ## Get the list of available Service Fabric resource provider API operations.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API
  var query_593893 = newJObject()
  add(query_593893, "api-version", newJString(apiVersion))
  result = call_593892.call(nil, query_593893, nil, nil, nil)

var operationsList* = Call_OperationsList_593646(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ServiceFabric/operations",
    validator: validate_OperationsList_593647, base: "", url: url_OperationsList_593648,
    schemes: {Scheme.Https})
type
  Call_ClustersList_593933 = ref object of OpenApiRestCall_593424
proc url_ClustersList_593935(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersList_593934(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all Service Fabric cluster resources created or in the process of being created in the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593959 = path.getOrDefault("subscriptionId")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = nil)
  if valid_593959 != nil:
    section.add "subscriptionId", valid_593959
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593973 = query.getOrDefault("api-version")
  valid_593973 = validateParameter(valid_593973, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_593973 != nil:
    section.add "api-version", valid_593973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593974: Call_ClustersList_593933; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all Service Fabric cluster resources created or in the process of being created in the subscription.
  ## 
  let valid = call_593974.validator(path, query, header, formData, body)
  let scheme = call_593974.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593974.url(scheme.get, call_593974.host, call_593974.base,
                         call_593974.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593974, url, valid)

proc call*(call_593975: Call_ClustersList_593933; subscriptionId: string;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## clustersList
  ## Gets all Service Fabric cluster resources created or in the process of being created in the subscription.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_593976 = newJObject()
  var query_593977 = newJObject()
  add(query_593977, "api-version", newJString(apiVersion))
  add(path_593976, "subscriptionId", newJString(subscriptionId))
  result = call_593975.call(path_593976, query_593977, nil, nil, nil)

var clustersList* = Call_ClustersList_593933(name: "clustersList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabric/clusters",
    validator: validate_ClustersList_593934, base: "", url: url_ClustersList_593935,
    schemes: {Scheme.Https})
type
  Call_ClusterVersionsList_593978 = ref object of OpenApiRestCall_593424
proc url_ClusterVersionsList_593980(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/clusterVersions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClusterVersionsList_593979(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Gets all available code versions for Service Fabric cluster resources by location.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   location: JString (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593981 = path.getOrDefault("subscriptionId")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "subscriptionId", valid_593981
  var valid_593982 = path.getOrDefault("location")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = nil)
  if valid_593982 != nil:
    section.add "location", valid_593982
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593983 = query.getOrDefault("api-version")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_593983 != nil:
    section.add "api-version", valid_593983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593984: Call_ClusterVersionsList_593978; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all available code versions for Service Fabric cluster resources by location.
  ## 
  let valid = call_593984.validator(path, query, header, formData, body)
  let scheme = call_593984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593984.url(scheme.get, call_593984.host, call_593984.base,
                         call_593984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593984, url, valid)

proc call*(call_593985: Call_ClusterVersionsList_593978; subscriptionId: string;
          location: string; apiVersion: string = "2019-03-01-preview"): Recallable =
  ## clusterVersionsList
  ## Gets all available code versions for Service Fabric cluster resources by location.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   location: string (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  var path_593986 = newJObject()
  var query_593987 = newJObject()
  add(query_593987, "api-version", newJString(apiVersion))
  add(path_593986, "subscriptionId", newJString(subscriptionId))
  add(path_593986, "location", newJString(location))
  result = call_593985.call(path_593986, query_593987, nil, nil, nil)

var clusterVersionsList* = Call_ClusterVersionsList_593978(
    name: "clusterVersionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabric/locations/{location}/clusterVersions",
    validator: validate_ClusterVersionsList_593979, base: "",
    url: url_ClusterVersionsList_593980, schemes: {Scheme.Https})
type
  Call_ClusterVersionsGet_593988 = ref object of OpenApiRestCall_593424
proc url_ClusterVersionsGet_593990(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "clusterVersion" in path, "`clusterVersion` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/clusterVersions/"),
               (kind: VariableSegment, value: "clusterVersion")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClusterVersionsGet_593989(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Gets information about an available Service Fabric cluster code version.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   clusterVersion: JString (required)
  ##                 : The cluster code version.
  ##   location: JString (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593991 = path.getOrDefault("subscriptionId")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "subscriptionId", valid_593991
  var valid_593992 = path.getOrDefault("clusterVersion")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "clusterVersion", valid_593992
  var valid_593993 = path.getOrDefault("location")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = nil)
  if valid_593993 != nil:
    section.add "location", valid_593993
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593994 = query.getOrDefault("api-version")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_593994 != nil:
    section.add "api-version", valid_593994
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593995: Call_ClusterVersionsGet_593988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets information about an available Service Fabric cluster code version.
  ## 
  let valid = call_593995.validator(path, query, header, formData, body)
  let scheme = call_593995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593995.url(scheme.get, call_593995.host, call_593995.base,
                         call_593995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593995, url, valid)

proc call*(call_593996: Call_ClusterVersionsGet_593988; subscriptionId: string;
          clusterVersion: string; location: string;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## clusterVersionsGet
  ## Gets information about an available Service Fabric cluster code version.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   clusterVersion: string (required)
  ##                 : The cluster code version.
  ##   location: string (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  var path_593997 = newJObject()
  var query_593998 = newJObject()
  add(query_593998, "api-version", newJString(apiVersion))
  add(path_593997, "subscriptionId", newJString(subscriptionId))
  add(path_593997, "clusterVersion", newJString(clusterVersion))
  add(path_593997, "location", newJString(location))
  result = call_593996.call(path_593997, query_593998, nil, nil, nil)

var clusterVersionsGet* = Call_ClusterVersionsGet_593988(
    name: "clusterVersionsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabric/locations/{location}/clusterVersions/{clusterVersion}",
    validator: validate_ClusterVersionsGet_593989, base: "",
    url: url_ClusterVersionsGet_593990, schemes: {Scheme.Https})
type
  Call_ClusterVersionsListByEnvironment_593999 = ref object of OpenApiRestCall_593424
proc url_ClusterVersionsListByEnvironment_594001(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "environment" in path, "`environment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "environment"),
               (kind: ConstantSegment, value: "/clusterVersions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClusterVersionsListByEnvironment_594000(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all available code versions for Service Fabric cluster resources by environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   environment: JString (required)
  ##              : The operating system of the cluster. The default means all.
  ##   location: JString (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594002 = path.getOrDefault("subscriptionId")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "subscriptionId", valid_594002
  var valid_594003 = path.getOrDefault("environment")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = newJString("Windows"))
  if valid_594003 != nil:
    section.add "environment", valid_594003
  var valid_594004 = path.getOrDefault("location")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = nil)
  if valid_594004 != nil:
    section.add "location", valid_594004
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594005 = query.getOrDefault("api-version")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594005 != nil:
    section.add "api-version", valid_594005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594006: Call_ClusterVersionsListByEnvironment_593999;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all available code versions for Service Fabric cluster resources by environment.
  ## 
  let valid = call_594006.validator(path, query, header, formData, body)
  let scheme = call_594006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594006.url(scheme.get, call_594006.host, call_594006.base,
                         call_594006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594006, url, valid)

proc call*(call_594007: Call_ClusterVersionsListByEnvironment_593999;
          subscriptionId: string; location: string;
          apiVersion: string = "2019-03-01-preview"; environment: string = "Windows"): Recallable =
  ## clusterVersionsListByEnvironment
  ## Gets all available code versions for Service Fabric cluster resources by environment.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   environment: string (required)
  ##              : The operating system of the cluster. The default means all.
  ##   location: string (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  var path_594008 = newJObject()
  var query_594009 = newJObject()
  add(query_594009, "api-version", newJString(apiVersion))
  add(path_594008, "subscriptionId", newJString(subscriptionId))
  add(path_594008, "environment", newJString(environment))
  add(path_594008, "location", newJString(location))
  result = call_594007.call(path_594008, query_594009, nil, nil, nil)

var clusterVersionsListByEnvironment* = Call_ClusterVersionsListByEnvironment_593999(
    name: "clusterVersionsListByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabric/locations/{location}/environments/{environment}/clusterVersions",
    validator: validate_ClusterVersionsListByEnvironment_594000, base: "",
    url: url_ClusterVersionsListByEnvironment_594001, schemes: {Scheme.Https})
type
  Call_ClusterVersionsGetByEnvironment_594010 = ref object of OpenApiRestCall_593424
proc url_ClusterVersionsGetByEnvironment_594012(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  assert "environment" in path, "`environment` is a required path parameter"
  assert "clusterVersion" in path, "`clusterVersion` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/environments/"),
               (kind: VariableSegment, value: "environment"),
               (kind: ConstantSegment, value: "/clusterVersions/"),
               (kind: VariableSegment, value: "clusterVersion")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClusterVersionsGetByEnvironment_594011(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about an available Service Fabric cluster code version by environment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  ##   environment: JString (required)
  ##              : The operating system of the cluster. The default means all.
  ##   clusterVersion: JString (required)
  ##                 : The cluster code version.
  ##   location: JString (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_594013 = path.getOrDefault("subscriptionId")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "subscriptionId", valid_594013
  var valid_594014 = path.getOrDefault("environment")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = newJString("Windows"))
  if valid_594014 != nil:
    section.add "environment", valid_594014
  var valid_594015 = path.getOrDefault("clusterVersion")
  valid_594015 = validateParameter(valid_594015, JString, required = true,
                                 default = nil)
  if valid_594015 != nil:
    section.add "clusterVersion", valid_594015
  var valid_594016 = path.getOrDefault("location")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "location", valid_594016
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594017 = query.getOrDefault("api-version")
  valid_594017 = validateParameter(valid_594017, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594017 != nil:
    section.add "api-version", valid_594017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594018: Call_ClusterVersionsGetByEnvironment_594010;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about an available Service Fabric cluster code version by environment.
  ## 
  let valid = call_594018.validator(path, query, header, formData, body)
  let scheme = call_594018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594018.url(scheme.get, call_594018.host, call_594018.base,
                         call_594018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594018, url, valid)

proc call*(call_594019: Call_ClusterVersionsGetByEnvironment_594010;
          subscriptionId: string; clusterVersion: string; location: string;
          apiVersion: string = "2019-03-01-preview"; environment: string = "Windows"): Recallable =
  ## clusterVersionsGetByEnvironment
  ## Gets information about an available Service Fabric cluster code version by environment.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   environment: string (required)
  ##              : The operating system of the cluster. The default means all.
  ##   clusterVersion: string (required)
  ##                 : The cluster code version.
  ##   location: string (required)
  ##           : The location for the cluster code versions. This is different from cluster location.
  var path_594020 = newJObject()
  var query_594021 = newJObject()
  add(query_594021, "api-version", newJString(apiVersion))
  add(path_594020, "subscriptionId", newJString(subscriptionId))
  add(path_594020, "environment", newJString(environment))
  add(path_594020, "clusterVersion", newJString(clusterVersion))
  add(path_594020, "location", newJString(location))
  result = call_594019.call(path_594020, query_594021, nil, nil, nil)

var clusterVersionsGetByEnvironment* = Call_ClusterVersionsGetByEnvironment_594010(
    name: "clusterVersionsGetByEnvironment", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabric/locations/{location}/environments/{environment}/clusterVersions/{clusterVersion}",
    validator: validate_ClusterVersionsGetByEnvironment_594011, base: "",
    url: url_ClusterVersionsGetByEnvironment_594012, schemes: {Scheme.Https})
type
  Call_ClustersCreate_594033 = ref object of OpenApiRestCall_593424
proc url_ClustersCreate_594035(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersCreate_594034(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Create or update a Service Fabric cluster resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_594036 = path.getOrDefault("clusterName")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "clusterName", valid_594036
  var valid_594037 = path.getOrDefault("resourceGroupName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "resourceGroupName", valid_594037
  var valid_594038 = path.getOrDefault("subscriptionId")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "subscriptionId", valid_594038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594039 = query.getOrDefault("api-version")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594039 != nil:
    section.add "api-version", valid_594039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The cluster resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594041: Call_ClustersCreate_594033; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create or update a Service Fabric cluster resource with the specified name.
  ## 
  let valid = call_594041.validator(path, query, header, formData, body)
  let scheme = call_594041.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594041.url(scheme.get, call_594041.host, call_594041.base,
                         call_594041.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594041, url, valid)

proc call*(call_594042: Call_ClustersCreate_594033; clusterName: string;
          resourceGroupName: string; subscriptionId: string; parameters: JsonNode;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## clustersCreate
  ## Create or update a Service Fabric cluster resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   parameters: JObject (required)
  ##             : The cluster resource.
  var path_594043 = newJObject()
  var query_594044 = newJObject()
  var body_594045 = newJObject()
  add(path_594043, "clusterName", newJString(clusterName))
  add(path_594043, "resourceGroupName", newJString(resourceGroupName))
  add(query_594044, "api-version", newJString(apiVersion))
  add(path_594043, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594045 = parameters
  result = call_594042.call(path_594043, query_594044, nil, nil, body_594045)

var clustersCreate* = Call_ClustersCreate_594033(name: "clustersCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}",
    validator: validate_ClustersCreate_594034, base: "", url: url_ClustersCreate_594035,
    schemes: {Scheme.Https})
type
  Call_ClustersGet_594022 = ref object of OpenApiRestCall_593424
proc url_ClustersGet_594024(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersGet_594023(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a Service Fabric cluster resource created or in the process of being created in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_594025 = path.getOrDefault("clusterName")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "clusterName", valid_594025
  var valid_594026 = path.getOrDefault("resourceGroupName")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "resourceGroupName", valid_594026
  var valid_594027 = path.getOrDefault("subscriptionId")
  valid_594027 = validateParameter(valid_594027, JString, required = true,
                                 default = nil)
  if valid_594027 != nil:
    section.add "subscriptionId", valid_594027
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594028 = query.getOrDefault("api-version")
  valid_594028 = validateParameter(valid_594028, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594028 != nil:
    section.add "api-version", valid_594028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594029: Call_ClustersGet_594022; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get a Service Fabric cluster resource created or in the process of being created in the specified resource group.
  ## 
  let valid = call_594029.validator(path, query, header, formData, body)
  let scheme = call_594029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594029.url(scheme.get, call_594029.host, call_594029.base,
                         call_594029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594029, url, valid)

proc call*(call_594030: Call_ClustersGet_594022; clusterName: string;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## clustersGet
  ## Get a Service Fabric cluster resource created or in the process of being created in the specified resource group.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_594031 = newJObject()
  var query_594032 = newJObject()
  add(path_594031, "clusterName", newJString(clusterName))
  add(path_594031, "resourceGroupName", newJString(resourceGroupName))
  add(query_594032, "api-version", newJString(apiVersion))
  add(path_594031, "subscriptionId", newJString(subscriptionId))
  result = call_594030.call(path_594031, query_594032, nil, nil, nil)

var clustersGet* = Call_ClustersGet_594022(name: "clustersGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}",
                                        validator: validate_ClustersGet_594023,
                                        base: "", url: url_ClustersGet_594024,
                                        schemes: {Scheme.Https})
type
  Call_ClustersUpdate_594057 = ref object of OpenApiRestCall_593424
proc url_ClustersUpdate_594059(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersUpdate_594058(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Update the configuration of a Service Fabric cluster resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_594077 = path.getOrDefault("clusterName")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = nil)
  if valid_594077 != nil:
    section.add "clusterName", valid_594077
  var valid_594078 = path.getOrDefault("resourceGroupName")
  valid_594078 = validateParameter(valid_594078, JString, required = true,
                                 default = nil)
  if valid_594078 != nil:
    section.add "resourceGroupName", valid_594078
  var valid_594079 = path.getOrDefault("subscriptionId")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "subscriptionId", valid_594079
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594080 = query.getOrDefault("api-version")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594080 != nil:
    section.add "api-version", valid_594080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : The parameters which contains the property value and property name which used to update the cluster configuration.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594082: Call_ClustersUpdate_594057; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the configuration of a Service Fabric cluster resource with the specified name.
  ## 
  let valid = call_594082.validator(path, query, header, formData, body)
  let scheme = call_594082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594082.url(scheme.get, call_594082.host, call_594082.base,
                         call_594082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594082, url, valid)

proc call*(call_594083: Call_ClustersUpdate_594057; clusterName: string;
          resourceGroupName: string; subscriptionId: string; parameters: JsonNode;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## clustersUpdate
  ## Update the configuration of a Service Fabric cluster resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  ##   parameters: JObject (required)
  ##             : The parameters which contains the property value and property name which used to update the cluster configuration.
  var path_594084 = newJObject()
  var query_594085 = newJObject()
  var body_594086 = newJObject()
  add(path_594084, "clusterName", newJString(clusterName))
  add(path_594084, "resourceGroupName", newJString(resourceGroupName))
  add(query_594085, "api-version", newJString(apiVersion))
  add(path_594084, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_594086 = parameters
  result = call_594083.call(path_594084, query_594085, nil, nil, body_594086)

var clustersUpdate* = Call_ClustersUpdate_594057(name: "clustersUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}",
    validator: validate_ClustersUpdate_594058, base: "", url: url_ClustersUpdate_594059,
    schemes: {Scheme.Https})
type
  Call_ClustersDelete_594046 = ref object of OpenApiRestCall_593424
proc url_ClustersDelete_594048(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "clusterName" in path, "`clusterName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters/"),
               (kind: VariableSegment, value: "clusterName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersDelete_594047(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Delete a Service Fabric cluster resource with the specified name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clusterName: JString (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `clusterName` field"
  var valid_594049 = path.getOrDefault("clusterName")
  valid_594049 = validateParameter(valid_594049, JString, required = true,
                                 default = nil)
  if valid_594049 != nil:
    section.add "clusterName", valid_594049
  var valid_594050 = path.getOrDefault("resourceGroupName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "resourceGroupName", valid_594050
  var valid_594051 = path.getOrDefault("subscriptionId")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "subscriptionId", valid_594051
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594052 = query.getOrDefault("api-version")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594052 != nil:
    section.add "api-version", valid_594052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594053: Call_ClustersDelete_594046; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Service Fabric cluster resource with the specified name.
  ## 
  let valid = call_594053.validator(path, query, header, formData, body)
  let scheme = call_594053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594053.url(scheme.get, call_594053.host, call_594053.base,
                         call_594053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594053, url, valid)

proc call*(call_594054: Call_ClustersDelete_594046; clusterName: string;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## clustersDelete
  ## Delete a Service Fabric cluster resource with the specified name.
  ##   clusterName: string (required)
  ##              : The name of the cluster resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_594055 = newJObject()
  var query_594056 = newJObject()
  add(path_594055, "clusterName", newJString(clusterName))
  add(path_594055, "resourceGroupName", newJString(resourceGroupName))
  add(query_594056, "api-version", newJString(apiVersion))
  add(path_594055, "subscriptionId", newJString(subscriptionId))
  result = call_594054.call(path_594055, query_594056, nil, nil, nil)

var clustersDelete* = Call_ClustersDelete_594046(name: "clustersDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters/{clusterName}",
    validator: validate_ClustersDelete_594047, base: "", url: url_ClustersDelete_594048,
    schemes: {Scheme.Https})
type
  Call_ClustersListByResourceGroup_594087 = ref object of OpenApiRestCall_593424
proc url_ClustersListByResourceGroup_594089(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabric/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ClustersListByResourceGroup_594088(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all Service Fabric cluster resources created or in the process of being created in the resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594090 = path.getOrDefault("resourceGroupName")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "resourceGroupName", valid_594090
  var valid_594091 = path.getOrDefault("subscriptionId")
  valid_594091 = validateParameter(valid_594091, JString, required = true,
                                 default = nil)
  if valid_594091 != nil:
    section.add "subscriptionId", valid_594091
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594092 = query.getOrDefault("api-version")
  valid_594092 = validateParameter(valid_594092, JString, required = true,
                                 default = newJString("2019-03-01-preview"))
  if valid_594092 != nil:
    section.add "api-version", valid_594092
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594093: Call_ClustersListByResourceGroup_594087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets all Service Fabric cluster resources created or in the process of being created in the resource group.
  ## 
  let valid = call_594093.validator(path, query, header, formData, body)
  let scheme = call_594093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594093.url(scheme.get, call_594093.host, call_594093.base,
                         call_594093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594093, url, valid)

proc call*(call_594094: Call_ClustersListByResourceGroup_594087;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2019-03-01-preview"): Recallable =
  ## clustersListByResourceGroup
  ## Gets all Service Fabric cluster resources created or in the process of being created in the resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : The version of the Service Fabric resource provider API. This is a required parameter and it's value must be "2019-03-01-preview" for this specification.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier.
  var path_594095 = newJObject()
  var query_594096 = newJObject()
  add(path_594095, "resourceGroupName", newJString(resourceGroupName))
  add(query_594096, "api-version", newJString(apiVersion))
  add(path_594095, "subscriptionId", newJString(subscriptionId))
  result = call_594094.call(path_594095, query_594096, nil, nil, nil)

var clustersListByResourceGroup* = Call_ClustersListByResourceGroup_594087(
    name: "clustersListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.ServiceFabric/clusters",
    validator: validate_ClustersListByResourceGroup_594088, base: "",
    url: url_ClustersListByResourceGroup_594089, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
