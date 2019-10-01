
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Engagement.ManagementClient
## version: 2014-12-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Microsoft Azure Mobile Engagement REST APIs.
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
  macServiceName = "mobileengagement-mobile-engagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppCollectionsList_567888 = ref object of OpenApiRestCall_567666
proc url_AppCollectionsList_567890(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.MobileEngagement/appCollections")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppCollectionsList_567889(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists app collections in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568063 = path.getOrDefault("subscriptionId")
  valid_568063 = validateParameter(valid_568063, JString, required = true,
                                 default = nil)
  if valid_568063 != nil:
    section.add "subscriptionId", valid_568063
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568064 = query.getOrDefault("api-version")
  valid_568064 = validateParameter(valid_568064, JString, required = true,
                                 default = nil)
  if valid_568064 != nil:
    section.add "api-version", valid_568064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568087: Call_AppCollectionsList_567888; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists app collections in a subscription.
  ## 
  let valid = call_568087.validator(path, query, header, formData, body)
  let scheme = call_568087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568087.url(scheme.get, call_568087.host, call_568087.base,
                         call_568087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568087, url, valid)

proc call*(call_568158: Call_AppCollectionsList_567888; apiVersion: string;
          subscriptionId: string): Recallable =
  ## appCollectionsList
  ## Lists app collections in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568159 = newJObject()
  var query_568161 = newJObject()
  add(query_568161, "api-version", newJString(apiVersion))
  add(path_568159, "subscriptionId", newJString(subscriptionId))
  result = call_568158.call(path_568159, query_568161, nil, nil, nil)

var appCollectionsList* = Call_AppCollectionsList_567888(
    name: "appCollectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MobileEngagement/appCollections",
    validator: validate_AppCollectionsList_567889, base: "",
    url: url_AppCollectionsList_567890, schemes: {Scheme.Https})
type
  Call_AppCollectionsCheckNameAvailability_568200 = ref object of OpenApiRestCall_567666
proc url_AppCollectionsCheckNameAvailability_568202(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.MobileEngagement/checkAppCollectionNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppCollectionsCheckNameAvailability_568201(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks availability of an app collection name in the Engagement domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568220 = path.getOrDefault("subscriptionId")
  valid_568220 = validateParameter(valid_568220, JString, required = true,
                                 default = nil)
  if valid_568220 != nil:
    section.add "subscriptionId", valid_568220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568221 = query.getOrDefault("api-version")
  valid_568221 = validateParameter(valid_568221, JString, required = true,
                                 default = nil)
  if valid_568221 != nil:
    section.add "api-version", valid_568221
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568223: Call_AppCollectionsCheckNameAvailability_568200;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks availability of an app collection name in the Engagement domain.
  ## 
  let valid = call_568223.validator(path, query, header, formData, body)
  let scheme = call_568223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568223.url(scheme.get, call_568223.host, call_568223.base,
                         call_568223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568223, url, valid)

proc call*(call_568224: Call_AppCollectionsCheckNameAvailability_568200;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## appCollectionsCheckNameAvailability
  ## Checks availability of an app collection name in the Engagement domain.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  var path_568225 = newJObject()
  var query_568226 = newJObject()
  var body_568227 = newJObject()
  add(query_568226, "api-version", newJString(apiVersion))
  add(path_568225, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_568227 = parameters
  result = call_568224.call(path_568225, query_568226, nil, nil, body_568227)

var appCollectionsCheckNameAvailability* = Call_AppCollectionsCheckNameAvailability_568200(
    name: "appCollectionsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MobileEngagement/checkAppCollectionNameAvailability",
    validator: validate_AppCollectionsCheckNameAvailability_568201, base: "",
    url: url_AppCollectionsCheckNameAvailability_568202, schemes: {Scheme.Https})
type
  Call_SupportedPlatformsList_568228 = ref object of OpenApiRestCall_567666
proc url_SupportedPlatformsList_568230(protocol: Scheme; host: string; base: string;
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
        value: "/providers/Microsoft.MobileEngagement/supportedPlatforms")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SupportedPlatformsList_568229(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists supported platforms for Engagement applications.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568231 = path.getOrDefault("subscriptionId")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "subscriptionId", valid_568231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568232 = query.getOrDefault("api-version")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "api-version", valid_568232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568233: Call_SupportedPlatformsList_568228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists supported platforms for Engagement applications.
  ## 
  let valid = call_568233.validator(path, query, header, formData, body)
  let scheme = call_568233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568233.url(scheme.get, call_568233.host, call_568233.base,
                         call_568233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568233, url, valid)

proc call*(call_568234: Call_SupportedPlatformsList_568228; apiVersion: string;
          subscriptionId: string): Recallable =
  ## supportedPlatformsList
  ## Lists supported platforms for Engagement applications.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_568235 = newJObject()
  var query_568236 = newJObject()
  add(query_568236, "api-version", newJString(apiVersion))
  add(path_568235, "subscriptionId", newJString(subscriptionId))
  result = call_568234.call(path_568235, query_568236, nil, nil, nil)

var supportedPlatformsList* = Call_SupportedPlatformsList_568228(
    name: "supportedPlatformsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MobileEngagement/supportedPlatforms",
    validator: validate_SupportedPlatformsList_568229, base: "",
    url: url_SupportedPlatformsList_568230, schemes: {Scheme.Https})
type
  Call_AppsList_568237 = ref object of OpenApiRestCall_567666
proc url_AppsList_568239(protocol: Scheme; host: string; base: string; route: string;
                        path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AppsList_568238(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists apps in an appCollection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568240 = path.getOrDefault("resourceGroupName")
  valid_568240 = validateParameter(valid_568240, JString, required = true,
                                 default = nil)
  if valid_568240 != nil:
    section.add "resourceGroupName", valid_568240
  var valid_568241 = path.getOrDefault("subscriptionId")
  valid_568241 = validateParameter(valid_568241, JString, required = true,
                                 default = nil)
  if valid_568241 != nil:
    section.add "subscriptionId", valid_568241
  var valid_568242 = path.getOrDefault("appCollection")
  valid_568242 = validateParameter(valid_568242, JString, required = true,
                                 default = nil)
  if valid_568242 != nil:
    section.add "appCollection", valid_568242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568243 = query.getOrDefault("api-version")
  valid_568243 = validateParameter(valid_568243, JString, required = true,
                                 default = nil)
  if valid_568243 != nil:
    section.add "api-version", valid_568243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568244: Call_AppsList_568237; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists apps in an appCollection.
  ## 
  let valid = call_568244.validator(path, query, header, formData, body)
  let scheme = call_568244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568244.url(scheme.get, call_568244.host, call_568244.base,
                         call_568244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568244, url, valid)

proc call*(call_568245: Call_AppsList_568237; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; appCollection: string): Recallable =
  ## appsList
  ## Lists apps in an appCollection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  var path_568246 = newJObject()
  var query_568247 = newJObject()
  add(path_568246, "resourceGroupName", newJString(resourceGroupName))
  add(query_568247, "api-version", newJString(apiVersion))
  add(path_568246, "subscriptionId", newJString(subscriptionId))
  add(path_568246, "appCollection", newJString(appCollection))
  result = call_568245.call(path_568246, query_568247, nil, nil, nil)

var appsList* = Call_AppsList_568237(name: "appsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps",
                                  validator: validate_AppsList_568238, base: "",
                                  url: url_AppsList_568239,
                                  schemes: {Scheme.Https})
type
  Call_CampaignsCreate_568280 = ref object of OpenApiRestCall_567666
proc url_CampaignsCreate_568282(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  assert "kind" in path, "`kind` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/campaigns/"),
               (kind: VariableSegment, value: "kind")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CampaignsCreate_568281(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Create a push campaign (announcement, poll, data push or native push).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568293 = path.getOrDefault("resourceGroupName")
  valid_568293 = validateParameter(valid_568293, JString, required = true,
                                 default = nil)
  if valid_568293 != nil:
    section.add "resourceGroupName", valid_568293
  var valid_568294 = path.getOrDefault("appName")
  valid_568294 = validateParameter(valid_568294, JString, required = true,
                                 default = nil)
  if valid_568294 != nil:
    section.add "appName", valid_568294
  var valid_568295 = path.getOrDefault("subscriptionId")
  valid_568295 = validateParameter(valid_568295, JString, required = true,
                                 default = nil)
  if valid_568295 != nil:
    section.add "subscriptionId", valid_568295
  var valid_568296 = path.getOrDefault("kind")
  valid_568296 = validateParameter(valid_568296, JString, required = true,
                                 default = newJString("announcements"))
  if valid_568296 != nil:
    section.add "kind", valid_568296
  var valid_568297 = path.getOrDefault("appCollection")
  valid_568297 = validateParameter(valid_568297, JString, required = true,
                                 default = nil)
  if valid_568297 != nil:
    section.add "appCollection", valid_568297
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568298 = query.getOrDefault("api-version")
  valid_568298 = validateParameter(valid_568298, JString, required = true,
                                 default = nil)
  if valid_568298 != nil:
    section.add "api-version", valid_568298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Campaign operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568300: Call_CampaignsCreate_568280; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a push campaign (announcement, poll, data push or native push).
  ## 
  let valid = call_568300.validator(path, query, header, formData, body)
  let scheme = call_568300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568300.url(scheme.get, call_568300.host, call_568300.base,
                         call_568300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568300, url, valid)

proc call*(call_568301: Call_CampaignsCreate_568280; resourceGroupName: string;
          apiVersion: string; appName: string; subscriptionId: string;
          appCollection: string; parameters: JsonNode;
          kind: string = "announcements"): Recallable =
  ## campaignsCreate
  ## Create a push campaign (announcement, poll, data push or native push).
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Campaign operation.
  var path_568302 = newJObject()
  var query_568303 = newJObject()
  var body_568304 = newJObject()
  add(path_568302, "resourceGroupName", newJString(resourceGroupName))
  add(query_568303, "api-version", newJString(apiVersion))
  add(path_568302, "appName", newJString(appName))
  add(path_568302, "subscriptionId", newJString(subscriptionId))
  add(path_568302, "kind", newJString(kind))
  add(path_568302, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_568304 = parameters
  result = call_568301.call(path_568302, query_568303, nil, nil, body_568304)

var campaignsCreate* = Call_CampaignsCreate_568280(name: "campaignsCreate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}",
    validator: validate_CampaignsCreate_568281, base: "", url: url_CampaignsCreate_568282,
    schemes: {Scheme.Https})
type
  Call_CampaignsList_568248 = ref object of OpenApiRestCall_567666
proc url_CampaignsList_568250(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  assert "kind" in path, "`kind` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/campaigns/"),
               (kind: VariableSegment, value: "kind")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CampaignsList_568249(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of campaigns.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568252 = path.getOrDefault("resourceGroupName")
  valid_568252 = validateParameter(valid_568252, JString, required = true,
                                 default = nil)
  if valid_568252 != nil:
    section.add "resourceGroupName", valid_568252
  var valid_568253 = path.getOrDefault("appName")
  valid_568253 = validateParameter(valid_568253, JString, required = true,
                                 default = nil)
  if valid_568253 != nil:
    section.add "appName", valid_568253
  var valid_568254 = path.getOrDefault("subscriptionId")
  valid_568254 = validateParameter(valid_568254, JString, required = true,
                                 default = nil)
  if valid_568254 != nil:
    section.add "subscriptionId", valid_568254
  var valid_568268 = path.getOrDefault("kind")
  valid_568268 = validateParameter(valid_568268, JString, required = true,
                                 default = newJString("announcements"))
  if valid_568268 != nil:
    section.add "kind", valid_568268
  var valid_568269 = path.getOrDefault("appCollection")
  valid_568269 = validateParameter(valid_568269, JString, required = true,
                                 default = nil)
  if valid_568269 != nil:
    section.add "appCollection", valid_568269
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Sort results by an expression which looks like `$orderby=id asc` (this example is actually the default behavior). The syntax is orderby={property} {direction} or just orderby={property}. The available sorting properties are id, name, state, activatedDate, and finishedDate. The available directions are asc (for ascending order) and desc (for descending order). When not specified the asc direction is used. Only one property at a time can be used for sorting.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Control paging of campaigns, number of campaigns to return with each call. It returns all campaigns by default. When specifying $top parameter, the response contains a `nextLink` property describing the path to get the next page if there are more results.
  ##   $skip: JInt
  ##        : Control paging of campaigns, start results at the given offset, defaults to 0 (1st page of data).
  ##   $search: JString
  ##          : Restrict results to campaigns matching the optional `search` expression. This currently performs the search based on the name on the campaign only, case insensitive. If the campaign contains the value of the `search` parameter anywhere in the name, it matches.
  ##   $filter: JString
  ##          : Filter can be used to restrict the results to campaigns matching a specific state. The syntax is `$filter=state eq 'draft'`. Valid state values are: draft, scheduled, in-progress, and finished. Only the eq operator and the state property are supported.
  section = newJObject()
  var valid_568270 = query.getOrDefault("$orderby")
  valid_568270 = validateParameter(valid_568270, JString, required = false,
                                 default = nil)
  if valid_568270 != nil:
    section.add "$orderby", valid_568270
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568271 = query.getOrDefault("api-version")
  valid_568271 = validateParameter(valid_568271, JString, required = true,
                                 default = nil)
  if valid_568271 != nil:
    section.add "api-version", valid_568271
  var valid_568272 = query.getOrDefault("$top")
  valid_568272 = validateParameter(valid_568272, JInt, required = false, default = nil)
  if valid_568272 != nil:
    section.add "$top", valid_568272
  var valid_568273 = query.getOrDefault("$skip")
  valid_568273 = validateParameter(valid_568273, JInt, required = false, default = nil)
  if valid_568273 != nil:
    section.add "$skip", valid_568273
  var valid_568274 = query.getOrDefault("$search")
  valid_568274 = validateParameter(valid_568274, JString, required = false,
                                 default = nil)
  if valid_568274 != nil:
    section.add "$search", valid_568274
  var valid_568275 = query.getOrDefault("$filter")
  valid_568275 = validateParameter(valid_568275, JString, required = false,
                                 default = nil)
  if valid_568275 != nil:
    section.add "$filter", valid_568275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568276: Call_CampaignsList_568248; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of campaigns.
  ## 
  let valid = call_568276.validator(path, query, header, formData, body)
  let scheme = call_568276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568276.url(scheme.get, call_568276.host, call_568276.base,
                         call_568276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568276, url, valid)

proc call*(call_568277: Call_CampaignsList_568248; resourceGroupName: string;
          apiVersion: string; appName: string; subscriptionId: string;
          appCollection: string; Orderby: string = ""; Top: int = 0;
          kind: string = "announcements"; Skip: int = 0; Search: string = "";
          Filter: string = ""): Recallable =
  ## campaignsList
  ## Get the list of campaigns.
  ##   Orderby: string
  ##          : Sort results by an expression which looks like `$orderby=id asc` (this example is actually the default behavior). The syntax is orderby={property} {direction} or just orderby={property}. The available sorting properties are id, name, state, activatedDate, and finishedDate. The available directions are asc (for ascending order) and desc (for descending order). When not specified the asc direction is used. Only one property at a time can be used for sorting.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Control paging of campaigns, number of campaigns to return with each call. It returns all campaigns by default. When specifying $top parameter, the response contains a `nextLink` property describing the path to get the next page if there are more results.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   Skip: int
  ##       : Control paging of campaigns, start results at the given offset, defaults to 0 (1st page of data).
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   Search: string
  ##         : Restrict results to campaigns matching the optional `search` expression. This currently performs the search based on the name on the campaign only, case insensitive. If the campaign contains the value of the `search` parameter anywhere in the name, it matches.
  ##   Filter: string
  ##         : Filter can be used to restrict the results to campaigns matching a specific state. The syntax is `$filter=state eq 'draft'`. Valid state values are: draft, scheduled, in-progress, and finished. Only the eq operator and the state property are supported.
  var path_568278 = newJObject()
  var query_568279 = newJObject()
  add(query_568279, "$orderby", newJString(Orderby))
  add(path_568278, "resourceGroupName", newJString(resourceGroupName))
  add(query_568279, "api-version", newJString(apiVersion))
  add(path_568278, "appName", newJString(appName))
  add(path_568278, "subscriptionId", newJString(subscriptionId))
  add(query_568279, "$top", newJInt(Top))
  add(path_568278, "kind", newJString(kind))
  add(query_568279, "$skip", newJInt(Skip))
  add(path_568278, "appCollection", newJString(appCollection))
  add(query_568279, "$search", newJString(Search))
  add(query_568279, "$filter", newJString(Filter))
  result = call_568277.call(path_568278, query_568279, nil, nil, nil)

var campaignsList* = Call_CampaignsList_568248(name: "campaignsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}",
    validator: validate_CampaignsList_568249, base: "", url: url_CampaignsList_568250,
    schemes: {Scheme.Https})
type
  Call_CampaignsTestNew_568305 = ref object of OpenApiRestCall_567666
proc url_CampaignsTestNew_568307(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  assert "kind" in path, "`kind` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/campaigns/"),
               (kind: VariableSegment, value: "kind"),
               (kind: ConstantSegment, value: "/test")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CampaignsTestNew_568306(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Test a new campaign on a set of devices.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568308 = path.getOrDefault("resourceGroupName")
  valid_568308 = validateParameter(valid_568308, JString, required = true,
                                 default = nil)
  if valid_568308 != nil:
    section.add "resourceGroupName", valid_568308
  var valid_568309 = path.getOrDefault("appName")
  valid_568309 = validateParameter(valid_568309, JString, required = true,
                                 default = nil)
  if valid_568309 != nil:
    section.add "appName", valid_568309
  var valid_568310 = path.getOrDefault("subscriptionId")
  valid_568310 = validateParameter(valid_568310, JString, required = true,
                                 default = nil)
  if valid_568310 != nil:
    section.add "subscriptionId", valid_568310
  var valid_568311 = path.getOrDefault("kind")
  valid_568311 = validateParameter(valid_568311, JString, required = true,
                                 default = newJString("announcements"))
  if valid_568311 != nil:
    section.add "kind", valid_568311
  var valid_568312 = path.getOrDefault("appCollection")
  valid_568312 = validateParameter(valid_568312, JString, required = true,
                                 default = nil)
  if valid_568312 != nil:
    section.add "appCollection", valid_568312
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568313 = query.getOrDefault("api-version")
  valid_568313 = validateParameter(valid_568313, JString, required = true,
                                 default = nil)
  if valid_568313 != nil:
    section.add "api-version", valid_568313
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Test Campaign operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568315: Call_CampaignsTestNew_568305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Test a new campaign on a set of devices.
  ## 
  let valid = call_568315.validator(path, query, header, formData, body)
  let scheme = call_568315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568315.url(scheme.get, call_568315.host, call_568315.base,
                         call_568315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568315, url, valid)

proc call*(call_568316: Call_CampaignsTestNew_568305; resourceGroupName: string;
          apiVersion: string; appName: string; subscriptionId: string;
          appCollection: string; parameters: JsonNode;
          kind: string = "announcements"): Recallable =
  ## campaignsTestNew
  ## Test a new campaign on a set of devices.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Test Campaign operation.
  var path_568317 = newJObject()
  var query_568318 = newJObject()
  var body_568319 = newJObject()
  add(path_568317, "resourceGroupName", newJString(resourceGroupName))
  add(query_568318, "api-version", newJString(apiVersion))
  add(path_568317, "appName", newJString(appName))
  add(path_568317, "subscriptionId", newJString(subscriptionId))
  add(path_568317, "kind", newJString(kind))
  add(path_568317, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_568319 = parameters
  result = call_568316.call(path_568317, query_568318, nil, nil, body_568319)

var campaignsTestNew* = Call_CampaignsTestNew_568305(name: "campaignsTestNew",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/test",
    validator: validate_CampaignsTestNew_568306, base: "",
    url: url_CampaignsTestNew_568307, schemes: {Scheme.Https})
type
  Call_CampaignsUpdate_568334 = ref object of OpenApiRestCall_567666
proc url_CampaignsUpdate_568336(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  assert "kind" in path, "`kind` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/campaigns/"),
               (kind: VariableSegment, value: "kind"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CampaignsUpdate_568335(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Update an existing push campaign (announcement, poll, data push or native push).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   id: JInt (required)
  ##     : Campaign identifier.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568337 = path.getOrDefault("resourceGroupName")
  valid_568337 = validateParameter(valid_568337, JString, required = true,
                                 default = nil)
  if valid_568337 != nil:
    section.add "resourceGroupName", valid_568337
  var valid_568338 = path.getOrDefault("appName")
  valid_568338 = validateParameter(valid_568338, JString, required = true,
                                 default = nil)
  if valid_568338 != nil:
    section.add "appName", valid_568338
  var valid_568339 = path.getOrDefault("subscriptionId")
  valid_568339 = validateParameter(valid_568339, JString, required = true,
                                 default = nil)
  if valid_568339 != nil:
    section.add "subscriptionId", valid_568339
  var valid_568340 = path.getOrDefault("kind")
  valid_568340 = validateParameter(valid_568340, JString, required = true,
                                 default = newJString("announcements"))
  if valid_568340 != nil:
    section.add "kind", valid_568340
  var valid_568341 = path.getOrDefault("id")
  valid_568341 = validateParameter(valid_568341, JInt, required = true, default = nil)
  if valid_568341 != nil:
    section.add "id", valid_568341
  var valid_568342 = path.getOrDefault("appCollection")
  valid_568342 = validateParameter(valid_568342, JString, required = true,
                                 default = nil)
  if valid_568342 != nil:
    section.add "appCollection", valid_568342
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568343 = query.getOrDefault("api-version")
  valid_568343 = validateParameter(valid_568343, JString, required = true,
                                 default = nil)
  if valid_568343 != nil:
    section.add "api-version", valid_568343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Campaign operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568345: Call_CampaignsUpdate_568334; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing push campaign (announcement, poll, data push or native push).
  ## 
  let valid = call_568345.validator(path, query, header, formData, body)
  let scheme = call_568345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568345.url(scheme.get, call_568345.host, call_568345.base,
                         call_568345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568345, url, valid)

proc call*(call_568346: Call_CampaignsUpdate_568334; resourceGroupName: string;
          apiVersion: string; appName: string; subscriptionId: string; id: int;
          appCollection: string; parameters: JsonNode;
          kind: string = "announcements"): Recallable =
  ## campaignsUpdate
  ## Update an existing push campaign (announcement, poll, data push or native push).
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   id: int (required)
  ##     : Campaign identifier.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Campaign operation.
  var path_568347 = newJObject()
  var query_568348 = newJObject()
  var body_568349 = newJObject()
  add(path_568347, "resourceGroupName", newJString(resourceGroupName))
  add(query_568348, "api-version", newJString(apiVersion))
  add(path_568347, "appName", newJString(appName))
  add(path_568347, "subscriptionId", newJString(subscriptionId))
  add(path_568347, "kind", newJString(kind))
  add(path_568347, "id", newJInt(id))
  add(path_568347, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_568349 = parameters
  result = call_568346.call(path_568347, query_568348, nil, nil, body_568349)

var campaignsUpdate* = Call_CampaignsUpdate_568334(name: "campaignsUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}",
    validator: validate_CampaignsUpdate_568335, base: "", url: url_CampaignsUpdate_568336,
    schemes: {Scheme.Https})
type
  Call_CampaignsGet_568320 = ref object of OpenApiRestCall_567666
proc url_CampaignsGet_568322(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  assert "kind" in path, "`kind` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/campaigns/"),
               (kind: VariableSegment, value: "kind"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CampaignsGet_568321(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get campaign operation retrieves information about a previously created campaign.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   id: JInt (required)
  ##     : Campaign identifier.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568323 = path.getOrDefault("resourceGroupName")
  valid_568323 = validateParameter(valid_568323, JString, required = true,
                                 default = nil)
  if valid_568323 != nil:
    section.add "resourceGroupName", valid_568323
  var valid_568324 = path.getOrDefault("appName")
  valid_568324 = validateParameter(valid_568324, JString, required = true,
                                 default = nil)
  if valid_568324 != nil:
    section.add "appName", valid_568324
  var valid_568325 = path.getOrDefault("subscriptionId")
  valid_568325 = validateParameter(valid_568325, JString, required = true,
                                 default = nil)
  if valid_568325 != nil:
    section.add "subscriptionId", valid_568325
  var valid_568326 = path.getOrDefault("kind")
  valid_568326 = validateParameter(valid_568326, JString, required = true,
                                 default = newJString("announcements"))
  if valid_568326 != nil:
    section.add "kind", valid_568326
  var valid_568327 = path.getOrDefault("id")
  valid_568327 = validateParameter(valid_568327, JInt, required = true, default = nil)
  if valid_568327 != nil:
    section.add "id", valid_568327
  var valid_568328 = path.getOrDefault("appCollection")
  valid_568328 = validateParameter(valid_568328, JString, required = true,
                                 default = nil)
  if valid_568328 != nil:
    section.add "appCollection", valid_568328
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568329 = query.getOrDefault("api-version")
  valid_568329 = validateParameter(valid_568329, JString, required = true,
                                 default = nil)
  if valid_568329 != nil:
    section.add "api-version", valid_568329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568330: Call_CampaignsGet_568320; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get campaign operation retrieves information about a previously created campaign.
  ## 
  let valid = call_568330.validator(path, query, header, formData, body)
  let scheme = call_568330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568330.url(scheme.get, call_568330.host, call_568330.base,
                         call_568330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568330, url, valid)

proc call*(call_568331: Call_CampaignsGet_568320; resourceGroupName: string;
          apiVersion: string; appName: string; subscriptionId: string; id: int;
          appCollection: string; kind: string = "announcements"): Recallable =
  ## campaignsGet
  ## The Get campaign operation retrieves information about a previously created campaign.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   id: int (required)
  ##     : Campaign identifier.
  ##   appCollection: string (required)
  ##                : Application collection.
  var path_568332 = newJObject()
  var query_568333 = newJObject()
  add(path_568332, "resourceGroupName", newJString(resourceGroupName))
  add(query_568333, "api-version", newJString(apiVersion))
  add(path_568332, "appName", newJString(appName))
  add(path_568332, "subscriptionId", newJString(subscriptionId))
  add(path_568332, "kind", newJString(kind))
  add(path_568332, "id", newJInt(id))
  add(path_568332, "appCollection", newJString(appCollection))
  result = call_568331.call(path_568332, query_568333, nil, nil, nil)

var campaignsGet* = Call_CampaignsGet_568320(name: "campaignsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}",
    validator: validate_CampaignsGet_568321, base: "", url: url_CampaignsGet_568322,
    schemes: {Scheme.Https})
type
  Call_CampaignsDelete_568350 = ref object of OpenApiRestCall_567666
proc url_CampaignsDelete_568352(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  assert "kind" in path, "`kind` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/campaigns/"),
               (kind: VariableSegment, value: "kind"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CampaignsDelete_568351(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Delete a campaign previously created by a call to Create campaign.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   id: JInt (required)
  ##     : Campaign identifier.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568353 = path.getOrDefault("resourceGroupName")
  valid_568353 = validateParameter(valid_568353, JString, required = true,
                                 default = nil)
  if valid_568353 != nil:
    section.add "resourceGroupName", valid_568353
  var valid_568354 = path.getOrDefault("appName")
  valid_568354 = validateParameter(valid_568354, JString, required = true,
                                 default = nil)
  if valid_568354 != nil:
    section.add "appName", valid_568354
  var valid_568355 = path.getOrDefault("subscriptionId")
  valid_568355 = validateParameter(valid_568355, JString, required = true,
                                 default = nil)
  if valid_568355 != nil:
    section.add "subscriptionId", valid_568355
  var valid_568356 = path.getOrDefault("kind")
  valid_568356 = validateParameter(valid_568356, JString, required = true,
                                 default = newJString("announcements"))
  if valid_568356 != nil:
    section.add "kind", valid_568356
  var valid_568357 = path.getOrDefault("id")
  valid_568357 = validateParameter(valid_568357, JInt, required = true, default = nil)
  if valid_568357 != nil:
    section.add "id", valid_568357
  var valid_568358 = path.getOrDefault("appCollection")
  valid_568358 = validateParameter(valid_568358, JString, required = true,
                                 default = nil)
  if valid_568358 != nil:
    section.add "appCollection", valid_568358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568359 = query.getOrDefault("api-version")
  valid_568359 = validateParameter(valid_568359, JString, required = true,
                                 default = nil)
  if valid_568359 != nil:
    section.add "api-version", valid_568359
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568360: Call_CampaignsDelete_568350; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a campaign previously created by a call to Create campaign.
  ## 
  let valid = call_568360.validator(path, query, header, formData, body)
  let scheme = call_568360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568360.url(scheme.get, call_568360.host, call_568360.base,
                         call_568360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568360, url, valid)

proc call*(call_568361: Call_CampaignsDelete_568350; resourceGroupName: string;
          apiVersion: string; appName: string; subscriptionId: string; id: int;
          appCollection: string; kind: string = "announcements"): Recallable =
  ## campaignsDelete
  ## Delete a campaign previously created by a call to Create campaign.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   id: int (required)
  ##     : Campaign identifier.
  ##   appCollection: string (required)
  ##                : Application collection.
  var path_568362 = newJObject()
  var query_568363 = newJObject()
  add(path_568362, "resourceGroupName", newJString(resourceGroupName))
  add(query_568363, "api-version", newJString(apiVersion))
  add(path_568362, "appName", newJString(appName))
  add(path_568362, "subscriptionId", newJString(subscriptionId))
  add(path_568362, "kind", newJString(kind))
  add(path_568362, "id", newJInt(id))
  add(path_568362, "appCollection", newJString(appCollection))
  result = call_568361.call(path_568362, query_568363, nil, nil, nil)

var campaignsDelete* = Call_CampaignsDelete_568350(name: "campaignsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}",
    validator: validate_CampaignsDelete_568351, base: "", url: url_CampaignsDelete_568352,
    schemes: {Scheme.Https})
type
  Call_CampaignsActivate_568364 = ref object of OpenApiRestCall_567666
proc url_CampaignsActivate_568366(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  assert "kind" in path, "`kind` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/campaigns/"),
               (kind: VariableSegment, value: "kind"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/activate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CampaignsActivate_568365(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Activate a campaign previously created by a call to Create campaign.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   id: JInt (required)
  ##     : Campaign identifier.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568367 = path.getOrDefault("resourceGroupName")
  valid_568367 = validateParameter(valid_568367, JString, required = true,
                                 default = nil)
  if valid_568367 != nil:
    section.add "resourceGroupName", valid_568367
  var valid_568368 = path.getOrDefault("appName")
  valid_568368 = validateParameter(valid_568368, JString, required = true,
                                 default = nil)
  if valid_568368 != nil:
    section.add "appName", valid_568368
  var valid_568369 = path.getOrDefault("subscriptionId")
  valid_568369 = validateParameter(valid_568369, JString, required = true,
                                 default = nil)
  if valid_568369 != nil:
    section.add "subscriptionId", valid_568369
  var valid_568370 = path.getOrDefault("kind")
  valid_568370 = validateParameter(valid_568370, JString, required = true,
                                 default = newJString("announcements"))
  if valid_568370 != nil:
    section.add "kind", valid_568370
  var valid_568371 = path.getOrDefault("id")
  valid_568371 = validateParameter(valid_568371, JInt, required = true, default = nil)
  if valid_568371 != nil:
    section.add "id", valid_568371
  var valid_568372 = path.getOrDefault("appCollection")
  valid_568372 = validateParameter(valid_568372, JString, required = true,
                                 default = nil)
  if valid_568372 != nil:
    section.add "appCollection", valid_568372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568373 = query.getOrDefault("api-version")
  valid_568373 = validateParameter(valid_568373, JString, required = true,
                                 default = nil)
  if valid_568373 != nil:
    section.add "api-version", valid_568373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568374: Call_CampaignsActivate_568364; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activate a campaign previously created by a call to Create campaign.
  ## 
  let valid = call_568374.validator(path, query, header, formData, body)
  let scheme = call_568374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568374.url(scheme.get, call_568374.host, call_568374.base,
                         call_568374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568374, url, valid)

proc call*(call_568375: Call_CampaignsActivate_568364; resourceGroupName: string;
          apiVersion: string; appName: string; subscriptionId: string; id: int;
          appCollection: string; kind: string = "announcements"): Recallable =
  ## campaignsActivate
  ## Activate a campaign previously created by a call to Create campaign.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   id: int (required)
  ##     : Campaign identifier.
  ##   appCollection: string (required)
  ##                : Application collection.
  var path_568376 = newJObject()
  var query_568377 = newJObject()
  add(path_568376, "resourceGroupName", newJString(resourceGroupName))
  add(query_568377, "api-version", newJString(apiVersion))
  add(path_568376, "appName", newJString(appName))
  add(path_568376, "subscriptionId", newJString(subscriptionId))
  add(path_568376, "kind", newJString(kind))
  add(path_568376, "id", newJInt(id))
  add(path_568376, "appCollection", newJString(appCollection))
  result = call_568375.call(path_568376, query_568377, nil, nil, nil)

var campaignsActivate* = Call_CampaignsActivate_568364(name: "campaignsActivate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}/activate",
    validator: validate_CampaignsActivate_568365, base: "",
    url: url_CampaignsActivate_568366, schemes: {Scheme.Https})
type
  Call_CampaignsFinish_568378 = ref object of OpenApiRestCall_567666
proc url_CampaignsFinish_568380(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  assert "kind" in path, "`kind` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/campaigns/"),
               (kind: VariableSegment, value: "kind"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/finish")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CampaignsFinish_568379(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Finish a push campaign previously activated by a call to Activate campaign.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   id: JInt (required)
  ##     : Campaign identifier.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568381 = path.getOrDefault("resourceGroupName")
  valid_568381 = validateParameter(valid_568381, JString, required = true,
                                 default = nil)
  if valid_568381 != nil:
    section.add "resourceGroupName", valid_568381
  var valid_568382 = path.getOrDefault("appName")
  valid_568382 = validateParameter(valid_568382, JString, required = true,
                                 default = nil)
  if valid_568382 != nil:
    section.add "appName", valid_568382
  var valid_568383 = path.getOrDefault("subscriptionId")
  valid_568383 = validateParameter(valid_568383, JString, required = true,
                                 default = nil)
  if valid_568383 != nil:
    section.add "subscriptionId", valid_568383
  var valid_568384 = path.getOrDefault("kind")
  valid_568384 = validateParameter(valid_568384, JString, required = true,
                                 default = newJString("announcements"))
  if valid_568384 != nil:
    section.add "kind", valid_568384
  var valid_568385 = path.getOrDefault("id")
  valid_568385 = validateParameter(valid_568385, JInt, required = true, default = nil)
  if valid_568385 != nil:
    section.add "id", valid_568385
  var valid_568386 = path.getOrDefault("appCollection")
  valid_568386 = validateParameter(valid_568386, JString, required = true,
                                 default = nil)
  if valid_568386 != nil:
    section.add "appCollection", valid_568386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568387 = query.getOrDefault("api-version")
  valid_568387 = validateParameter(valid_568387, JString, required = true,
                                 default = nil)
  if valid_568387 != nil:
    section.add "api-version", valid_568387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568388: Call_CampaignsFinish_568378; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Finish a push campaign previously activated by a call to Activate campaign.
  ## 
  let valid = call_568388.validator(path, query, header, formData, body)
  let scheme = call_568388.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568388.url(scheme.get, call_568388.host, call_568388.base,
                         call_568388.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568388, url, valid)

proc call*(call_568389: Call_CampaignsFinish_568378; resourceGroupName: string;
          apiVersion: string; appName: string; subscriptionId: string; id: int;
          appCollection: string; kind: string = "announcements"): Recallable =
  ## campaignsFinish
  ## Finish a push campaign previously activated by a call to Activate campaign.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   id: int (required)
  ##     : Campaign identifier.
  ##   appCollection: string (required)
  ##                : Application collection.
  var path_568390 = newJObject()
  var query_568391 = newJObject()
  add(path_568390, "resourceGroupName", newJString(resourceGroupName))
  add(query_568391, "api-version", newJString(apiVersion))
  add(path_568390, "appName", newJString(appName))
  add(path_568390, "subscriptionId", newJString(subscriptionId))
  add(path_568390, "kind", newJString(kind))
  add(path_568390, "id", newJInt(id))
  add(path_568390, "appCollection", newJString(appCollection))
  result = call_568389.call(path_568390, query_568391, nil, nil, nil)

var campaignsFinish* = Call_CampaignsFinish_568378(name: "campaignsFinish",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}/finish",
    validator: validate_CampaignsFinish_568379, base: "", url: url_CampaignsFinish_568380,
    schemes: {Scheme.Https})
type
  Call_CampaignsPush_568392 = ref object of OpenApiRestCall_567666
proc url_CampaignsPush_568394(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  assert "kind" in path, "`kind` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/campaigns/"),
               (kind: VariableSegment, value: "kind"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/push")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CampaignsPush_568393(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Push a previously saved campaign (created with Create campaign) to a set of devices.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   id: JInt (required)
  ##     : Campaign identifier.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568395 = path.getOrDefault("resourceGroupName")
  valid_568395 = validateParameter(valid_568395, JString, required = true,
                                 default = nil)
  if valid_568395 != nil:
    section.add "resourceGroupName", valid_568395
  var valid_568396 = path.getOrDefault("appName")
  valid_568396 = validateParameter(valid_568396, JString, required = true,
                                 default = nil)
  if valid_568396 != nil:
    section.add "appName", valid_568396
  var valid_568397 = path.getOrDefault("subscriptionId")
  valid_568397 = validateParameter(valid_568397, JString, required = true,
                                 default = nil)
  if valid_568397 != nil:
    section.add "subscriptionId", valid_568397
  var valid_568398 = path.getOrDefault("kind")
  valid_568398 = validateParameter(valid_568398, JString, required = true,
                                 default = newJString("announcements"))
  if valid_568398 != nil:
    section.add "kind", valid_568398
  var valid_568399 = path.getOrDefault("id")
  valid_568399 = validateParameter(valid_568399, JInt, required = true, default = nil)
  if valid_568399 != nil:
    section.add "id", valid_568399
  var valid_568400 = path.getOrDefault("appCollection")
  valid_568400 = validateParameter(valid_568400, JString, required = true,
                                 default = nil)
  if valid_568400 != nil:
    section.add "appCollection", valid_568400
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568401 = query.getOrDefault("api-version")
  valid_568401 = validateParameter(valid_568401, JString, required = true,
                                 default = nil)
  if valid_568401 != nil:
    section.add "api-version", valid_568401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Push Campaign operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568403: Call_CampaignsPush_568392; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Push a previously saved campaign (created with Create campaign) to a set of devices.
  ## 
  let valid = call_568403.validator(path, query, header, formData, body)
  let scheme = call_568403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568403.url(scheme.get, call_568403.host, call_568403.base,
                         call_568403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568403, url, valid)

proc call*(call_568404: Call_CampaignsPush_568392; resourceGroupName: string;
          apiVersion: string; appName: string; subscriptionId: string; id: int;
          appCollection: string; parameters: JsonNode;
          kind: string = "announcements"): Recallable =
  ## campaignsPush
  ## Push a previously saved campaign (created with Create campaign) to a set of devices.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   id: int (required)
  ##     : Campaign identifier.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Push Campaign operation.
  var path_568405 = newJObject()
  var query_568406 = newJObject()
  var body_568407 = newJObject()
  add(path_568405, "resourceGroupName", newJString(resourceGroupName))
  add(query_568406, "api-version", newJString(apiVersion))
  add(path_568405, "appName", newJString(appName))
  add(path_568405, "subscriptionId", newJString(subscriptionId))
  add(path_568405, "kind", newJString(kind))
  add(path_568405, "id", newJInt(id))
  add(path_568405, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_568407 = parameters
  result = call_568404.call(path_568405, query_568406, nil, nil, body_568407)

var campaignsPush* = Call_CampaignsPush_568392(name: "campaignsPush",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}/push",
    validator: validate_CampaignsPush_568393, base: "", url: url_CampaignsPush_568394,
    schemes: {Scheme.Https})
type
  Call_CampaignsGetStatistics_568408 = ref object of OpenApiRestCall_567666
proc url_CampaignsGetStatistics_568410(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  assert "kind" in path, "`kind` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/campaigns/"),
               (kind: VariableSegment, value: "kind"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/statistics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CampaignsGetStatistics_568409(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the campaign statistics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   id: JInt (required)
  ##     : Campaign identifier.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568411 = path.getOrDefault("resourceGroupName")
  valid_568411 = validateParameter(valid_568411, JString, required = true,
                                 default = nil)
  if valid_568411 != nil:
    section.add "resourceGroupName", valid_568411
  var valid_568412 = path.getOrDefault("appName")
  valid_568412 = validateParameter(valid_568412, JString, required = true,
                                 default = nil)
  if valid_568412 != nil:
    section.add "appName", valid_568412
  var valid_568413 = path.getOrDefault("subscriptionId")
  valid_568413 = validateParameter(valid_568413, JString, required = true,
                                 default = nil)
  if valid_568413 != nil:
    section.add "subscriptionId", valid_568413
  var valid_568414 = path.getOrDefault("kind")
  valid_568414 = validateParameter(valid_568414, JString, required = true,
                                 default = newJString("announcements"))
  if valid_568414 != nil:
    section.add "kind", valid_568414
  var valid_568415 = path.getOrDefault("id")
  valid_568415 = validateParameter(valid_568415, JInt, required = true, default = nil)
  if valid_568415 != nil:
    section.add "id", valid_568415
  var valid_568416 = path.getOrDefault("appCollection")
  valid_568416 = validateParameter(valid_568416, JString, required = true,
                                 default = nil)
  if valid_568416 != nil:
    section.add "appCollection", valid_568416
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568417 = query.getOrDefault("api-version")
  valid_568417 = validateParameter(valid_568417, JString, required = true,
                                 default = nil)
  if valid_568417 != nil:
    section.add "api-version", valid_568417
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568418: Call_CampaignsGetStatistics_568408; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the campaign statistics.
  ## 
  let valid = call_568418.validator(path, query, header, formData, body)
  let scheme = call_568418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568418.url(scheme.get, call_568418.host, call_568418.base,
                         call_568418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568418, url, valid)

proc call*(call_568419: Call_CampaignsGetStatistics_568408;
          resourceGroupName: string; apiVersion: string; appName: string;
          subscriptionId: string; id: int; appCollection: string;
          kind: string = "announcements"): Recallable =
  ## campaignsGetStatistics
  ## Get all the campaign statistics.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   id: int (required)
  ##     : Campaign identifier.
  ##   appCollection: string (required)
  ##                : Application collection.
  var path_568420 = newJObject()
  var query_568421 = newJObject()
  add(path_568420, "resourceGroupName", newJString(resourceGroupName))
  add(query_568421, "api-version", newJString(apiVersion))
  add(path_568420, "appName", newJString(appName))
  add(path_568420, "subscriptionId", newJString(subscriptionId))
  add(path_568420, "kind", newJString(kind))
  add(path_568420, "id", newJInt(id))
  add(path_568420, "appCollection", newJString(appCollection))
  result = call_568419.call(path_568420, query_568421, nil, nil, nil)

var campaignsGetStatistics* = Call_CampaignsGetStatistics_568408(
    name: "campaignsGetStatistics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}/statistics",
    validator: validate_CampaignsGetStatistics_568409, base: "",
    url: url_CampaignsGetStatistics_568410, schemes: {Scheme.Https})
type
  Call_CampaignsSuspend_568422 = ref object of OpenApiRestCall_567666
proc url_CampaignsSuspend_568424(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  assert "kind" in path, "`kind` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/campaigns/"),
               (kind: VariableSegment, value: "kind"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/suspend")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CampaignsSuspend_568423(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Suspend a push campaign previously activated by a call to Activate campaign.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   id: JInt (required)
  ##     : Campaign identifier.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568425 = path.getOrDefault("resourceGroupName")
  valid_568425 = validateParameter(valid_568425, JString, required = true,
                                 default = nil)
  if valid_568425 != nil:
    section.add "resourceGroupName", valid_568425
  var valid_568426 = path.getOrDefault("appName")
  valid_568426 = validateParameter(valid_568426, JString, required = true,
                                 default = nil)
  if valid_568426 != nil:
    section.add "appName", valid_568426
  var valid_568427 = path.getOrDefault("subscriptionId")
  valid_568427 = validateParameter(valid_568427, JString, required = true,
                                 default = nil)
  if valid_568427 != nil:
    section.add "subscriptionId", valid_568427
  var valid_568428 = path.getOrDefault("kind")
  valid_568428 = validateParameter(valid_568428, JString, required = true,
                                 default = newJString("announcements"))
  if valid_568428 != nil:
    section.add "kind", valid_568428
  var valid_568429 = path.getOrDefault("id")
  valid_568429 = validateParameter(valid_568429, JInt, required = true, default = nil)
  if valid_568429 != nil:
    section.add "id", valid_568429
  var valid_568430 = path.getOrDefault("appCollection")
  valid_568430 = validateParameter(valid_568430, JString, required = true,
                                 default = nil)
  if valid_568430 != nil:
    section.add "appCollection", valid_568430
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568431 = query.getOrDefault("api-version")
  valid_568431 = validateParameter(valid_568431, JString, required = true,
                                 default = nil)
  if valid_568431 != nil:
    section.add "api-version", valid_568431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568432: Call_CampaignsSuspend_568422; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suspend a push campaign previously activated by a call to Activate campaign.
  ## 
  let valid = call_568432.validator(path, query, header, formData, body)
  let scheme = call_568432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568432.url(scheme.get, call_568432.host, call_568432.base,
                         call_568432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568432, url, valid)

proc call*(call_568433: Call_CampaignsSuspend_568422; resourceGroupName: string;
          apiVersion: string; appName: string; subscriptionId: string; id: int;
          appCollection: string; kind: string = "announcements"): Recallable =
  ## campaignsSuspend
  ## Suspend a push campaign previously activated by a call to Activate campaign.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   id: int (required)
  ##     : Campaign identifier.
  ##   appCollection: string (required)
  ##                : Application collection.
  var path_568434 = newJObject()
  var query_568435 = newJObject()
  add(path_568434, "resourceGroupName", newJString(resourceGroupName))
  add(query_568435, "api-version", newJString(apiVersion))
  add(path_568434, "appName", newJString(appName))
  add(path_568434, "subscriptionId", newJString(subscriptionId))
  add(path_568434, "kind", newJString(kind))
  add(path_568434, "id", newJInt(id))
  add(path_568434, "appCollection", newJString(appCollection))
  result = call_568433.call(path_568434, query_568435, nil, nil, nil)

var campaignsSuspend* = Call_CampaignsSuspend_568422(name: "campaignsSuspend",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}/suspend",
    validator: validate_CampaignsSuspend_568423, base: "",
    url: url_CampaignsSuspend_568424, schemes: {Scheme.Https})
type
  Call_CampaignsTestSaved_568436 = ref object of OpenApiRestCall_567666
proc url_CampaignsTestSaved_568438(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  assert "kind" in path, "`kind` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/campaigns/"),
               (kind: VariableSegment, value: "kind"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "id"),
               (kind: ConstantSegment, value: "/test")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CampaignsTestSaved_568437(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Test an existing campaign (created with Create campaign) on a set of devices.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   id: JInt (required)
  ##     : Campaign identifier.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568439 = path.getOrDefault("resourceGroupName")
  valid_568439 = validateParameter(valid_568439, JString, required = true,
                                 default = nil)
  if valid_568439 != nil:
    section.add "resourceGroupName", valid_568439
  var valid_568440 = path.getOrDefault("appName")
  valid_568440 = validateParameter(valid_568440, JString, required = true,
                                 default = nil)
  if valid_568440 != nil:
    section.add "appName", valid_568440
  var valid_568441 = path.getOrDefault("subscriptionId")
  valid_568441 = validateParameter(valid_568441, JString, required = true,
                                 default = nil)
  if valid_568441 != nil:
    section.add "subscriptionId", valid_568441
  var valid_568442 = path.getOrDefault("kind")
  valid_568442 = validateParameter(valid_568442, JString, required = true,
                                 default = newJString("announcements"))
  if valid_568442 != nil:
    section.add "kind", valid_568442
  var valid_568443 = path.getOrDefault("id")
  valid_568443 = validateParameter(valid_568443, JInt, required = true, default = nil)
  if valid_568443 != nil:
    section.add "id", valid_568443
  var valid_568444 = path.getOrDefault("appCollection")
  valid_568444 = validateParameter(valid_568444, JString, required = true,
                                 default = nil)
  if valid_568444 != nil:
    section.add "appCollection", valid_568444
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568445 = query.getOrDefault("api-version")
  valid_568445 = validateParameter(valid_568445, JString, required = true,
                                 default = nil)
  if valid_568445 != nil:
    section.add "api-version", valid_568445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Test Campaign operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568447: Call_CampaignsTestSaved_568436; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Test an existing campaign (created with Create campaign) on a set of devices.
  ## 
  let valid = call_568447.validator(path, query, header, formData, body)
  let scheme = call_568447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568447.url(scheme.get, call_568447.host, call_568447.base,
                         call_568447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568447, url, valid)

proc call*(call_568448: Call_CampaignsTestSaved_568436; resourceGroupName: string;
          apiVersion: string; appName: string; subscriptionId: string; id: int;
          appCollection: string; parameters: JsonNode;
          kind: string = "announcements"): Recallable =
  ## campaignsTestSaved
  ## Test an existing campaign (created with Create campaign) on a set of devices.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   id: int (required)
  ##     : Campaign identifier.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Test Campaign operation.
  var path_568449 = newJObject()
  var query_568450 = newJObject()
  var body_568451 = newJObject()
  add(path_568449, "resourceGroupName", newJString(resourceGroupName))
  add(query_568450, "api-version", newJString(apiVersion))
  add(path_568449, "appName", newJString(appName))
  add(path_568449, "subscriptionId", newJString(subscriptionId))
  add(path_568449, "kind", newJString(kind))
  add(path_568449, "id", newJInt(id))
  add(path_568449, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_568451 = parameters
  result = call_568448.call(path_568449, query_568450, nil, nil, body_568451)

var campaignsTestSaved* = Call_CampaignsTestSaved_568436(
    name: "campaignsTestSaved", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}/test",
    validator: validate_CampaignsTestSaved_568437, base: "",
    url: url_CampaignsTestSaved_568438, schemes: {Scheme.Https})
type
  Call_CampaignsGetByName_568452 = ref object of OpenApiRestCall_567666
proc url_CampaignsGetByName_568454(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  assert "kind" in path, "`kind` is a required path parameter"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/campaignsByName/"),
               (kind: VariableSegment, value: "kind"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CampaignsGetByName_568453(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## The Get campaign operation retrieves information about a previously created campaign.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   name: JString (required)
  ##       : Campaign name.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568455 = path.getOrDefault("resourceGroupName")
  valid_568455 = validateParameter(valid_568455, JString, required = true,
                                 default = nil)
  if valid_568455 != nil:
    section.add "resourceGroupName", valid_568455
  var valid_568456 = path.getOrDefault("name")
  valid_568456 = validateParameter(valid_568456, JString, required = true,
                                 default = nil)
  if valid_568456 != nil:
    section.add "name", valid_568456
  var valid_568457 = path.getOrDefault("appName")
  valid_568457 = validateParameter(valid_568457, JString, required = true,
                                 default = nil)
  if valid_568457 != nil:
    section.add "appName", valid_568457
  var valid_568458 = path.getOrDefault("subscriptionId")
  valid_568458 = validateParameter(valid_568458, JString, required = true,
                                 default = nil)
  if valid_568458 != nil:
    section.add "subscriptionId", valid_568458
  var valid_568459 = path.getOrDefault("kind")
  valid_568459 = validateParameter(valid_568459, JString, required = true,
                                 default = newJString("announcements"))
  if valid_568459 != nil:
    section.add "kind", valid_568459
  var valid_568460 = path.getOrDefault("appCollection")
  valid_568460 = validateParameter(valid_568460, JString, required = true,
                                 default = nil)
  if valid_568460 != nil:
    section.add "appCollection", valid_568460
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568461 = query.getOrDefault("api-version")
  valid_568461 = validateParameter(valid_568461, JString, required = true,
                                 default = nil)
  if valid_568461 != nil:
    section.add "api-version", valid_568461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568462: Call_CampaignsGetByName_568452; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get campaign operation retrieves information about a previously created campaign.
  ## 
  let valid = call_568462.validator(path, query, header, formData, body)
  let scheme = call_568462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568462.url(scheme.get, call_568462.host, call_568462.base,
                         call_568462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568462, url, valid)

proc call*(call_568463: Call_CampaignsGetByName_568452; resourceGroupName: string;
          apiVersion: string; name: string; appName: string; subscriptionId: string;
          appCollection: string; kind: string = "announcements"): Recallable =
  ## campaignsGetByName
  ## The Get campaign operation retrieves information about a previously created campaign.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   name: string (required)
  ##       : Campaign name.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   appCollection: string (required)
  ##                : Application collection.
  var path_568464 = newJObject()
  var query_568465 = newJObject()
  add(path_568464, "resourceGroupName", newJString(resourceGroupName))
  add(query_568465, "api-version", newJString(apiVersion))
  add(path_568464, "name", newJString(name))
  add(path_568464, "appName", newJString(appName))
  add(path_568464, "subscriptionId", newJString(subscriptionId))
  add(path_568464, "kind", newJString(kind))
  add(path_568464, "appCollection", newJString(appCollection))
  result = call_568463.call(path_568464, query_568465, nil, nil, nil)

var campaignsGetByName* = Call_CampaignsGetByName_568452(
    name: "campaignsGetByName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaignsByName/{kind}/{name}",
    validator: validate_CampaignsGetByName_568453, base: "",
    url: url_CampaignsGetByName_568454, schemes: {Scheme.Https})
type
  Call_DevicesList_568466 = ref object of OpenApiRestCall_567666
proc url_DevicesList_568468(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/devices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesList_568467(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Query the information associated to the devices running an application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568469 = path.getOrDefault("resourceGroupName")
  valid_568469 = validateParameter(valid_568469, JString, required = true,
                                 default = nil)
  if valid_568469 != nil:
    section.add "resourceGroupName", valid_568469
  var valid_568470 = path.getOrDefault("appName")
  valid_568470 = validateParameter(valid_568470, JString, required = true,
                                 default = nil)
  if valid_568470 != nil:
    section.add "appName", valid_568470
  var valid_568471 = path.getOrDefault("subscriptionId")
  valid_568471 = validateParameter(valid_568471, JString, required = true,
                                 default = nil)
  if valid_568471 != nil:
    section.add "subscriptionId", valid_568471
  var valid_568472 = path.getOrDefault("appCollection")
  valid_568472 = validateParameter(valid_568472, JString, required = true,
                                 default = nil)
  if valid_568472 != nil:
    section.add "appCollection", valid_568472
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Number of devices to return with each call. Defaults to 100 and cannot return more. Passing a greater value is ignored. The response contains a `nextLink` property describing the URI path to get the next page of results if not all results could be returned at once.
  ##   $select: JString
  ##          : By default all `meta` and `appInfo` properties are returned, this property is used to restrict the output to the desired properties. It also excludes all devices from the output that have none of the selected properties. In other terms, only devices having at least one of the selected property being set is part of the results. Examples: - `$select=appInfo` : select all devices having at least 1 appInfo, return them all and don’t return any meta property. - `$select=meta` : return only meta properties in the output. - `$select=appInfo,meta/firstSeen,meta/lastSeen` : return all `appInfo`, plus meta object containing only firstSeen and lastSeen properties. The format is thus a comma separated list of properties to select. Use `appInfo` to select all appInfo properties, `meta` to select all meta properties. Use `appInfo/{key}` and `meta/{key}` to select specific appInfo and meta properties.
  ##   $filter: JString
  ##          : Filter can be used to reduce the number of results. Filter is a boolean expression that can look like the following examples: * `$filter=deviceId gt 'abcdef0123456789abcdef0123456789'` * `$filter=lastModified le 1447284263690L` * `$filter=(deviceId ge 'abcdef0123456789abcdef0123456789') and (deviceId lt 'bacdef0123456789abcdef0123456789') and (lastModified gt 1447284263690L)` The first example is used automatically for paging when returning the `nextLink` property. The filter expression is a combination of checks on some properties that can be compared to their value. The available operators are: * `gt`  : greater than * `ge`  : greater than or equals * `lt`  : less than * `le`  : less than or equals * `and` : to add multiple checks (all checks must pass), optional parentheses can be used. The properties that can be used in the expression are the following: * `deviceId {operator} '{deviceIdValue}'` : a lexicographical comparison is made on the deviceId value, use single quotes for the value. * `lastModified {operator} {number}L` : returns only meta properties or appInfo properties whose last value modification timestamp compared to the specified value is matching (value is milliseconds since January 1st, 1970 UTC). Please note the `L` character after the number of milliseconds, its required when the number of milliseconds exceeds `2^31 - 1` (which is always the case for recent timestamps). Using `lastModified` excludes all devices from the output that have no property matching the timestamp criteria, like `$select`. Please note that the internal value of `lastModified` timestamp for a given property is never part of the results.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568473 = query.getOrDefault("api-version")
  valid_568473 = validateParameter(valid_568473, JString, required = true,
                                 default = nil)
  if valid_568473 != nil:
    section.add "api-version", valid_568473
  var valid_568474 = query.getOrDefault("$top")
  valid_568474 = validateParameter(valid_568474, JInt, required = false, default = nil)
  if valid_568474 != nil:
    section.add "$top", valid_568474
  var valid_568475 = query.getOrDefault("$select")
  valid_568475 = validateParameter(valid_568475, JString, required = false,
                                 default = nil)
  if valid_568475 != nil:
    section.add "$select", valid_568475
  var valid_568476 = query.getOrDefault("$filter")
  valid_568476 = validateParameter(valid_568476, JString, required = false,
                                 default = nil)
  if valid_568476 != nil:
    section.add "$filter", valid_568476
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568477: Call_DevicesList_568466; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the information associated to the devices running an application.
  ## 
  let valid = call_568477.validator(path, query, header, formData, body)
  let scheme = call_568477.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568477.url(scheme.get, call_568477.host, call_568477.base,
                         call_568477.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568477, url, valid)

proc call*(call_568478: Call_DevicesList_568466; resourceGroupName: string;
          apiVersion: string; appName: string; subscriptionId: string;
          appCollection: string; Top: int = 0; Select: string = ""; Filter: string = ""): Recallable =
  ## devicesList
  ## Query the information associated to the devices running an application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Number of devices to return with each call. Defaults to 100 and cannot return more. Passing a greater value is ignored. The response contains a `nextLink` property describing the URI path to get the next page of results if not all results could be returned at once.
  ##   Select: string
  ##         : By default all `meta` and `appInfo` properties are returned, this property is used to restrict the output to the desired properties. It also excludes all devices from the output that have none of the selected properties. In other terms, only devices having at least one of the selected property being set is part of the results. Examples: - `$select=appInfo` : select all devices having at least 1 appInfo, return them all and don’t return any meta property. - `$select=meta` : return only meta properties in the output. - `$select=appInfo,meta/firstSeen,meta/lastSeen` : return all `appInfo`, plus meta object containing only firstSeen and lastSeen properties. The format is thus a comma separated list of properties to select. Use `appInfo` to select all appInfo properties, `meta` to select all meta properties. Use `appInfo/{key}` and `meta/{key}` to select specific appInfo and meta properties.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   Filter: string
  ##         : Filter can be used to reduce the number of results. Filter is a boolean expression that can look like the following examples: * `$filter=deviceId gt 'abcdef0123456789abcdef0123456789'` * `$filter=lastModified le 1447284263690L` * `$filter=(deviceId ge 'abcdef0123456789abcdef0123456789') and (deviceId lt 'bacdef0123456789abcdef0123456789') and (lastModified gt 1447284263690L)` The first example is used automatically for paging when returning the `nextLink` property. The filter expression is a combination of checks on some properties that can be compared to their value. The available operators are: * `gt`  : greater than * `ge`  : greater than or equals * `lt`  : less than * `le`  : less than or equals * `and` : to add multiple checks (all checks must pass), optional parentheses can be used. The properties that can be used in the expression are the following: * `deviceId {operator} '{deviceIdValue}'` : a lexicographical comparison is made on the deviceId value, use single quotes for the value. * `lastModified {operator} {number}L` : returns only meta properties or appInfo properties whose last value modification timestamp compared to the specified value is matching (value is milliseconds since January 1st, 1970 UTC). Please note the `L` character after the number of milliseconds, its required when the number of milliseconds exceeds `2^31 - 1` (which is always the case for recent timestamps). Using `lastModified` excludes all devices from the output that have no property matching the timestamp criteria, like `$select`. Please note that the internal value of `lastModified` timestamp for a given property is never part of the results.
  var path_568479 = newJObject()
  var query_568480 = newJObject()
  add(path_568479, "resourceGroupName", newJString(resourceGroupName))
  add(query_568480, "api-version", newJString(apiVersion))
  add(path_568479, "appName", newJString(appName))
  add(path_568479, "subscriptionId", newJString(subscriptionId))
  add(query_568480, "$top", newJInt(Top))
  add(query_568480, "$select", newJString(Select))
  add(path_568479, "appCollection", newJString(appCollection))
  add(query_568480, "$filter", newJString(Filter))
  result = call_568478.call(path_568479, query_568480, nil, nil, nil)

var devicesList* = Call_DevicesList_568466(name: "devicesList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices",
                                        validator: validate_DevicesList_568467,
                                        base: "", url: url_DevicesList_568468,
                                        schemes: {Scheme.Https})
type
  Call_ExportTasksList_568481 = ref object of OpenApiRestCall_567666
proc url_ExportTasksList_568483(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/devices/exportTasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportTasksList_568482(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get the list of export tasks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568484 = path.getOrDefault("resourceGroupName")
  valid_568484 = validateParameter(valid_568484, JString, required = true,
                                 default = nil)
  if valid_568484 != nil:
    section.add "resourceGroupName", valid_568484
  var valid_568485 = path.getOrDefault("appName")
  valid_568485 = validateParameter(valid_568485, JString, required = true,
                                 default = nil)
  if valid_568485 != nil:
    section.add "appName", valid_568485
  var valid_568486 = path.getOrDefault("subscriptionId")
  valid_568486 = validateParameter(valid_568486, JString, required = true,
                                 default = nil)
  if valid_568486 != nil:
    section.add "subscriptionId", valid_568486
  var valid_568487 = path.getOrDefault("appCollection")
  valid_568487 = validateParameter(valid_568487, JString, required = true,
                                 default = nil)
  if valid_568487 != nil:
    section.add "appCollection", valid_568487
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Sort results by an expression which looks like `$orderby=taskId asc` (default when not specified).
  ## The syntax is orderby={property} {direction} or just orderby={property}.
  ## Properties that can be specified for sorting: taskId, errorDetails, dateCreated, taskStatus, and dateCreated.
  ## The available directions are asc (for ascending order) and desc (for descending order).
  ## When not specified the asc direction is used.
  ## Only one orderby property can be specified.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Control paging of export tasks, number of export tasks to return with each call. By default, it returns all export tasks with a default paging of 20.
  ## The response contains a `nextLink` property describing the path to get the next page if there are more results.
  ## The maximum paging limit for $top is 40.
  ##   $skip: JInt
  ##        : Control paging of export tasks, start results at the given offset, defaults to 0 (1st page of data).
  section = newJObject()
  var valid_568488 = query.getOrDefault("$orderby")
  valid_568488 = validateParameter(valid_568488, JString, required = false,
                                 default = nil)
  if valid_568488 != nil:
    section.add "$orderby", valid_568488
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568489 = query.getOrDefault("api-version")
  valid_568489 = validateParameter(valid_568489, JString, required = true,
                                 default = nil)
  if valid_568489 != nil:
    section.add "api-version", valid_568489
  var valid_568491 = query.getOrDefault("$top")
  valid_568491 = validateParameter(valid_568491, JInt, required = false,
                                 default = newJInt(20))
  if valid_568491 != nil:
    section.add "$top", valid_568491
  var valid_568492 = query.getOrDefault("$skip")
  valid_568492 = validateParameter(valid_568492, JInt, required = false,
                                 default = newJInt(0))
  if valid_568492 != nil:
    section.add "$skip", valid_568492
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568493: Call_ExportTasksList_568481; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of export tasks.
  ## 
  let valid = call_568493.validator(path, query, header, formData, body)
  let scheme = call_568493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568493.url(scheme.get, call_568493.host, call_568493.base,
                         call_568493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568493, url, valid)

proc call*(call_568494: Call_ExportTasksList_568481; resourceGroupName: string;
          apiVersion: string; appName: string; subscriptionId: string;
          appCollection: string; Orderby: string = ""; Top: int = 20; Skip: int = 0): Recallable =
  ## exportTasksList
  ## Get the list of export tasks.
  ##   Orderby: string
  ##          : Sort results by an expression which looks like `$orderby=taskId asc` (default when not specified).
  ## The syntax is orderby={property} {direction} or just orderby={property}.
  ## Properties that can be specified for sorting: taskId, errorDetails, dateCreated, taskStatus, and dateCreated.
  ## The available directions are asc (for ascending order) and desc (for descending order).
  ## When not specified the asc direction is used.
  ## Only one orderby property can be specified.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Control paging of export tasks, number of export tasks to return with each call. By default, it returns all export tasks with a default paging of 20.
  ## The response contains a `nextLink` property describing the path to get the next page if there are more results.
  ## The maximum paging limit for $top is 40.
  ##   Skip: int
  ##       : Control paging of export tasks, start results at the given offset, defaults to 0 (1st page of data).
  ##   appCollection: string (required)
  ##                : Application collection.
  var path_568495 = newJObject()
  var query_568496 = newJObject()
  add(query_568496, "$orderby", newJString(Orderby))
  add(path_568495, "resourceGroupName", newJString(resourceGroupName))
  add(query_568496, "api-version", newJString(apiVersion))
  add(path_568495, "appName", newJString(appName))
  add(path_568495, "subscriptionId", newJString(subscriptionId))
  add(query_568496, "$top", newJInt(Top))
  add(query_568496, "$skip", newJInt(Skip))
  add(path_568495, "appCollection", newJString(appCollection))
  result = call_568494.call(path_568495, query_568496, nil, nil, nil)

var exportTasksList* = Call_ExportTasksList_568481(name: "exportTasksList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks",
    validator: validate_ExportTasksList_568482, base: "", url: url_ExportTasksList_568483,
    schemes: {Scheme.Https})
type
  Call_ExportTasksCreateActivitiesTask_568497 = ref object of OpenApiRestCall_567666
proc url_ExportTasksCreateActivitiesTask_568499(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"), (kind: ConstantSegment,
        value: "/devices/exportTasks/activities")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportTasksCreateActivitiesTask_568498(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task to export activities.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568500 = path.getOrDefault("resourceGroupName")
  valid_568500 = validateParameter(valid_568500, JString, required = true,
                                 default = nil)
  if valid_568500 != nil:
    section.add "resourceGroupName", valid_568500
  var valid_568501 = path.getOrDefault("appName")
  valid_568501 = validateParameter(valid_568501, JString, required = true,
                                 default = nil)
  if valid_568501 != nil:
    section.add "appName", valid_568501
  var valid_568502 = path.getOrDefault("subscriptionId")
  valid_568502 = validateParameter(valid_568502, JString, required = true,
                                 default = nil)
  if valid_568502 != nil:
    section.add "subscriptionId", valid_568502
  var valid_568503 = path.getOrDefault("appCollection")
  valid_568503 = validateParameter(valid_568503, JString, required = true,
                                 default = nil)
  if valid_568503 != nil:
    section.add "appCollection", valid_568503
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568504 = query.getOrDefault("api-version")
  valid_568504 = validateParameter(valid_568504, JString, required = true,
                                 default = nil)
  if valid_568504 != nil:
    section.add "api-version", valid_568504
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568506: Call_ExportTasksCreateActivitiesTask_568497;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a task to export activities.
  ## 
  let valid = call_568506.validator(path, query, header, formData, body)
  let scheme = call_568506.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568506.url(scheme.get, call_568506.host, call_568506.base,
                         call_568506.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568506, url, valid)

proc call*(call_568507: Call_ExportTasksCreateActivitiesTask_568497;
          resourceGroupName: string; apiVersion: string; appName: string;
          subscriptionId: string; appCollection: string; parameters: JsonNode): Recallable =
  ## exportTasksCreateActivitiesTask
  ## Creates a task to export activities.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   parameters: JObject (required)
  var path_568508 = newJObject()
  var query_568509 = newJObject()
  var body_568510 = newJObject()
  add(path_568508, "resourceGroupName", newJString(resourceGroupName))
  add(query_568509, "api-version", newJString(apiVersion))
  add(path_568508, "appName", newJString(appName))
  add(path_568508, "subscriptionId", newJString(subscriptionId))
  add(path_568508, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_568510 = parameters
  result = call_568507.call(path_568508, query_568509, nil, nil, body_568510)

var exportTasksCreateActivitiesTask* = Call_ExportTasksCreateActivitiesTask_568497(
    name: "exportTasksCreateActivitiesTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/activities",
    validator: validate_ExportTasksCreateActivitiesTask_568498, base: "",
    url: url_ExportTasksCreateActivitiesTask_568499, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateCrashesTask_568511 = ref object of OpenApiRestCall_567666
proc url_ExportTasksCreateCrashesTask_568513(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/devices/exportTasks/crashes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportTasksCreateCrashesTask_568512(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task to export crashes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568514 = path.getOrDefault("resourceGroupName")
  valid_568514 = validateParameter(valid_568514, JString, required = true,
                                 default = nil)
  if valid_568514 != nil:
    section.add "resourceGroupName", valid_568514
  var valid_568515 = path.getOrDefault("appName")
  valid_568515 = validateParameter(valid_568515, JString, required = true,
                                 default = nil)
  if valid_568515 != nil:
    section.add "appName", valid_568515
  var valid_568516 = path.getOrDefault("subscriptionId")
  valid_568516 = validateParameter(valid_568516, JString, required = true,
                                 default = nil)
  if valid_568516 != nil:
    section.add "subscriptionId", valid_568516
  var valid_568517 = path.getOrDefault("appCollection")
  valid_568517 = validateParameter(valid_568517, JString, required = true,
                                 default = nil)
  if valid_568517 != nil:
    section.add "appCollection", valid_568517
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568518 = query.getOrDefault("api-version")
  valid_568518 = validateParameter(valid_568518, JString, required = true,
                                 default = nil)
  if valid_568518 != nil:
    section.add "api-version", valid_568518
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568520: Call_ExportTasksCreateCrashesTask_568511; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export crashes.
  ## 
  let valid = call_568520.validator(path, query, header, formData, body)
  let scheme = call_568520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568520.url(scheme.get, call_568520.host, call_568520.base,
                         call_568520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568520, url, valid)

proc call*(call_568521: Call_ExportTasksCreateCrashesTask_568511;
          resourceGroupName: string; apiVersion: string; appName: string;
          subscriptionId: string; appCollection: string; parameters: JsonNode): Recallable =
  ## exportTasksCreateCrashesTask
  ## Creates a task to export crashes.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   parameters: JObject (required)
  var path_568522 = newJObject()
  var query_568523 = newJObject()
  var body_568524 = newJObject()
  add(path_568522, "resourceGroupName", newJString(resourceGroupName))
  add(query_568523, "api-version", newJString(apiVersion))
  add(path_568522, "appName", newJString(appName))
  add(path_568522, "subscriptionId", newJString(subscriptionId))
  add(path_568522, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_568524 = parameters
  result = call_568521.call(path_568522, query_568523, nil, nil, body_568524)

var exportTasksCreateCrashesTask* = Call_ExportTasksCreateCrashesTask_568511(
    name: "exportTasksCreateCrashesTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/crashes",
    validator: validate_ExportTasksCreateCrashesTask_568512, base: "",
    url: url_ExportTasksCreateCrashesTask_568513, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateErrorsTask_568525 = ref object of OpenApiRestCall_567666
proc url_ExportTasksCreateErrorsTask_568527(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/devices/exportTasks/errors")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportTasksCreateErrorsTask_568526(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task to export errors.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568528 = path.getOrDefault("resourceGroupName")
  valid_568528 = validateParameter(valid_568528, JString, required = true,
                                 default = nil)
  if valid_568528 != nil:
    section.add "resourceGroupName", valid_568528
  var valid_568529 = path.getOrDefault("appName")
  valid_568529 = validateParameter(valid_568529, JString, required = true,
                                 default = nil)
  if valid_568529 != nil:
    section.add "appName", valid_568529
  var valid_568530 = path.getOrDefault("subscriptionId")
  valid_568530 = validateParameter(valid_568530, JString, required = true,
                                 default = nil)
  if valid_568530 != nil:
    section.add "subscriptionId", valid_568530
  var valid_568531 = path.getOrDefault("appCollection")
  valid_568531 = validateParameter(valid_568531, JString, required = true,
                                 default = nil)
  if valid_568531 != nil:
    section.add "appCollection", valid_568531
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568532 = query.getOrDefault("api-version")
  valid_568532 = validateParameter(valid_568532, JString, required = true,
                                 default = nil)
  if valid_568532 != nil:
    section.add "api-version", valid_568532
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568534: Call_ExportTasksCreateErrorsTask_568525; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export errors.
  ## 
  let valid = call_568534.validator(path, query, header, formData, body)
  let scheme = call_568534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568534.url(scheme.get, call_568534.host, call_568534.base,
                         call_568534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568534, url, valid)

proc call*(call_568535: Call_ExportTasksCreateErrorsTask_568525;
          resourceGroupName: string; apiVersion: string; appName: string;
          subscriptionId: string; appCollection: string; parameters: JsonNode): Recallable =
  ## exportTasksCreateErrorsTask
  ## Creates a task to export errors.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   parameters: JObject (required)
  var path_568536 = newJObject()
  var query_568537 = newJObject()
  var body_568538 = newJObject()
  add(path_568536, "resourceGroupName", newJString(resourceGroupName))
  add(query_568537, "api-version", newJString(apiVersion))
  add(path_568536, "appName", newJString(appName))
  add(path_568536, "subscriptionId", newJString(subscriptionId))
  add(path_568536, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_568538 = parameters
  result = call_568535.call(path_568536, query_568537, nil, nil, body_568538)

var exportTasksCreateErrorsTask* = Call_ExportTasksCreateErrorsTask_568525(
    name: "exportTasksCreateErrorsTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/errors",
    validator: validate_ExportTasksCreateErrorsTask_568526, base: "",
    url: url_ExportTasksCreateErrorsTask_568527, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateEventsTask_568539 = ref object of OpenApiRestCall_567666
proc url_ExportTasksCreateEventsTask_568541(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/devices/exportTasks/events")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportTasksCreateEventsTask_568540(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task to export events.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568542 = path.getOrDefault("resourceGroupName")
  valid_568542 = validateParameter(valid_568542, JString, required = true,
                                 default = nil)
  if valid_568542 != nil:
    section.add "resourceGroupName", valid_568542
  var valid_568543 = path.getOrDefault("appName")
  valid_568543 = validateParameter(valid_568543, JString, required = true,
                                 default = nil)
  if valid_568543 != nil:
    section.add "appName", valid_568543
  var valid_568544 = path.getOrDefault("subscriptionId")
  valid_568544 = validateParameter(valid_568544, JString, required = true,
                                 default = nil)
  if valid_568544 != nil:
    section.add "subscriptionId", valid_568544
  var valid_568545 = path.getOrDefault("appCollection")
  valid_568545 = validateParameter(valid_568545, JString, required = true,
                                 default = nil)
  if valid_568545 != nil:
    section.add "appCollection", valid_568545
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568546 = query.getOrDefault("api-version")
  valid_568546 = validateParameter(valid_568546, JString, required = true,
                                 default = nil)
  if valid_568546 != nil:
    section.add "api-version", valid_568546
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568548: Call_ExportTasksCreateEventsTask_568539; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export events.
  ## 
  let valid = call_568548.validator(path, query, header, formData, body)
  let scheme = call_568548.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568548.url(scheme.get, call_568548.host, call_568548.base,
                         call_568548.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568548, url, valid)

proc call*(call_568549: Call_ExportTasksCreateEventsTask_568539;
          resourceGroupName: string; apiVersion: string; appName: string;
          subscriptionId: string; appCollection: string; parameters: JsonNode): Recallable =
  ## exportTasksCreateEventsTask
  ## Creates a task to export events.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   parameters: JObject (required)
  var path_568550 = newJObject()
  var query_568551 = newJObject()
  var body_568552 = newJObject()
  add(path_568550, "resourceGroupName", newJString(resourceGroupName))
  add(query_568551, "api-version", newJString(apiVersion))
  add(path_568550, "appName", newJString(appName))
  add(path_568550, "subscriptionId", newJString(subscriptionId))
  add(path_568550, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_568552 = parameters
  result = call_568549.call(path_568550, query_568551, nil, nil, body_568552)

var exportTasksCreateEventsTask* = Call_ExportTasksCreateEventsTask_568539(
    name: "exportTasksCreateEventsTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/events",
    validator: validate_ExportTasksCreateEventsTask_568540, base: "",
    url: url_ExportTasksCreateEventsTask_568541, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateFeedbackTaskByCampaign_568553 = ref object of OpenApiRestCall_567666
proc url_ExportTasksCreateFeedbackTaskByCampaign_568555(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"), (kind: ConstantSegment,
        value: "/devices/exportTasks/feedbackByCampaign")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportTasksCreateFeedbackTaskByCampaign_568554(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task to export push campaign data for a set of campaigns.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568556 = path.getOrDefault("resourceGroupName")
  valid_568556 = validateParameter(valid_568556, JString, required = true,
                                 default = nil)
  if valid_568556 != nil:
    section.add "resourceGroupName", valid_568556
  var valid_568557 = path.getOrDefault("appName")
  valid_568557 = validateParameter(valid_568557, JString, required = true,
                                 default = nil)
  if valid_568557 != nil:
    section.add "appName", valid_568557
  var valid_568558 = path.getOrDefault("subscriptionId")
  valid_568558 = validateParameter(valid_568558, JString, required = true,
                                 default = nil)
  if valid_568558 != nil:
    section.add "subscriptionId", valid_568558
  var valid_568559 = path.getOrDefault("appCollection")
  valid_568559 = validateParameter(valid_568559, JString, required = true,
                                 default = nil)
  if valid_568559 != nil:
    section.add "appCollection", valid_568559
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568560 = query.getOrDefault("api-version")
  valid_568560 = validateParameter(valid_568560, JString, required = true,
                                 default = nil)
  if valid_568560 != nil:
    section.add "api-version", valid_568560
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568562: Call_ExportTasksCreateFeedbackTaskByCampaign_568553;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a task to export push campaign data for a set of campaigns.
  ## 
  let valid = call_568562.validator(path, query, header, formData, body)
  let scheme = call_568562.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568562.url(scheme.get, call_568562.host, call_568562.base,
                         call_568562.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568562, url, valid)

proc call*(call_568563: Call_ExportTasksCreateFeedbackTaskByCampaign_568553;
          resourceGroupName: string; apiVersion: string; appName: string;
          subscriptionId: string; appCollection: string; parameters: JsonNode): Recallable =
  ## exportTasksCreateFeedbackTaskByCampaign
  ## Creates a task to export push campaign data for a set of campaigns.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   parameters: JObject (required)
  var path_568564 = newJObject()
  var query_568565 = newJObject()
  var body_568566 = newJObject()
  add(path_568564, "resourceGroupName", newJString(resourceGroupName))
  add(query_568565, "api-version", newJString(apiVersion))
  add(path_568564, "appName", newJString(appName))
  add(path_568564, "subscriptionId", newJString(subscriptionId))
  add(path_568564, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_568566 = parameters
  result = call_568563.call(path_568564, query_568565, nil, nil, body_568566)

var exportTasksCreateFeedbackTaskByCampaign* = Call_ExportTasksCreateFeedbackTaskByCampaign_568553(
    name: "exportTasksCreateFeedbackTaskByCampaign", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/feedbackByCampaign",
    validator: validate_ExportTasksCreateFeedbackTaskByCampaign_568554, base: "",
    url: url_ExportTasksCreateFeedbackTaskByCampaign_568555,
    schemes: {Scheme.Https})
type
  Call_ExportTasksCreateFeedbackTaskByDateRange_568567 = ref object of OpenApiRestCall_567666
proc url_ExportTasksCreateFeedbackTaskByDateRange_568569(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"), (kind: ConstantSegment,
        value: "/devices/exportTasks/feedbackByDate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportTasksCreateFeedbackTaskByDateRange_568568(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task to export push campaign data for a date range.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568570 = path.getOrDefault("resourceGroupName")
  valid_568570 = validateParameter(valid_568570, JString, required = true,
                                 default = nil)
  if valid_568570 != nil:
    section.add "resourceGroupName", valid_568570
  var valid_568571 = path.getOrDefault("appName")
  valid_568571 = validateParameter(valid_568571, JString, required = true,
                                 default = nil)
  if valid_568571 != nil:
    section.add "appName", valid_568571
  var valid_568572 = path.getOrDefault("subscriptionId")
  valid_568572 = validateParameter(valid_568572, JString, required = true,
                                 default = nil)
  if valid_568572 != nil:
    section.add "subscriptionId", valid_568572
  var valid_568573 = path.getOrDefault("appCollection")
  valid_568573 = validateParameter(valid_568573, JString, required = true,
                                 default = nil)
  if valid_568573 != nil:
    section.add "appCollection", valid_568573
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568574 = query.getOrDefault("api-version")
  valid_568574 = validateParameter(valid_568574, JString, required = true,
                                 default = nil)
  if valid_568574 != nil:
    section.add "api-version", valid_568574
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568576: Call_ExportTasksCreateFeedbackTaskByDateRange_568567;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a task to export push campaign data for a date range.
  ## 
  let valid = call_568576.validator(path, query, header, formData, body)
  let scheme = call_568576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568576.url(scheme.get, call_568576.host, call_568576.base,
                         call_568576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568576, url, valid)

proc call*(call_568577: Call_ExportTasksCreateFeedbackTaskByDateRange_568567;
          resourceGroupName: string; apiVersion: string; appName: string;
          subscriptionId: string; appCollection: string; parameters: JsonNode): Recallable =
  ## exportTasksCreateFeedbackTaskByDateRange
  ## Creates a task to export push campaign data for a date range.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   parameters: JObject (required)
  var path_568578 = newJObject()
  var query_568579 = newJObject()
  var body_568580 = newJObject()
  add(path_568578, "resourceGroupName", newJString(resourceGroupName))
  add(query_568579, "api-version", newJString(apiVersion))
  add(path_568578, "appName", newJString(appName))
  add(path_568578, "subscriptionId", newJString(subscriptionId))
  add(path_568578, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_568580 = parameters
  result = call_568577.call(path_568578, query_568579, nil, nil, body_568580)

var exportTasksCreateFeedbackTaskByDateRange* = Call_ExportTasksCreateFeedbackTaskByDateRange_568567(
    name: "exportTasksCreateFeedbackTaskByDateRange", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/feedbackByDate",
    validator: validate_ExportTasksCreateFeedbackTaskByDateRange_568568, base: "",
    url: url_ExportTasksCreateFeedbackTaskByDateRange_568569,
    schemes: {Scheme.Https})
type
  Call_ExportTasksCreateJobsTask_568581 = ref object of OpenApiRestCall_567666
proc url_ExportTasksCreateJobsTask_568583(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/devices/exportTasks/jobs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportTasksCreateJobsTask_568582(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task to export jobs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568584 = path.getOrDefault("resourceGroupName")
  valid_568584 = validateParameter(valid_568584, JString, required = true,
                                 default = nil)
  if valid_568584 != nil:
    section.add "resourceGroupName", valid_568584
  var valid_568585 = path.getOrDefault("appName")
  valid_568585 = validateParameter(valid_568585, JString, required = true,
                                 default = nil)
  if valid_568585 != nil:
    section.add "appName", valid_568585
  var valid_568586 = path.getOrDefault("subscriptionId")
  valid_568586 = validateParameter(valid_568586, JString, required = true,
                                 default = nil)
  if valid_568586 != nil:
    section.add "subscriptionId", valid_568586
  var valid_568587 = path.getOrDefault("appCollection")
  valid_568587 = validateParameter(valid_568587, JString, required = true,
                                 default = nil)
  if valid_568587 != nil:
    section.add "appCollection", valid_568587
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568588 = query.getOrDefault("api-version")
  valid_568588 = validateParameter(valid_568588, JString, required = true,
                                 default = nil)
  if valid_568588 != nil:
    section.add "api-version", valid_568588
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568590: Call_ExportTasksCreateJobsTask_568581; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export jobs.
  ## 
  let valid = call_568590.validator(path, query, header, formData, body)
  let scheme = call_568590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568590.url(scheme.get, call_568590.host, call_568590.base,
                         call_568590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568590, url, valid)

proc call*(call_568591: Call_ExportTasksCreateJobsTask_568581;
          resourceGroupName: string; apiVersion: string; appName: string;
          subscriptionId: string; appCollection: string; parameters: JsonNode): Recallable =
  ## exportTasksCreateJobsTask
  ## Creates a task to export jobs.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   parameters: JObject (required)
  var path_568592 = newJObject()
  var query_568593 = newJObject()
  var body_568594 = newJObject()
  add(path_568592, "resourceGroupName", newJString(resourceGroupName))
  add(query_568593, "api-version", newJString(apiVersion))
  add(path_568592, "appName", newJString(appName))
  add(path_568592, "subscriptionId", newJString(subscriptionId))
  add(path_568592, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_568594 = parameters
  result = call_568591.call(path_568592, query_568593, nil, nil, body_568594)

var exportTasksCreateJobsTask* = Call_ExportTasksCreateJobsTask_568581(
    name: "exportTasksCreateJobsTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/jobs",
    validator: validate_ExportTasksCreateJobsTask_568582, base: "",
    url: url_ExportTasksCreateJobsTask_568583, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateSessionsTask_568595 = ref object of OpenApiRestCall_567666
proc url_ExportTasksCreateSessionsTask_568597(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/devices/exportTasks/sessions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportTasksCreateSessionsTask_568596(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task to export sessions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568598 = path.getOrDefault("resourceGroupName")
  valid_568598 = validateParameter(valid_568598, JString, required = true,
                                 default = nil)
  if valid_568598 != nil:
    section.add "resourceGroupName", valid_568598
  var valid_568599 = path.getOrDefault("appName")
  valid_568599 = validateParameter(valid_568599, JString, required = true,
                                 default = nil)
  if valid_568599 != nil:
    section.add "appName", valid_568599
  var valid_568600 = path.getOrDefault("subscriptionId")
  valid_568600 = validateParameter(valid_568600, JString, required = true,
                                 default = nil)
  if valid_568600 != nil:
    section.add "subscriptionId", valid_568600
  var valid_568601 = path.getOrDefault("appCollection")
  valid_568601 = validateParameter(valid_568601, JString, required = true,
                                 default = nil)
  if valid_568601 != nil:
    section.add "appCollection", valid_568601
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568602 = query.getOrDefault("api-version")
  valid_568602 = validateParameter(valid_568602, JString, required = true,
                                 default = nil)
  if valid_568602 != nil:
    section.add "api-version", valid_568602
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568604: Call_ExportTasksCreateSessionsTask_568595; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export sessions.
  ## 
  let valid = call_568604.validator(path, query, header, formData, body)
  let scheme = call_568604.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568604.url(scheme.get, call_568604.host, call_568604.base,
                         call_568604.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568604, url, valid)

proc call*(call_568605: Call_ExportTasksCreateSessionsTask_568595;
          resourceGroupName: string; apiVersion: string; appName: string;
          subscriptionId: string; appCollection: string; parameters: JsonNode): Recallable =
  ## exportTasksCreateSessionsTask
  ## Creates a task to export sessions.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   parameters: JObject (required)
  var path_568606 = newJObject()
  var query_568607 = newJObject()
  var body_568608 = newJObject()
  add(path_568606, "resourceGroupName", newJString(resourceGroupName))
  add(query_568607, "api-version", newJString(apiVersion))
  add(path_568606, "appName", newJString(appName))
  add(path_568606, "subscriptionId", newJString(subscriptionId))
  add(path_568606, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_568608 = parameters
  result = call_568605.call(path_568606, query_568607, nil, nil, body_568608)

var exportTasksCreateSessionsTask* = Call_ExportTasksCreateSessionsTask_568595(
    name: "exportTasksCreateSessionsTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/sessions",
    validator: validate_ExportTasksCreateSessionsTask_568596, base: "",
    url: url_ExportTasksCreateSessionsTask_568597, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateTagsTask_568609 = ref object of OpenApiRestCall_567666
proc url_ExportTasksCreateTagsTask_568611(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/devices/exportTasks/tags")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportTasksCreateTagsTask_568610(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task to export tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568612 = path.getOrDefault("resourceGroupName")
  valid_568612 = validateParameter(valid_568612, JString, required = true,
                                 default = nil)
  if valid_568612 != nil:
    section.add "resourceGroupName", valid_568612
  var valid_568613 = path.getOrDefault("appName")
  valid_568613 = validateParameter(valid_568613, JString, required = true,
                                 default = nil)
  if valid_568613 != nil:
    section.add "appName", valid_568613
  var valid_568614 = path.getOrDefault("subscriptionId")
  valid_568614 = validateParameter(valid_568614, JString, required = true,
                                 default = nil)
  if valid_568614 != nil:
    section.add "subscriptionId", valid_568614
  var valid_568615 = path.getOrDefault("appCollection")
  valid_568615 = validateParameter(valid_568615, JString, required = true,
                                 default = nil)
  if valid_568615 != nil:
    section.add "appCollection", valid_568615
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568616 = query.getOrDefault("api-version")
  valid_568616 = validateParameter(valid_568616, JString, required = true,
                                 default = nil)
  if valid_568616 != nil:
    section.add "api-version", valid_568616
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568618: Call_ExportTasksCreateTagsTask_568609; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export tags.
  ## 
  let valid = call_568618.validator(path, query, header, formData, body)
  let scheme = call_568618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568618.url(scheme.get, call_568618.host, call_568618.base,
                         call_568618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568618, url, valid)

proc call*(call_568619: Call_ExportTasksCreateTagsTask_568609;
          resourceGroupName: string; apiVersion: string; appName: string;
          subscriptionId: string; appCollection: string; parameters: JsonNode): Recallable =
  ## exportTasksCreateTagsTask
  ## Creates a task to export tags.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   parameters: JObject (required)
  var path_568620 = newJObject()
  var query_568621 = newJObject()
  var body_568622 = newJObject()
  add(path_568620, "resourceGroupName", newJString(resourceGroupName))
  add(query_568621, "api-version", newJString(apiVersion))
  add(path_568620, "appName", newJString(appName))
  add(path_568620, "subscriptionId", newJString(subscriptionId))
  add(path_568620, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_568622 = parameters
  result = call_568619.call(path_568620, query_568621, nil, nil, body_568622)

var exportTasksCreateTagsTask* = Call_ExportTasksCreateTagsTask_568609(
    name: "exportTasksCreateTagsTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/tags",
    validator: validate_ExportTasksCreateTagsTask_568610, base: "",
    url: url_ExportTasksCreateTagsTask_568611, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateTokensTask_568623 = ref object of OpenApiRestCall_567666
proc url_ExportTasksCreateTokensTask_568625(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/devices/exportTasks/tokens")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportTasksCreateTokensTask_568624(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task to export tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568626 = path.getOrDefault("resourceGroupName")
  valid_568626 = validateParameter(valid_568626, JString, required = true,
                                 default = nil)
  if valid_568626 != nil:
    section.add "resourceGroupName", valid_568626
  var valid_568627 = path.getOrDefault("appName")
  valid_568627 = validateParameter(valid_568627, JString, required = true,
                                 default = nil)
  if valid_568627 != nil:
    section.add "appName", valid_568627
  var valid_568628 = path.getOrDefault("subscriptionId")
  valid_568628 = validateParameter(valid_568628, JString, required = true,
                                 default = nil)
  if valid_568628 != nil:
    section.add "subscriptionId", valid_568628
  var valid_568629 = path.getOrDefault("appCollection")
  valid_568629 = validateParameter(valid_568629, JString, required = true,
                                 default = nil)
  if valid_568629 != nil:
    section.add "appCollection", valid_568629
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568630 = query.getOrDefault("api-version")
  valid_568630 = validateParameter(valid_568630, JString, required = true,
                                 default = nil)
  if valid_568630 != nil:
    section.add "api-version", valid_568630
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568632: Call_ExportTasksCreateTokensTask_568623; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export tags.
  ## 
  let valid = call_568632.validator(path, query, header, formData, body)
  let scheme = call_568632.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568632.url(scheme.get, call_568632.host, call_568632.base,
                         call_568632.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568632, url, valid)

proc call*(call_568633: Call_ExportTasksCreateTokensTask_568623;
          resourceGroupName: string; apiVersion: string; appName: string;
          subscriptionId: string; appCollection: string; parameters: JsonNode): Recallable =
  ## exportTasksCreateTokensTask
  ## Creates a task to export tags.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   parameters: JObject (required)
  var path_568634 = newJObject()
  var query_568635 = newJObject()
  var body_568636 = newJObject()
  add(path_568634, "resourceGroupName", newJString(resourceGroupName))
  add(query_568635, "api-version", newJString(apiVersion))
  add(path_568634, "appName", newJString(appName))
  add(path_568634, "subscriptionId", newJString(subscriptionId))
  add(path_568634, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_568636 = parameters
  result = call_568633.call(path_568634, query_568635, nil, nil, body_568636)

var exportTasksCreateTokensTask* = Call_ExportTasksCreateTokensTask_568623(
    name: "exportTasksCreateTokensTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/tokens",
    validator: validate_ExportTasksCreateTokensTask_568624, base: "",
    url: url_ExportTasksCreateTokensTask_568625, schemes: {Scheme.Https})
type
  Call_ExportTasksGet_568637 = ref object of OpenApiRestCall_567666
proc url_ExportTasksGet_568639(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/devices/exportTasks/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ExportTasksGet_568638(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieves information about a previously created export task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   id: JString (required)
  ##     : Export task identifier.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568640 = path.getOrDefault("resourceGroupName")
  valid_568640 = validateParameter(valid_568640, JString, required = true,
                                 default = nil)
  if valid_568640 != nil:
    section.add "resourceGroupName", valid_568640
  var valid_568641 = path.getOrDefault("appName")
  valid_568641 = validateParameter(valid_568641, JString, required = true,
                                 default = nil)
  if valid_568641 != nil:
    section.add "appName", valid_568641
  var valid_568642 = path.getOrDefault("subscriptionId")
  valid_568642 = validateParameter(valid_568642, JString, required = true,
                                 default = nil)
  if valid_568642 != nil:
    section.add "subscriptionId", valid_568642
  var valid_568643 = path.getOrDefault("id")
  valid_568643 = validateParameter(valid_568643, JString, required = true,
                                 default = nil)
  if valid_568643 != nil:
    section.add "id", valid_568643
  var valid_568644 = path.getOrDefault("appCollection")
  valid_568644 = validateParameter(valid_568644, JString, required = true,
                                 default = nil)
  if valid_568644 != nil:
    section.add "appCollection", valid_568644
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568645 = query.getOrDefault("api-version")
  valid_568645 = validateParameter(valid_568645, JString, required = true,
                                 default = nil)
  if valid_568645 != nil:
    section.add "api-version", valid_568645
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568646: Call_ExportTasksGet_568637; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a previously created export task.
  ## 
  let valid = call_568646.validator(path, query, header, formData, body)
  let scheme = call_568646.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568646.url(scheme.get, call_568646.host, call_568646.base,
                         call_568646.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568646, url, valid)

proc call*(call_568647: Call_ExportTasksGet_568637; resourceGroupName: string;
          apiVersion: string; appName: string; subscriptionId: string; id: string;
          appCollection: string): Recallable =
  ## exportTasksGet
  ## Retrieves information about a previously created export task.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   id: string (required)
  ##     : Export task identifier.
  ##   appCollection: string (required)
  ##                : Application collection.
  var path_568648 = newJObject()
  var query_568649 = newJObject()
  add(path_568648, "resourceGroupName", newJString(resourceGroupName))
  add(query_568649, "api-version", newJString(apiVersion))
  add(path_568648, "appName", newJString(appName))
  add(path_568648, "subscriptionId", newJString(subscriptionId))
  add(path_568648, "id", newJString(id))
  add(path_568648, "appCollection", newJString(appCollection))
  result = call_568647.call(path_568648, query_568649, nil, nil, nil)

var exportTasksGet* = Call_ExportTasksGet_568637(name: "exportTasksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/{id}",
    validator: validate_ExportTasksGet_568638, base: "", url: url_ExportTasksGet_568639,
    schemes: {Scheme.Https})
type
  Call_ImportTasksCreate_568665 = ref object of OpenApiRestCall_567666
proc url_ImportTasksCreate_568667(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/devices/importTasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ImportTasksCreate_568666(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a job to import the specified data to a storageUrl.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568668 = path.getOrDefault("resourceGroupName")
  valid_568668 = validateParameter(valid_568668, JString, required = true,
                                 default = nil)
  if valid_568668 != nil:
    section.add "resourceGroupName", valid_568668
  var valid_568669 = path.getOrDefault("appName")
  valid_568669 = validateParameter(valid_568669, JString, required = true,
                                 default = nil)
  if valid_568669 != nil:
    section.add "appName", valid_568669
  var valid_568670 = path.getOrDefault("subscriptionId")
  valid_568670 = validateParameter(valid_568670, JString, required = true,
                                 default = nil)
  if valid_568670 != nil:
    section.add "subscriptionId", valid_568670
  var valid_568671 = path.getOrDefault("appCollection")
  valid_568671 = validateParameter(valid_568671, JString, required = true,
                                 default = nil)
  if valid_568671 != nil:
    section.add "appCollection", valid_568671
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568672 = query.getOrDefault("api-version")
  valid_568672 = validateParameter(valid_568672, JString, required = true,
                                 default = nil)
  if valid_568672 != nil:
    section.add "api-version", valid_568672
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568674: Call_ImportTasksCreate_568665; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a job to import the specified data to a storageUrl.
  ## 
  let valid = call_568674.validator(path, query, header, formData, body)
  let scheme = call_568674.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568674.url(scheme.get, call_568674.host, call_568674.base,
                         call_568674.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568674, url, valid)

proc call*(call_568675: Call_ImportTasksCreate_568665; resourceGroupName: string;
          apiVersion: string; appName: string; subscriptionId: string;
          appCollection: string; parameters: JsonNode): Recallable =
  ## importTasksCreate
  ## Creates a job to import the specified data to a storageUrl.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   parameters: JObject (required)
  var path_568676 = newJObject()
  var query_568677 = newJObject()
  var body_568678 = newJObject()
  add(path_568676, "resourceGroupName", newJString(resourceGroupName))
  add(query_568677, "api-version", newJString(apiVersion))
  add(path_568676, "appName", newJString(appName))
  add(path_568676, "subscriptionId", newJString(subscriptionId))
  add(path_568676, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_568678 = parameters
  result = call_568675.call(path_568676, query_568677, nil, nil, body_568678)

var importTasksCreate* = Call_ImportTasksCreate_568665(name: "importTasksCreate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/importTasks",
    validator: validate_ImportTasksCreate_568666, base: "",
    url: url_ImportTasksCreate_568667, schemes: {Scheme.Https})
type
  Call_ImportTasksList_568650 = ref object of OpenApiRestCall_567666
proc url_ImportTasksList_568652(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/devices/importTasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ImportTasksList_568651(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get the list of import jobs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568653 = path.getOrDefault("resourceGroupName")
  valid_568653 = validateParameter(valid_568653, JString, required = true,
                                 default = nil)
  if valid_568653 != nil:
    section.add "resourceGroupName", valid_568653
  var valid_568654 = path.getOrDefault("appName")
  valid_568654 = validateParameter(valid_568654, JString, required = true,
                                 default = nil)
  if valid_568654 != nil:
    section.add "appName", valid_568654
  var valid_568655 = path.getOrDefault("subscriptionId")
  valid_568655 = validateParameter(valid_568655, JString, required = true,
                                 default = nil)
  if valid_568655 != nil:
    section.add "subscriptionId", valid_568655
  var valid_568656 = path.getOrDefault("appCollection")
  valid_568656 = validateParameter(valid_568656, JString, required = true,
                                 default = nil)
  if valid_568656 != nil:
    section.add "appCollection", valid_568656
  result.add "path", section
  ## parameters in `query` object:
  ##   $orderby: JString
  ##           : Sort results by an expression which looks like `$orderby=jobId asc` (default when not specified).
  ## The syntax is orderby={property} {direction} or just orderby={property}.
  ## Properties that can be specified for sorting: jobId, errorDetails, dateCreated, jobStatus, and dateCreated.
  ## The available directions are asc (for ascending order) and desc (for descending order).
  ## When not specified the asc direction is used.
  ## Only one orderby property can be specified.
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Control paging of import jobs, number of import jobs to return with each call. By default, it returns all import jobs with a default paging of 20.
  ## The response contains a `nextLink` property describing the path to get the next page if there are more results.
  ## The maximum paging limit for $top is 40.
  ##   $skip: JInt
  ##        : Control paging of import jobs, start results at the given offset, defaults to 0 (1st page of data).
  section = newJObject()
  var valid_568657 = query.getOrDefault("$orderby")
  valid_568657 = validateParameter(valid_568657, JString, required = false,
                                 default = nil)
  if valid_568657 != nil:
    section.add "$orderby", valid_568657
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568658 = query.getOrDefault("api-version")
  valid_568658 = validateParameter(valid_568658, JString, required = true,
                                 default = nil)
  if valid_568658 != nil:
    section.add "api-version", valid_568658
  var valid_568659 = query.getOrDefault("$top")
  valid_568659 = validateParameter(valid_568659, JInt, required = false,
                                 default = newJInt(20))
  if valid_568659 != nil:
    section.add "$top", valid_568659
  var valid_568660 = query.getOrDefault("$skip")
  valid_568660 = validateParameter(valid_568660, JInt, required = false,
                                 default = newJInt(0))
  if valid_568660 != nil:
    section.add "$skip", valid_568660
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568661: Call_ImportTasksList_568650; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of import jobs.
  ## 
  let valid = call_568661.validator(path, query, header, formData, body)
  let scheme = call_568661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568661.url(scheme.get, call_568661.host, call_568661.base,
                         call_568661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568661, url, valid)

proc call*(call_568662: Call_ImportTasksList_568650; resourceGroupName: string;
          apiVersion: string; appName: string; subscriptionId: string;
          appCollection: string; Orderby: string = ""; Top: int = 20; Skip: int = 0): Recallable =
  ## importTasksList
  ## Get the list of import jobs.
  ##   Orderby: string
  ##          : Sort results by an expression which looks like `$orderby=jobId asc` (default when not specified).
  ## The syntax is orderby={property} {direction} or just orderby={property}.
  ## Properties that can be specified for sorting: jobId, errorDetails, dateCreated, jobStatus, and dateCreated.
  ## The available directions are asc (for ascending order) and desc (for descending order).
  ## When not specified the asc direction is used.
  ## Only one orderby property can be specified.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Top: int
  ##      : Control paging of import jobs, number of import jobs to return with each call. By default, it returns all import jobs with a default paging of 20.
  ## The response contains a `nextLink` property describing the path to get the next page if there are more results.
  ## The maximum paging limit for $top is 40.
  ##   Skip: int
  ##       : Control paging of import jobs, start results at the given offset, defaults to 0 (1st page of data).
  ##   appCollection: string (required)
  ##                : Application collection.
  var path_568663 = newJObject()
  var query_568664 = newJObject()
  add(query_568664, "$orderby", newJString(Orderby))
  add(path_568663, "resourceGroupName", newJString(resourceGroupName))
  add(query_568664, "api-version", newJString(apiVersion))
  add(path_568663, "appName", newJString(appName))
  add(path_568663, "subscriptionId", newJString(subscriptionId))
  add(query_568664, "$top", newJInt(Top))
  add(query_568664, "$skip", newJInt(Skip))
  add(path_568663, "appCollection", newJString(appCollection))
  result = call_568662.call(path_568663, query_568664, nil, nil, nil)

var importTasksList* = Call_ImportTasksList_568650(name: "importTasksList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/importTasks",
    validator: validate_ImportTasksList_568651, base: "", url: url_ImportTasksList_568652,
    schemes: {Scheme.Https})
type
  Call_ImportTasksGet_568679 = ref object of OpenApiRestCall_567666
proc url_ImportTasksGet_568681(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  assert "id" in path, "`id` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/devices/importTasks/"),
               (kind: VariableSegment, value: "id")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ImportTasksGet_568680(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The Get import job operation retrieves information about a previously created import job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   id: JString (required)
  ##     : Import job identifier.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568682 = path.getOrDefault("resourceGroupName")
  valid_568682 = validateParameter(valid_568682, JString, required = true,
                                 default = nil)
  if valid_568682 != nil:
    section.add "resourceGroupName", valid_568682
  var valid_568683 = path.getOrDefault("appName")
  valid_568683 = validateParameter(valid_568683, JString, required = true,
                                 default = nil)
  if valid_568683 != nil:
    section.add "appName", valid_568683
  var valid_568684 = path.getOrDefault("subscriptionId")
  valid_568684 = validateParameter(valid_568684, JString, required = true,
                                 default = nil)
  if valid_568684 != nil:
    section.add "subscriptionId", valid_568684
  var valid_568685 = path.getOrDefault("id")
  valid_568685 = validateParameter(valid_568685, JString, required = true,
                                 default = nil)
  if valid_568685 != nil:
    section.add "id", valid_568685
  var valid_568686 = path.getOrDefault("appCollection")
  valid_568686 = validateParameter(valid_568686, JString, required = true,
                                 default = nil)
  if valid_568686 != nil:
    section.add "appCollection", valid_568686
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568687 = query.getOrDefault("api-version")
  valid_568687 = validateParameter(valid_568687, JString, required = true,
                                 default = nil)
  if valid_568687 != nil:
    section.add "api-version", valid_568687
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568688: Call_ImportTasksGet_568679; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get import job operation retrieves information about a previously created import job.
  ## 
  let valid = call_568688.validator(path, query, header, formData, body)
  let scheme = call_568688.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568688.url(scheme.get, call_568688.host, call_568688.base,
                         call_568688.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568688, url, valid)

proc call*(call_568689: Call_ImportTasksGet_568679; resourceGroupName: string;
          apiVersion: string; appName: string; subscriptionId: string; id: string;
          appCollection: string): Recallable =
  ## importTasksGet
  ## The Get import job operation retrieves information about a previously created import job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   id: string (required)
  ##     : Import job identifier.
  ##   appCollection: string (required)
  ##                : Application collection.
  var path_568690 = newJObject()
  var query_568691 = newJObject()
  add(path_568690, "resourceGroupName", newJString(resourceGroupName))
  add(query_568691, "api-version", newJString(apiVersion))
  add(path_568690, "appName", newJString(appName))
  add(path_568690, "subscriptionId", newJString(subscriptionId))
  add(path_568690, "id", newJString(id))
  add(path_568690, "appCollection", newJString(appCollection))
  result = call_568689.call(path_568690, query_568691, nil, nil, nil)

var importTasksGet* = Call_ImportTasksGet_568679(name: "importTasksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/importTasks/{id}",
    validator: validate_ImportTasksGet_568680, base: "", url: url_ImportTasksGet_568681,
    schemes: {Scheme.Https})
type
  Call_DevicesTagByDeviceId_568692 = ref object of OpenApiRestCall_567666
proc url_DevicesTagByDeviceId_568694(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/devices/tag")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesTagByDeviceId_568693(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the tags registered for a set of devices running an application. Updates are performed asynchronously, meaning that a few seconds are needed before the modifications appear in the results of the Get device command.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568695 = path.getOrDefault("resourceGroupName")
  valid_568695 = validateParameter(valid_568695, JString, required = true,
                                 default = nil)
  if valid_568695 != nil:
    section.add "resourceGroupName", valid_568695
  var valid_568696 = path.getOrDefault("appName")
  valid_568696 = validateParameter(valid_568696, JString, required = true,
                                 default = nil)
  if valid_568696 != nil:
    section.add "appName", valid_568696
  var valid_568697 = path.getOrDefault("subscriptionId")
  valid_568697 = validateParameter(valid_568697, JString, required = true,
                                 default = nil)
  if valid_568697 != nil:
    section.add "subscriptionId", valid_568697
  var valid_568698 = path.getOrDefault("appCollection")
  valid_568698 = validateParameter(valid_568698, JString, required = true,
                                 default = nil)
  if valid_568698 != nil:
    section.add "appCollection", valid_568698
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568699 = query.getOrDefault("api-version")
  valid_568699 = validateParameter(valid_568699, JString, required = true,
                                 default = nil)
  if valid_568699 != nil:
    section.add "api-version", valid_568699
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568701: Call_DevicesTagByDeviceId_568692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the tags registered for a set of devices running an application. Updates are performed asynchronously, meaning that a few seconds are needed before the modifications appear in the results of the Get device command.
  ## 
  ## 
  let valid = call_568701.validator(path, query, header, formData, body)
  let scheme = call_568701.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568701.url(scheme.get, call_568701.host, call_568701.base,
                         call_568701.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568701, url, valid)

proc call*(call_568702: Call_DevicesTagByDeviceId_568692;
          resourceGroupName: string; apiVersion: string; appName: string;
          subscriptionId: string; appCollection: string; parameters: JsonNode): Recallable =
  ## devicesTagByDeviceId
  ## Update the tags registered for a set of devices running an application. Updates are performed asynchronously, meaning that a few seconds are needed before the modifications appear in the results of the Get device command.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   parameters: JObject (required)
  var path_568703 = newJObject()
  var query_568704 = newJObject()
  var body_568705 = newJObject()
  add(path_568703, "resourceGroupName", newJString(resourceGroupName))
  add(query_568704, "api-version", newJString(apiVersion))
  add(path_568703, "appName", newJString(appName))
  add(path_568703, "subscriptionId", newJString(subscriptionId))
  add(path_568703, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_568705 = parameters
  result = call_568702.call(path_568703, query_568704, nil, nil, body_568705)

var devicesTagByDeviceId* = Call_DevicesTagByDeviceId_568692(
    name: "devicesTagByDeviceId", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/tag",
    validator: validate_DevicesTagByDeviceId_568693, base: "",
    url: url_DevicesTagByDeviceId_568694, schemes: {Scheme.Https})
type
  Call_DevicesGetByDeviceId_568706 = ref object of OpenApiRestCall_567666
proc url_DevicesGetByDeviceId_568708(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesGetByDeviceId_568707(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the information associated to a device running an application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   deviceId: JString (required)
  ##           : Device identifier.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568709 = path.getOrDefault("resourceGroupName")
  valid_568709 = validateParameter(valid_568709, JString, required = true,
                                 default = nil)
  if valid_568709 != nil:
    section.add "resourceGroupName", valid_568709
  var valid_568710 = path.getOrDefault("appName")
  valid_568710 = validateParameter(valid_568710, JString, required = true,
                                 default = nil)
  if valid_568710 != nil:
    section.add "appName", valid_568710
  var valid_568711 = path.getOrDefault("deviceId")
  valid_568711 = validateParameter(valid_568711, JString, required = true,
                                 default = nil)
  if valid_568711 != nil:
    section.add "deviceId", valid_568711
  var valid_568712 = path.getOrDefault("subscriptionId")
  valid_568712 = validateParameter(valid_568712, JString, required = true,
                                 default = nil)
  if valid_568712 != nil:
    section.add "subscriptionId", valid_568712
  var valid_568713 = path.getOrDefault("appCollection")
  valid_568713 = validateParameter(valid_568713, JString, required = true,
                                 default = nil)
  if valid_568713 != nil:
    section.add "appCollection", valid_568713
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568714 = query.getOrDefault("api-version")
  valid_568714 = validateParameter(valid_568714, JString, required = true,
                                 default = nil)
  if valid_568714 != nil:
    section.add "api-version", valid_568714
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568715: Call_DevicesGetByDeviceId_568706; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the information associated to a device running an application.
  ## 
  let valid = call_568715.validator(path, query, header, formData, body)
  let scheme = call_568715.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568715.url(scheme.get, call_568715.host, call_568715.base,
                         call_568715.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568715, url, valid)

proc call*(call_568716: Call_DevicesGetByDeviceId_568706;
          resourceGroupName: string; apiVersion: string; appName: string;
          deviceId: string; subscriptionId: string; appCollection: string): Recallable =
  ## devicesGetByDeviceId
  ## Get the information associated to a device running an application.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   deviceId: string (required)
  ##           : Device identifier.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  var path_568717 = newJObject()
  var query_568718 = newJObject()
  add(path_568717, "resourceGroupName", newJString(resourceGroupName))
  add(query_568718, "api-version", newJString(apiVersion))
  add(path_568717, "appName", newJString(appName))
  add(path_568717, "deviceId", newJString(deviceId))
  add(path_568717, "subscriptionId", newJString(subscriptionId))
  add(path_568717, "appCollection", newJString(appCollection))
  result = call_568716.call(path_568717, query_568718, nil, nil, nil)

var devicesGetByDeviceId* = Call_DevicesGetByDeviceId_568706(
    name: "devicesGetByDeviceId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/{deviceId}",
    validator: validate_DevicesGetByDeviceId_568707, base: "",
    url: url_DevicesGetByDeviceId_568708, schemes: {Scheme.Https})
type
  Call_DevicesTagByUserId_568719 = ref object of OpenApiRestCall_567666
proc url_DevicesTagByUserId_568721(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/users/tag")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesTagByUserId_568720(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Update the tags registered for a set of users running an application. Updates are performed asynchronously, meaning that a few seconds are needed before the modifications appear in the results of the Get device command.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568722 = path.getOrDefault("resourceGroupName")
  valid_568722 = validateParameter(valid_568722, JString, required = true,
                                 default = nil)
  if valid_568722 != nil:
    section.add "resourceGroupName", valid_568722
  var valid_568723 = path.getOrDefault("appName")
  valid_568723 = validateParameter(valid_568723, JString, required = true,
                                 default = nil)
  if valid_568723 != nil:
    section.add "appName", valid_568723
  var valid_568724 = path.getOrDefault("subscriptionId")
  valid_568724 = validateParameter(valid_568724, JString, required = true,
                                 default = nil)
  if valid_568724 != nil:
    section.add "subscriptionId", valid_568724
  var valid_568725 = path.getOrDefault("appCollection")
  valid_568725 = validateParameter(valid_568725, JString, required = true,
                                 default = nil)
  if valid_568725 != nil:
    section.add "appCollection", valid_568725
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568726 = query.getOrDefault("api-version")
  valid_568726 = validateParameter(valid_568726, JString, required = true,
                                 default = nil)
  if valid_568726 != nil:
    section.add "api-version", valid_568726
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568728: Call_DevicesTagByUserId_568719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the tags registered for a set of users running an application. Updates are performed asynchronously, meaning that a few seconds are needed before the modifications appear in the results of the Get device command.
  ## 
  ## 
  let valid = call_568728.validator(path, query, header, formData, body)
  let scheme = call_568728.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568728.url(scheme.get, call_568728.host, call_568728.base,
                         call_568728.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568728, url, valid)

proc call*(call_568729: Call_DevicesTagByUserId_568719; resourceGroupName: string;
          apiVersion: string; appName: string; subscriptionId: string;
          appCollection: string; parameters: JsonNode): Recallable =
  ## devicesTagByUserId
  ## Update the tags registered for a set of users running an application. Updates are performed asynchronously, meaning that a few seconds are needed before the modifications appear in the results of the Get device command.
  ## 
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   parameters: JObject (required)
  var path_568730 = newJObject()
  var query_568731 = newJObject()
  var body_568732 = newJObject()
  add(path_568730, "resourceGroupName", newJString(resourceGroupName))
  add(query_568731, "api-version", newJString(apiVersion))
  add(path_568730, "appName", newJString(appName))
  add(path_568730, "subscriptionId", newJString(subscriptionId))
  add(path_568730, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_568732 = parameters
  result = call_568729.call(path_568730, query_568731, nil, nil, body_568732)

var devicesTagByUserId* = Call_DevicesTagByUserId_568719(
    name: "devicesTagByUserId", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/users/tag",
    validator: validate_DevicesTagByUserId_568720, base: "",
    url: url_DevicesTagByUserId_568721, schemes: {Scheme.Https})
type
  Call_DevicesGetByUserId_568733 = ref object of OpenApiRestCall_567666
proc url_DevicesGetByUserId_568735(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "appCollection" in path, "`appCollection` is a required path parameter"
  assert "appName" in path, "`appName` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.MobileEngagement/appcollections/"),
               (kind: VariableSegment, value: "appCollection"),
               (kind: ConstantSegment, value: "/apps/"),
               (kind: VariableSegment, value: "appName"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DevicesGetByUserId_568734(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the information associated to a device running an application using the user identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   userId: JString (required)
  ##         : User identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_568736 = path.getOrDefault("resourceGroupName")
  valid_568736 = validateParameter(valid_568736, JString, required = true,
                                 default = nil)
  if valid_568736 != nil:
    section.add "resourceGroupName", valid_568736
  var valid_568737 = path.getOrDefault("appName")
  valid_568737 = validateParameter(valid_568737, JString, required = true,
                                 default = nil)
  if valid_568737 != nil:
    section.add "appName", valid_568737
  var valid_568738 = path.getOrDefault("subscriptionId")
  valid_568738 = validateParameter(valid_568738, JString, required = true,
                                 default = nil)
  if valid_568738 != nil:
    section.add "subscriptionId", valid_568738
  var valid_568739 = path.getOrDefault("appCollection")
  valid_568739 = validateParameter(valid_568739, JString, required = true,
                                 default = nil)
  if valid_568739 != nil:
    section.add "appCollection", valid_568739
  var valid_568740 = path.getOrDefault("userId")
  valid_568740 = validateParameter(valid_568740, JString, required = true,
                                 default = nil)
  if valid_568740 != nil:
    section.add "userId", valid_568740
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568741 = query.getOrDefault("api-version")
  valid_568741 = validateParameter(valid_568741, JString, required = true,
                                 default = nil)
  if valid_568741 != nil:
    section.add "api-version", valid_568741
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568742: Call_DevicesGetByUserId_568733; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the information associated to a device running an application using the user identifier.
  ## 
  let valid = call_568742.validator(path, query, header, formData, body)
  let scheme = call_568742.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568742.url(scheme.get, call_568742.host, call_568742.base,
                         call_568742.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568742, url, valid)

proc call*(call_568743: Call_DevicesGetByUserId_568733; resourceGroupName: string;
          apiVersion: string; appName: string; subscriptionId: string;
          appCollection: string; userId: string): Recallable =
  ## devicesGetByUserId
  ## Get the information associated to a device running an application using the user identifier.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   userId: string (required)
  ##         : User identifier.
  var path_568744 = newJObject()
  var query_568745 = newJObject()
  add(path_568744, "resourceGroupName", newJString(resourceGroupName))
  add(query_568745, "api-version", newJString(apiVersion))
  add(path_568744, "appName", newJString(appName))
  add(path_568744, "subscriptionId", newJString(subscriptionId))
  add(path_568744, "appCollection", newJString(appCollection))
  add(path_568744, "userId", newJString(userId))
  result = call_568743.call(path_568744, query_568745, nil, nil, nil)

var devicesGetByUserId* = Call_DevicesGetByUserId_568733(
    name: "devicesGetByUserId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/users/{userId}",
    validator: validate_DevicesGetByUserId_568734, base: "",
    url: url_DevicesGetByUserId_568735, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
