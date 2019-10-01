
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Power BI Embedded Management Client
## version: 2016-01-29
## termsOfService: (not provided)
## license: (not provided)
## 
## Client to manage your Power BI Embedded workspace collections and retrieve workspaces.
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

  OpenApiRestCall_567642 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567642](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567642): Option[Scheme] {.used.} =
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
  macServiceName = "powerbiembedded"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GetAvailableOperations_567864 = ref object of OpenApiRestCall_567642
proc url_GetAvailableOperations_567866(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GetAvailableOperations_567865(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Indicates which operations can be performed by the Power BI Resource Provider.
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
  var valid_568025 = query.getOrDefault("api-version")
  valid_568025 = validateParameter(valid_568025, JString, required = true,
                                 default = nil)
  if valid_568025 != nil:
    section.add "api-version", valid_568025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568048: Call_GetAvailableOperations_567864; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Indicates which operations can be performed by the Power BI Resource Provider.
  ## 
  let valid = call_568048.validator(path, query, header, formData, body)
  let scheme = call_568048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568048.url(scheme.get, call_568048.host, call_568048.base,
                         call_568048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568048, url, valid)

proc call*(call_568119: Call_GetAvailableOperations_567864; apiVersion: string): Recallable =
  ## getAvailableOperations
  ## Indicates which operations can be performed by the Power BI Resource Provider.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  var query_568120 = newJObject()
  add(query_568120, "api-version", newJString(apiVersion))
  result = call_568119.call(nil, query_568120, nil, nil, nil)

var getAvailableOperations* = Call_GetAvailableOperations_567864(
    name: "getAvailableOperations", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/providers/Microsoft.PowerBI/operations",
    validator: validate_GetAvailableOperations_567865, base: "",
    url: url_GetAvailableOperations_567866, schemes: {Scheme.Https})
type
  Call_WorkspaceCollectionsCheckNameAvailability_568160 = ref object of OpenApiRestCall_567642
proc url_WorkspaceCollectionsCheckNameAvailability_568162(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "location" in path, "`location` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.PowerBI/locations/"),
               (kind: VariableSegment, value: "location"),
               (kind: ConstantSegment, value: "/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceCollectionsCheckNameAvailability_568161(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Verify the specified Power BI Workspace Collection name is valid and not already in use.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   location: JString (required)
  ##           : Azure location
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568177 = path.getOrDefault("subscriptionId")
  valid_568177 = validateParameter(valid_568177, JString, required = true,
                                 default = nil)
  if valid_568177 != nil:
    section.add "subscriptionId", valid_568177
  var valid_568178 = path.getOrDefault("location")
  valid_568178 = validateParameter(valid_568178, JString, required = true,
                                 default = nil)
  if valid_568178 != nil:
    section.add "location", valid_568178
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568179 = query.getOrDefault("api-version")
  valid_568179 = validateParameter(valid_568179, JString, required = true,
                                 default = nil)
  if valid_568179 != nil:
    section.add "api-version", valid_568179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Check name availability request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568181: Call_WorkspaceCollectionsCheckNameAvailability_568160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Verify the specified Power BI Workspace Collection name is valid and not already in use.
  ## 
  let valid = call_568181.validator(path, query, header, formData, body)
  let scheme = call_568181.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568181.url(scheme.get, call_568181.host, call_568181.base,
                         call_568181.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568181, url, valid)

proc call*(call_568182: Call_WorkspaceCollectionsCheckNameAvailability_568160;
          apiVersion: string; subscriptionId: string; body: JsonNode; location: string): Recallable =
  ## workspaceCollectionsCheckNameAvailability
  ## Verify the specified Power BI Workspace Collection name is valid and not already in use.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   body: JObject (required)
  ##       : Check name availability request
  ##   location: string (required)
  ##           : Azure location
  var path_568183 = newJObject()
  var query_568184 = newJObject()
  var body_568185 = newJObject()
  add(query_568184, "api-version", newJString(apiVersion))
  add(path_568183, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_568185 = body
  add(path_568183, "location", newJString(location))
  result = call_568182.call(path_568183, query_568184, nil, nil, body_568185)

var workspaceCollectionsCheckNameAvailability* = Call_WorkspaceCollectionsCheckNameAvailability_568160(
    name: "workspaceCollectionsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PowerBI/locations/{location}/checkNameAvailability",
    validator: validate_WorkspaceCollectionsCheckNameAvailability_568161,
    base: "", url: url_WorkspaceCollectionsCheckNameAvailability_568162,
    schemes: {Scheme.Https})
type
  Call_WorkspaceCollectionsListBySubscription_568186 = ref object of OpenApiRestCall_567642
proc url_WorkspaceCollectionsListBySubscription_568188(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBI/workspaceCollections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceCollectionsListBySubscription_568187(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all existing Power BI workspace collections in the specified subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568189 = path.getOrDefault("subscriptionId")
  valid_568189 = validateParameter(valid_568189, JString, required = true,
                                 default = nil)
  if valid_568189 != nil:
    section.add "subscriptionId", valid_568189
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568190 = query.getOrDefault("api-version")
  valid_568190 = validateParameter(valid_568190, JString, required = true,
                                 default = nil)
  if valid_568190 != nil:
    section.add "api-version", valid_568190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568191: Call_WorkspaceCollectionsListBySubscription_568186;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all existing Power BI workspace collections in the specified subscription.
  ## 
  let valid = call_568191.validator(path, query, header, formData, body)
  let scheme = call_568191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568191.url(scheme.get, call_568191.host, call_568191.base,
                         call_568191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568191, url, valid)

proc call*(call_568192: Call_WorkspaceCollectionsListBySubscription_568186;
          apiVersion: string; subscriptionId: string): Recallable =
  ## workspaceCollectionsListBySubscription
  ## Retrieves all existing Power BI workspace collections in the specified subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568193 = newJObject()
  var query_568194 = newJObject()
  add(query_568194, "api-version", newJString(apiVersion))
  add(path_568193, "subscriptionId", newJString(subscriptionId))
  result = call_568192.call(path_568193, query_568194, nil, nil, nil)

var workspaceCollectionsListBySubscription* = Call_WorkspaceCollectionsListBySubscription_568186(
    name: "workspaceCollectionsListBySubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.PowerBI/workspaceCollections",
    validator: validate_WorkspaceCollectionsListBySubscription_568187, base: "",
    url: url_WorkspaceCollectionsListBySubscription_568188,
    schemes: {Scheme.Https})
type
  Call_WorkspaceCollectionsMigrate_568195 = ref object of OpenApiRestCall_567642
proc url_WorkspaceCollectionsMigrate_568197(protocol: Scheme; host: string;
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
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/moveResources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceCollectionsMigrate_568196(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Migrates an existing Power BI Workspace Collection to a different resource group and/or subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568198 = path.getOrDefault("resourceGroupName")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "resourceGroupName", valid_568198
  var valid_568199 = path.getOrDefault("subscriptionId")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "subscriptionId", valid_568199
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568200 = query.getOrDefault("api-version")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "api-version", valid_568200
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Workspace migration request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568202: Call_WorkspaceCollectionsMigrate_568195; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Migrates an existing Power BI Workspace Collection to a different resource group and/or subscription.
  ## 
  let valid = call_568202.validator(path, query, header, formData, body)
  let scheme = call_568202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568202.url(scheme.get, call_568202.host, call_568202.base,
                         call_568202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568202, url, valid)

proc call*(call_568203: Call_WorkspaceCollectionsMigrate_568195;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          body: JsonNode): Recallable =
  ## workspaceCollectionsMigrate
  ## Migrates an existing Power BI Workspace Collection to a different resource group and/or subscription.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   body: JObject (required)
  ##       : Workspace migration request
  var path_568204 = newJObject()
  var query_568205 = newJObject()
  var body_568206 = newJObject()
  add(path_568204, "resourceGroupName", newJString(resourceGroupName))
  add(query_568205, "api-version", newJString(apiVersion))
  add(path_568204, "subscriptionId", newJString(subscriptionId))
  if body != nil:
    body_568206 = body
  result = call_568203.call(path_568204, query_568205, nil, nil, body_568206)

var workspaceCollectionsMigrate* = Call_WorkspaceCollectionsMigrate_568195(
    name: "workspaceCollectionsMigrate", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/moveResources",
    validator: validate_WorkspaceCollectionsMigrate_568196, base: "",
    url: url_WorkspaceCollectionsMigrate_568197, schemes: {Scheme.Https})
type
  Call_WorkspaceCollectionsListByResourceGroup_568207 = ref object of OpenApiRestCall_567642
proc url_WorkspaceCollectionsListByResourceGroup_568209(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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
        value: "/providers/Microsoft.PowerBI/workspaceCollections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceCollectionsListByResourceGroup_568208(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves all existing Power BI workspace collections in the specified resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568210 = path.getOrDefault("resourceGroupName")
  valid_568210 = validateParameter(valid_568210, JString, required = true,
                                 default = nil)
  if valid_568210 != nil:
    section.add "resourceGroupName", valid_568210
  var valid_568211 = path.getOrDefault("subscriptionId")
  valid_568211 = validateParameter(valid_568211, JString, required = true,
                                 default = nil)
  if valid_568211 != nil:
    section.add "subscriptionId", valid_568211
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568212 = query.getOrDefault("api-version")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "api-version", valid_568212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568213: Call_WorkspaceCollectionsListByResourceGroup_568207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves all existing Power BI workspace collections in the specified resource group.
  ## 
  let valid = call_568213.validator(path, query, header, formData, body)
  let scheme = call_568213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568213.url(scheme.get, call_568213.host, call_568213.base,
                         call_568213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568213, url, valid)

proc call*(call_568214: Call_WorkspaceCollectionsListByResourceGroup_568207;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## workspaceCollectionsListByResourceGroup
  ## Retrieves all existing Power BI workspace collections in the specified resource group.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568215 = newJObject()
  var query_568216 = newJObject()
  add(path_568215, "resourceGroupName", newJString(resourceGroupName))
  add(query_568216, "api-version", newJString(apiVersion))
  add(path_568215, "subscriptionId", newJString(subscriptionId))
  result = call_568214.call(path_568215, query_568216, nil, nil, nil)

var workspaceCollectionsListByResourceGroup* = Call_WorkspaceCollectionsListByResourceGroup_568207(
    name: "workspaceCollectionsListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBI/workspaceCollections",
    validator: validate_WorkspaceCollectionsListByResourceGroup_568208, base: "",
    url: url_WorkspaceCollectionsListByResourceGroup_568209,
    schemes: {Scheme.Https})
type
  Call_WorkspaceCollectionsCreate_568228 = ref object of OpenApiRestCall_567642
proc url_WorkspaceCollectionsCreate_568230(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceCollectionName" in path,
        "`workspaceCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBI/workspaceCollections/"),
               (kind: VariableSegment, value: "workspaceCollectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceCollectionsCreate_568229(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Power BI Workspace Collection with the specified properties. A Power BI Workspace Collection contains one or more workspaces, and can be used to provision keys that provide API access to those workspaces.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: JString (required)
  ##                          : Power BI Embedded Workspace Collection name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568231 = path.getOrDefault("resourceGroupName")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "resourceGroupName", valid_568231
  var valid_568232 = path.getOrDefault("subscriptionId")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "subscriptionId", valid_568232
  var valid_568233 = path.getOrDefault("workspaceCollectionName")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "workspaceCollectionName", valid_568233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568234 = query.getOrDefault("api-version")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "api-version", valid_568234
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Create workspace collection request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568236: Call_WorkspaceCollectionsCreate_568228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new Power BI Workspace Collection with the specified properties. A Power BI Workspace Collection contains one or more workspaces, and can be used to provision keys that provide API access to those workspaces.
  ## 
  let valid = call_568236.validator(path, query, header, formData, body)
  let scheme = call_568236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568236.url(scheme.get, call_568236.host, call_568236.base,
                         call_568236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568236, url, valid)

proc call*(call_568237: Call_WorkspaceCollectionsCreate_568228;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceCollectionName: string; body: JsonNode): Recallable =
  ## workspaceCollectionsCreate
  ## Creates a new Power BI Workspace Collection with the specified properties. A Power BI Workspace Collection contains one or more workspaces, and can be used to provision keys that provide API access to those workspaces.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: string (required)
  ##                          : Power BI Embedded Workspace Collection name
  ##   body: JObject (required)
  ##       : Create workspace collection request
  var path_568238 = newJObject()
  var query_568239 = newJObject()
  var body_568240 = newJObject()
  add(path_568238, "resourceGroupName", newJString(resourceGroupName))
  add(query_568239, "api-version", newJString(apiVersion))
  add(path_568238, "subscriptionId", newJString(subscriptionId))
  add(path_568238, "workspaceCollectionName", newJString(workspaceCollectionName))
  if body != nil:
    body_568240 = body
  result = call_568237.call(path_568238, query_568239, nil, nil, body_568240)

var workspaceCollectionsCreate* = Call_WorkspaceCollectionsCreate_568228(
    name: "workspaceCollectionsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBI/workspaceCollections/{workspaceCollectionName}",
    validator: validate_WorkspaceCollectionsCreate_568229, base: "",
    url: url_WorkspaceCollectionsCreate_568230, schemes: {Scheme.Https})
type
  Call_WorkspaceCollectionsGetByName_568217 = ref object of OpenApiRestCall_567642
proc url_WorkspaceCollectionsGetByName_568219(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceCollectionName" in path,
        "`workspaceCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBI/workspaceCollections/"),
               (kind: VariableSegment, value: "workspaceCollectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceCollectionsGetByName_568218(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves an existing Power BI Workspace Collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: JString (required)
  ##                          : Power BI Embedded Workspace Collection name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568220 = path.getOrDefault("resourceGroupName")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "resourceGroupName", valid_568220
  var valid_568221 = path.getOrDefault("subscriptionId")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "subscriptionId", valid_568221
  var valid_568222 = path.getOrDefault("workspaceCollectionName")
  valid_568222 = validateParameter(valid_568222, JString, required = true,
                                 default = nil)
  if valid_568222 != nil:
    section.add "workspaceCollectionName", valid_568222
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568223 = query.getOrDefault("api-version")
  valid_568223 = validateParameter(valid_568223, JString, required = true,
                                 default = nil)
  if valid_568223 != nil:
    section.add "api-version", valid_568223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568224: Call_WorkspaceCollectionsGetByName_568217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an existing Power BI Workspace Collection.
  ## 
  let valid = call_568224.validator(path, query, header, formData, body)
  let scheme = call_568224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568224.url(scheme.get, call_568224.host, call_568224.base,
                         call_568224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568224, url, valid)

proc call*(call_568225: Call_WorkspaceCollectionsGetByName_568217;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceCollectionName: string): Recallable =
  ## workspaceCollectionsGetByName
  ## Retrieves an existing Power BI Workspace Collection.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: string (required)
  ##                          : Power BI Embedded Workspace Collection name
  var path_568226 = newJObject()
  var query_568227 = newJObject()
  add(path_568226, "resourceGroupName", newJString(resourceGroupName))
  add(query_568227, "api-version", newJString(apiVersion))
  add(path_568226, "subscriptionId", newJString(subscriptionId))
  add(path_568226, "workspaceCollectionName", newJString(workspaceCollectionName))
  result = call_568225.call(path_568226, query_568227, nil, nil, nil)

var workspaceCollectionsGetByName* = Call_WorkspaceCollectionsGetByName_568217(
    name: "workspaceCollectionsGetByName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBI/workspaceCollections/{workspaceCollectionName}",
    validator: validate_WorkspaceCollectionsGetByName_568218, base: "",
    url: url_WorkspaceCollectionsGetByName_568219, schemes: {Scheme.Https})
type
  Call_WorkspaceCollectionsUpdate_568252 = ref object of OpenApiRestCall_567642
proc url_WorkspaceCollectionsUpdate_568254(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceCollectionName" in path,
        "`workspaceCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBI/workspaceCollections/"),
               (kind: VariableSegment, value: "workspaceCollectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceCollectionsUpdate_568253(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing Power BI Workspace Collection with the specified properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: JString (required)
  ##                          : Power BI Embedded Workspace Collection name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568255 = path.getOrDefault("resourceGroupName")
  valid_568255 = validateParameter(valid_568255, JString, required = true,
                                 default = nil)
  if valid_568255 != nil:
    section.add "resourceGroupName", valid_568255
  var valid_568256 = path.getOrDefault("subscriptionId")
  valid_568256 = validateParameter(valid_568256, JString, required = true,
                                 default = nil)
  if valid_568256 != nil:
    section.add "subscriptionId", valid_568256
  var valid_568257 = path.getOrDefault("workspaceCollectionName")
  valid_568257 = validateParameter(valid_568257, JString, required = true,
                                 default = nil)
  if valid_568257 != nil:
    section.add "workspaceCollectionName", valid_568257
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568258 = query.getOrDefault("api-version")
  valid_568258 = validateParameter(valid_568258, JString, required = true,
                                 default = nil)
  if valid_568258 != nil:
    section.add "api-version", valid_568258
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Update workspace collection request
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568260: Call_WorkspaceCollectionsUpdate_568252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing Power BI Workspace Collection with the specified properties.
  ## 
  let valid = call_568260.validator(path, query, header, formData, body)
  let scheme = call_568260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568260.url(scheme.get, call_568260.host, call_568260.base,
                         call_568260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568260, url, valid)

proc call*(call_568261: Call_WorkspaceCollectionsUpdate_568252;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceCollectionName: string; body: JsonNode): Recallable =
  ## workspaceCollectionsUpdate
  ## Update an existing Power BI Workspace Collection with the specified properties.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: string (required)
  ##                          : Power BI Embedded Workspace Collection name
  ##   body: JObject (required)
  ##       : Update workspace collection request
  var path_568262 = newJObject()
  var query_568263 = newJObject()
  var body_568264 = newJObject()
  add(path_568262, "resourceGroupName", newJString(resourceGroupName))
  add(query_568263, "api-version", newJString(apiVersion))
  add(path_568262, "subscriptionId", newJString(subscriptionId))
  add(path_568262, "workspaceCollectionName", newJString(workspaceCollectionName))
  if body != nil:
    body_568264 = body
  result = call_568261.call(path_568262, query_568263, nil, nil, body_568264)

var workspaceCollectionsUpdate* = Call_WorkspaceCollectionsUpdate_568252(
    name: "workspaceCollectionsUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBI/workspaceCollections/{workspaceCollectionName}",
    validator: validate_WorkspaceCollectionsUpdate_568253, base: "",
    url: url_WorkspaceCollectionsUpdate_568254, schemes: {Scheme.Https})
type
  Call_WorkspaceCollectionsDelete_568241 = ref object of OpenApiRestCall_567642
proc url_WorkspaceCollectionsDelete_568243(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceCollectionName" in path,
        "`workspaceCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBI/workspaceCollections/"),
               (kind: VariableSegment, value: "workspaceCollectionName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceCollectionsDelete_568242(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a Power BI Workspace Collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: JString (required)
  ##                          : Power BI Embedded Workspace Collection name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568244 = path.getOrDefault("resourceGroupName")
  valid_568244 = validateParameter(valid_568244, JString, required = true,
                                 default = nil)
  if valid_568244 != nil:
    section.add "resourceGroupName", valid_568244
  var valid_568245 = path.getOrDefault("subscriptionId")
  valid_568245 = validateParameter(valid_568245, JString, required = true,
                                 default = nil)
  if valid_568245 != nil:
    section.add "subscriptionId", valid_568245
  var valid_568246 = path.getOrDefault("workspaceCollectionName")
  valid_568246 = validateParameter(valid_568246, JString, required = true,
                                 default = nil)
  if valid_568246 != nil:
    section.add "workspaceCollectionName", valid_568246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568247 = query.getOrDefault("api-version")
  valid_568247 = validateParameter(valid_568247, JString, required = true,
                                 default = nil)
  if valid_568247 != nil:
    section.add "api-version", valid_568247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568248: Call_WorkspaceCollectionsDelete_568241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a Power BI Workspace Collection.
  ## 
  let valid = call_568248.validator(path, query, header, formData, body)
  let scheme = call_568248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568248.url(scheme.get, call_568248.host, call_568248.base,
                         call_568248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568248, url, valid)

proc call*(call_568249: Call_WorkspaceCollectionsDelete_568241;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceCollectionName: string): Recallable =
  ## workspaceCollectionsDelete
  ## Delete a Power BI Workspace Collection.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: string (required)
  ##                          : Power BI Embedded Workspace Collection name
  var path_568250 = newJObject()
  var query_568251 = newJObject()
  add(path_568250, "resourceGroupName", newJString(resourceGroupName))
  add(query_568251, "api-version", newJString(apiVersion))
  add(path_568250, "subscriptionId", newJString(subscriptionId))
  add(path_568250, "workspaceCollectionName", newJString(workspaceCollectionName))
  result = call_568249.call(path_568250, query_568251, nil, nil, nil)

var workspaceCollectionsDelete* = Call_WorkspaceCollectionsDelete_568241(
    name: "workspaceCollectionsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBI/workspaceCollections/{workspaceCollectionName}",
    validator: validate_WorkspaceCollectionsDelete_568242, base: "",
    url: url_WorkspaceCollectionsDelete_568243, schemes: {Scheme.Https})
type
  Call_WorkspaceCollectionsGetAccessKeys_568265 = ref object of OpenApiRestCall_567642
proc url_WorkspaceCollectionsGetAccessKeys_568267(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceCollectionName" in path,
        "`workspaceCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBI/workspaceCollections/"),
               (kind: VariableSegment, value: "workspaceCollectionName"),
               (kind: ConstantSegment, value: "/listKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceCollectionsGetAccessKeys_568266(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the primary and secondary access keys for the specified Power BI Workspace Collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: JString (required)
  ##                          : Power BI Embedded Workspace Collection name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568268 = path.getOrDefault("resourceGroupName")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = nil)
  if valid_568268 != nil:
    section.add "resourceGroupName", valid_568268
  var valid_568269 = path.getOrDefault("subscriptionId")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "subscriptionId", valid_568269
  var valid_568270 = path.getOrDefault("workspaceCollectionName")
  valid_568270 = validateParameter(valid_568270, JString, required = true,
                                 default = nil)
  if valid_568270 != nil:
    section.add "workspaceCollectionName", valid_568270
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568271 = query.getOrDefault("api-version")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "api-version", valid_568271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568272: Call_WorkspaceCollectionsGetAccessKeys_568265;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the primary and secondary access keys for the specified Power BI Workspace Collection.
  ## 
  let valid = call_568272.validator(path, query, header, formData, body)
  let scheme = call_568272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568272.url(scheme.get, call_568272.host, call_568272.base,
                         call_568272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568272, url, valid)

proc call*(call_568273: Call_WorkspaceCollectionsGetAccessKeys_568265;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceCollectionName: string): Recallable =
  ## workspaceCollectionsGetAccessKeys
  ## Retrieves the primary and secondary access keys for the specified Power BI Workspace Collection.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: string (required)
  ##                          : Power BI Embedded Workspace Collection name
  var path_568274 = newJObject()
  var query_568275 = newJObject()
  add(path_568274, "resourceGroupName", newJString(resourceGroupName))
  add(query_568275, "api-version", newJString(apiVersion))
  add(path_568274, "subscriptionId", newJString(subscriptionId))
  add(path_568274, "workspaceCollectionName", newJString(workspaceCollectionName))
  result = call_568273.call(path_568274, query_568275, nil, nil, nil)

var workspaceCollectionsGetAccessKeys* = Call_WorkspaceCollectionsGetAccessKeys_568265(
    name: "workspaceCollectionsGetAccessKeys", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBI/workspaceCollections/{workspaceCollectionName}/listKeys",
    validator: validate_WorkspaceCollectionsGetAccessKeys_568266, base: "",
    url: url_WorkspaceCollectionsGetAccessKeys_568267, schemes: {Scheme.Https})
type
  Call_WorkspaceCollectionsRegenerateKey_568276 = ref object of OpenApiRestCall_567642
proc url_WorkspaceCollectionsRegenerateKey_568278(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceCollectionName" in path,
        "`workspaceCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBI/workspaceCollections/"),
               (kind: VariableSegment, value: "workspaceCollectionName"),
               (kind: ConstantSegment, value: "/regenerateKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspaceCollectionsRegenerateKey_568277(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Regenerates the primary or secondary access key for the specified Power BI Workspace Collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: JString (required)
  ##                          : Power BI Embedded Workspace Collection name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568279 = path.getOrDefault("resourceGroupName")
  valid_568279 = validateParameter(valid_568279, JString, required = true,
                                 default = nil)
  if valid_568279 != nil:
    section.add "resourceGroupName", valid_568279
  var valid_568280 = path.getOrDefault("subscriptionId")
  valid_568280 = validateParameter(valid_568280, JString, required = true,
                                 default = nil)
  if valid_568280 != nil:
    section.add "subscriptionId", valid_568280
  var valid_568281 = path.getOrDefault("workspaceCollectionName")
  valid_568281 = validateParameter(valid_568281, JString, required = true,
                                 default = nil)
  if valid_568281 != nil:
    section.add "workspaceCollectionName", valid_568281
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568282 = query.getOrDefault("api-version")
  valid_568282 = validateParameter(valid_568282, JString, required = true,
                                 default = nil)
  if valid_568282 != nil:
    section.add "api-version", valid_568282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  ##       : Access key to regenerate
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568284: Call_WorkspaceCollectionsRegenerateKey_568276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Regenerates the primary or secondary access key for the specified Power BI Workspace Collection.
  ## 
  let valid = call_568284.validator(path, query, header, formData, body)
  let scheme = call_568284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568284.url(scheme.get, call_568284.host, call_568284.base,
                         call_568284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568284, url, valid)

proc call*(call_568285: Call_WorkspaceCollectionsRegenerateKey_568276;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          workspaceCollectionName: string; body: JsonNode): Recallable =
  ## workspaceCollectionsRegenerateKey
  ## Regenerates the primary or secondary access key for the specified Power BI Workspace Collection.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: string (required)
  ##                          : Power BI Embedded Workspace Collection name
  ##   body: JObject (required)
  ##       : Access key to regenerate
  var path_568286 = newJObject()
  var query_568287 = newJObject()
  var body_568288 = newJObject()
  add(path_568286, "resourceGroupName", newJString(resourceGroupName))
  add(query_568287, "api-version", newJString(apiVersion))
  add(path_568286, "subscriptionId", newJString(subscriptionId))
  add(path_568286, "workspaceCollectionName", newJString(workspaceCollectionName))
  if body != nil:
    body_568288 = body
  result = call_568285.call(path_568286, query_568287, nil, nil, body_568288)

var workspaceCollectionsRegenerateKey* = Call_WorkspaceCollectionsRegenerateKey_568276(
    name: "workspaceCollectionsRegenerateKey", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBI/workspaceCollections/{workspaceCollectionName}/regenerateKey",
    validator: validate_WorkspaceCollectionsRegenerateKey_568277, base: "",
    url: url_WorkspaceCollectionsRegenerateKey_568278, schemes: {Scheme.Https})
type
  Call_WorkspacesList_568289 = ref object of OpenApiRestCall_567642
proc url_WorkspacesList_568291(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "workspaceCollectionName" in path,
        "`workspaceCollectionName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.PowerBI/workspaceCollections/"),
               (kind: VariableSegment, value: "workspaceCollectionName"),
               (kind: ConstantSegment, value: "/workspaces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_WorkspacesList_568290(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieves all existing Power BI workspaces in the specified workspace collection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Azure resource group
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: JString (required)
  ##                          : Power BI Embedded Workspace Collection name
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568292 = path.getOrDefault("resourceGroupName")
  valid_568292 = validateParameter(valid_568292, JString, required = true,
                                 default = nil)
  if valid_568292 != nil:
    section.add "resourceGroupName", valid_568292
  var valid_568293 = path.getOrDefault("subscriptionId")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "subscriptionId", valid_568293
  var valid_568294 = path.getOrDefault("workspaceCollectionName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "workspaceCollectionName", valid_568294
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568295 = query.getOrDefault("api-version")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "api-version", valid_568295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568296: Call_WorkspacesList_568289; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves all existing Power BI workspaces in the specified workspace collection.
  ## 
  let valid = call_568296.validator(path, query, header, formData, body)
  let scheme = call_568296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568296.url(scheme.get, call_568296.host, call_568296.base,
                         call_568296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568296, url, valid)

proc call*(call_568297: Call_WorkspacesList_568289; resourceGroupName: string;
          apiVersion: string; subscriptionId: string;
          workspaceCollectionName: string): Recallable =
  ## workspacesList
  ## Retrieves all existing Power BI workspaces in the specified workspace collection.
  ##   resourceGroupName: string (required)
  ##                    : Azure resource group
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify a Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   workspaceCollectionName: string (required)
  ##                          : Power BI Embedded Workspace Collection name
  var path_568298 = newJObject()
  var query_568299 = newJObject()
  add(path_568298, "resourceGroupName", newJString(resourceGroupName))
  add(query_568299, "api-version", newJString(apiVersion))
  add(path_568298, "subscriptionId", newJString(subscriptionId))
  add(path_568298, "workspaceCollectionName", newJString(workspaceCollectionName))
  result = call_568297.call(path_568298, query_568299, nil, nil, nil)

var workspacesList* = Call_WorkspacesList_568289(name: "workspacesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.PowerBI/workspaceCollections/{workspaceCollectionName}/workspaces",
    validator: validate_WorkspacesList_568290, base: "", url: url_WorkspacesList_568291,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
