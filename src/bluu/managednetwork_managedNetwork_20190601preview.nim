
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

  OpenApiRestCall_573657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_573657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_573657): Option[Scheme] {.used.} =
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
  macServiceName = "managednetwork-managedNetwork"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_573879 = ref object of OpenApiRestCall_573657
proc url_OperationsList_573881(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_573880(path: JsonNode; query: JsonNode;
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
  var valid_574040 = query.getOrDefault("api-version")
  valid_574040 = validateParameter(valid_574040, JString, required = true,
                                 default = nil)
  if valid_574040 != nil:
    section.add "api-version", valid_574040
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574063: Call_OperationsList_573879; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available MNC operations.
  ## 
  let valid = call_574063.validator(path, query, header, formData, body)
  let scheme = call_574063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574063.url(scheme.get, call_574063.host, call_574063.base,
                         call_574063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574063, url, valid)

proc call*(call_574134: Call_OperationsList_573879; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available MNC operations.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_574135 = newJObject()
  add(query_574135, "api-version", newJString(apiVersion))
  result = call_574134.call(nil, query_574135, nil, nil, nil)

var operationsList* = Call_OperationsList_573879(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.ManagedNetwork/operations",
    validator: validate_OperationsList_573880, base: "", url: url_OperationsList_573881,
    schemes: {Scheme.Https})
type
  Call_ManagedNetworksListBySubscription_574175 = ref object of OpenApiRestCall_573657
proc url_ManagedNetworksListBySubscription_574177(protocol: Scheme; host: string;
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

proc validate_ManagedNetworksListBySubscription_574176(path: JsonNode;
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
  var valid_574193 = path.getOrDefault("subscriptionId")
  valid_574193 = validateParameter(valid_574193, JString, required = true,
                                 default = nil)
  if valid_574193 != nil:
    section.add "subscriptionId", valid_574193
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
  var valid_574194 = query.getOrDefault("api-version")
  valid_574194 = validateParameter(valid_574194, JString, required = true,
                                 default = nil)
  if valid_574194 != nil:
    section.add "api-version", valid_574194
  var valid_574195 = query.getOrDefault("$top")
  valid_574195 = validateParameter(valid_574195, JInt, required = false, default = nil)
  if valid_574195 != nil:
    section.add "$top", valid_574195
  var valid_574196 = query.getOrDefault("$skiptoken")
  valid_574196 = validateParameter(valid_574196, JString, required = false,
                                 default = nil)
  if valid_574196 != nil:
    section.add "$skiptoken", valid_574196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574197: Call_ManagedNetworksListBySubscription_574175;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListBySubscription  ManagedNetwork operation retrieves all the Managed Network Resources in the current subscription in a paginated format.
  ## 
  let valid = call_574197.validator(path, query, header, formData, body)
  let scheme = call_574197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574197.url(scheme.get, call_574197.host, call_574197.base,
                         call_574197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574197, url, valid)

proc call*(call_574198: Call_ManagedNetworksListBySubscription_574175;
          apiVersion: string; subscriptionId: string; Top: int = 0;
          Skiptoken: string = ""): Recallable =
  ## managedNetworksListBySubscription
  ## The ListBySubscription  ManagedNetwork operation retrieves all the Managed Network Resources in the current subscription in a paginated format.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : May be used to limit the number of results in a page for list queries.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  var path_574199 = newJObject()
  var query_574200 = newJObject()
  add(query_574200, "api-version", newJString(apiVersion))
  add(path_574199, "subscriptionId", newJString(subscriptionId))
  add(query_574200, "$top", newJInt(Top))
  add(query_574200, "$skiptoken", newJString(Skiptoken))
  result = call_574198.call(path_574199, query_574200, nil, nil, nil)

var managedNetworksListBySubscription* = Call_ManagedNetworksListBySubscription_574175(
    name: "managedNetworksListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.ManagedNetwork/managedNetworks",
    validator: validate_ManagedNetworksListBySubscription_574176, base: "",
    url: url_ManagedNetworksListBySubscription_574177, schemes: {Scheme.Https})
type
  Call_ManagedNetworksListByResourceGroup_574201 = ref object of OpenApiRestCall_573657
proc url_ManagedNetworksListByResourceGroup_574203(protocol: Scheme; host: string;
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

proc validate_ManagedNetworksListByResourceGroup_574202(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The ListByResourceGroup ManagedNetwork operation retrieves all the Managed Network resources in a resource group in a paginated format.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574204 = path.getOrDefault("resourceGroupName")
  valid_574204 = validateParameter(valid_574204, JString, required = true,
                                 default = nil)
  if valid_574204 != nil:
    section.add "resourceGroupName", valid_574204
  var valid_574205 = path.getOrDefault("subscriptionId")
  valid_574205 = validateParameter(valid_574205, JString, required = true,
                                 default = nil)
  if valid_574205 != nil:
    section.add "subscriptionId", valid_574205
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
  var valid_574206 = query.getOrDefault("api-version")
  valid_574206 = validateParameter(valid_574206, JString, required = true,
                                 default = nil)
  if valid_574206 != nil:
    section.add "api-version", valid_574206
  var valid_574207 = query.getOrDefault("$top")
  valid_574207 = validateParameter(valid_574207, JInt, required = false, default = nil)
  if valid_574207 != nil:
    section.add "$top", valid_574207
  var valid_574208 = query.getOrDefault("$skiptoken")
  valid_574208 = validateParameter(valid_574208, JString, required = false,
                                 default = nil)
  if valid_574208 != nil:
    section.add "$skiptoken", valid_574208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574209: Call_ManagedNetworksListByResourceGroup_574201;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListByResourceGroup ManagedNetwork operation retrieves all the Managed Network resources in a resource group in a paginated format.
  ## 
  let valid = call_574209.validator(path, query, header, formData, body)
  let scheme = call_574209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574209.url(scheme.get, call_574209.host, call_574209.base,
                         call_574209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574209, url, valid)

proc call*(call_574210: Call_ManagedNetworksListByResourceGroup_574201;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          Top: int = 0; Skiptoken: string = ""): Recallable =
  ## managedNetworksListByResourceGroup
  ## The ListByResourceGroup ManagedNetwork operation retrieves all the Managed Network resources in a resource group in a paginated format.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : May be used to limit the number of results in a page for list queries.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  var path_574211 = newJObject()
  var query_574212 = newJObject()
  add(path_574211, "resourceGroupName", newJString(resourceGroupName))
  add(query_574212, "api-version", newJString(apiVersion))
  add(path_574211, "subscriptionId", newJString(subscriptionId))
  add(query_574212, "$top", newJInt(Top))
  add(query_574212, "$skiptoken", newJString(Skiptoken))
  result = call_574210.call(path_574211, query_574212, nil, nil, nil)

var managedNetworksListByResourceGroup* = Call_ManagedNetworksListByResourceGroup_574201(
    name: "managedNetworksListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks",
    validator: validate_ManagedNetworksListByResourceGroup_574202, base: "",
    url: url_ManagedNetworksListByResourceGroup_574203, schemes: {Scheme.Https})
type
  Call_ManagedNetworksCreateOrUpdate_574224 = ref object of OpenApiRestCall_573657
proc url_ManagedNetworksCreateOrUpdate_574226(protocol: Scheme; host: string;
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

proc validate_ManagedNetworksCreateOrUpdate_574225(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put ManagedNetworks operation creates/updates a Managed Network Resource, specified by resource group and Managed Network name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574244 = path.getOrDefault("resourceGroupName")
  valid_574244 = validateParameter(valid_574244, JString, required = true,
                                 default = nil)
  if valid_574244 != nil:
    section.add "resourceGroupName", valid_574244
  var valid_574245 = path.getOrDefault("managedNetworkName")
  valid_574245 = validateParameter(valid_574245, JString, required = true,
                                 default = nil)
  if valid_574245 != nil:
    section.add "managedNetworkName", valid_574245
  var valid_574246 = path.getOrDefault("subscriptionId")
  valid_574246 = validateParameter(valid_574246, JString, required = true,
                                 default = nil)
  if valid_574246 != nil:
    section.add "subscriptionId", valid_574246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574247 = query.getOrDefault("api-version")
  valid_574247 = validateParameter(valid_574247, JString, required = true,
                                 default = nil)
  if valid_574247 != nil:
    section.add "api-version", valid_574247
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

proc call*(call_574249: Call_ManagedNetworksCreateOrUpdate_574224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Put ManagedNetworks operation creates/updates a Managed Network Resource, specified by resource group and Managed Network name
  ## 
  let valid = call_574249.validator(path, query, header, formData, body)
  let scheme = call_574249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574249.url(scheme.get, call_574249.host, call_574249.base,
                         call_574249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574249, url, valid)

proc call*(call_574250: Call_ManagedNetworksCreateOrUpdate_574224;
          resourceGroupName: string; apiVersion: string; managedNetworkName: string;
          subscriptionId: string; managedNetwork: JsonNode): Recallable =
  ## managedNetworksCreateOrUpdate
  ## The Put ManagedNetworks operation creates/updates a Managed Network Resource, specified by resource group and Managed Network name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   managedNetwork: JObject (required)
  ##                 : Parameters supplied to the create/update a Managed Network Resource
  var path_574251 = newJObject()
  var query_574252 = newJObject()
  var body_574253 = newJObject()
  add(path_574251, "resourceGroupName", newJString(resourceGroupName))
  add(query_574252, "api-version", newJString(apiVersion))
  add(path_574251, "managedNetworkName", newJString(managedNetworkName))
  add(path_574251, "subscriptionId", newJString(subscriptionId))
  if managedNetwork != nil:
    body_574253 = managedNetwork
  result = call_574250.call(path_574251, query_574252, nil, nil, body_574253)

var managedNetworksCreateOrUpdate* = Call_ManagedNetworksCreateOrUpdate_574224(
    name: "managedNetworksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}",
    validator: validate_ManagedNetworksCreateOrUpdate_574225, base: "",
    url: url_ManagedNetworksCreateOrUpdate_574226, schemes: {Scheme.Https})
type
  Call_ManagedNetworksGet_574213 = ref object of OpenApiRestCall_573657
proc url_ManagedNetworksGet_574215(protocol: Scheme; host: string; base: string;
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

proc validate_ManagedNetworksGet_574214(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## The Get ManagedNetworks operation gets a Managed Network Resource, specified by the resource group and Managed Network name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574216 = path.getOrDefault("resourceGroupName")
  valid_574216 = validateParameter(valid_574216, JString, required = true,
                                 default = nil)
  if valid_574216 != nil:
    section.add "resourceGroupName", valid_574216
  var valid_574217 = path.getOrDefault("managedNetworkName")
  valid_574217 = validateParameter(valid_574217, JString, required = true,
                                 default = nil)
  if valid_574217 != nil:
    section.add "managedNetworkName", valid_574217
  var valid_574218 = path.getOrDefault("subscriptionId")
  valid_574218 = validateParameter(valid_574218, JString, required = true,
                                 default = nil)
  if valid_574218 != nil:
    section.add "subscriptionId", valid_574218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574219 = query.getOrDefault("api-version")
  valid_574219 = validateParameter(valid_574219, JString, required = true,
                                 default = nil)
  if valid_574219 != nil:
    section.add "api-version", valid_574219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574220: Call_ManagedNetworksGet_574213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get ManagedNetworks operation gets a Managed Network Resource, specified by the resource group and Managed Network name
  ## 
  let valid = call_574220.validator(path, query, header, formData, body)
  let scheme = call_574220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574220.url(scheme.get, call_574220.host, call_574220.base,
                         call_574220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574220, url, valid)

proc call*(call_574221: Call_ManagedNetworksGet_574213; resourceGroupName: string;
          apiVersion: string; managedNetworkName: string; subscriptionId: string): Recallable =
  ## managedNetworksGet
  ## The Get ManagedNetworks operation gets a Managed Network Resource, specified by the resource group and Managed Network name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574222 = newJObject()
  var query_574223 = newJObject()
  add(path_574222, "resourceGroupName", newJString(resourceGroupName))
  add(query_574223, "api-version", newJString(apiVersion))
  add(path_574222, "managedNetworkName", newJString(managedNetworkName))
  add(path_574222, "subscriptionId", newJString(subscriptionId))
  result = call_574221.call(path_574222, query_574223, nil, nil, nil)

var managedNetworksGet* = Call_ManagedNetworksGet_574213(
    name: "managedNetworksGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}",
    validator: validate_ManagedNetworksGet_574214, base: "",
    url: url_ManagedNetworksGet_574215, schemes: {Scheme.Https})
type
  Call_ManagedNetworksUpdate_574265 = ref object of OpenApiRestCall_573657
proc url_ManagedNetworksUpdate_574267(protocol: Scheme; host: string; base: string;
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

proc validate_ManagedNetworksUpdate_574266(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the specified Managed Network resource tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574268 = path.getOrDefault("resourceGroupName")
  valid_574268 = validateParameter(valid_574268, JString, required = true,
                                 default = nil)
  if valid_574268 != nil:
    section.add "resourceGroupName", valid_574268
  var valid_574269 = path.getOrDefault("managedNetworkName")
  valid_574269 = validateParameter(valid_574269, JString, required = true,
                                 default = nil)
  if valid_574269 != nil:
    section.add "managedNetworkName", valid_574269
  var valid_574270 = path.getOrDefault("subscriptionId")
  valid_574270 = validateParameter(valid_574270, JString, required = true,
                                 default = nil)
  if valid_574270 != nil:
    section.add "subscriptionId", valid_574270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574271 = query.getOrDefault("api-version")
  valid_574271 = validateParameter(valid_574271, JString, required = true,
                                 default = nil)
  if valid_574271 != nil:
    section.add "api-version", valid_574271
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

proc call*(call_574273: Call_ManagedNetworksUpdate_574265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified Managed Network resource tags.
  ## 
  let valid = call_574273.validator(path, query, header, formData, body)
  let scheme = call_574273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574273.url(scheme.get, call_574273.host, call_574273.base,
                         call_574273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574273, url, valid)

proc call*(call_574274: Call_ManagedNetworksUpdate_574265;
          resourceGroupName: string; apiVersion: string; managedNetworkName: string;
          subscriptionId: string; parameters: JsonNode): Recallable =
  ## managedNetworksUpdate
  ## Updates the specified Managed Network resource tags.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to update application gateway tags and/or scope.
  var path_574275 = newJObject()
  var query_574276 = newJObject()
  var body_574277 = newJObject()
  add(path_574275, "resourceGroupName", newJString(resourceGroupName))
  add(query_574276, "api-version", newJString(apiVersion))
  add(path_574275, "managedNetworkName", newJString(managedNetworkName))
  add(path_574275, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_574277 = parameters
  result = call_574274.call(path_574275, query_574276, nil, nil, body_574277)

var managedNetworksUpdate* = Call_ManagedNetworksUpdate_574265(
    name: "managedNetworksUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}",
    validator: validate_ManagedNetworksUpdate_574266, base: "",
    url: url_ManagedNetworksUpdate_574267, schemes: {Scheme.Https})
type
  Call_ManagedNetworksDelete_574254 = ref object of OpenApiRestCall_573657
proc url_ManagedNetworksDelete_574256(protocol: Scheme; host: string; base: string;
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

proc validate_ManagedNetworksDelete_574255(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Delete ManagedNetworks operation deletes a Managed Network Resource, specified by the  resource group and Managed Network name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574257 = path.getOrDefault("resourceGroupName")
  valid_574257 = validateParameter(valid_574257, JString, required = true,
                                 default = nil)
  if valid_574257 != nil:
    section.add "resourceGroupName", valid_574257
  var valid_574258 = path.getOrDefault("managedNetworkName")
  valid_574258 = validateParameter(valid_574258, JString, required = true,
                                 default = nil)
  if valid_574258 != nil:
    section.add "managedNetworkName", valid_574258
  var valid_574259 = path.getOrDefault("subscriptionId")
  valid_574259 = validateParameter(valid_574259, JString, required = true,
                                 default = nil)
  if valid_574259 != nil:
    section.add "subscriptionId", valid_574259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574260 = query.getOrDefault("api-version")
  valid_574260 = validateParameter(valid_574260, JString, required = true,
                                 default = nil)
  if valid_574260 != nil:
    section.add "api-version", valid_574260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574261: Call_ManagedNetworksDelete_574254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete ManagedNetworks operation deletes a Managed Network Resource, specified by the  resource group and Managed Network name
  ## 
  let valid = call_574261.validator(path, query, header, formData, body)
  let scheme = call_574261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574261.url(scheme.get, call_574261.host, call_574261.base,
                         call_574261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574261, url, valid)

proc call*(call_574262: Call_ManagedNetworksDelete_574254;
          resourceGroupName: string; apiVersion: string; managedNetworkName: string;
          subscriptionId: string): Recallable =
  ## managedNetworksDelete
  ## The Delete ManagedNetworks operation deletes a Managed Network Resource, specified by the  resource group and Managed Network name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574263 = newJObject()
  var query_574264 = newJObject()
  add(path_574263, "resourceGroupName", newJString(resourceGroupName))
  add(query_574264, "api-version", newJString(apiVersion))
  add(path_574263, "managedNetworkName", newJString(managedNetworkName))
  add(path_574263, "subscriptionId", newJString(subscriptionId))
  result = call_574262.call(path_574263, query_574264, nil, nil, nil)

var managedNetworksDelete* = Call_ManagedNetworksDelete_574254(
    name: "managedNetworksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}",
    validator: validate_ManagedNetworksDelete_574255, base: "",
    url: url_ManagedNetworksDelete_574256, schemes: {Scheme.Https})
type
  Call_ManagedNetworkGroupsListByManagedNetwork_574278 = ref object of OpenApiRestCall_573657
proc url_ManagedNetworkGroupsListByManagedNetwork_574280(protocol: Scheme;
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

proc validate_ManagedNetworkGroupsListByManagedNetwork_574279(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The ListByManagedNetwork ManagedNetworkGroup operation retrieves all the Managed Network Groups in a specified Managed Networks in a paginated format.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574281 = path.getOrDefault("resourceGroupName")
  valid_574281 = validateParameter(valid_574281, JString, required = true,
                                 default = nil)
  if valid_574281 != nil:
    section.add "resourceGroupName", valid_574281
  var valid_574282 = path.getOrDefault("managedNetworkName")
  valid_574282 = validateParameter(valid_574282, JString, required = true,
                                 default = nil)
  if valid_574282 != nil:
    section.add "managedNetworkName", valid_574282
  var valid_574283 = path.getOrDefault("subscriptionId")
  valid_574283 = validateParameter(valid_574283, JString, required = true,
                                 default = nil)
  if valid_574283 != nil:
    section.add "subscriptionId", valid_574283
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
  var valid_574284 = query.getOrDefault("api-version")
  valid_574284 = validateParameter(valid_574284, JString, required = true,
                                 default = nil)
  if valid_574284 != nil:
    section.add "api-version", valid_574284
  var valid_574285 = query.getOrDefault("$top")
  valid_574285 = validateParameter(valid_574285, JInt, required = false, default = nil)
  if valid_574285 != nil:
    section.add "$top", valid_574285
  var valid_574286 = query.getOrDefault("$skiptoken")
  valid_574286 = validateParameter(valid_574286, JString, required = false,
                                 default = nil)
  if valid_574286 != nil:
    section.add "$skiptoken", valid_574286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574287: Call_ManagedNetworkGroupsListByManagedNetwork_574278;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListByManagedNetwork ManagedNetworkGroup operation retrieves all the Managed Network Groups in a specified Managed Networks in a paginated format.
  ## 
  let valid = call_574287.validator(path, query, header, formData, body)
  let scheme = call_574287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574287.url(scheme.get, call_574287.host, call_574287.base,
                         call_574287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574287, url, valid)

proc call*(call_574288: Call_ManagedNetworkGroupsListByManagedNetwork_574278;
          resourceGroupName: string; apiVersion: string; managedNetworkName: string;
          subscriptionId: string; Top: int = 0; Skiptoken: string = ""): Recallable =
  ## managedNetworkGroupsListByManagedNetwork
  ## The ListByManagedNetwork ManagedNetworkGroup operation retrieves all the Managed Network Groups in a specified Managed Networks in a paginated format.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : May be used to limit the number of results in a page for list queries.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  var path_574289 = newJObject()
  var query_574290 = newJObject()
  add(path_574289, "resourceGroupName", newJString(resourceGroupName))
  add(query_574290, "api-version", newJString(apiVersion))
  add(path_574289, "managedNetworkName", newJString(managedNetworkName))
  add(path_574289, "subscriptionId", newJString(subscriptionId))
  add(query_574290, "$top", newJInt(Top))
  add(query_574290, "$skiptoken", newJString(Skiptoken))
  result = call_574288.call(path_574289, query_574290, nil, nil, nil)

var managedNetworkGroupsListByManagedNetwork* = Call_ManagedNetworkGroupsListByManagedNetwork_574278(
    name: "managedNetworkGroupsListByManagedNetwork", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}/managedNetworkGroups",
    validator: validate_ManagedNetworkGroupsListByManagedNetwork_574279, base: "",
    url: url_ManagedNetworkGroupsListByManagedNetwork_574280,
    schemes: {Scheme.Https})
type
  Call_ManagedNetworkGroupsCreateOrUpdate_574303 = ref object of OpenApiRestCall_573657
proc url_ManagedNetworkGroupsCreateOrUpdate_574305(protocol: Scheme; host: string;
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

proc validate_ManagedNetworkGroupsCreateOrUpdate_574304(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put ManagedNetworkGroups operation creates or updates a Managed Network Group resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  ##   managedNetworkGroupName: JString (required)
  ##                          : The name of the Managed Network Group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574306 = path.getOrDefault("resourceGroupName")
  valid_574306 = validateParameter(valid_574306, JString, required = true,
                                 default = nil)
  if valid_574306 != nil:
    section.add "resourceGroupName", valid_574306
  var valid_574307 = path.getOrDefault("managedNetworkName")
  valid_574307 = validateParameter(valid_574307, JString, required = true,
                                 default = nil)
  if valid_574307 != nil:
    section.add "managedNetworkName", valid_574307
  var valid_574308 = path.getOrDefault("managedNetworkGroupName")
  valid_574308 = validateParameter(valid_574308, JString, required = true,
                                 default = nil)
  if valid_574308 != nil:
    section.add "managedNetworkGroupName", valid_574308
  var valid_574309 = path.getOrDefault("subscriptionId")
  valid_574309 = validateParameter(valid_574309, JString, required = true,
                                 default = nil)
  if valid_574309 != nil:
    section.add "subscriptionId", valid_574309
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574310 = query.getOrDefault("api-version")
  valid_574310 = validateParameter(valid_574310, JString, required = true,
                                 default = nil)
  if valid_574310 != nil:
    section.add "api-version", valid_574310
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

proc call*(call_574312: Call_ManagedNetworkGroupsCreateOrUpdate_574303;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put ManagedNetworkGroups operation creates or updates a Managed Network Group resource
  ## 
  let valid = call_574312.validator(path, query, header, formData, body)
  let scheme = call_574312.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574312.url(scheme.get, call_574312.host, call_574312.base,
                         call_574312.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574312, url, valid)

proc call*(call_574313: Call_ManagedNetworkGroupsCreateOrUpdate_574303;
          resourceGroupName: string; apiVersion: string; managedNetworkName: string;
          managedNetworkGroupName: string; subscriptionId: string;
          managedNetworkGroup: JsonNode): Recallable =
  ## managedNetworkGroupsCreateOrUpdate
  ## The Put ManagedNetworkGroups operation creates or updates a Managed Network Group resource
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  ##   managedNetworkGroupName: string (required)
  ##                          : The name of the Managed Network Group.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   managedNetworkGroup: JObject (required)
  ##                      : Parameters supplied to the create/update a Managed Network Group resource
  var path_574314 = newJObject()
  var query_574315 = newJObject()
  var body_574316 = newJObject()
  add(path_574314, "resourceGroupName", newJString(resourceGroupName))
  add(query_574315, "api-version", newJString(apiVersion))
  add(path_574314, "managedNetworkName", newJString(managedNetworkName))
  add(path_574314, "managedNetworkGroupName", newJString(managedNetworkGroupName))
  add(path_574314, "subscriptionId", newJString(subscriptionId))
  if managedNetworkGroup != nil:
    body_574316 = managedNetworkGroup
  result = call_574313.call(path_574314, query_574315, nil, nil, body_574316)

var managedNetworkGroupsCreateOrUpdate* = Call_ManagedNetworkGroupsCreateOrUpdate_574303(
    name: "managedNetworkGroupsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}/managedNetworkGroups/{managedNetworkGroupName}",
    validator: validate_ManagedNetworkGroupsCreateOrUpdate_574304, base: "",
    url: url_ManagedNetworkGroupsCreateOrUpdate_574305, schemes: {Scheme.Https})
type
  Call_ManagedNetworkGroupsGet_574291 = ref object of OpenApiRestCall_573657
proc url_ManagedNetworkGroupsGet_574293(protocol: Scheme; host: string; base: string;
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

proc validate_ManagedNetworkGroupsGet_574292(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get ManagedNetworkGroups operation gets a Managed Network Group specified by the resource group, Managed Network name, and group name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  ##   managedNetworkGroupName: JString (required)
  ##                          : The name of the Managed Network Group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574294 = path.getOrDefault("resourceGroupName")
  valid_574294 = validateParameter(valid_574294, JString, required = true,
                                 default = nil)
  if valid_574294 != nil:
    section.add "resourceGroupName", valid_574294
  var valid_574295 = path.getOrDefault("managedNetworkName")
  valid_574295 = validateParameter(valid_574295, JString, required = true,
                                 default = nil)
  if valid_574295 != nil:
    section.add "managedNetworkName", valid_574295
  var valid_574296 = path.getOrDefault("managedNetworkGroupName")
  valid_574296 = validateParameter(valid_574296, JString, required = true,
                                 default = nil)
  if valid_574296 != nil:
    section.add "managedNetworkGroupName", valid_574296
  var valid_574297 = path.getOrDefault("subscriptionId")
  valid_574297 = validateParameter(valid_574297, JString, required = true,
                                 default = nil)
  if valid_574297 != nil:
    section.add "subscriptionId", valid_574297
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574298 = query.getOrDefault("api-version")
  valid_574298 = validateParameter(valid_574298, JString, required = true,
                                 default = nil)
  if valid_574298 != nil:
    section.add "api-version", valid_574298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574299: Call_ManagedNetworkGroupsGet_574291; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get ManagedNetworkGroups operation gets a Managed Network Group specified by the resource group, Managed Network name, and group name
  ## 
  let valid = call_574299.validator(path, query, header, formData, body)
  let scheme = call_574299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574299.url(scheme.get, call_574299.host, call_574299.base,
                         call_574299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574299, url, valid)

proc call*(call_574300: Call_ManagedNetworkGroupsGet_574291;
          resourceGroupName: string; apiVersion: string; managedNetworkName: string;
          managedNetworkGroupName: string; subscriptionId: string): Recallable =
  ## managedNetworkGroupsGet
  ## The Get ManagedNetworkGroups operation gets a Managed Network Group specified by the resource group, Managed Network name, and group name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  ##   managedNetworkGroupName: string (required)
  ##                          : The name of the Managed Network Group.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574301 = newJObject()
  var query_574302 = newJObject()
  add(path_574301, "resourceGroupName", newJString(resourceGroupName))
  add(query_574302, "api-version", newJString(apiVersion))
  add(path_574301, "managedNetworkName", newJString(managedNetworkName))
  add(path_574301, "managedNetworkGroupName", newJString(managedNetworkGroupName))
  add(path_574301, "subscriptionId", newJString(subscriptionId))
  result = call_574300.call(path_574301, query_574302, nil, nil, nil)

var managedNetworkGroupsGet* = Call_ManagedNetworkGroupsGet_574291(
    name: "managedNetworkGroupsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}/managedNetworkGroups/{managedNetworkGroupName}",
    validator: validate_ManagedNetworkGroupsGet_574292, base: "",
    url: url_ManagedNetworkGroupsGet_574293, schemes: {Scheme.Https})
type
  Call_ManagedNetworkGroupsDelete_574317 = ref object of OpenApiRestCall_573657
proc url_ManagedNetworkGroupsDelete_574319(protocol: Scheme; host: string;
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

proc validate_ManagedNetworkGroupsDelete_574318(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Delete ManagedNetworkGroups operation deletes a Managed Network Group specified by the resource group, Managed Network name, and group name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  ##   managedNetworkGroupName: JString (required)
  ##                          : The name of the Managed Network Group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574320 = path.getOrDefault("resourceGroupName")
  valid_574320 = validateParameter(valid_574320, JString, required = true,
                                 default = nil)
  if valid_574320 != nil:
    section.add "resourceGroupName", valid_574320
  var valid_574321 = path.getOrDefault("managedNetworkName")
  valid_574321 = validateParameter(valid_574321, JString, required = true,
                                 default = nil)
  if valid_574321 != nil:
    section.add "managedNetworkName", valid_574321
  var valid_574322 = path.getOrDefault("managedNetworkGroupName")
  valid_574322 = validateParameter(valid_574322, JString, required = true,
                                 default = nil)
  if valid_574322 != nil:
    section.add "managedNetworkGroupName", valid_574322
  var valid_574323 = path.getOrDefault("subscriptionId")
  valid_574323 = validateParameter(valid_574323, JString, required = true,
                                 default = nil)
  if valid_574323 != nil:
    section.add "subscriptionId", valid_574323
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574324 = query.getOrDefault("api-version")
  valid_574324 = validateParameter(valid_574324, JString, required = true,
                                 default = nil)
  if valid_574324 != nil:
    section.add "api-version", valid_574324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574325: Call_ManagedNetworkGroupsDelete_574317; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Delete ManagedNetworkGroups operation deletes a Managed Network Group specified by the resource group, Managed Network name, and group name
  ## 
  let valid = call_574325.validator(path, query, header, formData, body)
  let scheme = call_574325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574325.url(scheme.get, call_574325.host, call_574325.base,
                         call_574325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574325, url, valid)

proc call*(call_574326: Call_ManagedNetworkGroupsDelete_574317;
          resourceGroupName: string; apiVersion: string; managedNetworkName: string;
          managedNetworkGroupName: string; subscriptionId: string): Recallable =
  ## managedNetworkGroupsDelete
  ## The Delete ManagedNetworkGroups operation deletes a Managed Network Group specified by the resource group, Managed Network name, and group name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  ##   managedNetworkGroupName: string (required)
  ##                          : The name of the Managed Network Group.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_574327 = newJObject()
  var query_574328 = newJObject()
  add(path_574327, "resourceGroupName", newJString(resourceGroupName))
  add(query_574328, "api-version", newJString(apiVersion))
  add(path_574327, "managedNetworkName", newJString(managedNetworkName))
  add(path_574327, "managedNetworkGroupName", newJString(managedNetworkGroupName))
  add(path_574327, "subscriptionId", newJString(subscriptionId))
  result = call_574326.call(path_574327, query_574328, nil, nil, nil)

var managedNetworkGroupsDelete* = Call_ManagedNetworkGroupsDelete_574317(
    name: "managedNetworkGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}/managedNetworkGroups/{managedNetworkGroupName}",
    validator: validate_ManagedNetworkGroupsDelete_574318, base: "",
    url: url_ManagedNetworkGroupsDelete_574319, schemes: {Scheme.Https})
type
  Call_ManagedNetworkPeeringPoliciesListByManagedNetwork_574329 = ref object of OpenApiRestCall_573657
proc url_ManagedNetworkPeeringPoliciesListByManagedNetwork_574331(
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

proc validate_ManagedNetworkPeeringPoliciesListByManagedNetwork_574330(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## The ListByManagedNetwork PeeringPolicies operation retrieves all the Managed Network Peering Policies in a specified Managed Network, in a paginated format.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574332 = path.getOrDefault("resourceGroupName")
  valid_574332 = validateParameter(valid_574332, JString, required = true,
                                 default = nil)
  if valid_574332 != nil:
    section.add "resourceGroupName", valid_574332
  var valid_574333 = path.getOrDefault("managedNetworkName")
  valid_574333 = validateParameter(valid_574333, JString, required = true,
                                 default = nil)
  if valid_574333 != nil:
    section.add "managedNetworkName", valid_574333
  var valid_574334 = path.getOrDefault("subscriptionId")
  valid_574334 = validateParameter(valid_574334, JString, required = true,
                                 default = nil)
  if valid_574334 != nil:
    section.add "subscriptionId", valid_574334
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
  var valid_574335 = query.getOrDefault("api-version")
  valid_574335 = validateParameter(valid_574335, JString, required = true,
                                 default = nil)
  if valid_574335 != nil:
    section.add "api-version", valid_574335
  var valid_574336 = query.getOrDefault("$top")
  valid_574336 = validateParameter(valid_574336, JInt, required = false, default = nil)
  if valid_574336 != nil:
    section.add "$top", valid_574336
  var valid_574337 = query.getOrDefault("$skiptoken")
  valid_574337 = validateParameter(valid_574337, JString, required = false,
                                 default = nil)
  if valid_574337 != nil:
    section.add "$skiptoken", valid_574337
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574338: Call_ManagedNetworkPeeringPoliciesListByManagedNetwork_574329;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The ListByManagedNetwork PeeringPolicies operation retrieves all the Managed Network Peering Policies in a specified Managed Network, in a paginated format.
  ## 
  let valid = call_574338.validator(path, query, header, formData, body)
  let scheme = call_574338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574338.url(scheme.get, call_574338.host, call_574338.base,
                         call_574338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574338, url, valid)

proc call*(call_574339: Call_ManagedNetworkPeeringPoliciesListByManagedNetwork_574329;
          resourceGroupName: string; apiVersion: string; managedNetworkName: string;
          subscriptionId: string; Top: int = 0; Skiptoken: string = ""): Recallable =
  ## managedNetworkPeeringPoliciesListByManagedNetwork
  ## The ListByManagedNetwork PeeringPolicies operation retrieves all the Managed Network Peering Policies in a specified Managed Network, in a paginated format.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : May be used to limit the number of results in a page for list queries.
  ##   Skiptoken: string
  ##            : Skiptoken is only used if a previous operation returned a partial result. If a previous response contains a nextLink element, the value of the nextLink element will include a skiptoken parameter that specifies a starting point to use for subsequent calls.
  var path_574340 = newJObject()
  var query_574341 = newJObject()
  add(path_574340, "resourceGroupName", newJString(resourceGroupName))
  add(query_574341, "api-version", newJString(apiVersion))
  add(path_574340, "managedNetworkName", newJString(managedNetworkName))
  add(path_574340, "subscriptionId", newJString(subscriptionId))
  add(query_574341, "$top", newJInt(Top))
  add(query_574341, "$skiptoken", newJString(Skiptoken))
  result = call_574339.call(path_574340, query_574341, nil, nil, nil)

var managedNetworkPeeringPoliciesListByManagedNetwork* = Call_ManagedNetworkPeeringPoliciesListByManagedNetwork_574329(
    name: "managedNetworkPeeringPoliciesListByManagedNetwork",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}/managedNetworkPeeringPolicies",
    validator: validate_ManagedNetworkPeeringPoliciesListByManagedNetwork_574330,
    base: "", url: url_ManagedNetworkPeeringPoliciesListByManagedNetwork_574331,
    schemes: {Scheme.Https})
type
  Call_ManagedNetworkPeeringPoliciesCreateOrUpdate_574354 = ref object of OpenApiRestCall_573657
proc url_ManagedNetworkPeeringPoliciesCreateOrUpdate_574356(protocol: Scheme;
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

proc validate_ManagedNetworkPeeringPoliciesCreateOrUpdate_574355(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Put ManagedNetworkPeeringPolicies operation creates/updates a new Managed Network Peering Policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   managedNetworkPeeringPolicyName: JString (required)
  ##                                  : The name of the Managed Network Peering Policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574357 = path.getOrDefault("resourceGroupName")
  valid_574357 = validateParameter(valid_574357, JString, required = true,
                                 default = nil)
  if valid_574357 != nil:
    section.add "resourceGroupName", valid_574357
  var valid_574358 = path.getOrDefault("managedNetworkName")
  valid_574358 = validateParameter(valid_574358, JString, required = true,
                                 default = nil)
  if valid_574358 != nil:
    section.add "managedNetworkName", valid_574358
  var valid_574359 = path.getOrDefault("subscriptionId")
  valid_574359 = validateParameter(valid_574359, JString, required = true,
                                 default = nil)
  if valid_574359 != nil:
    section.add "subscriptionId", valid_574359
  var valid_574360 = path.getOrDefault("managedNetworkPeeringPolicyName")
  valid_574360 = validateParameter(valid_574360, JString, required = true,
                                 default = nil)
  if valid_574360 != nil:
    section.add "managedNetworkPeeringPolicyName", valid_574360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574361 = query.getOrDefault("api-version")
  valid_574361 = validateParameter(valid_574361, JString, required = true,
                                 default = nil)
  if valid_574361 != nil:
    section.add "api-version", valid_574361
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

proc call*(call_574363: Call_ManagedNetworkPeeringPoliciesCreateOrUpdate_574354;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Put ManagedNetworkPeeringPolicies operation creates/updates a new Managed Network Peering Policy
  ## 
  let valid = call_574363.validator(path, query, header, formData, body)
  let scheme = call_574363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574363.url(scheme.get, call_574363.host, call_574363.base,
                         call_574363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574363, url, valid)

proc call*(call_574364: Call_ManagedNetworkPeeringPoliciesCreateOrUpdate_574354;
          managedNetworkPolicy: JsonNode; resourceGroupName: string;
          apiVersion: string; managedNetworkName: string; subscriptionId: string;
          managedNetworkPeeringPolicyName: string): Recallable =
  ## managedNetworkPeeringPoliciesCreateOrUpdate
  ## The Put ManagedNetworkPeeringPolicies operation creates/updates a new Managed Network Peering Policy
  ##   managedNetworkPolicy: JObject (required)
  ##                       : Parameters supplied to create/update a Managed Network Peering Policy
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   managedNetworkPeeringPolicyName: string (required)
  ##                                  : The name of the Managed Network Peering Policy.
  var path_574365 = newJObject()
  var query_574366 = newJObject()
  var body_574367 = newJObject()
  if managedNetworkPolicy != nil:
    body_574367 = managedNetworkPolicy
  add(path_574365, "resourceGroupName", newJString(resourceGroupName))
  add(query_574366, "api-version", newJString(apiVersion))
  add(path_574365, "managedNetworkName", newJString(managedNetworkName))
  add(path_574365, "subscriptionId", newJString(subscriptionId))
  add(path_574365, "managedNetworkPeeringPolicyName",
      newJString(managedNetworkPeeringPolicyName))
  result = call_574364.call(path_574365, query_574366, nil, nil, body_574367)

var managedNetworkPeeringPoliciesCreateOrUpdate* = Call_ManagedNetworkPeeringPoliciesCreateOrUpdate_574354(
    name: "managedNetworkPeeringPoliciesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}/managedNetworkPeeringPolicies/{managedNetworkPeeringPolicyName}",
    validator: validate_ManagedNetworkPeeringPoliciesCreateOrUpdate_574355,
    base: "", url: url_ManagedNetworkPeeringPoliciesCreateOrUpdate_574356,
    schemes: {Scheme.Https})
type
  Call_ManagedNetworkPeeringPoliciesGet_574342 = ref object of OpenApiRestCall_573657
proc url_ManagedNetworkPeeringPoliciesGet_574344(protocol: Scheme; host: string;
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

proc validate_ManagedNetworkPeeringPoliciesGet_574343(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get ManagedNetworkPeeringPolicies operation gets a Managed Network Peering Policy resource, specified by the  resource group, Managed Network name, and peering policy name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   managedNetworkPeeringPolicyName: JString (required)
  ##                                  : The name of the Managed Network Peering Policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574345 = path.getOrDefault("resourceGroupName")
  valid_574345 = validateParameter(valid_574345, JString, required = true,
                                 default = nil)
  if valid_574345 != nil:
    section.add "resourceGroupName", valid_574345
  var valid_574346 = path.getOrDefault("managedNetworkName")
  valid_574346 = validateParameter(valid_574346, JString, required = true,
                                 default = nil)
  if valid_574346 != nil:
    section.add "managedNetworkName", valid_574346
  var valid_574347 = path.getOrDefault("subscriptionId")
  valid_574347 = validateParameter(valid_574347, JString, required = true,
                                 default = nil)
  if valid_574347 != nil:
    section.add "subscriptionId", valid_574347
  var valid_574348 = path.getOrDefault("managedNetworkPeeringPolicyName")
  valid_574348 = validateParameter(valid_574348, JString, required = true,
                                 default = nil)
  if valid_574348 != nil:
    section.add "managedNetworkPeeringPolicyName", valid_574348
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574349 = query.getOrDefault("api-version")
  valid_574349 = validateParameter(valid_574349, JString, required = true,
                                 default = nil)
  if valid_574349 != nil:
    section.add "api-version", valid_574349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574350: Call_ManagedNetworkPeeringPoliciesGet_574342;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Get ManagedNetworkPeeringPolicies operation gets a Managed Network Peering Policy resource, specified by the  resource group, Managed Network name, and peering policy name
  ## 
  let valid = call_574350.validator(path, query, header, formData, body)
  let scheme = call_574350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574350.url(scheme.get, call_574350.host, call_574350.base,
                         call_574350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574350, url, valid)

proc call*(call_574351: Call_ManagedNetworkPeeringPoliciesGet_574342;
          resourceGroupName: string; apiVersion: string; managedNetworkName: string;
          subscriptionId: string; managedNetworkPeeringPolicyName: string): Recallable =
  ## managedNetworkPeeringPoliciesGet
  ## The Get ManagedNetworkPeeringPolicies operation gets a Managed Network Peering Policy resource, specified by the  resource group, Managed Network name, and peering policy name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   managedNetworkPeeringPolicyName: string (required)
  ##                                  : The name of the Managed Network Peering Policy.
  var path_574352 = newJObject()
  var query_574353 = newJObject()
  add(path_574352, "resourceGroupName", newJString(resourceGroupName))
  add(query_574353, "api-version", newJString(apiVersion))
  add(path_574352, "managedNetworkName", newJString(managedNetworkName))
  add(path_574352, "subscriptionId", newJString(subscriptionId))
  add(path_574352, "managedNetworkPeeringPolicyName",
      newJString(managedNetworkPeeringPolicyName))
  result = call_574351.call(path_574352, query_574353, nil, nil, nil)

var managedNetworkPeeringPoliciesGet* = Call_ManagedNetworkPeeringPoliciesGet_574342(
    name: "managedNetworkPeeringPoliciesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}/managedNetworkPeeringPolicies/{managedNetworkPeeringPolicyName}",
    validator: validate_ManagedNetworkPeeringPoliciesGet_574343, base: "",
    url: url_ManagedNetworkPeeringPoliciesGet_574344, schemes: {Scheme.Https})
type
  Call_ManagedNetworkPeeringPoliciesDelete_574368 = ref object of OpenApiRestCall_573657
proc url_ManagedNetworkPeeringPoliciesDelete_574370(protocol: Scheme; host: string;
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

proc validate_ManagedNetworkPeeringPoliciesDelete_574369(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## The Delete ManagedNetworkPeeringPolicies operation deletes a Managed Network Peering Policy, specified by the  resource group, Managed Network name, and peering policy name
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   managedNetworkName: JString (required)
  ##                     : The name of the Managed Network.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   managedNetworkPeeringPolicyName: JString (required)
  ##                                  : The name of the Managed Network Peering Policy.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_574371 = path.getOrDefault("resourceGroupName")
  valid_574371 = validateParameter(valid_574371, JString, required = true,
                                 default = nil)
  if valid_574371 != nil:
    section.add "resourceGroupName", valid_574371
  var valid_574372 = path.getOrDefault("managedNetworkName")
  valid_574372 = validateParameter(valid_574372, JString, required = true,
                                 default = nil)
  if valid_574372 != nil:
    section.add "managedNetworkName", valid_574372
  var valid_574373 = path.getOrDefault("subscriptionId")
  valid_574373 = validateParameter(valid_574373, JString, required = true,
                                 default = nil)
  if valid_574373 != nil:
    section.add "subscriptionId", valid_574373
  var valid_574374 = path.getOrDefault("managedNetworkPeeringPolicyName")
  valid_574374 = validateParameter(valid_574374, JString, required = true,
                                 default = nil)
  if valid_574374 != nil:
    section.add "managedNetworkPeeringPolicyName", valid_574374
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574375 = query.getOrDefault("api-version")
  valid_574375 = validateParameter(valid_574375, JString, required = true,
                                 default = nil)
  if valid_574375 != nil:
    section.add "api-version", valid_574375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574376: Call_ManagedNetworkPeeringPoliciesDelete_574368;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## The Delete ManagedNetworkPeeringPolicies operation deletes a Managed Network Peering Policy, specified by the  resource group, Managed Network name, and peering policy name
  ## 
  let valid = call_574376.validator(path, query, header, formData, body)
  let scheme = call_574376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574376.url(scheme.get, call_574376.host, call_574376.base,
                         call_574376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574376, url, valid)

proc call*(call_574377: Call_ManagedNetworkPeeringPoliciesDelete_574368;
          resourceGroupName: string; apiVersion: string; managedNetworkName: string;
          subscriptionId: string; managedNetworkPeeringPolicyName: string): Recallable =
  ## managedNetworkPeeringPoliciesDelete
  ## The Delete ManagedNetworkPeeringPolicies operation deletes a Managed Network Peering Policy, specified by the  resource group, Managed Network name, and peering policy name
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   managedNetworkName: string (required)
  ##                     : The name of the Managed Network.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   managedNetworkPeeringPolicyName: string (required)
  ##                                  : The name of the Managed Network Peering Policy.
  var path_574378 = newJObject()
  var query_574379 = newJObject()
  add(path_574378, "resourceGroupName", newJString(resourceGroupName))
  add(query_574379, "api-version", newJString(apiVersion))
  add(path_574378, "managedNetworkName", newJString(managedNetworkName))
  add(path_574378, "subscriptionId", newJString(subscriptionId))
  add(path_574378, "managedNetworkPeeringPolicyName",
      newJString(managedNetworkPeeringPolicyName))
  result = call_574377.call(path_574378, query_574379, nil, nil, nil)

var managedNetworkPeeringPoliciesDelete* = Call_ManagedNetworkPeeringPoliciesDelete_574368(
    name: "managedNetworkPeeringPoliciesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetwork/managedNetworks/{managedNetworkName}/managedNetworkPeeringPolicies/{managedNetworkPeeringPolicyName}",
    validator: validate_ManagedNetworkPeeringPoliciesDelete_574369, base: "",
    url: url_ManagedNetworkPeeringPoliciesDelete_574370, schemes: {Scheme.Https})
type
  Call_ScopeAssignmentsList_574380 = ref object of OpenApiRestCall_573657
proc url_ScopeAssignmentsList_574382(protocol: Scheme; host: string; base: string;
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

proc validate_ScopeAssignmentsList_574381(path: JsonNode; query: JsonNode;
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
  var valid_574383 = path.getOrDefault("scope")
  valid_574383 = validateParameter(valid_574383, JString, required = true,
                                 default = nil)
  if valid_574383 != nil:
    section.add "scope", valid_574383
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574384 = query.getOrDefault("api-version")
  valid_574384 = validateParameter(valid_574384, JString, required = true,
                                 default = nil)
  if valid_574384 != nil:
    section.add "api-version", valid_574384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574385: Call_ScopeAssignmentsList_574380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified scope assignment.
  ## 
  let valid = call_574385.validator(path, query, header, formData, body)
  let scheme = call_574385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574385.url(scheme.get, call_574385.host, call_574385.base,
                         call_574385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574385, url, valid)

proc call*(call_574386: Call_ScopeAssignmentsList_574380; apiVersion: string;
          scope: string): Recallable =
  ## scopeAssignmentsList
  ## Get the specified scope assignment.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   scope: string (required)
  ##        : The base resource of the scope assignment.
  var path_574387 = newJObject()
  var query_574388 = newJObject()
  add(query_574388, "api-version", newJString(apiVersion))
  add(path_574387, "scope", newJString(scope))
  result = call_574386.call(path_574387, query_574388, nil, nil, nil)

var scopeAssignmentsList* = Call_ScopeAssignmentsList_574380(
    name: "scopeAssignmentsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.ManagedNetwork/scopeAssignments",
    validator: validate_ScopeAssignmentsList_574381, base: "",
    url: url_ScopeAssignmentsList_574382, schemes: {Scheme.Https})
type
  Call_ScopeAssignmentsCreateOrUpdate_574399 = ref object of OpenApiRestCall_573657
proc url_ScopeAssignmentsCreateOrUpdate_574401(protocol: Scheme; host: string;
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

proc validate_ScopeAssignmentsCreateOrUpdate_574400(path: JsonNode;
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
  var valid_574402 = path.getOrDefault("scopeAssignmentName")
  valid_574402 = validateParameter(valid_574402, JString, required = true,
                                 default = nil)
  if valid_574402 != nil:
    section.add "scopeAssignmentName", valid_574402
  var valid_574403 = path.getOrDefault("scope")
  valid_574403 = validateParameter(valid_574403, JString, required = true,
                                 default = nil)
  if valid_574403 != nil:
    section.add "scope", valid_574403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574404 = query.getOrDefault("api-version")
  valid_574404 = validateParameter(valid_574404, JString, required = true,
                                 default = nil)
  if valid_574404 != nil:
    section.add "api-version", valid_574404
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

proc call*(call_574406: Call_ScopeAssignmentsCreateOrUpdate_574399; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a scope assignment.
  ## 
  let valid = call_574406.validator(path, query, header, formData, body)
  let scheme = call_574406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574406.url(scheme.get, call_574406.host, call_574406.base,
                         call_574406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574406, url, valid)

proc call*(call_574407: Call_ScopeAssignmentsCreateOrUpdate_574399;
          apiVersion: string; scopeAssignmentName: string; parameters: JsonNode;
          scope: string): Recallable =
  ## scopeAssignmentsCreateOrUpdate
  ## Creates a scope assignment.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   scopeAssignmentName: string (required)
  ##                      : The name of the scope assignment to create.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the specify which Managed Network this scope is being assigned
  ##   scope: string (required)
  ##        : The base resource of the scope assignment to create. The scope can be any REST resource instance. For example, use '/subscriptions/{subscription-id}/' for a subscription, '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}' for a resource group, and 
  ## '/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/{resource-provider}/{resource-type}/{resource-name}' for a resource.
  var path_574408 = newJObject()
  var query_574409 = newJObject()
  var body_574410 = newJObject()
  add(query_574409, "api-version", newJString(apiVersion))
  add(path_574408, "scopeAssignmentName", newJString(scopeAssignmentName))
  if parameters != nil:
    body_574410 = parameters
  add(path_574408, "scope", newJString(scope))
  result = call_574407.call(path_574408, query_574409, nil, nil, body_574410)

var scopeAssignmentsCreateOrUpdate* = Call_ScopeAssignmentsCreateOrUpdate_574399(
    name: "scopeAssignmentsCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedNetwork/scopeAssignments/{scopeAssignmentName}",
    validator: validate_ScopeAssignmentsCreateOrUpdate_574400, base: "",
    url: url_ScopeAssignmentsCreateOrUpdate_574401, schemes: {Scheme.Https})
type
  Call_ScopeAssignmentsGet_574389 = ref object of OpenApiRestCall_573657
proc url_ScopeAssignmentsGet_574391(protocol: Scheme; host: string; base: string;
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

proc validate_ScopeAssignmentsGet_574390(path: JsonNode; query: JsonNode;
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
  var valid_574392 = path.getOrDefault("scopeAssignmentName")
  valid_574392 = validateParameter(valid_574392, JString, required = true,
                                 default = nil)
  if valid_574392 != nil:
    section.add "scopeAssignmentName", valid_574392
  var valid_574393 = path.getOrDefault("scope")
  valid_574393 = validateParameter(valid_574393, JString, required = true,
                                 default = nil)
  if valid_574393 != nil:
    section.add "scope", valid_574393
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574394 = query.getOrDefault("api-version")
  valid_574394 = validateParameter(valid_574394, JString, required = true,
                                 default = nil)
  if valid_574394 != nil:
    section.add "api-version", valid_574394
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574395: Call_ScopeAssignmentsGet_574389; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the specified scope assignment.
  ## 
  let valid = call_574395.validator(path, query, header, formData, body)
  let scheme = call_574395.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574395.url(scheme.get, call_574395.host, call_574395.base,
                         call_574395.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574395, url, valid)

proc call*(call_574396: Call_ScopeAssignmentsGet_574389; apiVersion: string;
          scopeAssignmentName: string; scope: string): Recallable =
  ## scopeAssignmentsGet
  ## Get the specified scope assignment.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   scopeAssignmentName: string (required)
  ##                      : The name of the scope assignment to get.
  ##   scope: string (required)
  ##        : The base resource of the scope assignment.
  var path_574397 = newJObject()
  var query_574398 = newJObject()
  add(query_574398, "api-version", newJString(apiVersion))
  add(path_574397, "scopeAssignmentName", newJString(scopeAssignmentName))
  add(path_574397, "scope", newJString(scope))
  result = call_574396.call(path_574397, query_574398, nil, nil, nil)

var scopeAssignmentsGet* = Call_ScopeAssignmentsGet_574389(
    name: "scopeAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedNetwork/scopeAssignments/{scopeAssignmentName}",
    validator: validate_ScopeAssignmentsGet_574390, base: "",
    url: url_ScopeAssignmentsGet_574391, schemes: {Scheme.Https})
type
  Call_ScopeAssignmentsDelete_574411 = ref object of OpenApiRestCall_573657
proc url_ScopeAssignmentsDelete_574413(protocol: Scheme; host: string; base: string;
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

proc validate_ScopeAssignmentsDelete_574412(path: JsonNode; query: JsonNode;
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
  var valid_574414 = path.getOrDefault("scopeAssignmentName")
  valid_574414 = validateParameter(valid_574414, JString, required = true,
                                 default = nil)
  if valid_574414 != nil:
    section.add "scopeAssignmentName", valid_574414
  var valid_574415 = path.getOrDefault("scope")
  valid_574415 = validateParameter(valid_574415, JString, required = true,
                                 default = nil)
  if valid_574415 != nil:
    section.add "scope", valid_574415
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574416 = query.getOrDefault("api-version")
  valid_574416 = validateParameter(valid_574416, JString, required = true,
                                 default = nil)
  if valid_574416 != nil:
    section.add "api-version", valid_574416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574417: Call_ScopeAssignmentsDelete_574411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a scope assignment.
  ## 
  let valid = call_574417.validator(path, query, header, formData, body)
  let scheme = call_574417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574417.url(scheme.get, call_574417.host, call_574417.base,
                         call_574417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574417, url, valid)

proc call*(call_574418: Call_ScopeAssignmentsDelete_574411; apiVersion: string;
          scopeAssignmentName: string; scope: string): Recallable =
  ## scopeAssignmentsDelete
  ## Deletes a scope assignment.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   scopeAssignmentName: string (required)
  ##                      : The name of the scope assignment to delete.
  ##   scope: string (required)
  ##        : The scope of the scope assignment to delete.
  var path_574419 = newJObject()
  var query_574420 = newJObject()
  add(query_574420, "api-version", newJString(apiVersion))
  add(path_574419, "scopeAssignmentName", newJString(scopeAssignmentName))
  add(path_574419, "scope", newJString(scope))
  result = call_574418.call(path_574419, query_574420, nil, nil, nil)

var scopeAssignmentsDelete* = Call_ScopeAssignmentsDelete_574411(
    name: "scopeAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{scope}/providers/Microsoft.ManagedNetwork/scopeAssignments/{scopeAssignmentName}",
    validator: validate_ScopeAssignmentsDelete_574412, base: "",
    url: url_ScopeAssignmentsDelete_574413, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
