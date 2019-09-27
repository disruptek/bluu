
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  macServiceName = "servicefabricmesh"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593659 = ref object of OpenApiRestCall_593437
proc url_OperationsList_593661(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593660(path: JsonNode; query: JsonNode;
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
  var valid_593833 = query.getOrDefault("api-version")
  valid_593833 = validateParameter(valid_593833, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_593833 != nil:
    section.add "api-version", valid_593833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593856: Call_OperationsList_593659; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all the available operations provided by Service Fabric SeaBreeze resource provider.
  ## 
  let valid = call_593856.validator(path, query, header, formData, body)
  let scheme = call_593856.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593856.url(scheme.get, call_593856.host, call_593856.base,
                         call_593856.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593856, url, valid)

proc call*(call_593927: Call_OperationsList_593659;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## operationsList
  ## Lists all the available operations provided by Service Fabric SeaBreeze resource provider.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  var query_593928 = newJObject()
  add(query_593928, "api-version", newJString(apiVersion))
  result = call_593927.call(nil, query_593928, nil, nil, nil)

var operationsList* = Call_OperationsList_593659(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ServiceFabricMesh/operations",
    validator: validate_OperationsList_593660, base: "", url: url_OperationsList_593661,
    schemes: {Scheme.Https})
type
  Call_ApplicationListBySubscription_593968 = ref object of OpenApiRestCall_593437
proc url_ApplicationListBySubscription_593970(protocol: Scheme; host: string;
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

proc validate_ApplicationListBySubscription_593969(path: JsonNode; query: JsonNode;
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
  var valid_593985 = path.getOrDefault("subscriptionId")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "subscriptionId", valid_593985
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593986 = query.getOrDefault("api-version")
  valid_593986 = validateParameter(valid_593986, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_593986 != nil:
    section.add "api-version", valid_593986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593987: Call_ApplicationListBySubscription_593968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all application resources in a given subscription. The information includes the information about the application's services and other runtime properties.
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_ApplicationListBySubscription_593968;
          subscriptionId: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## applicationListBySubscription
  ## Gets the information about all application resources in a given subscription. The information includes the information about the application's services and other runtime properties.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_593989 = newJObject()
  var query_593990 = newJObject()
  add(query_593990, "api-version", newJString(apiVersion))
  add(path_593989, "subscriptionId", newJString(subscriptionId))
  result = call_593988.call(path_593989, query_593990, nil, nil, nil)

var applicationListBySubscription* = Call_ApplicationListBySubscription_593968(
    name: "applicationListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/applications",
    validator: validate_ApplicationListBySubscription_593969, base: "",
    url: url_ApplicationListBySubscription_593970, schemes: {Scheme.Https})
type
  Call_NetworkListBySubscription_593991 = ref object of OpenApiRestCall_593437
proc url_NetworkListBySubscription_593993(protocol: Scheme; host: string;
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

proc validate_NetworkListBySubscription_593992(path: JsonNode; query: JsonNode;
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
  var valid_593994 = path.getOrDefault("subscriptionId")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "subscriptionId", valid_593994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593995 = query.getOrDefault("api-version")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_593995 != nil:
    section.add "api-version", valid_593995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593996: Call_NetworkListBySubscription_593991; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all network resources in a given subscription. The information includes the network description and other runtime properties.
  ## 
  let valid = call_593996.validator(path, query, header, formData, body)
  let scheme = call_593996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593996.url(scheme.get, call_593996.host, call_593996.base,
                         call_593996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593996, url, valid)

proc call*(call_593997: Call_NetworkListBySubscription_593991;
          subscriptionId: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## networkListBySubscription
  ## Gets the information about all network resources in a given subscription. The information includes the network description and other runtime properties.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_593998 = newJObject()
  var query_593999 = newJObject()
  add(query_593999, "api-version", newJString(apiVersion))
  add(path_593998, "subscriptionId", newJString(subscriptionId))
  result = call_593997.call(path_593998, query_593999, nil, nil, nil)

var networkListBySubscription* = Call_NetworkListBySubscription_593991(
    name: "networkListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/networks",
    validator: validate_NetworkListBySubscription_593992, base: "",
    url: url_NetworkListBySubscription_593993, schemes: {Scheme.Https})
type
  Call_VolumeListBySubscription_594000 = ref object of OpenApiRestCall_593437
proc url_VolumeListBySubscription_594002(protocol: Scheme; host: string;
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

proc validate_VolumeListBySubscription_594001(path: JsonNode; query: JsonNode;
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
  var valid_594003 = path.getOrDefault("subscriptionId")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "subscriptionId", valid_594003
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594004 = query.getOrDefault("api-version")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_594004 != nil:
    section.add "api-version", valid_594004
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594005: Call_VolumeListBySubscription_594000; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all volume resources in a given subscription. The information includes the volume description and other runtime information.
  ## 
  ## 
  let valid = call_594005.validator(path, query, header, formData, body)
  let scheme = call_594005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594005.url(scheme.get, call_594005.host, call_594005.base,
                         call_594005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594005, url, valid)

proc call*(call_594006: Call_VolumeListBySubscription_594000;
          subscriptionId: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## volumeListBySubscription
  ## Gets the information about all volume resources in a given subscription. The information includes the volume description and other runtime information.
  ## 
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_594007 = newJObject()
  var query_594008 = newJObject()
  add(query_594008, "api-version", newJString(apiVersion))
  add(path_594007, "subscriptionId", newJString(subscriptionId))
  result = call_594006.call(path_594007, query_594008, nil, nil, nil)

var volumeListBySubscription* = Call_VolumeListBySubscription_594000(
    name: "volumeListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ServiceFabricMesh/volumes",
    validator: validate_VolumeListBySubscription_594001, base: "",
    url: url_VolumeListBySubscription_594002, schemes: {Scheme.Https})
type
  Call_ApplicationListByResourceGroup_594009 = ref object of OpenApiRestCall_593437
proc url_ApplicationListByResourceGroup_594011(protocol: Scheme; host: string;
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

proc validate_ApplicationListByResourceGroup_594010(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all application resources in a given resource group. The information includes the information about the application's services and other runtime properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594012 = path.getOrDefault("resourceGroupName")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "resourceGroupName", valid_594012
  var valid_594013 = path.getOrDefault("subscriptionId")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "subscriptionId", valid_594013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594014 = query.getOrDefault("api-version")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_594014 != nil:
    section.add "api-version", valid_594014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_ApplicationListByResourceGroup_594009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all application resources in a given resource group. The information includes the information about the application's services and other runtime properties.
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_ApplicationListByResourceGroup_594009;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## applicationListByResourceGroup
  ## Gets the information about all application resources in a given resource group. The information includes the information about the application's services and other runtime properties.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  add(path_594017, "resourceGroupName", newJString(resourceGroupName))
  add(query_594018, "api-version", newJString(apiVersion))
  add(path_594017, "subscriptionId", newJString(subscriptionId))
  result = call_594016.call(path_594017, query_594018, nil, nil, nil)

var applicationListByResourceGroup* = Call_ApplicationListByResourceGroup_594009(
    name: "applicationListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications",
    validator: validate_ApplicationListByResourceGroup_594010, base: "",
    url: url_ApplicationListByResourceGroup_594011, schemes: {Scheme.Https})
type
  Call_ApplicationCreate_594030 = ref object of OpenApiRestCall_593437
proc url_ApplicationCreate_594032(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationCreate_594031(path: JsonNode; query: JsonNode;
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
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594050 = path.getOrDefault("resourceGroupName")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "resourceGroupName", valid_594050
  var valid_594051 = path.getOrDefault("applicationName")
  valid_594051 = validateParameter(valid_594051, JString, required = true,
                                 default = nil)
  if valid_594051 != nil:
    section.add "applicationName", valid_594051
  var valid_594052 = path.getOrDefault("subscriptionId")
  valid_594052 = validateParameter(valid_594052, JString, required = true,
                                 default = nil)
  if valid_594052 != nil:
    section.add "subscriptionId", valid_594052
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594053 = query.getOrDefault("api-version")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_594053 != nil:
    section.add "api-version", valid_594053
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

proc call*(call_594055: Call_ApplicationCreate_594030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an application resource with the specified name and description. If an application with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## Use network resources to provide public connectivity to the services of an application.
  ## 
  ## 
  let valid = call_594055.validator(path, query, header, formData, body)
  let scheme = call_594055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594055.url(scheme.get, call_594055.host, call_594055.base,
                         call_594055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594055, url, valid)

proc call*(call_594056: Call_ApplicationCreate_594030;
          applicationResourceDescription: JsonNode; resourceGroupName: string;
          applicationName: string; subscriptionId: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## applicationCreate
  ## Creates an application resource with the specified name and description. If an application with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## Use network resources to provide public connectivity to the services of an application.
  ## 
  ##   applicationResourceDescription: JObject (required)
  ##                                 : Description for creating an application resource.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_594057 = newJObject()
  var query_594058 = newJObject()
  var body_594059 = newJObject()
  if applicationResourceDescription != nil:
    body_594059 = applicationResourceDescription
  add(path_594057, "resourceGroupName", newJString(resourceGroupName))
  add(query_594058, "api-version", newJString(apiVersion))
  add(path_594057, "applicationName", newJString(applicationName))
  add(path_594057, "subscriptionId", newJString(subscriptionId))
  result = call_594056.call(path_594057, query_594058, nil, nil, body_594059)

var applicationCreate* = Call_ApplicationCreate_594030(name: "applicationCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}",
    validator: validate_ApplicationCreate_594031, base: "",
    url: url_ApplicationCreate_594032, schemes: {Scheme.Https})
type
  Call_ApplicationGet_594019 = ref object of OpenApiRestCall_593437
proc url_ApplicationGet_594021(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationGet_594020(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Gets the information about the application resource with a given name. The information includes the information about the application's services and other runtime properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594022 = path.getOrDefault("resourceGroupName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "resourceGroupName", valid_594022
  var valid_594023 = path.getOrDefault("applicationName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "applicationName", valid_594023
  var valid_594024 = path.getOrDefault("subscriptionId")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "subscriptionId", valid_594024
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594025 = query.getOrDefault("api-version")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_594025 != nil:
    section.add "api-version", valid_594025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594026: Call_ApplicationGet_594019; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the application resource with a given name. The information includes the information about the application's services and other runtime properties.
  ## 
  let valid = call_594026.validator(path, query, header, formData, body)
  let scheme = call_594026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594026.url(scheme.get, call_594026.host, call_594026.base,
                         call_594026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594026, url, valid)

proc call*(call_594027: Call_ApplicationGet_594019; resourceGroupName: string;
          applicationName: string; subscriptionId: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## applicationGet
  ## Gets the information about the application resource with a given name. The information includes the information about the application's services and other runtime properties.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_594028 = newJObject()
  var query_594029 = newJObject()
  add(path_594028, "resourceGroupName", newJString(resourceGroupName))
  add(query_594029, "api-version", newJString(apiVersion))
  add(path_594028, "applicationName", newJString(applicationName))
  add(path_594028, "subscriptionId", newJString(subscriptionId))
  result = call_594027.call(path_594028, query_594029, nil, nil, nil)

var applicationGet* = Call_ApplicationGet_594019(name: "applicationGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}",
    validator: validate_ApplicationGet_594020, base: "", url: url_ApplicationGet_594021,
    schemes: {Scheme.Https})
type
  Call_ApplicationDelete_594060 = ref object of OpenApiRestCall_593437
proc url_ApplicationDelete_594062(protocol: Scheme; host: string; base: string;
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

proc validate_ApplicationDelete_594061(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Deletes the application resource identified by the name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594063 = path.getOrDefault("resourceGroupName")
  valid_594063 = validateParameter(valid_594063, JString, required = true,
                                 default = nil)
  if valid_594063 != nil:
    section.add "resourceGroupName", valid_594063
  var valid_594064 = path.getOrDefault("applicationName")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "applicationName", valid_594064
  var valid_594065 = path.getOrDefault("subscriptionId")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "subscriptionId", valid_594065
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594066 = query.getOrDefault("api-version")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_594066 != nil:
    section.add "api-version", valid_594066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594067: Call_ApplicationDelete_594060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the application resource identified by the name.
  ## 
  let valid = call_594067.validator(path, query, header, formData, body)
  let scheme = call_594067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594067.url(scheme.get, call_594067.host, call_594067.base,
                         call_594067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594067, url, valid)

proc call*(call_594068: Call_ApplicationDelete_594060; resourceGroupName: string;
          applicationName: string; subscriptionId: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## applicationDelete
  ## Deletes the application resource identified by the name.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_594069 = newJObject()
  var query_594070 = newJObject()
  add(path_594069, "resourceGroupName", newJString(resourceGroupName))
  add(query_594070, "api-version", newJString(apiVersion))
  add(path_594069, "applicationName", newJString(applicationName))
  add(path_594069, "subscriptionId", newJString(subscriptionId))
  result = call_594068.call(path_594069, query_594070, nil, nil, nil)

var applicationDelete* = Call_ApplicationDelete_594060(name: "applicationDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}",
    validator: validate_ApplicationDelete_594061, base: "",
    url: url_ApplicationDelete_594062, schemes: {Scheme.Https})
type
  Call_ServiceListByApplicationName_594071 = ref object of OpenApiRestCall_593437
proc url_ServiceListByApplicationName_594073(protocol: Scheme; host: string;
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

proc validate_ServiceListByApplicationName_594072(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all services of a given service of an application. The information includes the runtime properties of the service instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594074 = path.getOrDefault("resourceGroupName")
  valid_594074 = validateParameter(valid_594074, JString, required = true,
                                 default = nil)
  if valid_594074 != nil:
    section.add "resourceGroupName", valid_594074
  var valid_594075 = path.getOrDefault("applicationName")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "applicationName", valid_594075
  var valid_594076 = path.getOrDefault("subscriptionId")
  valid_594076 = validateParameter(valid_594076, JString, required = true,
                                 default = nil)
  if valid_594076 != nil:
    section.add "subscriptionId", valid_594076
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594077 = query.getOrDefault("api-version")
  valid_594077 = validateParameter(valid_594077, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_594077 != nil:
    section.add "api-version", valid_594077
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594078: Call_ServiceListByApplicationName_594071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all services of a given service of an application. The information includes the runtime properties of the service instance.
  ## 
  let valid = call_594078.validator(path, query, header, formData, body)
  let scheme = call_594078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594078.url(scheme.get, call_594078.host, call_594078.base,
                         call_594078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594078, url, valid)

proc call*(call_594079: Call_ServiceListByApplicationName_594071;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## serviceListByApplicationName
  ## Gets the information about all services of a given service of an application. The information includes the runtime properties of the service instance.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_594080 = newJObject()
  var query_594081 = newJObject()
  add(path_594080, "resourceGroupName", newJString(resourceGroupName))
  add(query_594081, "api-version", newJString(apiVersion))
  add(path_594080, "applicationName", newJString(applicationName))
  add(path_594080, "subscriptionId", newJString(subscriptionId))
  result = call_594079.call(path_594080, query_594081, nil, nil, nil)

var serviceListByApplicationName* = Call_ServiceListByApplicationName_594071(
    name: "serviceListByApplicationName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}/services",
    validator: validate_ServiceListByApplicationName_594072, base: "",
    url: url_ServiceListByApplicationName_594073, schemes: {Scheme.Https})
type
  Call_ServiceGet_594082 = ref object of OpenApiRestCall_593437
proc url_ServiceGet_594084(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ServiceGet_594083(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## The operation returns the properties of the service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   serviceName: JString (required)
  ##              : The identity of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594085 = path.getOrDefault("resourceGroupName")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "resourceGroupName", valid_594085
  var valid_594086 = path.getOrDefault("applicationName")
  valid_594086 = validateParameter(valid_594086, JString, required = true,
                                 default = nil)
  if valid_594086 != nil:
    section.add "applicationName", valid_594086
  var valid_594087 = path.getOrDefault("subscriptionId")
  valid_594087 = validateParameter(valid_594087, JString, required = true,
                                 default = nil)
  if valid_594087 != nil:
    section.add "subscriptionId", valid_594087
  var valid_594088 = path.getOrDefault("serviceName")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "serviceName", valid_594088
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594089 = query.getOrDefault("api-version")
  valid_594089 = validateParameter(valid_594089, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_594089 != nil:
    section.add "api-version", valid_594089
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594090: Call_ServiceGet_594082; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The operation returns the properties of the service.
  ## 
  let valid = call_594090.validator(path, query, header, formData, body)
  let scheme = call_594090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594090.url(scheme.get, call_594090.host, call_594090.base,
                         call_594090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594090, url, valid)

proc call*(call_594091: Call_ServiceGet_594082; resourceGroupName: string;
          applicationName: string; subscriptionId: string; serviceName: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## serviceGet
  ## The operation returns the properties of the service.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   serviceName: string (required)
  ##              : The identity of the service.
  var path_594092 = newJObject()
  var query_594093 = newJObject()
  add(path_594092, "resourceGroupName", newJString(resourceGroupName))
  add(query_594093, "api-version", newJString(apiVersion))
  add(path_594092, "applicationName", newJString(applicationName))
  add(path_594092, "subscriptionId", newJString(subscriptionId))
  add(path_594092, "serviceName", newJString(serviceName))
  result = call_594091.call(path_594092, query_594093, nil, nil, nil)

var serviceGet* = Call_ServiceGet_594082(name: "serviceGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}/services/{serviceName}",
                                      validator: validate_ServiceGet_594083,
                                      base: "", url: url_ServiceGet_594084,
                                      schemes: {Scheme.Https})
type
  Call_ReplicaListByServiceName_594094 = ref object of OpenApiRestCall_593437
proc url_ReplicaListByServiceName_594096(protocol: Scheme; host: string;
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

proc validate_ReplicaListByServiceName_594095(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all replicas of a given service of an application. The information includes the runtime properties of the replica instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   serviceName: JString (required)
  ##              : The identity of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594097 = path.getOrDefault("resourceGroupName")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = nil)
  if valid_594097 != nil:
    section.add "resourceGroupName", valid_594097
  var valid_594098 = path.getOrDefault("applicationName")
  valid_594098 = validateParameter(valid_594098, JString, required = true,
                                 default = nil)
  if valid_594098 != nil:
    section.add "applicationName", valid_594098
  var valid_594099 = path.getOrDefault("subscriptionId")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "subscriptionId", valid_594099
  var valid_594100 = path.getOrDefault("serviceName")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "serviceName", valid_594100
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594101 = query.getOrDefault("api-version")
  valid_594101 = validateParameter(valid_594101, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_594101 != nil:
    section.add "api-version", valid_594101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594102: Call_ReplicaListByServiceName_594094; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all replicas of a given service of an application. The information includes the runtime properties of the replica instance.
  ## 
  let valid = call_594102.validator(path, query, header, formData, body)
  let scheme = call_594102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594102.url(scheme.get, call_594102.host, call_594102.base,
                         call_594102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594102, url, valid)

proc call*(call_594103: Call_ReplicaListByServiceName_594094;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; serviceName: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## replicaListByServiceName
  ## Gets the information about all replicas of a given service of an application. The information includes the runtime properties of the replica instance.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   serviceName: string (required)
  ##              : The identity of the service.
  var path_594104 = newJObject()
  var query_594105 = newJObject()
  add(path_594104, "resourceGroupName", newJString(resourceGroupName))
  add(query_594105, "api-version", newJString(apiVersion))
  add(path_594104, "applicationName", newJString(applicationName))
  add(path_594104, "subscriptionId", newJString(subscriptionId))
  add(path_594104, "serviceName", newJString(serviceName))
  result = call_594103.call(path_594104, query_594105, nil, nil, nil)

var replicaListByServiceName* = Call_ReplicaListByServiceName_594094(
    name: "replicaListByServiceName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}/services/{serviceName}/replicas",
    validator: validate_ReplicaListByServiceName_594095, base: "",
    url: url_ReplicaListByServiceName_594096, schemes: {Scheme.Https})
type
  Call_ReplicaGet_594106 = ref object of OpenApiRestCall_593437
proc url_ReplicaGet_594108(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_ReplicaGet_594107(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the specified replica of a given service of an application. The information includes the runtime properties of the replica instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   replicaName: JString (required)
  ##              : The identity of the service replica.
  ##   serviceName: JString (required)
  ##              : The identity of the service.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594109 = path.getOrDefault("resourceGroupName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "resourceGroupName", valid_594109
  var valid_594110 = path.getOrDefault("applicationName")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "applicationName", valid_594110
  var valid_594111 = path.getOrDefault("subscriptionId")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = nil)
  if valid_594111 != nil:
    section.add "subscriptionId", valid_594111
  var valid_594112 = path.getOrDefault("replicaName")
  valid_594112 = validateParameter(valid_594112, JString, required = true,
                                 default = nil)
  if valid_594112 != nil:
    section.add "replicaName", valid_594112
  var valid_594113 = path.getOrDefault("serviceName")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "serviceName", valid_594113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594114 = query.getOrDefault("api-version")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_594114 != nil:
    section.add "api-version", valid_594114
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594115: Call_ReplicaGet_594106; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the specified replica of a given service of an application. The information includes the runtime properties of the replica instance.
  ## 
  let valid = call_594115.validator(path, query, header, formData, body)
  let scheme = call_594115.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594115.url(scheme.get, call_594115.host, call_594115.base,
                         call_594115.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594115, url, valid)

proc call*(call_594116: Call_ReplicaGet_594106; resourceGroupName: string;
          applicationName: string; subscriptionId: string; replicaName: string;
          serviceName: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## replicaGet
  ## Gets the information about the specified replica of a given service of an application. The information includes the runtime properties of the replica instance.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   replicaName: string (required)
  ##              : The identity of the service replica.
  ##   serviceName: string (required)
  ##              : The identity of the service.
  var path_594117 = newJObject()
  var query_594118 = newJObject()
  add(path_594117, "resourceGroupName", newJString(resourceGroupName))
  add(query_594118, "api-version", newJString(apiVersion))
  add(path_594117, "applicationName", newJString(applicationName))
  add(path_594117, "subscriptionId", newJString(subscriptionId))
  add(path_594117, "replicaName", newJString(replicaName))
  add(path_594117, "serviceName", newJString(serviceName))
  result = call_594116.call(path_594117, query_594118, nil, nil, nil)

var replicaGet* = Call_ReplicaGet_594106(name: "replicaGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}/services/{serviceName}/replicas/{replicaName}",
                                      validator: validate_ReplicaGet_594107,
                                      base: "", url: url_ReplicaGet_594108,
                                      schemes: {Scheme.Https})
type
  Call_CodePackageGetContainerLog_594119 = ref object of OpenApiRestCall_593437
proc url_CodePackageGetContainerLog_594121(protocol: Scheme; host: string;
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

proc validate_CodePackageGetContainerLog_594120(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the logs for the container of a given code package of an application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   applicationName: JString (required)
  ##                  : The identity of the application.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   replicaName: JString (required)
  ##              : The identity of the service replica.
  ##   serviceName: JString (required)
  ##              : The identity of the service.
  ##   codePackageName: JString (required)
  ##                  : The name of the code package.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594122 = path.getOrDefault("resourceGroupName")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "resourceGroupName", valid_594122
  var valid_594123 = path.getOrDefault("applicationName")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "applicationName", valid_594123
  var valid_594124 = path.getOrDefault("subscriptionId")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "subscriptionId", valid_594124
  var valid_594125 = path.getOrDefault("replicaName")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "replicaName", valid_594125
  var valid_594126 = path.getOrDefault("serviceName")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "serviceName", valid_594126
  var valid_594127 = path.getOrDefault("codePackageName")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = nil)
  if valid_594127 != nil:
    section.add "codePackageName", valid_594127
  result.add "path", section
  ## parameters in `query` object:
  ##   tail: JInt
  ##       : Number of lines to show from the end of the logs. Default is 100.
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  var valid_594128 = query.getOrDefault("tail")
  valid_594128 = validateParameter(valid_594128, JInt, required = false, default = nil)
  if valid_594128 != nil:
    section.add "tail", valid_594128
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594129 = query.getOrDefault("api-version")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_594129 != nil:
    section.add "api-version", valid_594129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594130: Call_CodePackageGetContainerLog_594119; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the logs for the container of a given code package of an application.
  ## 
  let valid = call_594130.validator(path, query, header, formData, body)
  let scheme = call_594130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594130.url(scheme.get, call_594130.host, call_594130.base,
                         call_594130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594130, url, valid)

proc call*(call_594131: Call_CodePackageGetContainerLog_594119;
          resourceGroupName: string; applicationName: string;
          subscriptionId: string; replicaName: string; serviceName: string;
          codePackageName: string; tail: int = 0;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## codePackageGetContainerLog
  ## Get the logs for the container of a given code package of an application.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   tail: int
  ##       : Number of lines to show from the end of the logs. Default is 100.
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   applicationName: string (required)
  ##                  : The identity of the application.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   replicaName: string (required)
  ##              : The identity of the service replica.
  ##   serviceName: string (required)
  ##              : The identity of the service.
  ##   codePackageName: string (required)
  ##                  : The name of the code package.
  var path_594132 = newJObject()
  var query_594133 = newJObject()
  add(path_594132, "resourceGroupName", newJString(resourceGroupName))
  add(query_594133, "tail", newJInt(tail))
  add(query_594133, "api-version", newJString(apiVersion))
  add(path_594132, "applicationName", newJString(applicationName))
  add(path_594132, "subscriptionId", newJString(subscriptionId))
  add(path_594132, "replicaName", newJString(replicaName))
  add(path_594132, "serviceName", newJString(serviceName))
  add(path_594132, "codePackageName", newJString(codePackageName))
  result = call_594131.call(path_594132, query_594133, nil, nil, nil)

var codePackageGetContainerLog* = Call_CodePackageGetContainerLog_594119(
    name: "codePackageGetContainerLog", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/applications/{applicationName}/services/{serviceName}/replicas/{replicaName}/codePackages/{codePackageName}/logs",
    validator: validate_CodePackageGetContainerLog_594120, base: "",
    url: url_CodePackageGetContainerLog_594121, schemes: {Scheme.Https})
type
  Call_NetworkListByResourceGroup_594134 = ref object of OpenApiRestCall_593437
proc url_NetworkListByResourceGroup_594136(protocol: Scheme; host: string;
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

proc validate_NetworkListByResourceGroup_594135(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all network resources in a given resource group. The information includes the network description and other runtime properties.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594137 = path.getOrDefault("resourceGroupName")
  valid_594137 = validateParameter(valid_594137, JString, required = true,
                                 default = nil)
  if valid_594137 != nil:
    section.add "resourceGroupName", valid_594137
  var valid_594138 = path.getOrDefault("subscriptionId")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "subscriptionId", valid_594138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594139 = query.getOrDefault("api-version")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_594139 != nil:
    section.add "api-version", valid_594139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594140: Call_NetworkListByResourceGroup_594134; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all network resources in a given resource group. The information includes the network description and other runtime properties.
  ## 
  ## 
  let valid = call_594140.validator(path, query, header, formData, body)
  let scheme = call_594140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594140.url(scheme.get, call_594140.host, call_594140.base,
                         call_594140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594140, url, valid)

proc call*(call_594141: Call_NetworkListByResourceGroup_594134;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## networkListByResourceGroup
  ## Gets the information about all network resources in a given resource group. The information includes the network description and other runtime properties.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_594142 = newJObject()
  var query_594143 = newJObject()
  add(path_594142, "resourceGroupName", newJString(resourceGroupName))
  add(query_594143, "api-version", newJString(apiVersion))
  add(path_594142, "subscriptionId", newJString(subscriptionId))
  result = call_594141.call(path_594142, query_594143, nil, nil, nil)

var networkListByResourceGroup* = Call_NetworkListByResourceGroup_594134(
    name: "networkListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks",
    validator: validate_NetworkListByResourceGroup_594135, base: "",
    url: url_NetworkListByResourceGroup_594136, schemes: {Scheme.Https})
type
  Call_NetworkCreate_594155 = ref object of OpenApiRestCall_593437
proc url_NetworkCreate_594157(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkCreate_594156(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a network resource with the specified name and description. If a network with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## Use network resources to create private network and configure public connectivity for services within your application. 
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   networkName: JString (required)
  ##              : The identity of the network.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594158 = path.getOrDefault("resourceGroupName")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "resourceGroupName", valid_594158
  var valid_594159 = path.getOrDefault("networkName")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "networkName", valid_594159
  var valid_594160 = path.getOrDefault("subscriptionId")
  valid_594160 = validateParameter(valid_594160, JString, required = true,
                                 default = nil)
  if valid_594160 != nil:
    section.add "subscriptionId", valid_594160
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594161 = query.getOrDefault("api-version")
  valid_594161 = validateParameter(valid_594161, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_594161 != nil:
    section.add "api-version", valid_594161
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

proc call*(call_594163: Call_NetworkCreate_594155; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a network resource with the specified name and description. If a network with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## Use network resources to create private network and configure public connectivity for services within your application. 
  ## 
  ## 
  let valid = call_594163.validator(path, query, header, formData, body)
  let scheme = call_594163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594163.url(scheme.get, call_594163.host, call_594163.base,
                         call_594163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594163, url, valid)

proc call*(call_594164: Call_NetworkCreate_594155; resourceGroupName: string;
          networkResourceDescription: JsonNode; networkName: string;
          subscriptionId: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## networkCreate
  ## Creates a network resource with the specified name and description. If a network with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## Use network resources to create private network and configure public connectivity for services within your application. 
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   networkResourceDescription: JObject (required)
  ##                             : Description for creating a network resource.
  ##   networkName: string (required)
  ##              : The identity of the network.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_594165 = newJObject()
  var query_594166 = newJObject()
  var body_594167 = newJObject()
  add(path_594165, "resourceGroupName", newJString(resourceGroupName))
  add(query_594166, "api-version", newJString(apiVersion))
  if networkResourceDescription != nil:
    body_594167 = networkResourceDescription
  add(path_594165, "networkName", newJString(networkName))
  add(path_594165, "subscriptionId", newJString(subscriptionId))
  result = call_594164.call(path_594165, query_594166, nil, nil, body_594167)

var networkCreate* = Call_NetworkCreate_594155(name: "networkCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks/{networkName}",
    validator: validate_NetworkCreate_594156, base: "", url: url_NetworkCreate_594157,
    schemes: {Scheme.Https})
type
  Call_NetworkGet_594144 = ref object of OpenApiRestCall_593437
proc url_NetworkGet_594146(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_NetworkGet_594145(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the network resource with a given name. This information includes the network description and other runtime information.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   networkName: JString (required)
  ##              : The identity of the network.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594147 = path.getOrDefault("resourceGroupName")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "resourceGroupName", valid_594147
  var valid_594148 = path.getOrDefault("networkName")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "networkName", valid_594148
  var valid_594149 = path.getOrDefault("subscriptionId")
  valid_594149 = validateParameter(valid_594149, JString, required = true,
                                 default = nil)
  if valid_594149 != nil:
    section.add "subscriptionId", valid_594149
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594150 = query.getOrDefault("api-version")
  valid_594150 = validateParameter(valid_594150, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_594150 != nil:
    section.add "api-version", valid_594150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594151: Call_NetworkGet_594144; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the network resource with a given name. This information includes the network description and other runtime information.
  ## 
  ## 
  let valid = call_594151.validator(path, query, header, formData, body)
  let scheme = call_594151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594151.url(scheme.get, call_594151.host, call_594151.base,
                         call_594151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594151, url, valid)

proc call*(call_594152: Call_NetworkGet_594144; resourceGroupName: string;
          networkName: string; subscriptionId: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## networkGet
  ## Gets the information about the network resource with a given name. This information includes the network description and other runtime information.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   networkName: string (required)
  ##              : The identity of the network.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_594153 = newJObject()
  var query_594154 = newJObject()
  add(path_594153, "resourceGroupName", newJString(resourceGroupName))
  add(query_594154, "api-version", newJString(apiVersion))
  add(path_594153, "networkName", newJString(networkName))
  add(path_594153, "subscriptionId", newJString(subscriptionId))
  result = call_594152.call(path_594153, query_594154, nil, nil, nil)

var networkGet* = Call_NetworkGet_594144(name: "networkGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks/{networkName}",
                                      validator: validate_NetworkGet_594145,
                                      base: "", url: url_NetworkGet_594146,
                                      schemes: {Scheme.Https})
type
  Call_NetworkDelete_594168 = ref object of OpenApiRestCall_593437
proc url_NetworkDelete_594170(protocol: Scheme; host: string; base: string;
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

proc validate_NetworkDelete_594169(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the network resource identified by the name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   networkName: JString (required)
  ##              : The identity of the network.
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594171 = path.getOrDefault("resourceGroupName")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "resourceGroupName", valid_594171
  var valid_594172 = path.getOrDefault("networkName")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "networkName", valid_594172
  var valid_594173 = path.getOrDefault("subscriptionId")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "subscriptionId", valid_594173
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594174 = query.getOrDefault("api-version")
  valid_594174 = validateParameter(valid_594174, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_594174 != nil:
    section.add "api-version", valid_594174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594175: Call_NetworkDelete_594168; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the network resource identified by the name.
  ## 
  let valid = call_594175.validator(path, query, header, formData, body)
  let scheme = call_594175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594175.url(scheme.get, call_594175.host, call_594175.base,
                         call_594175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594175, url, valid)

proc call*(call_594176: Call_NetworkDelete_594168; resourceGroupName: string;
          networkName: string; subscriptionId: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## networkDelete
  ## Deletes the network resource identified by the name.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   networkName: string (required)
  ##              : The identity of the network.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_594177 = newJObject()
  var query_594178 = newJObject()
  add(path_594177, "resourceGroupName", newJString(resourceGroupName))
  add(query_594178, "api-version", newJString(apiVersion))
  add(path_594177, "networkName", newJString(networkName))
  add(path_594177, "subscriptionId", newJString(subscriptionId))
  result = call_594176.call(path_594177, query_594178, nil, nil, nil)

var networkDelete* = Call_NetworkDelete_594168(name: "networkDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/networks/{networkName}",
    validator: validate_NetworkDelete_594169, base: "", url: url_NetworkDelete_594170,
    schemes: {Scheme.Https})
type
  Call_VolumeListByResourceGroup_594179 = ref object of OpenApiRestCall_593437
proc url_VolumeListByResourceGroup_594181(protocol: Scheme; host: string;
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

proc validate_VolumeListByResourceGroup_594180(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about all volume resources in a given resource group. The information includes the volume description and other runtime information.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594182 = path.getOrDefault("resourceGroupName")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "resourceGroupName", valid_594182
  var valid_594183 = path.getOrDefault("subscriptionId")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "subscriptionId", valid_594183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594184 = query.getOrDefault("api-version")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_594184 != nil:
    section.add "api-version", valid_594184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594185: Call_VolumeListByResourceGroup_594179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about all volume resources in a given resource group. The information includes the volume description and other runtime information.
  ## 
  ## 
  let valid = call_594185.validator(path, query, header, formData, body)
  let scheme = call_594185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594185.url(scheme.get, call_594185.host, call_594185.base,
                         call_594185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594185, url, valid)

proc call*(call_594186: Call_VolumeListByResourceGroup_594179;
          resourceGroupName: string; subscriptionId: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## volumeListByResourceGroup
  ## Gets the information about all volume resources in a given resource group. The information includes the volume description and other runtime information.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  var path_594187 = newJObject()
  var query_594188 = newJObject()
  add(path_594187, "resourceGroupName", newJString(resourceGroupName))
  add(query_594188, "api-version", newJString(apiVersion))
  add(path_594187, "subscriptionId", newJString(subscriptionId))
  result = call_594186.call(path_594187, query_594188, nil, nil, nil)

var volumeListByResourceGroup* = Call_VolumeListByResourceGroup_594179(
    name: "volumeListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes",
    validator: validate_VolumeListByResourceGroup_594180, base: "",
    url: url_VolumeListByResourceGroup_594181, schemes: {Scheme.Https})
type
  Call_VolumeCreate_594200 = ref object of OpenApiRestCall_593437
proc url_VolumeCreate_594202(protocol: Scheme; host: string; base: string;
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

proc validate_VolumeCreate_594201(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a volume resource with the specified name and description. If a volume with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   volumeName: JString (required)
  ##             : The identity of the volume.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594203 = path.getOrDefault("resourceGroupName")
  valid_594203 = validateParameter(valid_594203, JString, required = true,
                                 default = nil)
  if valid_594203 != nil:
    section.add "resourceGroupName", valid_594203
  var valid_594204 = path.getOrDefault("subscriptionId")
  valid_594204 = validateParameter(valid_594204, JString, required = true,
                                 default = nil)
  if valid_594204 != nil:
    section.add "subscriptionId", valid_594204
  var valid_594205 = path.getOrDefault("volumeName")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "volumeName", valid_594205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594206 = query.getOrDefault("api-version")
  valid_594206 = validateParameter(valid_594206, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_594206 != nil:
    section.add "api-version", valid_594206
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

proc call*(call_594208: Call_VolumeCreate_594200; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a volume resource with the specified name and description. If a volume with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ## 
  let valid = call_594208.validator(path, query, header, formData, body)
  let scheme = call_594208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594208.url(scheme.get, call_594208.host, call_594208.base,
                         call_594208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594208, url, valid)

proc call*(call_594209: Call_VolumeCreate_594200; resourceGroupName: string;
          subscriptionId: string; volumeResourceDescription: JsonNode;
          volumeName: string; apiVersion: string = "2018-07-01-preview"): Recallable =
  ## volumeCreate
  ## Creates a volume resource with the specified name and description. If a volume with the same name already exists, then its description is updated to the one indicated in this request.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   volumeResourceDescription: JObject (required)
  ##                            : Description for creating a volume resource.
  ##   volumeName: string (required)
  ##             : The identity of the volume.
  var path_594210 = newJObject()
  var query_594211 = newJObject()
  var body_594212 = newJObject()
  add(path_594210, "resourceGroupName", newJString(resourceGroupName))
  add(query_594211, "api-version", newJString(apiVersion))
  add(path_594210, "subscriptionId", newJString(subscriptionId))
  if volumeResourceDescription != nil:
    body_594212 = volumeResourceDescription
  add(path_594210, "volumeName", newJString(volumeName))
  result = call_594209.call(path_594210, query_594211, nil, nil, body_594212)

var volumeCreate* = Call_VolumeCreate_594200(name: "volumeCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes/{volumeName}",
    validator: validate_VolumeCreate_594201, base: "", url: url_VolumeCreate_594202,
    schemes: {Scheme.Https})
type
  Call_VolumeGet_594189 = ref object of OpenApiRestCall_593437
proc url_VolumeGet_594191(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_VolumeGet_594190(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the information about the volume resource with a given name. This information includes the volume description and other runtime information.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   volumeName: JString (required)
  ##             : The identity of the volume.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594192 = path.getOrDefault("resourceGroupName")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "resourceGroupName", valid_594192
  var valid_594193 = path.getOrDefault("subscriptionId")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "subscriptionId", valid_594193
  var valid_594194 = path.getOrDefault("volumeName")
  valid_594194 = validateParameter(valid_594194, JString, required = true,
                                 default = nil)
  if valid_594194 != nil:
    section.add "volumeName", valid_594194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594195 = query.getOrDefault("api-version")
  valid_594195 = validateParameter(valid_594195, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_594195 != nil:
    section.add "api-version", valid_594195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594196: Call_VolumeGet_594189; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the information about the volume resource with a given name. This information includes the volume description and other runtime information.
  ## 
  ## 
  let valid = call_594196.validator(path, query, header, formData, body)
  let scheme = call_594196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594196.url(scheme.get, call_594196.host, call_594196.base,
                         call_594196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594196, url, valid)

proc call*(call_594197: Call_VolumeGet_594189; resourceGroupName: string;
          subscriptionId: string; volumeName: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## volumeGet
  ## Gets the information about the volume resource with a given name. This information includes the volume description and other runtime information.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   volumeName: string (required)
  ##             : The identity of the volume.
  var path_594198 = newJObject()
  var query_594199 = newJObject()
  add(path_594198, "resourceGroupName", newJString(resourceGroupName))
  add(query_594199, "api-version", newJString(apiVersion))
  add(path_594198, "subscriptionId", newJString(subscriptionId))
  add(path_594198, "volumeName", newJString(volumeName))
  result = call_594197.call(path_594198, query_594199, nil, nil, nil)

var volumeGet* = Call_VolumeGet_594189(name: "volumeGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes/{volumeName}",
                                    validator: validate_VolumeGet_594190,
                                    base: "", url: url_VolumeGet_594191,
                                    schemes: {Scheme.Https})
type
  Call_VolumeDelete_594213 = ref object of OpenApiRestCall_593437
proc url_VolumeDelete_594215(protocol: Scheme; host: string; base: string;
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

proc validate_VolumeDelete_594214(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the volume identified by the name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group name
  ##   subscriptionId: JString (required)
  ##                 : The customer subscription identifier
  ##   volumeName: JString (required)
  ##             : The identity of the volume.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594216 = path.getOrDefault("resourceGroupName")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "resourceGroupName", valid_594216
  var valid_594217 = path.getOrDefault("subscriptionId")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "subscriptionId", valid_594217
  var valid_594218 = path.getOrDefault("volumeName")
  valid_594218 = validateParameter(valid_594218, JString, required = true,
                                 default = nil)
  if valid_594218 != nil:
    section.add "volumeName", valid_594218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594219 = query.getOrDefault("api-version")
  valid_594219 = validateParameter(valid_594219, JString, required = true,
                                 default = newJString("2018-07-01-preview"))
  if valid_594219 != nil:
    section.add "api-version", valid_594219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594220: Call_VolumeDelete_594213; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the volume identified by the name.
  ## 
  let valid = call_594220.validator(path, query, header, formData, body)
  let scheme = call_594220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594220.url(scheme.get, call_594220.host, call_594220.base,
                         call_594220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594220, url, valid)

proc call*(call_594221: Call_VolumeDelete_594213; resourceGroupName: string;
          subscriptionId: string; volumeName: string;
          apiVersion: string = "2018-07-01-preview"): Recallable =
  ## volumeDelete
  ## Deletes the volume identified by the name.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group name
  ##   apiVersion: string (required)
  ##             : The version of the API. This parameter is required and its value must be `2018-07-01-preview`.
  ##   subscriptionId: string (required)
  ##                 : The customer subscription identifier
  ##   volumeName: string (required)
  ##             : The identity of the volume.
  var path_594222 = newJObject()
  var query_594223 = newJObject()
  add(path_594222, "resourceGroupName", newJString(resourceGroupName))
  add(query_594223, "api-version", newJString(apiVersion))
  add(path_594222, "subscriptionId", newJString(subscriptionId))
  add(path_594222, "volumeName", newJString(volumeName))
  result = call_594221.call(path_594222, query_594223, nil, nil, nil)

var volumeDelete* = Call_VolumeDelete_594213(name: "volumeDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ServiceFabricMesh/volumes/{volumeName}",
    validator: validate_VolumeDelete_594214, base: "", url: url_VolumeDelete_594215,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
