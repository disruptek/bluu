
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: ManagedNetworkManagementClient
## version: 2019-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## The Microsoft Azure Managed Network management API provides a RESTful set of web services that interact with Microsoft Azure Networks service to programmatically view, control, change, and monitor your entire Azure network centrally and with ease.
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
  macServiceName = "managednetwork-managedNetwork"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563777 = ref object of OpenApiRestCall_563555
proc url_OperationsList_563779(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563778(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available MNC operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563940 = query.getOrDefault("api-version")
  valid_563940 = validateParameter(valid_563940, JString, required = true,
                                 default = nil)
  if valid_563940 != nil:
    section.add "api-version", valid_563940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563963: Call_OperationsList_563777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available MNC operations.
  ## 
  let valid = call_563963.validator(path, query, header, formData, body)
  let scheme = call_563963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563963.url(scheme.get, call_563963.host, call_563963.base,
                         call_563963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563963, url, valid)

proc call*(call_564034: Call_OperationsList_563777; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available MNC operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_564035 = newJObject()
  add(query_564035, "api-version", newJString(apiVersion))
  result = call_564034.call(nil, query_564035, nil, nil, nil)

var operationsList* = Call_OperationsList_563777(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ManagedNetwork/operations",
    validator: validate_OperationsList_563778, base: "", url: url_OperationsList_563779,
    schemes: {Scheme.Https})
type
  Call_ManagedNetworksListBySubscription_564075 = ref object of OpenApiRestCall_563555
proc url_ManagedNetworksListBySubscription_564077(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.ManagedNetwork/managedNetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedNetworksListBySubscription_564076(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The ListBySubscription  ManagedNetwork operation retrieves all the Managed Network Resources in the current subscription in a paginated format.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564093 = path.getOrDefault("subscriptionId")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "subscriptionId", valid_564093
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : May be used to limit the number of results in a page for list queries.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564094 = query.getOrDefault("api-version")
  valid_564094 = validateParameter(valid_564094, JString, required = true,
                                 default = nil)
  if valid_564094 != nil:
    section.add "api-version", valid_564094
  var valid_564095 = query.getOrDefault("$top")
  valid_564095 = validateParameter(valid_564095, JInt, required = false, default = nil)
  if valid_564095 != nil:
    section.add "$top", valid_564095
  var valid_564096 = query.getOrDefault("$skiptoken")
  valid_564096 = validateParameter(valid_564096, JString, required = false,
                                 default = nil)
  if valid_564096 != nil:
    section.add "$skiptoken", valid_564096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564097: Call_ManagedNetworksListBySubscription_564075;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListBySubscription  ManagedNetwork operation retrieves all the Managed Network Resources in the current subscription in a paginated format.
  ## 
  let valid = call_564097.validator(path, query, header, formData, body)
  let scheme = call_564097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564097.url(scheme.get, call_564097.host, call_564097.base,
                         call_564097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564097, url, valid)

proc call*(call_564098: Call_ManagedNetworksListBySubscription_564075;
          apiVersion: string; subscriptionId: string; Top: int = 0;
          Skiptoken: string = ""): Recallable =
  ## managedNetworksListBySubscription
  ## The ListBySubscription  ManagedNetwork operation retrieves all the Managed Network Resources in the current subscription in a paginated format.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : May be used to limit the number of results in a page for list queries.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  var path_564099 = newJObject()
  var query_564100 = newJObject()
  add(query_564100, "api-version", newJString(apiVersion))
  add(query_564100, "$top", newJInt(Top))
  add(path_564099, "subscriptionId", newJString(subscriptionId))
  add(query_564100, "$skiptoken", newJString(Skiptoken))
  result = call_564098.call(path_564099, query_564100, nil, nil, nil)

var managedNetworksListBySubscription* = Call_ManagedNetworksListBySubscription_564075(
    name: "managedNetworksListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ManagedNetwork/managedNetworks",
    validator: validate_ManagedNetworksListBySubscription_564076, base: "",
    url: url_ManagedNetworksListBySubscription_564077, schemes: {Scheme.Https})
type
  Call_ManagedNetworksListByResourceGroup_564101 = ref object of OpenApiRestCall_563555
proc url_ManagedNetworksListByResourceGroup_564103(protocol: Scheme; host: string;
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
        value: "/providers/Microsoft.ManagedNetwork/managedNetworks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedNetworksListByResourceGroup_564102(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The ListByResourceGroup ManagedNetwork operation retrieves all the Managed Network resources in a resource group in a paginated format.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564104 = path.getOrDefault("subscriptionId")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "subscriptionId", valid_564104
  var valid_564105 = path.getOrDefault("resourceGroupName")
  valid_564105 = validateParameter(valid_564105, JString, required = true,
                                 default = nil)
  if valid_564105 != nil:
    section.add "resourceGroupName", valid_564105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : May be used to limit the number of results in a page for list queries.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564106 = query.getOrDefault("api-version")
  valid_564106 = validateParameter(valid_564106, JString, required = true,
                                 default = nil)
  if valid_564106 != nil:
    section.add "api-version", valid_564106
  var valid_564107 = query.getOrDefault("$top")
  valid_564107 = validateParameter(valid_564107, JInt, required = false, default = nil)
  if valid_564107 != nil:
    section.add "$top", valid_564107
  var valid_564108 = query.getOrDefault("$skiptoken")
  valid_564108 = validateParameter(valid_564108, JString, required = false,
                                 default = nil)
  if valid_564108 != nil:
    section.add "$skiptoken", valid_564108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564109: Call_ManagedNetworksListByResourceGroup_564101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListByResourceGroup ManagedNetwork operation retrieves all the Managed Network resources in a resource group in a paginated format.
  ## 
  let valid = call_564109.validator(path, query, header, formData, body)
  let scheme = call_564109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564109.url(scheme.get, call_564109.host, call_564109.base,
                         call_564109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564109, url, valid)

proc call*(call_564110: Call_ManagedNetworksListByResourceGroup_564101;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          Top: int = 0; Skiptoken: string = ""): Recallable =
  ## managedNetworksListByResourceGroup
  ## The ListByResourceGroup ManagedNetwork operation retrieves all the Managed Network resources in a resource group in a paginated format.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : May be used to limit the number of results in a page for list queries.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564111 = newJObject()
  var query_564112 = newJObject()
  add(query_564112, "api-version", newJString(apiVersion))
  add(query_564112, "$top", newJInt(Top))
  add(path_564111, "subscriptionId", newJString(subscriptionId))
  add(query_564112, "$skiptoken", newJString(Skiptoken))
  add(path_564111, "resourceGroupName", newJString(resourceGroupName))
  result = call_564110.call(path_564111, query_564112, nil, nil, nil)

var managedNetworksListByResourceGroup* = Call_ManagedNetworksListByResourceGroup_564101(
    name: "managedNetworksListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks",
    validator: validate_ManagedNetworksListByResourceGroup_564102, base: "",
    url: url_ManagedNetworksListByResourceGroup_564103, schemes: {Scheme.Https})
type
  Call_ManagedNetworksCreateOrUpdate_564124 = ref object of OpenApiRestCall_563555
proc url_ManagedNetworksCreateOrUpdate_564126(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedNetworkName" in path,
        "`managedNetworkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedNetwork/managedNetworks/"),
               (kind: VariableSegment, value: "managedNetworkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedNetworksCreateOrUpdate_564125(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put ManagedNetworks operation creates/updates a Managed Network Resource, specified by resource group and Managed Network name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564144 = path.getOrDefault("subscriptionId")
  valid_564144 = validateParameter(valid_564144, JString, required = true,
                                 default = nil)
  if valid_564144 != nil:
    section.add "subscriptionId", valid_564144
  var valid_564145 = path.getOrDefault("resourceGroupName")
  valid_564145 = validateParameter(valid_564145, JString, required = true,
                                 default = nil)
  if valid_564145 != nil:
    section.add "resourceGroupName", valid_564145
  var valid_564146 = path.getOrDefault("managedNetworkName")
  valid_564146 = validateParameter(valid_564146, JString, required = true,
                                 default = nil)
  if valid_564146 != nil:
    section.add "managedNetworkName", valid_564146
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564147 = query.getOrDefault("api-version")
  valid_564147 = validateParameter(valid_564147, JString, required = true,
                                 default = nil)
  if valid_564147 != nil:
    section.add "api-version", valid_564147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   managedNetwork: JObject (required)
  ##                 : Parameters supplied to the create/update a Managed Network Resource
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564149: Call_ManagedNetworksCreateOrUpdate_564124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put ManagedNetworks operation creates/updates a Managed Network Resource, specified by resource group and Managed Network name
  ## 
  let valid = call_564149.validator(path, query, header, formData, body)
  let scheme = call_564149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564149.url(scheme.get, call_564149.host, call_564149.base,
                         call_564149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564149, url, valid)

proc call*(call_564150: Call_ManagedNetworksCreateOrUpdate_564124;
          apiVersion: string; managedNetwork: JsonNode; subscriptionId: string;
          resourceGroupName: string; managedNetworkName: string): Recallable =
  ## managedNetworksCreateOrUpdate
  ## The Put ManagedNetworks operation creates/updates a Managed Network Resource, specified by resource group and Managed Network name
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managedNetwork: JObject (required)
  ##                 : Parameters supplied to the create/update a Managed Network Resource
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  var path_564151 = newJObject()
  var query_564152 = newJObject()
  var body_564153 = newJObject()
  add(query_564152, "api-version", newJString(apiVersion))
  if managedNetwork != nil:
    body_564153 = managedNetwork
  add(path_564151, "subscriptionId", newJString(subscriptionId))
  add(path_564151, "resourceGroupName", newJString(resourceGroupName))
  add(path_564151, "managedNetworkName", newJString(managedNetworkName))
  result = call_564150.call(path_564151, query_564152, nil, nil, body_564153)

var managedNetworksCreateOrUpdate* = Call_ManagedNetworksCreateOrUpdate_564124(
    name: "managedNetworksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}",
    validator: validate_ManagedNetworksCreateOrUpdate_564125, base: "",
    url: url_ManagedNetworksCreateOrUpdate_564126, schemes: {Scheme.Https})
type
  Call_ManagedNetworksGet_564113 = ref object of OpenApiRestCall_563555
proc url_ManagedNetworksGet_564115(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedNetworkName" in path,
        "`managedNetworkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedNetwork/managedNetworks/"),
               (kind: VariableSegment, value: "managedNetworkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedNetworksGet_564114(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## The Get ManagedNetworks operation gets a Managed Network Resource, specified by the resource group and Managed Network name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564116 = path.getOrDefault("subscriptionId")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "subscriptionId", valid_564116
  var valid_564117 = path.getOrDefault("resourceGroupName")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "resourceGroupName", valid_564117
  var valid_564118 = path.getOrDefault("managedNetworkName")
  valid_564118 = validateParameter(valid_564118, JString, required = true,
                                 default = nil)
  if valid_564118 != nil:
    section.add "managedNetworkName", valid_564118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564119 = query.getOrDefault("api-version")
  valid_564119 = validateParameter(valid_564119, JString, required = true,
                                 default = nil)
  if valid_564119 != nil:
    section.add "api-version", valid_564119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564120: Call_ManagedNetworksGet_564113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get ManagedNetworks operation gets a Managed Network Resource, specified by the resource group and Managed Network name
  ## 
  let valid = call_564120.validator(path, query, header, formData, body)
  let scheme = call_564120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564120.url(scheme.get, call_564120.host, call_564120.base,
                         call_564120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564120, url, valid)

proc call*(call_564121: Call_ManagedNetworksGet_564113; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          managedNetworkName: string): Recallable =
  ## managedNetworksGet
  ## The Get ManagedNetworks operation gets a Managed Network Resource, specified by the resource group and Managed Network name
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  var path_564122 = newJObject()
  var query_564123 = newJObject()
  add(query_564123, "api-version", newJString(apiVersion))
  add(path_564122, "subscriptionId", newJString(subscriptionId))
  add(path_564122, "resourceGroupName", newJString(resourceGroupName))
  add(path_564122, "managedNetworkName", newJString(managedNetworkName))
  result = call_564121.call(path_564122, query_564123, nil, nil, nil)

var managedNetworksGet* = Call_ManagedNetworksGet_564113(
    name: "managedNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}",
    validator: validate_ManagedNetworksGet_564114, base: "",
    url: url_ManagedNetworksGet_564115, schemes: {Scheme.Https})
type
  Call_ManagedNetworksUpdate_564165 = ref object of OpenApiRestCall_563555
proc url_ManagedNetworksUpdate_564167(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedNetworkName" in path,
        "`managedNetworkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedNetwork/managedNetworks/"),
               (kind: VariableSegment, value: "managedNetworkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedNetworksUpdate_564166(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Managed Network resource tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564168 = path.getOrDefault("subscriptionId")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "subscriptionId", valid_564168
  var valid_564169 = path.getOrDefault("resourceGroupName")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "resourceGroupName", valid_564169
  var valid_564170 = path.getOrDefault("managedNetworkName")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "managedNetworkName", valid_564170
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564171 = query.getOrDefault("api-version")
  valid_564171 = validateParameter(valid_564171, JString, required = true,
                                 default = nil)
  if valid_564171 != nil:
    section.add "api-version", valid_564171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update application gateway tags and/or scope.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564173: Call_ManagedNetworksUpdate_564165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Managed Network resource tags.
  ## 
  let valid = call_564173.validator(path, query, header, formData, body)
  let scheme = call_564173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564173.url(scheme.get, call_564173.host, call_564173.base,
                         call_564173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564173, url, valid)

proc call*(call_564174: Call_ManagedNetworksUpdate_564165; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          managedNetworkName: string; parameters: JsonNode): Recallable =
  ## managedNetworksUpdate
  ## Updates the specified Managed Network resource tags.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update application gateway tags and/or scope.
  var path_564175 = newJObject()
  var query_564176 = newJObject()
  var body_564177 = newJObject()
  add(query_564176, "api-version", newJString(apiVersion))
  add(path_564175, "subscriptionId", newJString(subscriptionId))
  add(path_564175, "resourceGroupName", newJString(resourceGroupName))
  add(path_564175, "managedNetworkName", newJString(managedNetworkName))
  if parameters != nil:
    body_564177 = parameters
  result = call_564174.call(path_564175, query_564176, nil, nil, body_564177)

var managedNetworksUpdate* = Call_ManagedNetworksUpdate_564165(
    name: "managedNetworksUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}",
    validator: validate_ManagedNetworksUpdate_564166, base: "",
    url: url_ManagedNetworksUpdate_564167, schemes: {Scheme.Https})
type
  Call_ManagedNetworksDelete_564154 = ref object of OpenApiRestCall_563555
proc url_ManagedNetworksDelete_564156(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedNetworkName" in path,
        "`managedNetworkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedNetwork/managedNetworks/"),
               (kind: VariableSegment, value: "managedNetworkName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedNetworksDelete_564155(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Delete ManagedNetworks operation deletes a Managed Network Resource, specified by the  resource group and Managed Network name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564157 = path.getOrDefault("subscriptionId")
  valid_564157 = validateParameter(valid_564157, JString, required = true,
                                 default = nil)
  if valid_564157 != nil:
    section.add "subscriptionId", valid_564157
  var valid_564158 = path.getOrDefault("resourceGroupName")
  valid_564158 = validateParameter(valid_564158, JString, required = true,
                                 default = nil)
  if valid_564158 != nil:
    section.add "resourceGroupName", valid_564158
  var valid_564159 = path.getOrDefault("managedNetworkName")
  valid_564159 = validateParameter(valid_564159, JString, required = true,
                                 default = nil)
  if valid_564159 != nil:
    section.add "managedNetworkName", valid_564159
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564160 = query.getOrDefault("api-version")
  valid_564160 = validateParameter(valid_564160, JString, required = true,
                                 default = nil)
  if valid_564160 != nil:
    section.add "api-version", valid_564160
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564161: Call_ManagedNetworksDelete_564154; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete ManagedNetworks operation deletes a Managed Network Resource, specified by the  resource group and Managed Network name
  ## 
  let valid = call_564161.validator(path, query, header, formData, body)
  let scheme = call_564161.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564161.url(scheme.get, call_564161.host, call_564161.base,
                         call_564161.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564161, url, valid)

proc call*(call_564162: Call_ManagedNetworksDelete_564154; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          managedNetworkName: string): Recallable =
  ## managedNetworksDelete
  ## The Delete ManagedNetworks operation deletes a Managed Network Resource, specified by the  resource group and Managed Network name
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  var path_564163 = newJObject()
  var query_564164 = newJObject()
  add(query_564164, "api-version", newJString(apiVersion))
  add(path_564163, "subscriptionId", newJString(subscriptionId))
  add(path_564163, "resourceGroupName", newJString(resourceGroupName))
  add(path_564163, "managedNetworkName", newJString(managedNetworkName))
  result = call_564162.call(path_564163, query_564164, nil, nil, nil)

var managedNetworksDelete* = Call_ManagedNetworksDelete_564154(
    name: "managedNetworksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}",
    validator: validate_ManagedNetworksDelete_564155, base: "",
    url: url_ManagedNetworksDelete_564156, schemes: {Scheme.Https})
type
  Call_ManagedNetworkGroupsListByManagedNetwork_564178 = ref object of OpenApiRestCall_563555
proc url_ManagedNetworkGroupsListByManagedNetwork_564180(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedNetworkName" in path,
        "`managedNetworkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedNetwork/managedNetworks/"),
               (kind: VariableSegment, value: "managedNetworkName"),
               (kind: ConstantSegment, value: "/managedNetworkGroups")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedNetworkGroupsListByManagedNetwork_564179(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The ListByManagedNetwork ManagedNetworkGroup operation retrieves all the Managed Network Groups in a specified Managed Networks in a paginated format.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564181 = path.getOrDefault("subscriptionId")
  valid_564181 = validateParameter(valid_564181, JString, required = true,
                                 default = nil)
  if valid_564181 != nil:
    section.add "subscriptionId", valid_564181
  var valid_564182 = path.getOrDefault("resourceGroupName")
  valid_564182 = validateParameter(valid_564182, JString, required = true,
                                 default = nil)
  if valid_564182 != nil:
    section.add "resourceGroupName", valid_564182
  var valid_564183 = path.getOrDefault("managedNetworkName")
  valid_564183 = validateParameter(valid_564183, JString, required = true,
                                 default = nil)
  if valid_564183 != nil:
    section.add "managedNetworkName", valid_564183
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : May be used to limit the number of results in a page for list queries.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564184 = query.getOrDefault("api-version")
  valid_564184 = validateParameter(valid_564184, JString, required = true,
                                 default = nil)
  if valid_564184 != nil:
    section.add "api-version", valid_564184
  var valid_564185 = query.getOrDefault("$top")
  valid_564185 = validateParameter(valid_564185, JInt, required = false, default = nil)
  if valid_564185 != nil:
    section.add "$top", valid_564185
  var valid_564186 = query.getOrDefault("$skiptoken")
  valid_564186 = validateParameter(valid_564186, JString, required = false,
                                 default = nil)
  if valid_564186 != nil:
    section.add "$skiptoken", valid_564186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564187: Call_ManagedNetworkGroupsListByManagedNetwork_564178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListByManagedNetwork ManagedNetworkGroup operation retrieves all the Managed Network Groups in a specified Managed Networks in a paginated format.
  ## 
  let valid = call_564187.validator(path, query, header, formData, body)
  let scheme = call_564187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564187.url(scheme.get, call_564187.host, call_564187.base,
                         call_564187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564187, url, valid)

proc call*(call_564188: Call_ManagedNetworkGroupsListByManagedNetwork_564178;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          managedNetworkName: string; Top: int = 0; Skiptoken: string = ""): Recallable =
  ## managedNetworkGroupsListByManagedNetwork
  ## The ListByManagedNetwork ManagedNetworkGroup operation retrieves all the Managed Network Groups in a specified Managed Networks in a paginated format.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : May be used to limit the number of results in a page for list queries.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  var path_564189 = newJObject()
  var query_564190 = newJObject()
  add(query_564190, "api-version", newJString(apiVersion))
  add(query_564190, "$top", newJInt(Top))
  add(path_564189, "subscriptionId", newJString(subscriptionId))
  add(query_564190, "$skiptoken", newJString(Skiptoken))
  add(path_564189, "resourceGroupName", newJString(resourceGroupName))
  add(path_564189, "managedNetworkName", newJString(managedNetworkName))
  result = call_564188.call(path_564189, query_564190, nil, nil, nil)

var managedNetworkGroupsListByManagedNetwork* = Call_ManagedNetworkGroupsListByManagedNetwork_564178(
    name: "managedNetworkGroupsListByManagedNetwork", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}/managedNetworkGroups",
    validator: validate_ManagedNetworkGroupsListByManagedNetwork_564179, base: "",
    url: url_ManagedNetworkGroupsListByManagedNetwork_564180,
    schemes: {Scheme.Https})
type
  Call_ManagedNetworkGroupsCreateOrUpdate_564203 = ref object of OpenApiRestCall_563555
proc url_ManagedNetworkGroupsCreateOrUpdate_564205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedNetworkName" in path,
        "`managedNetworkName` is a required path parameter"
  assert "managedNetworkGroupName" in path,
        "`managedNetworkGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedNetwork/managedNetworks/"),
               (kind: VariableSegment, value: "managedNetworkName"),
               (kind: ConstantSegment, value: "/managedNetworkGroups/"),
               (kind: VariableSegment, value: "managedNetworkGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedNetworkGroupsCreateOrUpdate_564204(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put ManagedNetworkGroups operation creates or updates a Managed Network Group resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managedNetworkGroupName: JString (required)
  ##                          : The name of the Managed Network Group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managedNetworkGroupName` field"
  var valid_564206 = path.getOrDefault("managedNetworkGroupName")
  valid_564206 = validateParameter(valid_564206, JString, required = true,
                                 default = nil)
  if valid_564206 != nil:
    section.add "managedNetworkGroupName", valid_564206
  var valid_564207 = path.getOrDefault("subscriptionId")
  valid_564207 = validateParameter(valid_564207, JString, required = true,
                                 default = nil)
  if valid_564207 != nil:
    section.add "subscriptionId", valid_564207
  var valid_564208 = path.getOrDefault("resourceGroupName")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = nil)
  if valid_564208 != nil:
    section.add "resourceGroupName", valid_564208
  var valid_564209 = path.getOrDefault("managedNetworkName")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "managedNetworkName", valid_564209
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564210 = query.getOrDefault("api-version")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "api-version", valid_564210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   managedNetworkGroup: JObject (required)
  ##                      : Parameters supplied to the create/update a Managed Network Group resource
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564212: Call_ManagedNetworkGroupsCreateOrUpdate_564203;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put ManagedNetworkGroups operation creates or updates a Managed Network Group resource
  ## 
  let valid = call_564212.validator(path, query, header, formData, body)
  let scheme = call_564212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564212.url(scheme.get, call_564212.host, call_564212.base,
                         call_564212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564212, url, valid)

proc call*(call_564213: Call_ManagedNetworkGroupsCreateOrUpdate_564203;
          managedNetworkGroupName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          managedNetworkGroup: JsonNode; managedNetworkName: string): Recallable =
  ## managedNetworkGroupsCreateOrUpdate
  ## The Put ManagedNetworkGroups operation creates or updates a Managed Network Group resource
  ##   managedNetworkGroupName: string (required)
  ##                          : The name of the Managed Network Group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   managedNetworkGroup: JObject (required)
  ##                      : Parameters supplied to the create/update a Managed Network Group resource
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  var path_564214 = newJObject()
  var query_564215 = newJObject()
  var body_564216 = newJObject()
  add(path_564214, "managedNetworkGroupName", newJString(managedNetworkGroupName))
  add(query_564215, "api-version", newJString(apiVersion))
  add(path_564214, "subscriptionId", newJString(subscriptionId))
  add(path_564214, "resourceGroupName", newJString(resourceGroupName))
  if managedNetworkGroup != nil:
    body_564216 = managedNetworkGroup
  add(path_564214, "managedNetworkName", newJString(managedNetworkName))
  result = call_564213.call(path_564214, query_564215, nil, nil, body_564216)

var managedNetworkGroupsCreateOrUpdate* = Call_ManagedNetworkGroupsCreateOrUpdate_564203(
    name: "managedNetworkGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}/managedNetworkGroups/{managedNetworkGroupName}",
    validator: validate_ManagedNetworkGroupsCreateOrUpdate_564204, base: "",
    url: url_ManagedNetworkGroupsCreateOrUpdate_564205, schemes: {Scheme.Https})
type
  Call_ManagedNetworkGroupsGet_564191 = ref object of OpenApiRestCall_563555
proc url_ManagedNetworkGroupsGet_564193(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedNetworkName" in path,
        "`managedNetworkName` is a required path parameter"
  assert "managedNetworkGroupName" in path,
        "`managedNetworkGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedNetwork/managedNetworks/"),
               (kind: VariableSegment, value: "managedNetworkName"),
               (kind: ConstantSegment, value: "/managedNetworkGroups/"),
               (kind: VariableSegment, value: "managedNetworkGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedNetworkGroupsGet_564192(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get ManagedNetworkGroups operation gets a Managed Network Group specified by the resource group, Managed Network name, and group name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managedNetworkGroupName: JString (required)
  ##                          : The name of the Managed Network Group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managedNetworkGroupName` field"
  var valid_564194 = path.getOrDefault("managedNetworkGroupName")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "managedNetworkGroupName", valid_564194
  var valid_564195 = path.getOrDefault("subscriptionId")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "subscriptionId", valid_564195
  var valid_564196 = path.getOrDefault("resourceGroupName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "resourceGroupName", valid_564196
  var valid_564197 = path.getOrDefault("managedNetworkName")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "managedNetworkName", valid_564197
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564198 = query.getOrDefault("api-version")
  valid_564198 = validateParameter(valid_564198, JString, required = true,
                                 default = nil)
  if valid_564198 != nil:
    section.add "api-version", valid_564198
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564199: Call_ManagedNetworkGroupsGet_564191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get ManagedNetworkGroups operation gets a Managed Network Group specified by the resource group, Managed Network name, and group name
  ## 
  let valid = call_564199.validator(path, query, header, formData, body)
  let scheme = call_564199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564199.url(scheme.get, call_564199.host, call_564199.base,
                         call_564199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564199, url, valid)

proc call*(call_564200: Call_ManagedNetworkGroupsGet_564191;
          managedNetworkGroupName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          managedNetworkName: string): Recallable =
  ## managedNetworkGroupsGet
  ## The Get ManagedNetworkGroups operation gets a Managed Network Group specified by the resource group, Managed Network name, and group name
  ##   managedNetworkGroupName: string (required)
  ##                          : The name of the Managed Network Group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  var path_564201 = newJObject()
  var query_564202 = newJObject()
  add(path_564201, "managedNetworkGroupName", newJString(managedNetworkGroupName))
  add(query_564202, "api-version", newJString(apiVersion))
  add(path_564201, "subscriptionId", newJString(subscriptionId))
  add(path_564201, "resourceGroupName", newJString(resourceGroupName))
  add(path_564201, "managedNetworkName", newJString(managedNetworkName))
  result = call_564200.call(path_564201, query_564202, nil, nil, nil)

var managedNetworkGroupsGet* = Call_ManagedNetworkGroupsGet_564191(
    name: "managedNetworkGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}/managedNetworkGroups/{managedNetworkGroupName}",
    validator: validate_ManagedNetworkGroupsGet_564192, base: "",
    url: url_ManagedNetworkGroupsGet_564193, schemes: {Scheme.Https})
type
  Call_ManagedNetworkGroupsDelete_564217 = ref object of OpenApiRestCall_563555
proc url_ManagedNetworkGroupsDelete_564219(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedNetworkName" in path,
        "`managedNetworkName` is a required path parameter"
  assert "managedNetworkGroupName" in path,
        "`managedNetworkGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedNetwork/managedNetworks/"),
               (kind: VariableSegment, value: "managedNetworkName"),
               (kind: ConstantSegment, value: "/managedNetworkGroups/"),
               (kind: VariableSegment, value: "managedNetworkGroupName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedNetworkGroupsDelete_564218(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Delete ManagedNetworkGroups operation deletes a Managed Network Group specified by the resource group, Managed Network name, and group name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managedNetworkGroupName: JString (required)
  ##                          : The name of the Managed Network Group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managedNetworkGroupName` field"
  var valid_564220 = path.getOrDefault("managedNetworkGroupName")
  valid_564220 = validateParameter(valid_564220, JString, required = true,
                                 default = nil)
  if valid_564220 != nil:
    section.add "managedNetworkGroupName", valid_564220
  var valid_564221 = path.getOrDefault("subscriptionId")
  valid_564221 = validateParameter(valid_564221, JString, required = true,
                                 default = nil)
  if valid_564221 != nil:
    section.add "subscriptionId", valid_564221
  var valid_564222 = path.getOrDefault("resourceGroupName")
  valid_564222 = validateParameter(valid_564222, JString, required = true,
                                 default = nil)
  if valid_564222 != nil:
    section.add "resourceGroupName", valid_564222
  var valid_564223 = path.getOrDefault("managedNetworkName")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = nil)
  if valid_564223 != nil:
    section.add "managedNetworkName", valid_564223
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564224 = query.getOrDefault("api-version")
  valid_564224 = validateParameter(valid_564224, JString, required = true,
                                 default = nil)
  if valid_564224 != nil:
    section.add "api-version", valid_564224
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564225: Call_ManagedNetworkGroupsDelete_564217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete ManagedNetworkGroups operation deletes a Managed Network Group specified by the resource group, Managed Network name, and group name
  ## 
  let valid = call_564225.validator(path, query, header, formData, body)
  let scheme = call_564225.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564225.url(scheme.get, call_564225.host, call_564225.base,
                         call_564225.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564225, url, valid)

proc call*(call_564226: Call_ManagedNetworkGroupsDelete_564217;
          managedNetworkGroupName: string; apiVersion: string;
          subscriptionId: string; resourceGroupName: string;
          managedNetworkName: string): Recallable =
  ## managedNetworkGroupsDelete
  ## The Delete ManagedNetworkGroups operation deletes a Managed Network Group specified by the resource group, Managed Network name, and group name
  ##   managedNetworkGroupName: string (required)
  ##                          : The name of the Managed Network Group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  var path_564227 = newJObject()
  var query_564228 = newJObject()
  add(path_564227, "managedNetworkGroupName", newJString(managedNetworkGroupName))
  add(query_564228, "api-version", newJString(apiVersion))
  add(path_564227, "subscriptionId", newJString(subscriptionId))
  add(path_564227, "resourceGroupName", newJString(resourceGroupName))
  add(path_564227, "managedNetworkName", newJString(managedNetworkName))
  result = call_564226.call(path_564227, query_564228, nil, nil, nil)

var managedNetworkGroupsDelete* = Call_ManagedNetworkGroupsDelete_564217(
    name: "managedNetworkGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}/managedNetworkGroups/{managedNetworkGroupName}",
    validator: validate_ManagedNetworkGroupsDelete_564218, base: "",
    url: url_ManagedNetworkGroupsDelete_564219, schemes: {Scheme.Https})
type
  Call_ManagedNetworkPeeringPoliciesListByManagedNetwork_564229 = ref object of OpenApiRestCall_563555
proc url_ManagedNetworkPeeringPoliciesListByManagedNetwork_564231(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedNetworkName" in path,
        "`managedNetworkName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedNetwork/managedNetworks/"),
               (kind: VariableSegment, value: "managedNetworkName"),
               (kind: ConstantSegment, value: "/managedNetworkPeeringPolicies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedNetworkPeeringPoliciesListByManagedNetwork_564230(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The ListByManagedNetwork PeeringPolicies operation retrieves all the Managed Network Peering Policies in a specified Managed Network, in a paginated format.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564232 = path.getOrDefault("subscriptionId")
  valid_564232 = validateParameter(valid_564232, JString, required = true,
                                 default = nil)
  if valid_564232 != nil:
    section.add "subscriptionId", valid_564232
  var valid_564233 = path.getOrDefault("resourceGroupName")
  valid_564233 = validateParameter(valid_564233, JString, required = true,
                                 default = nil)
  if valid_564233 != nil:
    section.add "resourceGroupName", valid_564233
  var valid_564234 = path.getOrDefault("managedNetworkName")
  valid_564234 = validateParameter(valid_564234, JString, required = true,
                                 default = nil)
  if valid_564234 != nil:
    section.add "managedNetworkName", valid_564234
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : May be used to limit the number of results in a page for list queries.
  ##   $skiptoken: JString
  ##             : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564235 = query.getOrDefault("api-version")
  valid_564235 = validateParameter(valid_564235, JString, required = true,
                                 default = nil)
  if valid_564235 != nil:
    section.add "api-version", valid_564235
  var valid_564236 = query.getOrDefault("$top")
  valid_564236 = validateParameter(valid_564236, JInt, required = false, default = nil)
  if valid_564236 != nil:
    section.add "$top", valid_564236
  var valid_564237 = query.getOrDefault("$skiptoken")
  valid_564237 = validateParameter(valid_564237, JString, required = false,
                                 default = nil)
  if valid_564237 != nil:
    section.add "$skiptoken", valid_564237
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564238: Call_ManagedNetworkPeeringPoliciesListByManagedNetwork_564229;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListByManagedNetwork PeeringPolicies operation retrieves all the Managed Network Peering Policies in a specified Managed Network, in a paginated format.
  ## 
  let valid = call_564238.validator(path, query, header, formData, body)
  let scheme = call_564238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564238.url(scheme.get, call_564238.host, call_564238.base,
                         call_564238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564238, url, valid)

proc call*(call_564239: Call_ManagedNetworkPeeringPoliciesListByManagedNetwork_564229;
          apiVersion: string; subscriptionId: string; resourceGroupName: string;
          managedNetworkName: string; Top: int = 0; Skiptoken: string = ""): Recallable =
  ## managedNetworkPeeringPoliciesListByManagedNetwork
  ## The ListByManagedNetwork PeeringPolicies operation retrieves all the Managed Network Peering Policies in a specified Managed Network, in a paginated format.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : May be used to limit the number of results in a page for list queries.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  var path_564240 = newJObject()
  var query_564241 = newJObject()
  add(query_564241, "api-version", newJString(apiVersion))
  add(query_564241, "$top", newJInt(Top))
  add(path_564240, "subscriptionId", newJString(subscriptionId))
  add(query_564241, "$skiptoken", newJString(Skiptoken))
  add(path_564240, "resourceGroupName", newJString(resourceGroupName))
  add(path_564240, "managedNetworkName", newJString(managedNetworkName))
  result = call_564239.call(path_564240, query_564241, nil, nil, nil)

var managedNetworkPeeringPoliciesListByManagedNetwork* = Call_ManagedNetworkPeeringPoliciesListByManagedNetwork_564229(
    name: "managedNetworkPeeringPoliciesListByManagedNetwork",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}/managedNetworkPeeringPolicies",
    validator: validate_ManagedNetworkPeeringPoliciesListByManagedNetwork_564230,
    base: "", url: url_ManagedNetworkPeeringPoliciesListByManagedNetwork_564231,
    schemes: {Scheme.Https})
type
  Call_ManagedNetworkPeeringPoliciesCreateOrUpdate_564254 = ref object of OpenApiRestCall_563555
proc url_ManagedNetworkPeeringPoliciesCreateOrUpdate_564256(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedNetworkName" in path,
        "`managedNetworkName` is a required path parameter"
  assert "managedNetworkPeeringPolicyName" in path,
        "`managedNetworkPeeringPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedNetwork/managedNetworks/"),
               (kind: VariableSegment, value: "managedNetworkName"), (
        kind: ConstantSegment, value: "/managedNetworkPeeringPolicies/"), (
        kind: VariableSegment, value: "managedNetworkPeeringPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedNetworkPeeringPoliciesCreateOrUpdate_564255(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put ManagedNetworkPeeringPolicies operation creates/updates a new Managed Network Peering Policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   managedNetworkPeeringPolicyName: JString (required)
  ##                                  : The name of the Managed Network Peering Policy.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564257 = path.getOrDefault("subscriptionId")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "subscriptionId", valid_564257
  var valid_564258 = path.getOrDefault("managedNetworkPeeringPolicyName")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "managedNetworkPeeringPolicyName", valid_564258
  var valid_564259 = path.getOrDefault("resourceGroupName")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "resourceGroupName", valid_564259
  var valid_564260 = path.getOrDefault("managedNetworkName")
  valid_564260 = validateParameter(valid_564260, JString, required = true,
                                 default = nil)
  if valid_564260 != nil:
    section.add "managedNetworkName", valid_564260
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564261 = query.getOrDefault("api-version")
  valid_564261 = validateParameter(valid_564261, JString, required = true,
                                 default = nil)
  if valid_564261 != nil:
    section.add "api-version", valid_564261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   managedNetworkPolicy: JObject (required)
  ##                       : Parameters supplied to create/update a Managed Network Peering Policy
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564263: Call_ManagedNetworkPeeringPoliciesCreateOrUpdate_564254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put ManagedNetworkPeeringPolicies operation creates/updates a new Managed Network Peering Policy
  ## 
  let valid = call_564263.validator(path, query, header, formData, body)
  let scheme = call_564263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564263.url(scheme.get, call_564263.host, call_564263.base,
                         call_564263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564263, url, valid)

proc call*(call_564264: Call_ManagedNetworkPeeringPoliciesCreateOrUpdate_564254;
          apiVersion: string; subscriptionId: string;
          managedNetworkPeeringPolicyName: string; resourceGroupName: string;
          managedNetworkPolicy: JsonNode; managedNetworkName: string): Recallable =
  ## managedNetworkPeeringPoliciesCreateOrUpdate
  ## The Put ManagedNetworkPeeringPolicies operation creates/updates a new Managed Network Peering Policy
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   managedNetworkPeeringPolicyName: string (required)
  ##                                  : The name of the Managed Network Peering Policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   managedNetworkPolicy: JObject (required)
  ##                       : Parameters supplied to create/update a Managed Network Peering Policy
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  var path_564265 = newJObject()
  var query_564266 = newJObject()
  var body_564267 = newJObject()
  add(query_564266, "api-version", newJString(apiVersion))
  add(path_564265, "subscriptionId", newJString(subscriptionId))
  add(path_564265, "managedNetworkPeeringPolicyName",
      newJString(managedNetworkPeeringPolicyName))
  add(path_564265, "resourceGroupName", newJString(resourceGroupName))
  if managedNetworkPolicy != nil:
    body_564267 = managedNetworkPolicy
  add(path_564265, "managedNetworkName", newJString(managedNetworkName))
  result = call_564264.call(path_564265, query_564266, nil, nil, body_564267)

var managedNetworkPeeringPoliciesCreateOrUpdate* = Call_ManagedNetworkPeeringPoliciesCreateOrUpdate_564254(
    name: "managedNetworkPeeringPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}/managedNetworkPeeringPolicies/{managedNetworkPeeringPolicyName}",
    validator: validate_ManagedNetworkPeeringPoliciesCreateOrUpdate_564255,
    base: "", url: url_ManagedNetworkPeeringPoliciesCreateOrUpdate_564256,
    schemes: {Scheme.Https})
type
  Call_ManagedNetworkPeeringPoliciesGet_564242 = ref object of OpenApiRestCall_563555
proc url_ManagedNetworkPeeringPoliciesGet_564244(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedNetworkName" in path,
        "`managedNetworkName` is a required path parameter"
  assert "managedNetworkPeeringPolicyName" in path,
        "`managedNetworkPeeringPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedNetwork/managedNetworks/"),
               (kind: VariableSegment, value: "managedNetworkName"), (
        kind: ConstantSegment, value: "/managedNetworkPeeringPolicies/"), (
        kind: VariableSegment, value: "managedNetworkPeeringPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedNetworkPeeringPoliciesGet_564243(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get ManagedNetworkPeeringPolicies operation gets a Managed Network Peering Policy resource, specified by the  resource group, Managed Network name, and peering policy name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   managedNetworkPeeringPolicyName: JString (required)
  ##                                  : The name of the Managed Network Peering Policy.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564245 = path.getOrDefault("subscriptionId")
  valid_564245 = validateParameter(valid_564245, JString, required = true,
                                 default = nil)
  if valid_564245 != nil:
    section.add "subscriptionId", valid_564245
  var valid_564246 = path.getOrDefault("managedNetworkPeeringPolicyName")
  valid_564246 = validateParameter(valid_564246, JString, required = true,
                                 default = nil)
  if valid_564246 != nil:
    section.add "managedNetworkPeeringPolicyName", valid_564246
  var valid_564247 = path.getOrDefault("resourceGroupName")
  valid_564247 = validateParameter(valid_564247, JString, required = true,
                                 default = nil)
  if valid_564247 != nil:
    section.add "resourceGroupName", valid_564247
  var valid_564248 = path.getOrDefault("managedNetworkName")
  valid_564248 = validateParameter(valid_564248, JString, required = true,
                                 default = nil)
  if valid_564248 != nil:
    section.add "managedNetworkName", valid_564248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564249 = query.getOrDefault("api-version")
  valid_564249 = validateParameter(valid_564249, JString, required = true,
                                 default = nil)
  if valid_564249 != nil:
    section.add "api-version", valid_564249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564250: Call_ManagedNetworkPeeringPoliciesGet_564242;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get ManagedNetworkPeeringPolicies operation gets a Managed Network Peering Policy resource, specified by the  resource group, Managed Network name, and peering policy name
  ## 
  let valid = call_564250.validator(path, query, header, formData, body)
  let scheme = call_564250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564250.url(scheme.get, call_564250.host, call_564250.base,
                         call_564250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564250, url, valid)

proc call*(call_564251: Call_ManagedNetworkPeeringPoliciesGet_564242;
          apiVersion: string; subscriptionId: string;
          managedNetworkPeeringPolicyName: string; resourceGroupName: string;
          managedNetworkName: string): Recallable =
  ## managedNetworkPeeringPoliciesGet
  ## The Get ManagedNetworkPeeringPolicies operation gets a Managed Network Peering Policy resource, specified by the  resource group, Managed Network name, and peering policy name
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   managedNetworkPeeringPolicyName: string (required)
  ##                                  : The name of the Managed Network Peering Policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  var path_564252 = newJObject()
  var query_564253 = newJObject()
  add(query_564253, "api-version", newJString(apiVersion))
  add(path_564252, "subscriptionId", newJString(subscriptionId))
  add(path_564252, "managedNetworkPeeringPolicyName",
      newJString(managedNetworkPeeringPolicyName))
  add(path_564252, "resourceGroupName", newJString(resourceGroupName))
  add(path_564252, "managedNetworkName", newJString(managedNetworkName))
  result = call_564251.call(path_564252, query_564253, nil, nil, nil)

var managedNetworkPeeringPoliciesGet* = Call_ManagedNetworkPeeringPoliciesGet_564242(
    name: "managedNetworkPeeringPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}/managedNetworkPeeringPolicies/{managedNetworkPeeringPolicyName}",
    validator: validate_ManagedNetworkPeeringPoliciesGet_564243, base: "",
    url: url_ManagedNetworkPeeringPoliciesGet_564244, schemes: {Scheme.Https})
type
  Call_ManagedNetworkPeeringPoliciesDelete_564268 = ref object of OpenApiRestCall_563555
proc url_ManagedNetworkPeeringPoliciesDelete_564270(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "managedNetworkName" in path,
        "`managedNetworkName` is a required path parameter"
  assert "managedNetworkPeeringPolicyName" in path,
        "`managedNetworkPeeringPolicyName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedNetwork/managedNetworks/"),
               (kind: VariableSegment, value: "managedNetworkName"), (
        kind: ConstantSegment, value: "/managedNetworkPeeringPolicies/"), (
        kind: VariableSegment, value: "managedNetworkPeeringPolicyName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ManagedNetworkPeeringPoliciesDelete_564269(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Delete ManagedNetworkPeeringPolicies operation deletes a Managed Network Peering Policy, specified by the  resource group, Managed Network name, and peering policy name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   managedNetworkPeeringPolicyName: JString (required)
  ##                                  : The name of the Managed Network Peering Policy.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564271 = path.getOrDefault("subscriptionId")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "subscriptionId", valid_564271
  var valid_564272 = path.getOrDefault("managedNetworkPeeringPolicyName")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "managedNetworkPeeringPolicyName", valid_564272
  var valid_564273 = path.getOrDefault("resourceGroupName")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "resourceGroupName", valid_564273
  var valid_564274 = path.getOrDefault("managedNetworkName")
  valid_564274 = validateParameter(valid_564274, JString, required = true,
                                 default = nil)
  if valid_564274 != nil:
    section.add "managedNetworkName", valid_564274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564275 = query.getOrDefault("api-version")
  valid_564275 = validateParameter(valid_564275, JString, required = true,
                                 default = nil)
  if valid_564275 != nil:
    section.add "api-version", valid_564275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564276: Call_ManagedNetworkPeeringPoliciesDelete_564268;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Delete ManagedNetworkPeeringPolicies operation deletes a Managed Network Peering Policy, specified by the  resource group, Managed Network name, and peering policy name
  ## 
  let valid = call_564276.validator(path, query, header, formData, body)
  let scheme = call_564276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564276.url(scheme.get, call_564276.host, call_564276.base,
                         call_564276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564276, url, valid)

proc call*(call_564277: Call_ManagedNetworkPeeringPoliciesDelete_564268;
          apiVersion: string; subscriptionId: string;
          managedNetworkPeeringPolicyName: string; resourceGroupName: string;
          managedNetworkName: string): Recallable =
  ## managedNetworkPeeringPoliciesDelete
  ## The Delete ManagedNetworkPeeringPolicies operation deletes a Managed Network Peering Policy, specified by the  resource group, Managed Network name, and peering policy name
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   managedNetworkPeeringPolicyName: string (required)
  ##                                  : The name of the Managed Network Peering Policy.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  var path_564278 = newJObject()
  var query_564279 = newJObject()
  add(query_564279, "api-version", newJString(apiVersion))
  add(path_564278, "subscriptionId", newJString(subscriptionId))
  add(path_564278, "managedNetworkPeeringPolicyName",
      newJString(managedNetworkPeeringPolicyName))
  add(path_564278, "resourceGroupName", newJString(resourceGroupName))
  add(path_564278, "managedNetworkName", newJString(managedNetworkName))
  result = call_564277.call(path_564278, query_564279, nil, nil, nil)

var managedNetworkPeeringPoliciesDelete* = Call_ManagedNetworkPeeringPoliciesDelete_564268(
    name: "managedNetworkPeeringPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}/managedNetworkPeeringPolicies/{managedNetworkPeeringPolicyName}",
    validator: validate_ManagedNetworkPeeringPoliciesDelete_564269, base: "",
    url: url_ManagedNetworkPeeringPoliciesDelete_564270, schemes: {Scheme.Https})
type
  Call_ScopeAssignmentsList_564280 = ref object of OpenApiRestCall_563555
proc url_ScopeAssignmentsList_564282(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedNetwork/scopeAssignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScopeAssignmentsList_564281(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the specified scope assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The base resource of the scope assignment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_564283 = path.getOrDefault("scope")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "scope", valid_564283
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564284 = query.getOrDefault("api-version")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "api-version", valid_564284
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564285: Call_ScopeAssignmentsList_564280; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified scope assignment.
  ## 
  let valid = call_564285.validator(path, query, header, formData, body)
  let scheme = call_564285.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564285.url(scheme.get, call_564285.host, call_564285.base,
                         call_564285.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564285, url, valid)

proc call*(call_564286: Call_ScopeAssignmentsList_564280; apiVersion: string;
          scope: string): Recallable =
  ## scopeAssignmentsList
  ## Get the specified scope assignment.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   scope: string (required)
  ##        : The base resource of the scope assignment.
  var path_564287 = newJObject()
  var query_564288 = newJObject()
  add(query_564288, "api-version", newJString(apiVersion))
  add(path_564287, "scope", newJString(scope))
  result = call_564286.call(path_564287, query_564288, nil, nil, nil)

var scopeAssignmentsList* = Call_ScopeAssignmentsList_564280(
    name: "scopeAssignmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.ManagedNetwork/scopeAssignments",
    validator: validate_ScopeAssignmentsList_564281, base: "",
    url: url_ScopeAssignmentsList_564282, schemes: {Scheme.Https})
type
  Call_ScopeAssignmentsCreateOrUpdate_564299 = ref object of OpenApiRestCall_563555
proc url_ScopeAssignmentsCreateOrUpdate_564301(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "scopeAssignmentName" in path,
        "`scopeAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedNetwork/scopeAssignments/"),
               (kind: VariableSegment, value: "scopeAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScopeAssignmentsCreateOrUpdate_564300(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a scope assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scopeAssignmentName: JString (required)
  ##                      : The name of the scope assignment to create.
  ##   scope: JString (required)
  ##        : The base resource of the scope assignment to create. The scope can be any REST resource instance. For example, use '/subscriptions/{subscription-id}/' for a subscription, '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}' for a resource group, and 
  ## '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/{resource-provider}/{resource-type}/{resource-name}' for a resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scopeAssignmentName` field"
  var valid_564302 = path.getOrDefault("scopeAssignmentName")
  valid_564302 = validateParameter(valid_564302, JString, required = true,
                                 default = nil)
  if valid_564302 != nil:
    section.add "scopeAssignmentName", valid_564302
  var valid_564303 = path.getOrDefault("scope")
  valid_564303 = validateParameter(valid_564303, JString, required = true,
                                 default = nil)
  if valid_564303 != nil:
    section.add "scope", valid_564303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564304 = query.getOrDefault("api-version")
  valid_564304 = validateParameter(valid_564304, JString, required = true,
                                 default = nil)
  if valid_564304 != nil:
    section.add "api-version", valid_564304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the specify which Managed Network this scope is being assigned
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564306: Call_ScopeAssignmentsCreateOrUpdate_564299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a scope assignment.
  ## 
  let valid = call_564306.validator(path, query, header, formData, body)
  let scheme = call_564306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564306.url(scheme.get, call_564306.host, call_564306.base,
                         call_564306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564306, url, valid)

proc call*(call_564307: Call_ScopeAssignmentsCreateOrUpdate_564299;
          scopeAssignmentName: string; apiVersion: string; parameters: JsonNode;
          scope: string): Recallable =
  ## scopeAssignmentsCreateOrUpdate
  ## Creates a scope assignment.
  ##   scopeAssignmentName: string (required)
  ##                      : The name of the scope assignment to create.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the specify which Managed Network this scope is being assigned
  ##   scope: string (required)
  ##        : The base resource of the scope assignment to create. The scope can be any REST resource instance. For example, use '/subscriptions/{subscription-id}/' for a subscription, '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}' for a resource group, and 
  ## '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/{resource-provider}/{resource-type}/{resource-name}' for a resource.
  var path_564308 = newJObject()
  var query_564309 = newJObject()
  var body_564310 = newJObject()
  add(path_564308, "scopeAssignmentName", newJString(scopeAssignmentName))
  add(query_564309, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_564310 = parameters
  add(path_564308, "scope", newJString(scope))
  result = call_564307.call(path_564308, query_564309, nil, nil, body_564310)

var scopeAssignmentsCreateOrUpdate* = Call_ScopeAssignmentsCreateOrUpdate_564299(
    name: "scopeAssignmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedNetwork/scopeAssignments/{scopeAssignmentName}",
    validator: validate_ScopeAssignmentsCreateOrUpdate_564300, base: "",
    url: url_ScopeAssignmentsCreateOrUpdate_564301, schemes: {Scheme.Https})
type
  Call_ScopeAssignmentsGet_564289 = ref object of OpenApiRestCall_563555
proc url_ScopeAssignmentsGet_564291(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "scopeAssignmentName" in path,
        "`scopeAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedNetwork/scopeAssignments/"),
               (kind: VariableSegment, value: "scopeAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScopeAssignmentsGet_564290(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Get the specified scope assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scopeAssignmentName: JString (required)
  ##                      : The name of the scope assignment to get.
  ##   scope: JString (required)
  ##        : The base resource of the scope assignment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scopeAssignmentName` field"
  var valid_564292 = path.getOrDefault("scopeAssignmentName")
  valid_564292 = validateParameter(valid_564292, JString, required = true,
                                 default = nil)
  if valid_564292 != nil:
    section.add "scopeAssignmentName", valid_564292
  var valid_564293 = path.getOrDefault("scope")
  valid_564293 = validateParameter(valid_564293, JString, required = true,
                                 default = nil)
  if valid_564293 != nil:
    section.add "scope", valid_564293
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564294 = query.getOrDefault("api-version")
  valid_564294 = validateParameter(valid_564294, JString, required = true,
                                 default = nil)
  if valid_564294 != nil:
    section.add "api-version", valid_564294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564295: Call_ScopeAssignmentsGet_564289; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified scope assignment.
  ## 
  let valid = call_564295.validator(path, query, header, formData, body)
  let scheme = call_564295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564295.url(scheme.get, call_564295.host, call_564295.base,
                         call_564295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564295, url, valid)

proc call*(call_564296: Call_ScopeAssignmentsGet_564289;
          scopeAssignmentName: string; apiVersion: string; scope: string): Recallable =
  ## scopeAssignmentsGet
  ## Get the specified scope assignment.
  ##   scopeAssignmentName: string (required)
  ##                      : The name of the scope assignment to get.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   scope: string (required)
  ##        : The base resource of the scope assignment.
  var path_564297 = newJObject()
  var query_564298 = newJObject()
  add(path_564297, "scopeAssignmentName", newJString(scopeAssignmentName))
  add(query_564298, "api-version", newJString(apiVersion))
  add(path_564297, "scope", newJString(scope))
  result = call_564296.call(path_564297, query_564298, nil, nil, nil)

var scopeAssignmentsGet* = Call_ScopeAssignmentsGet_564289(
    name: "scopeAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedNetwork/scopeAssignments/{scopeAssignmentName}",
    validator: validate_ScopeAssignmentsGet_564290, base: "",
    url: url_ScopeAssignmentsGet_564291, schemes: {Scheme.Https})
type
  Call_ScopeAssignmentsDelete_564311 = ref object of OpenApiRestCall_563555
proc url_ScopeAssignmentsDelete_564313(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  assert "scopeAssignmentName" in path,
        "`scopeAssignmentName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.ManagedNetwork/scopeAssignments/"),
               (kind: VariableSegment, value: "scopeAssignmentName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ScopeAssignmentsDelete_564312(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a scope assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scopeAssignmentName: JString (required)
  ##                      : The name of the scope assignment to delete.
  ##   scope: JString (required)
  ##        : The scope of the scope assignment to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scopeAssignmentName` field"
  var valid_564314 = path.getOrDefault("scopeAssignmentName")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "scopeAssignmentName", valid_564314
  var valid_564315 = path.getOrDefault("scope")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "scope", valid_564315
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564316 = query.getOrDefault("api-version")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "api-version", valid_564316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564317: Call_ScopeAssignmentsDelete_564311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a scope assignment.
  ## 
  let valid = call_564317.validator(path, query, header, formData, body)
  let scheme = call_564317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564317.url(scheme.get, call_564317.host, call_564317.base,
                         call_564317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564317, url, valid)

proc call*(call_564318: Call_ScopeAssignmentsDelete_564311;
          scopeAssignmentName: string; apiVersion: string; scope: string): Recallable =
  ## scopeAssignmentsDelete
  ## Deletes a scope assignment.
  ##   scopeAssignmentName: string (required)
  ##                      : The name of the scope assignment to delete.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   scope: string (required)
  ##        : The scope of the scope assignment to delete.
  var path_564319 = newJObject()
  var query_564320 = newJObject()
  add(path_564319, "scopeAssignmentName", newJString(scopeAssignmentName))
  add(query_564320, "api-version", newJString(apiVersion))
  add(path_564319, "scope", newJString(scope))
  result = call_564318.call(path_564319, query_564320, nil, nil, nil)

var scopeAssignmentsDelete* = Call_ScopeAssignmentsDelete_564311(
    name: "scopeAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedNetwork/scopeAssignments/{scopeAssignmentName}",
    validator: validate_ScopeAssignmentsDelete_564312, base: "",
    url: url_ScopeAssignmentsDelete_564313, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
