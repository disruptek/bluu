
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: SeaBreezeManagementClient
## version: 2018-07-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## APIs to deploy and manage resources to SeaBreeze.
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
  macServiceName = "servicefabricmesh"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563786 = ref object of OpenApiRestCall_563564
proc url_OperationsList_563788(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563787(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all the available operations provided by Service Fabric SeaBreeze resource provider.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563962 = query.getOrDefault("api-version")
  valid_563962 = validateParameter(valid_563962, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_563962 != nil:
    section.add "api-version", valid_563962
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563985: Call_OperationsList_563786; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available operations provided by Service Fabric SeaBreeze resource provider.
  ## 
  let valid = call_563985.validator(path, query, header, formData, body)
  let scheme = call_563985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563985.url(scheme.get, call_563985.host, call_563985.base,
                         call_563985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563985, url, valid)

proc call*(call_564056: Call_OperationsList_563786;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## operationsList
  ## Lists all the available operations provided by Service Fabric SeaBreeze resource provider.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  var query_564057 = newJObject()
  add(query_564057, "api-version", newJString(apiVersion))
  result = call_564056.call(nil, query_564057, nil, nil, nil)

var operationsList* = Call_OperationsList_563786(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ServiceFabricMesh/operations",
    validator: validate_OperationsList_563787, base: "", url: url_OperationsList_563788,
    schemes: {Scheme.Https})
type
  Call_ApplicationListBySubscription_564097 = ref object of OpenApiRestCall_563564
proc url_ApplicationListBySubscription_564099(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationListBySubscription_564098(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all application resources in a given subscription. The information includes the information about the application's services and other runtime properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564114 = path.getOrDefault("subscriptionId")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "subscriptionId", valid_564114
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564115 = query.getOrDefault("api-version")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_564115 != nil:
    section.add "api-version", valid_564115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564116: Call_ApplicationListBySubscription_564097; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all application resources in a given subscription. The information includes the information about the application's services and other runtime properties.
  ## 
  let valid = call_564116.validator(path, query, header, formData, body)
  let scheme = call_564116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564116.url(scheme.get, call_564116.host, call_564116.base,
                         call_564116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564116, url, valid)

proc call*(call_564117: Call_ApplicationListBySubscription_564097;
          subscriptionId: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## applicationListBySubscription
  ## Gets the information about all application resources in a given subscription. The information includes the information about the application's services and other runtime properties.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_564118 = newJObject()
  var query_564119 = newJObject()
  add(query_564119, "api-version", newJString(apiVersion))
  add(path_564118, "subscriptionId", newJString(subscriptionId))
  result = call_564117.call(path_564118, query_564119, nil, nil, nil)

var applicationListBySubscription* = Call_ApplicationListBySubscription_564097(
    name: "applicationListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/applications",
    validator: validate_ApplicationListBySubscription_564098, base: "",
    url: url_ApplicationListBySubscription_564099, schemes: {Scheme.Https})
type
  Call_NetworkListBySubscription_564120 = ref object of OpenApiRestCall_563564
proc url_NetworkListBySubscription_564122(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/networks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkListBySubscription_564121(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all network resources in a given subscription. The information includes the network description and other runtime properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564123 = path.getOrDefault("subscriptionId")
  valid_564123 = validateParameter(valid_564123, JString, required = true,
                                 default = nil)
  if valid_564123 != nil:
    section.add "subscriptionId", valid_564123
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564124 = query.getOrDefault("api-version")
  valid_564124 = validateParameter(valid_564124, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_564124 != nil:
    section.add "api-version", valid_564124
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564125: Call_NetworkListBySubscription_564120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all network resources in a given subscription. The information includes the network description and other runtime properties.
  ## 
  let valid = call_564125.validator(path, query, header, formData, body)
  let scheme = call_564125.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564125.url(scheme.get, call_564125.host, call_564125.base,
                         call_564125.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564125, url, valid)

proc call*(call_564126: Call_NetworkListBySubscription_564120;
          subscriptionId: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## networkListBySubscription
  ## Gets the information about all network resources in a given subscription. The information includes the network description and other runtime properties.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_564127 = newJObject()
  var query_564128 = newJObject()
  add(query_564128, "api-version", newJString(apiVersion))
  add(path_564127, "subscriptionId", newJString(subscriptionId))
  result = call_564126.call(path_564127, query_564128, nil, nil, nil)

var networkListBySubscription* = Call_NetworkListBySubscription_564120(
    name: "networkListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/networks",
    validator: validate_NetworkListBySubscription_564121, base: "",
    url: url_NetworkListBySubscription_564122, schemes: {Scheme.Https})
type
  Call_VolumeListBySubscription_564129 = ref object of OpenApiRestCall_563564
proc url_VolumeListBySubscription_564131(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/volumes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeListBySubscription_564130(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all volume resources in a given subscription. The information includes the volume description and other runtime information.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564132 = path.getOrDefault("subscriptionId")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "subscriptionId", valid_564132
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564133 = query.getOrDefault("api-version")
  valid_564133 = validateParameter(valid_564133, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_564133 != nil:
    section.add "api-version", valid_564133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564134: Call_VolumeListBySubscription_564129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all volume resources in a given subscription. The information includes the volume description and other runtime information.
  ## 
  ## 
  let valid = call_564134.validator(path, query, header, formData, body)
  let scheme = call_564134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564134.url(scheme.get, call_564134.host, call_564134.base,
                         call_564134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564134, url, valid)

proc call*(call_564135: Call_VolumeListBySubscription_564129;
          subscriptionId: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## volumeListBySubscription
  ## Gets the information about all volume resources in a given subscription. The information includes the volume description and other runtime information.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_564136 = newJObject()
  var query_564137 = newJObject()
  add(query_564137, "api-version", newJString(apiVersion))
  add(path_564136, "subscriptionId", newJString(subscriptionId))
  result = call_564135.call(path_564136, query_564137, nil, nil, nil)

var volumeListBySubscription* = Call_VolumeListBySubscription_564129(
    name: "volumeListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/volumes",
    validator: validate_VolumeListBySubscription_564130, base: "",
    url: url_VolumeListBySubscription_564131, schemes: {Scheme.Https})
type
  Call_ApplicationListByResourceGroup_564138 = ref object of OpenApiRestCall_563564
proc url_ApplicationListByResourceGroup_564140(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationListByResourceGroup_564139(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all application resources in a given resource group. The information includes the information about the application's services and other runtime properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564141 = path.getOrDefault("subscriptionId")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "subscriptionId", valid_564141
  var valid_564142 = path.getOrDefault("resourceGroupName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "resourceGroupName", valid_564142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564143 = query.getOrDefault("api-version")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_564143 != nil:
    section.add "api-version", valid_564143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564144: Call_ApplicationListByResourceGroup_564138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all application resources in a given resource group. The information includes the information about the application's services and other runtime properties.
  ## 
  let valid = call_564144.validator(path, query, header, formData, body)
  let scheme = call_564144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564144.url(scheme.get, call_564144.host, call_564144.base,
                         call_564144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564144, url, valid)

proc call*(call_564145: Call_ApplicationListByResourceGroup_564138;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## applicationListByResourceGroup
  ## Gets the information about all application resources in a given resource group. The information includes the information about the application's services and other runtime properties.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564146 = newJObject()
  var query_564147 = newJObject()
  add(query_564147, "api-version", newJString(apiVersion))
  add(path_564146, "subscriptionId", newJString(subscriptionId))
  add(path_564146, "resourceGroupName", newJString(resourceGroupName))
  result = call_564145.call(path_564146, query_564147, nil, nil, nil)

var applicationListByResourceGroup* = Call_ApplicationListByResourceGroup_564138(
    name: "applicationListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications",
    validator: validate_ApplicationListByResourceGroup_564139, base: "",
    url: url_ApplicationListByResourceGroup_564140, schemes: {Scheme.Https})
type
  Call_ApplicationCreate_564159 = ref object of OpenApiRestCall_563564
proc url_ApplicationCreate_564161(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationCreate_564160(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates an application resource with the specified name and description. If an application with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## Use network resources to provide public connectivity to the services of an application.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_564179 = path.getOrDefault("applicationName")
  valid_564179 = validateParameter(valid_564179, JString, required = true,
                                 default = nil)
  if valid_564179 != nil:
    section.add "applicationName", valid_564179
  var valid_564180 = path.getOrDefault("subscriptionId")
  valid_564180 = validateParameter(valid_564180, JString, required = true,
                                 default = nil)
  if valid_564180 != nil:
    section.add "subscriptionId", valid_564180
  var valid_564181 = path.getOrDefault("resourceGroupName")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "resourceGroupName", valid_564181
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564182 = query.getOrDefault("api-version")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_564182 != nil:
    section.add "api-version", valid_564182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   applicationResourceDescription: JObject (required)
  ##                                 : Description for creating an application resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564184: Call_ApplicationCreate_564159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an application resource with the specified name and description. If an application with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## Use network resources to provide public connectivity to the services of an application.
  ## 
  ## 
  let valid = call_564184.validator(path, query, header, formData, body)
  let scheme = call_564184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564184.url(scheme.get, call_564184.host, call_564184.base,
                         call_564184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564184, url, valid)

proc call*(call_564185: Call_ApplicationCreate_564159; applicationName: string;
          applicationResourceDescription: JsonNode; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## applicationCreate
  ## Creates an application resource with the specified name and description. If an application with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## Use network resources to provide public connectivity to the services of an application.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   applicationResourceDescription: JObject (required)
  ##                                 : Description for creating an application resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564186 = newJObject()
  var query_564187 = newJObject()
  var body_564188 = newJObject()
  add(query_564187, "api-version", newJString(apiVersion))
  add(path_564186, "applicationName", newJString(applicationName))
  if applicationResourceDescription != nil:
    body_564188 = applicationResourceDescription
  add(path_564186, "subscriptionId", newJString(subscriptionId))
  add(path_564186, "resourceGroupName", newJString(resourceGroupName))
  result = call_564185.call(path_564186, query_564187, nil, nil, body_564188)

var applicationCreate* = Call_ApplicationCreate_564159(name: "applicationCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}",
    validator: validate_ApplicationCreate_564160, base: "",
    url: url_ApplicationCreate_564161, schemes: {Scheme.Https})
type
  Call_ApplicationGet_564148 = ref object of OpenApiRestCall_563564
proc url_ApplicationGet_564150(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationGet_564149(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets the information about the application resource with a given name. The information includes the information about the application's services and other runtime properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_564151 = path.getOrDefault("applicationName")
  valid_564151 = validateParameter(valid_564151, JString, required = true,
                                 default = nil)
  if valid_564151 != nil:
    section.add "applicationName", valid_564151
  var valid_564152 = path.getOrDefault("subscriptionId")
  valid_564152 = validateParameter(valid_564152, JString, required = true,
                                 default = nil)
  if valid_564152 != nil:
    section.add "subscriptionId", valid_564152
  var valid_564153 = path.getOrDefault("resourceGroupName")
  valid_564153 = validateParameter(valid_564153, JString, required = true,
                                 default = nil)
  if valid_564153 != nil:
    section.add "resourceGroupName", valid_564153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564154 = query.getOrDefault("api-version")
  valid_564154 = validateParameter(valid_564154, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_564154 != nil:
    section.add "api-version", valid_564154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564155: Call_ApplicationGet_564148; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the application resource with a given name. The information includes the information about the application's services and other runtime properties.
  ## 
  let valid = call_564155.validator(path, query, header, formData, body)
  let scheme = call_564155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564155.url(scheme.get, call_564155.host, call_564155.base,
                         call_564155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564155, url, valid)

proc call*(call_564156: Call_ApplicationGet_564148; applicationName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## applicationGet
  ## Gets the information about the application resource with a given name. The information includes the information about the application's services and other runtime properties.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564157 = newJObject()
  var query_564158 = newJObject()
  add(query_564158, "api-version", newJString(apiVersion))
  add(path_564157, "applicationName", newJString(applicationName))
  add(path_564157, "subscriptionId", newJString(subscriptionId))
  add(path_564157, "resourceGroupName", newJString(resourceGroupName))
  result = call_564156.call(path_564157, query_564158, nil, nil, nil)

var applicationGet* = Call_ApplicationGet_564148(name: "applicationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}",
    validator: validate_ApplicationGet_564149, base: "", url: url_ApplicationGet_564150,
    schemes: {Scheme.Https})
type
  Call_ApplicationDelete_564189 = ref object of OpenApiRestCall_563564
proc url_ApplicationDelete_564191(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ApplicationDelete_564190(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes the application resource identified by the name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_564192 = path.getOrDefault("applicationName")
  valid_564192 = validateParameter(valid_564192, JString, required = true,
                                 default = nil)
  if valid_564192 != nil:
    section.add "applicationName", valid_564192
  var valid_564193 = path.getOrDefault("subscriptionId")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = nil)
  if valid_564193 != nil:
    section.add "subscriptionId", valid_564193
  var valid_564194 = path.getOrDefault("resourceGroupName")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "resourceGroupName", valid_564194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564195 = query.getOrDefault("api-version")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_564195 != nil:
    section.add "api-version", valid_564195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564196: Call_ApplicationDelete_564189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the application resource identified by the name.
  ## 
  let valid = call_564196.validator(path, query, header, formData, body)
  let scheme = call_564196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564196.url(scheme.get, call_564196.host, call_564196.base,
                         call_564196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564196, url, valid)

proc call*(call_564197: Call_ApplicationDelete_564189; applicationName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## applicationDelete
  ## Deletes the application resource identified by the name.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564198 = newJObject()
  var query_564199 = newJObject()
  add(query_564199, "api-version", newJString(apiVersion))
  add(path_564198, "applicationName", newJString(applicationName))
  add(path_564198, "subscriptionId", newJString(subscriptionId))
  add(path_564198, "resourceGroupName", newJString(resourceGroupName))
  result = call_564197.call(path_564198, query_564199, nil, nil, nil)

var applicationDelete* = Call_ApplicationDelete_564189(name: "applicationDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}",
    validator: validate_ApplicationDelete_564190, base: "",
    url: url_ApplicationDelete_564191, schemes: {Scheme.Https})
type
  Call_ServiceListByApplicationName_564200 = ref object of OpenApiRestCall_563564
proc url_ServiceListByApplicationName_564202(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/services")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceListByApplicationName_564201(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all services of a given service of an application. The information includes the runtime properties of the service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `applicationName` field"
  var valid_564203 = path.getOrDefault("applicationName")
  valid_564203 = validateParameter(valid_564203, JString, required = true,
                                 default = nil)
  if valid_564203 != nil:
    section.add "applicationName", valid_564203
  var valid_564204 = path.getOrDefault("subscriptionId")
  valid_564204 = validateParameter(valid_564204, JString, required = true,
                                 default = nil)
  if valid_564204 != nil:
    section.add "subscriptionId", valid_564204
  var valid_564205 = path.getOrDefault("resourceGroupName")
  valid_564205 = validateParameter(valid_564205, JString, required = true,
                                 default = nil)
  if valid_564205 != nil:
    section.add "resourceGroupName", valid_564205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564206 = query.getOrDefault("api-version")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_564206 != nil:
    section.add "api-version", valid_564206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564207: Call_ServiceListByApplicationName_564200; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all services of a given service of an application. The information includes the runtime properties of the service instance.
  ## 
  let valid = call_564207.validator(path, query, header, formData, body)
  let scheme = call_564207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564207.url(scheme.get, call_564207.host, call_564207.base,
                         call_564207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564207, url, valid)

proc call*(call_564208: Call_ServiceListByApplicationName_564200;
          applicationName: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## serviceListByApplicationName
  ## Gets the information about all services of a given service of an application. The information includes the runtime properties of the service instance.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564209 = newJObject()
  var query_564210 = newJObject()
  add(query_564210, "api-version", newJString(apiVersion))
  add(path_564209, "applicationName", newJString(applicationName))
  add(path_564209, "subscriptionId", newJString(subscriptionId))
  add(path_564209, "resourceGroupName", newJString(resourceGroupName))
  result = call_564208.call(path_564209, query_564210, nil, nil, nil)

var serviceListByApplicationName* = Call_ServiceListByApplicationName_564200(
    name: "serviceListByApplicationName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}/services",
    validator: validate_ServiceListByApplicationName_564201, base: "",
    url: url_ServiceListByApplicationName_564202, schemes: {Scheme.Https})
type
  Call_ServiceGet_564211 = ref object of OpenApiRestCall_563564
proc url_ServiceGet_564213(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ServiceGet_564212(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation returns the properties of the service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The identity of the service.
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564214 = path.getOrDefault("serviceName")
  valid_564214 = validateParameter(valid_564214, JString, required = true,
                                 default = nil)
  if valid_564214 != nil:
    section.add "serviceName", valid_564214
  var valid_564215 = path.getOrDefault("applicationName")
  valid_564215 = validateParameter(valid_564215, JString, required = true,
                                 default = nil)
  if valid_564215 != nil:
    section.add "applicationName", valid_564215
  var valid_564216 = path.getOrDefault("subscriptionId")
  valid_564216 = validateParameter(valid_564216, JString, required = true,
                                 default = nil)
  if valid_564216 != nil:
    section.add "subscriptionId", valid_564216
  var valid_564217 = path.getOrDefault("resourceGroupName")
  valid_564217 = validateParameter(valid_564217, JString, required = true,
                                 default = nil)
  if valid_564217 != nil:
    section.add "resourceGroupName", valid_564217
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564218 = query.getOrDefault("api-version")
  valid_564218 = validateParameter(valid_564218, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_564218 != nil:
    section.add "api-version", valid_564218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564219: Call_ServiceGet_564211; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation returns the properties of the service.
  ## 
  let valid = call_564219.validator(path, query, header, formData, body)
  let scheme = call_564219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564219.url(scheme.get, call_564219.host, call_564219.base,
                         call_564219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564219, url, valid)

proc call*(call_564220: Call_ServiceGet_564211; serviceName: string;
          applicationName: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## serviceGet
  ## The operation returns the properties of the service.
  ##   serviceName: string (required)
  ##              : The identity of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564221 = newJObject()
  var query_564222 = newJObject()
  add(path_564221, "serviceName", newJString(serviceName))
  add(query_564222, "api-version", newJString(apiVersion))
  add(path_564221, "applicationName", newJString(applicationName))
  add(path_564221, "subscriptionId", newJString(subscriptionId))
  add(path_564221, "resourceGroupName", newJString(resourceGroupName))
  result = call_564220.call(path_564221, query_564222, nil, nil, nil)

var serviceGet* = Call_ServiceGet_564211(name: "serviceGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}/services/{serviceName}",
                                      validator: validate_ServiceGet_564212,
                                      base: "", url: url_ServiceGet_564213,
                                      schemes: {Scheme.Https})
type
  Call_ReplicaListByServiceName_564223 = ref object of OpenApiRestCall_563564
proc url_ReplicaListByServiceName_564225(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/replicas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicaListByServiceName_564224(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all replicas of a given service of an application. The information includes the runtime properties of the replica instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The identity of the service.
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564226 = path.getOrDefault("serviceName")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "serviceName", valid_564226
  var valid_564227 = path.getOrDefault("applicationName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "applicationName", valid_564227
  var valid_564228 = path.getOrDefault("subscriptionId")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "subscriptionId", valid_564228
  var valid_564229 = path.getOrDefault("resourceGroupName")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "resourceGroupName", valid_564229
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564230 = query.getOrDefault("api-version")
  valid_564230 = validateParameter(valid_564230, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_564230 != nil:
    section.add "api-version", valid_564230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564231: Call_ReplicaListByServiceName_564223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all replicas of a given service of an application. The information includes the runtime properties of the replica instance.
  ## 
  let valid = call_564231.validator(path, query, header, formData, body)
  let scheme = call_564231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564231.url(scheme.get, call_564231.host, call_564231.base,
                         call_564231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564231, url, valid)

proc call*(call_564232: Call_ReplicaListByServiceName_564223; serviceName: string;
          applicationName: string; subscriptionId: string;
          resourceGroupName: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## replicaListByServiceName
  ## Gets the information about all replicas of a given service of an application. The information includes the runtime properties of the replica instance.
  ##   serviceName: string (required)
  ##              : The identity of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564233 = newJObject()
  var query_564234 = newJObject()
  add(path_564233, "serviceName", newJString(serviceName))
  add(query_564234, "api-version", newJString(apiVersion))
  add(path_564233, "applicationName", newJString(applicationName))
  add(path_564233, "subscriptionId", newJString(subscriptionId))
  add(path_564233, "resourceGroupName", newJString(resourceGroupName))
  result = call_564232.call(path_564233, query_564234, nil, nil, nil)

var replicaListByServiceName* = Call_ReplicaListByServiceName_564223(
    name: "replicaListByServiceName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}/services/{serviceName}/replicas",
    validator: validate_ReplicaListByServiceName_564224, base: "",
    url: url_ReplicaListByServiceName_564225, schemes: {Scheme.Https})
type
  Call_ReplicaGet_564235 = ref object of OpenApiRestCall_563564
proc url_ReplicaGet_564237(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "replicaName" in path, "`replicaName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/replicas/"),
               (kind: VariableSegment, value: "replicaName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ReplicaGet_564236(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the specified replica of a given service of an application. The information includes the runtime properties of the replica instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The identity of the service.
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   replicaName: JString (required)
  ##              : The identity of the service replica.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564238 = path.getOrDefault("serviceName")
  valid_564238 = validateParameter(valid_564238, JString, required = true,
                                 default = nil)
  if valid_564238 != nil:
    section.add "serviceName", valid_564238
  var valid_564239 = path.getOrDefault("applicationName")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "applicationName", valid_564239
  var valid_564240 = path.getOrDefault("subscriptionId")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "subscriptionId", valid_564240
  var valid_564241 = path.getOrDefault("resourceGroupName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "resourceGroupName", valid_564241
  var valid_564242 = path.getOrDefault("replicaName")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "replicaName", valid_564242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564243 = query.getOrDefault("api-version")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_564243 != nil:
    section.add "api-version", valid_564243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564244: Call_ReplicaGet_564235; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the specified replica of a given service of an application. The information includes the runtime properties of the replica instance.
  ## 
  let valid = call_564244.validator(path, query, header, formData, body)
  let scheme = call_564244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564244.url(scheme.get, call_564244.host, call_564244.base,
                         call_564244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564244, url, valid)

proc call*(call_564245: Call_ReplicaGet_564235; serviceName: string;
          applicationName: string; subscriptionId: string;
          resourceGroupName: string; replicaName: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## replicaGet
  ## Gets the information about the specified replica of a given service of an application. The information includes the runtime properties of the replica instance.
  ##   serviceName: string (required)
  ##              : The identity of the service.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   replicaName: string (required)
  ##              : The identity of the service replica.
  var path_564246 = newJObject()
  var query_564247 = newJObject()
  add(path_564246, "serviceName", newJString(serviceName))
  add(query_564247, "api-version", newJString(apiVersion))
  add(path_564246, "applicationName", newJString(applicationName))
  add(path_564246, "subscriptionId", newJString(subscriptionId))
  add(path_564246, "resourceGroupName", newJString(resourceGroupName))
  add(path_564246, "replicaName", newJString(replicaName))
  result = call_564245.call(path_564246, query_564247, nil, nil, nil)

var replicaGet* = Call_ReplicaGet_564235(name: "replicaGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}/services/{serviceName}/replicas/{replicaName}",
                                      validator: validate_ReplicaGet_564236,
                                      base: "", url: url_ReplicaGet_564237,
                                      schemes: {Scheme.Https})
type
  Call_CodePackageGetContainerLog_564248 = ref object of OpenApiRestCall_563564
proc url_CodePackageGetContainerLog_564250(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "applicationName" in path, "`applicationName` is a required path parameter"
  assert "serviceName" in path, "`serviceName` is a required path parameter"
  assert "replicaName" in path, "`replicaName` is a required path parameter"
  assert "codePackageName" in path, "`codePackageName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/applications/"),
               (kind: VariableSegment, value: "applicationName"),
               (kind: ConstantSegment, value: "/services/"),
               (kind: VariableSegment, value: "serviceName"),
               (kind: ConstantSegment, value: "/replicas/"),
               (kind: VariableSegment, value: "replicaName"),
               (kind: ConstantSegment, value: "/codePackages/"),
               (kind: VariableSegment, value: "codePackageName"),
               (kind: ConstantSegment, value: "/logs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CodePackageGetContainerLog_564249(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the logs for the container of a given code package of an application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   serviceName: JString (required)
  ##              : The identity of the service.
  ##   codePackageName: JString (required)
  ##                  : The name of the code package.
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   replicaName: JString (required)
  ##              : The identity of the service replica.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `serviceName` field"
  var valid_564251 = path.getOrDefault("serviceName")
  valid_564251 = validateParameter(valid_564251, JString, required = true,
                                 default = nil)
  if valid_564251 != nil:
    section.add "serviceName", valid_564251
  var valid_564252 = path.getOrDefault("codePackageName")
  valid_564252 = validateParameter(valid_564252, JString, required = true,
                                 default = nil)
  if valid_564252 != nil:
    section.add "codePackageName", valid_564252
  var valid_564253 = path.getOrDefault("applicationName")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = nil)
  if valid_564253 != nil:
    section.add "applicationName", valid_564253
  var valid_564254 = path.getOrDefault("subscriptionId")
  valid_564254 = validateParameter(valid_564254, JString, required = true,
                                 default = nil)
  if valid_564254 != nil:
    section.add "subscriptionId", valid_564254
  var valid_564255 = path.getOrDefault("resourceGroupName")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "resourceGroupName", valid_564255
  var valid_564256 = path.getOrDefault("replicaName")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "replicaName", valid_564256
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   tail: JInt
  ##       : Number of lines to show from the end of the logs. Default is 100.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564257 = query.getOrDefault("api-version")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_564257 != nil:
    section.add "api-version", valid_564257
  var valid_564258 = query.getOrDefault("tail")
  valid_564258 = validateParameter(valid_564258, JInt, required = false, default = nil)
  if valid_564258 != nil:
    section.add "tail", valid_564258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564259: Call_CodePackageGetContainerLog_564248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the logs for the container of a given code package of an application.
  ## 
  let valid = call_564259.validator(path, query, header, formData, body)
  let scheme = call_564259.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564259.url(scheme.get, call_564259.host, call_564259.base,
                         call_564259.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564259, url, valid)

proc call*(call_564260: Call_CodePackageGetContainerLog_564248;
          serviceName: string; codePackageName: string; applicationName: string;
          subscriptionId: string; resourceGroupName: string; replicaName: string;
          apiVersion: string = "2018-07-01-preview"; tail: int = 0): Recallable =
  ## codePackageGetContainerLog
  ## Get the logs for the container of a given code package of an application.
  ##   serviceName: string (required)
  ##              : The identity of the service.
  ##   codePackageName: string (required)
  ##                  : The name of the code package.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   tail: int
  ##       : Number of lines to show from the end of the logs. Default is 100.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   replicaName: string (required)
  ##              : The identity of the service replica.
  var path_564261 = newJObject()
  var query_564262 = newJObject()
  add(path_564261, "serviceName", newJString(serviceName))
  add(path_564261, "codePackageName", newJString(codePackageName))
  add(query_564262, "api-version", newJString(apiVersion))
  add(path_564261, "applicationName", newJString(applicationName))
  add(path_564261, "subscriptionId", newJString(subscriptionId))
  add(query_564262, "tail", newJInt(tail))
  add(path_564261, "resourceGroupName", newJString(resourceGroupName))
  add(path_564261, "replicaName", newJString(replicaName))
  result = call_564260.call(path_564261, query_564262, nil, nil, nil)

var codePackageGetContainerLog* = Call_CodePackageGetContainerLog_564248(
    name: "codePackageGetContainerLog", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}/services/{serviceName}/replicas/{replicaName}/codePackages/{codePackageName}/logs",
    validator: validate_CodePackageGetContainerLog_564249, base: "",
    url: url_CodePackageGetContainerLog_564250, schemes: {Scheme.Https})
type
  Call_NetworkListByResourceGroup_564263 = ref object of OpenApiRestCall_563564
proc url_NetworkListByResourceGroup_564265(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/networks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkListByResourceGroup_564264(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all network resources in a given resource group. The information includes the network description and other runtime properties.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564266 = path.getOrDefault("subscriptionId")
  valid_564266 = validateParameter(valid_564266, JString, required = true,
                                 default = nil)
  if valid_564266 != nil:
    section.add "subscriptionId", valid_564266
  var valid_564267 = path.getOrDefault("resourceGroupName")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = nil)
  if valid_564267 != nil:
    section.add "resourceGroupName", valid_564267
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564268 = query.getOrDefault("api-version")
  valid_564268 = validateParameter(valid_564268, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_564268 != nil:
    section.add "api-version", valid_564268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564269: Call_NetworkListByResourceGroup_564263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all network resources in a given resource group. The information includes the network description and other runtime properties.
  ## 
  ## 
  let valid = call_564269.validator(path, query, header, formData, body)
  let scheme = call_564269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564269.url(scheme.get, call_564269.host, call_564269.base,
                         call_564269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564269, url, valid)

proc call*(call_564270: Call_NetworkListByResourceGroup_564263;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## networkListByResourceGroup
  ## Gets the information about all network resources in a given resource group. The information includes the network description and other runtime properties.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564271 = newJObject()
  var query_564272 = newJObject()
  add(query_564272, "api-version", newJString(apiVersion))
  add(path_564271, "subscriptionId", newJString(subscriptionId))
  add(path_564271, "resourceGroupName", newJString(resourceGroupName))
  result = call_564270.call(path_564271, query_564272, nil, nil, nil)

var networkListByResourceGroup* = Call_NetworkListByResourceGroup_564263(
    name: "networkListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks",
    validator: validate_NetworkListByResourceGroup_564264, base: "",
    url: url_NetworkListByResourceGroup_564265, schemes: {Scheme.Https})
type
  Call_NetworkCreate_564284 = ref object of OpenApiRestCall_563564
proc url_NetworkCreate_564286(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkName" in path, "`networkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/networks/"),
               (kind: VariableSegment, value: "networkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkCreate_564285(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a network resource with the specified name and description. If a network with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## Use network resources to create private network and configure public connectivity for services within your application. 
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkName: JString (required)
  ##              : The identity of the network.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkName` field"
  var valid_564287 = path.getOrDefault("networkName")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "networkName", valid_564287
  var valid_564288 = path.getOrDefault("subscriptionId")
  valid_564288 = validateParameter(valid_564288, JString, required = true,
                                 default = nil)
  if valid_564288 != nil:
    section.add "subscriptionId", valid_564288
  var valid_564289 = path.getOrDefault("resourceGroupName")
  valid_564289 = validateParameter(valid_564289, JString, required = true,
                                 default = nil)
  if valid_564289 != nil:
    section.add "resourceGroupName", valid_564289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564290 = query.getOrDefault("api-version")
  valid_564290 = validateParameter(valid_564290, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_564290 != nil:
    section.add "api-version", valid_564290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   networkResourceDescription: JObject (required)
  ##                             : Description for creating a network resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564292: Call_NetworkCreate_564284; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a network resource with the specified name and description. If a network with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## Use network resources to create private network and configure public connectivity for services within your application. 
  ## 
  ## 
  let valid = call_564292.validator(path, query, header, formData, body)
  let scheme = call_564292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564292.url(scheme.get, call_564292.host, call_564292.base,
                         call_564292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564292, url, valid)

proc call*(call_564293: Call_NetworkCreate_564284;
          networkResourceDescription: JsonNode; networkName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## networkCreate
  ## Creates a network resource with the specified name and description. If a network with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## Use network resources to create private network and configure public connectivity for services within your application. 
  ## 
  ##   networkResourceDescription: JObject (required)
  ##                             : Description for creating a network resource.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   networkName: string (required)
  ##              : The identity of the network.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564294 = newJObject()
  var query_564295 = newJObject()
  var body_564296 = newJObject()
  if networkResourceDescription != nil:
    body_564296 = networkResourceDescription
  add(query_564295, "api-version", newJString(apiVersion))
  add(path_564294, "networkName", newJString(networkName))
  add(path_564294, "subscriptionId", newJString(subscriptionId))
  add(path_564294, "resourceGroupName", newJString(resourceGroupName))
  result = call_564293.call(path_564294, query_564295, nil, nil, body_564296)

var networkCreate* = Call_NetworkCreate_564284(name: "networkCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks/{networkName}",
    validator: validate_NetworkCreate_564285, base: "", url: url_NetworkCreate_564286,
    schemes: {Scheme.Https})
type
  Call_NetworkGet_564273 = ref object of OpenApiRestCall_563564
proc url_NetworkGet_564275(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkName" in path, "`networkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/networks/"),
               (kind: VariableSegment, value: "networkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkGet_564274(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the network resource with a given name. This information includes the network description and other runtime information.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkName: JString (required)
  ##              : The identity of the network.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkName` field"
  var valid_564276 = path.getOrDefault("networkName")
  valid_564276 = validateParameter(valid_564276, JString, required = true,
                                 default = nil)
  if valid_564276 != nil:
    section.add "networkName", valid_564276
  var valid_564277 = path.getOrDefault("subscriptionId")
  valid_564277 = validateParameter(valid_564277, JString, required = true,
                                 default = nil)
  if valid_564277 != nil:
    section.add "subscriptionId", valid_564277
  var valid_564278 = path.getOrDefault("resourceGroupName")
  valid_564278 = validateParameter(valid_564278, JString, required = true,
                                 default = nil)
  if valid_564278 != nil:
    section.add "resourceGroupName", valid_564278
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564279 = query.getOrDefault("api-version")
  valid_564279 = validateParameter(valid_564279, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_564279 != nil:
    section.add "api-version", valid_564279
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564280: Call_NetworkGet_564273; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the network resource with a given name. This information includes the network description and other runtime information.
  ## 
  ## 
  let valid = call_564280.validator(path, query, header, formData, body)
  let scheme = call_564280.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564280.url(scheme.get, call_564280.host, call_564280.base,
                         call_564280.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564280, url, valid)

proc call*(call_564281: Call_NetworkGet_564273; networkName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## networkGet
  ## Gets the information about the network resource with a given name. This information includes the network description and other runtime information.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   networkName: string (required)
  ##              : The identity of the network.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564282 = newJObject()
  var query_564283 = newJObject()
  add(query_564283, "api-version", newJString(apiVersion))
  add(path_564282, "networkName", newJString(networkName))
  add(path_564282, "subscriptionId", newJString(subscriptionId))
  add(path_564282, "resourceGroupName", newJString(resourceGroupName))
  result = call_564281.call(path_564282, query_564283, nil, nil, nil)

var networkGet* = Call_NetworkGet_564273(name: "networkGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks/{networkName}",
                                      validator: validate_NetworkGet_564274,
                                      base: "", url: url_NetworkGet_564275,
                                      schemes: {Scheme.Https})
type
  Call_NetworkDelete_564297 = ref object of OpenApiRestCall_563564
proc url_NetworkDelete_564299(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "networkName" in path, "`networkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/networks/"),
               (kind: VariableSegment, value: "networkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_NetworkDelete_564298(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the network resource identified by the name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   networkName: JString (required)
  ##              : The identity of the network.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `networkName` field"
  var valid_564300 = path.getOrDefault("networkName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "networkName", valid_564300
  var valid_564301 = path.getOrDefault("subscriptionId")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "subscriptionId", valid_564301
  var valid_564302 = path.getOrDefault("resourceGroupName")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "resourceGroupName", valid_564302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564303 = query.getOrDefault("api-version")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_564303 != nil:
    section.add "api-version", valid_564303
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564304: Call_NetworkDelete_564297; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the network resource identified by the name.
  ## 
  let valid = call_564304.validator(path, query, header, formData, body)
  let scheme = call_564304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564304.url(scheme.get, call_564304.host, call_564304.base,
                         call_564304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564304, url, valid)

proc call*(call_564305: Call_NetworkDelete_564297; networkName: string;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## networkDelete
  ## Deletes the network resource identified by the name.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   networkName: string (required)
  ##              : The identity of the network.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564306 = newJObject()
  var query_564307 = newJObject()
  add(query_564307, "api-version", newJString(apiVersion))
  add(path_564306, "networkName", newJString(networkName))
  add(path_564306, "subscriptionId", newJString(subscriptionId))
  add(path_564306, "resourceGroupName", newJString(resourceGroupName))
  result = call_564305.call(path_564306, query_564307, nil, nil, nil)

var networkDelete* = Call_NetworkDelete_564297(name: "networkDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks/{networkName}",
    validator: validate_NetworkDelete_564298, base: "", url: url_NetworkDelete_564299,
    schemes: {Scheme.Https})
type
  Call_VolumeListByResourceGroup_564308 = ref object of OpenApiRestCall_563564
proc url_VolumeListByResourceGroup_564310(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/volumes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeListByResourceGroup_564309(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all volume resources in a given resource group. The information includes the volume description and other runtime information.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564311 = path.getOrDefault("subscriptionId")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = nil)
  if valid_564311 != nil:
    section.add "subscriptionId", valid_564311
  var valid_564312 = path.getOrDefault("resourceGroupName")
  valid_564312 = validateParameter(valid_564312, JString, required = true,
                                 default = nil)
  if valid_564312 != nil:
    section.add "resourceGroupName", valid_564312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564313 = query.getOrDefault("api-version")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_564313 != nil:
    section.add "api-version", valid_564313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564314: Call_VolumeListByResourceGroup_564308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all volume resources in a given resource group. The information includes the volume description and other runtime information.
  ## 
  ## 
  let valid = call_564314.validator(path, query, header, formData, body)
  let scheme = call_564314.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564314.url(scheme.get, call_564314.host, call_564314.base,
                         call_564314.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564314, url, valid)

proc call*(call_564315: Call_VolumeListByResourceGroup_564308;
          subscriptionId: string; resourceGroupName: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## volumeListByResourceGroup
  ## Gets the information about all volume resources in a given resource group. The information includes the volume description and other runtime information.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564316 = newJObject()
  var query_564317 = newJObject()
  add(query_564317, "api-version", newJString(apiVersion))
  add(path_564316, "subscriptionId", newJString(subscriptionId))
  add(path_564316, "resourceGroupName", newJString(resourceGroupName))
  result = call_564315.call(path_564316, query_564317, nil, nil, nil)

var volumeListByResourceGroup* = Call_VolumeListByResourceGroup_564308(
    name: "volumeListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes",
    validator: validate_VolumeListByResourceGroup_564309, base: "",
    url: url_VolumeListByResourceGroup_564310, schemes: {Scheme.Https})
type
  Call_VolumeCreate_564329 = ref object of OpenApiRestCall_563564
proc url_VolumeCreate_564331(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/volumes/"),
               (kind: VariableSegment, value: "volumeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeCreate_564330(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a volume resource with the specified name and description. If a volume with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   volumeName: JString (required)
  ##             : The identity of the volume.
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564332 = path.getOrDefault("subscriptionId")
  valid_564332 = validateParameter(valid_564332, JString, required = true,
                                 default = nil)
  if valid_564332 != nil:
    section.add "subscriptionId", valid_564332
  var valid_564333 = path.getOrDefault("volumeName")
  valid_564333 = validateParameter(valid_564333, JString, required = true,
                                 default = nil)
  if valid_564333 != nil:
    section.add "volumeName", valid_564333
  var valid_564334 = path.getOrDefault("resourceGroupName")
  valid_564334 = validateParameter(valid_564334, JString, required = true,
                                 default = nil)
  if valid_564334 != nil:
    section.add "resourceGroupName", valid_564334
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564335 = query.getOrDefault("api-version")
  valid_564335 = validateParameter(valid_564335, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_564335 != nil:
    section.add "api-version", valid_564335
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   volumeResourceDescription: JObject (required)
  ##                            : Description for creating a volume resource.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564337: Call_VolumeCreate_564329; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a volume resource with the specified name and description. If a volume with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## 
  let valid = call_564337.validator(path, query, header, formData, body)
  let scheme = call_564337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564337.url(scheme.get, call_564337.host, call_564337.base,
                         call_564337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564337, url, valid)

proc call*(call_564338: Call_VolumeCreate_564329;
          volumeResourceDescription: JsonNode; subscriptionId: string;
          volumeName: string; resourceGroupName: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## volumeCreate
  ## Creates a volume resource with the specified name and description. If a volume with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   volumeResourceDescription: JObject (required)
  ##                            : Description for creating a volume resource.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   volumeName: string (required)
  ##             : The identity of the volume.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564339 = newJObject()
  var query_564340 = newJObject()
  var body_564341 = newJObject()
  add(query_564340, "api-version", newJString(apiVersion))
  if volumeResourceDescription != nil:
    body_564341 = volumeResourceDescription
  add(path_564339, "subscriptionId", newJString(subscriptionId))
  add(path_564339, "volumeName", newJString(volumeName))
  add(path_564339, "resourceGroupName", newJString(resourceGroupName))
  result = call_564338.call(path_564339, query_564340, nil, nil, body_564341)

var volumeCreate* = Call_VolumeCreate_564329(name: "volumeCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes/{volumeName}",
    validator: validate_VolumeCreate_564330, base: "", url: url_VolumeCreate_564331,
    schemes: {Scheme.Https})
type
  Call_VolumeGet_564318 = ref object of OpenApiRestCall_563564
proc url_VolumeGet_564320(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/volumes/"),
               (kind: VariableSegment, value: "volumeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeGet_564319(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the volume resource with a given name. This information includes the volume description and other runtime information.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   volumeName: JString (required)
  ##             : The identity of the volume.
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564321 = path.getOrDefault("subscriptionId")
  valid_564321 = validateParameter(valid_564321, JString, required = true,
                                 default = nil)
  if valid_564321 != nil:
    section.add "subscriptionId", valid_564321
  var valid_564322 = path.getOrDefault("volumeName")
  valid_564322 = validateParameter(valid_564322, JString, required = true,
                                 default = nil)
  if valid_564322 != nil:
    section.add "volumeName", valid_564322
  var valid_564323 = path.getOrDefault("resourceGroupName")
  valid_564323 = validateParameter(valid_564323, JString, required = true,
                                 default = nil)
  if valid_564323 != nil:
    section.add "resourceGroupName", valid_564323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564324 = query.getOrDefault("api-version")
  valid_564324 = validateParameter(valid_564324, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_564324 != nil:
    section.add "api-version", valid_564324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564325: Call_VolumeGet_564318; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the volume resource with a given name. This information includes the volume description and other runtime information.
  ## 
  ## 
  let valid = call_564325.validator(path, query, header, formData, body)
  let scheme = call_564325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564325.url(scheme.get, call_564325.host, call_564325.base,
                         call_564325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564325, url, valid)

proc call*(call_564326: Call_VolumeGet_564318; subscriptionId: string;
          volumeName: string; resourceGroupName: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## volumeGet
  ## Gets the information about the volume resource with a given name. This information includes the volume description and other runtime information.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   volumeName: string (required)
  ##             : The identity of the volume.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564327 = newJObject()
  var query_564328 = newJObject()
  add(query_564328, "api-version", newJString(apiVersion))
  add(path_564327, "subscriptionId", newJString(subscriptionId))
  add(path_564327, "volumeName", newJString(volumeName))
  add(path_564327, "resourceGroupName", newJString(resourceGroupName))
  result = call_564326.call(path_564327, query_564328, nil, nil, nil)

var volumeGet* = Call_VolumeGet_564318(name: "volumeGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes/{volumeName}",
                                    validator: validate_VolumeGet_564319,
                                    base: "", url: url_VolumeGet_564320,
                                    schemes: {Scheme.Https})
type
  Call_VolumeDelete_564342 = ref object of OpenApiRestCall_563564
proc url_VolumeDelete_564344(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "volumeName" in path, "`volumeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ServiceFabricMesh/volumes/"),
               (kind: VariableSegment, value: "volumeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_VolumeDelete_564343(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the volume identified by the name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   volumeName: JString (required)
  ##             : The identity of the volume.
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564345 = path.getOrDefault("subscriptionId")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "subscriptionId", valid_564345
  var valid_564346 = path.getOrDefault("volumeName")
  valid_564346 = validateParameter(valid_564346, JString, required = true,
                                 default = nil)
  if valid_564346 != nil:
    section.add "volumeName", valid_564346
  var valid_564347 = path.getOrDefault("resourceGroupName")
  valid_564347 = validateParameter(valid_564347, JString, required = true,
                                 default = nil)
  if valid_564347 != nil:
    section.add "resourceGroupName", valid_564347
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564348 = query.getOrDefault("api-version")
  valid_564348 = validateParameter(valid_564348, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_564348 != nil:
    section.add "api-version", valid_564348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564349: Call_VolumeDelete_564342; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the volume identified by the name.
  ## 
  let valid = call_564349.validator(path, query, header, formData, body)
  let scheme = call_564349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564349.url(scheme.get, call_564349.host, call_564349.base,
                         call_564349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564349, url, valid)

proc call*(call_564350: Call_VolumeDelete_564342; subscriptionId: string;
          volumeName: string; resourceGroupName: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## volumeDelete
  ## Deletes the volume identified by the name.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   volumeName: string (required)
  ##             : The identity of the volume.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  var path_564351 = newJObject()
  var query_564352 = newJObject()
  add(query_564352, "api-version", newJString(apiVersion))
  add(path_564351, "subscriptionId", newJString(subscriptionId))
  add(path_564351, "volumeName", newJString(volumeName))
  add(path_564351, "resourceGroupName", newJString(resourceGroupName))
  result = call_564350.call(path_564351, query_564352, nil, nil, nil)

var volumeDelete* = Call_VolumeDelete_564342(name: "volumeDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes/{volumeName}",
    validator: validate_VolumeDelete_564343, base: "", url: url_VolumeDelete_564344,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
