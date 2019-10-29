
import
  json, options, hashes, uri, rest, os, uri, httpcore

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
  macServiceName = "mobileengagement-mobile-engagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppCollectionsList_563786 = ref object of OpenApiRestCall_563564
proc url_AppCollectionsList_563788(protocol: Scheme; host: string; base: string;
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

proc validate_AppCollectionsList_563787(path: JsonNode; query: JsonNode;
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
  var valid_563963 = path.getOrDefault("subscriptionId")
  valid_563963 = validateParameter(valid_563963, JString, required = true,
                                 default = nil)
  if valid_563963 != nil:
    section.add "subscriptionId", valid_563963
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563964 = query.getOrDefault("api-version")
  valid_563964 = validateParameter(valid_563964, JString, required = true,
                                 default = nil)
  if valid_563964 != nil:
    section.add "api-version", valid_563964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563987: Call_AppCollectionsList_563786; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists app collections in a subscription.
  ## 
  let valid = call_563987.validator(path, query, header, formData, body)
  let scheme = call_563987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563987.url(scheme.get, call_563987.host, call_563987.base,
                         call_563987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563987, url, valid)

proc call*(call_564058: Call_AppCollectionsList_563786; apiVersion: string;
          subscriptionId: string): Recallable =
  ## appCollectionsList
  ## Lists app collections in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564059 = newJObject()
  var query_564061 = newJObject()
  add(query_564061, "api-version", newJString(apiVersion))
  add(path_564059, "subscriptionId", newJString(subscriptionId))
  result = call_564058.call(path_564059, query_564061, nil, nil, nil)

var appCollectionsList* = Call_AppCollectionsList_563786(
    name: "appCollectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MobileEngagement/appCollections",
    validator: validate_AppCollectionsList_563787, base: "",
    url: url_AppCollectionsList_563788, schemes: {Scheme.Https})
type
  Call_AppCollectionsCheckNameAvailability_564100 = ref object of OpenApiRestCall_563564
proc url_AppCollectionsCheckNameAvailability_564102(protocol: Scheme; host: string;
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

proc validate_AppCollectionsCheckNameAvailability_564101(path: JsonNode;
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
  var valid_564120 = path.getOrDefault("subscriptionId")
  valid_564120 = validateParameter(valid_564120, JString, required = true,
                                 default = nil)
  if valid_564120 != nil:
    section.add "subscriptionId", valid_564120
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564121 = query.getOrDefault("api-version")
  valid_564121 = validateParameter(valid_564121, JString, required = true,
                                 default = nil)
  if valid_564121 != nil:
    section.add "api-version", valid_564121
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

proc call*(call_564123: Call_AppCollectionsCheckNameAvailability_564100;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks availability of an app collection name in the Engagement domain.
  ## 
  let valid = call_564123.validator(path, query, header, formData, body)
  let scheme = call_564123.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564123.url(scheme.get, call_564123.host, call_564123.base,
                         call_564123.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564123, url, valid)

proc call*(call_564124: Call_AppCollectionsCheckNameAvailability_564100;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## appCollectionsCheckNameAvailability
  ## Checks availability of an app collection name in the Engagement domain.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  var path_564125 = newJObject()
  var query_564126 = newJObject()
  var body_564127 = newJObject()
  add(query_564126, "api-version", newJString(apiVersion))
  add(path_564125, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_564127 = parameters
  result = call_564124.call(path_564125, query_564126, nil, nil, body_564127)

var appCollectionsCheckNameAvailability* = Call_AppCollectionsCheckNameAvailability_564100(
    name: "appCollectionsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MobileEngagement/checkAppCollectionNameAvailability",
    validator: validate_AppCollectionsCheckNameAvailability_564101, base: "",
    url: url_AppCollectionsCheckNameAvailability_564102, schemes: {Scheme.Https})
type
  Call_SupportedPlatformsList_564128 = ref object of OpenApiRestCall_563564
proc url_SupportedPlatformsList_564130(protocol: Scheme; host: string; base: string;
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

proc validate_SupportedPlatformsList_564129(path: JsonNode; query: JsonNode;
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
  var valid_564131 = path.getOrDefault("subscriptionId")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = nil)
  if valid_564131 != nil:
    section.add "subscriptionId", valid_564131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564132 = query.getOrDefault("api-version")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "api-version", valid_564132
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564133: Call_SupportedPlatformsList_564128; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists supported platforms for Engagement applications.
  ## 
  let valid = call_564133.validator(path, query, header, formData, body)
  let scheme = call_564133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564133.url(scheme.get, call_564133.host, call_564133.base,
                         call_564133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564133, url, valid)

proc call*(call_564134: Call_SupportedPlatformsList_564128; apiVersion: string;
          subscriptionId: string): Recallable =
  ## supportedPlatformsList
  ## Lists supported platforms for Engagement applications.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564135 = newJObject()
  var query_564136 = newJObject()
  add(query_564136, "api-version", newJString(apiVersion))
  add(path_564135, "subscriptionId", newJString(subscriptionId))
  result = call_564134.call(path_564135, query_564136, nil, nil, nil)

var supportedPlatformsList* = Call_SupportedPlatformsList_564128(
    name: "supportedPlatformsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MobileEngagement/supportedPlatforms",
    validator: validate_SupportedPlatformsList_564129, base: "",
    url: url_SupportedPlatformsList_564130, schemes: {Scheme.Https})
type
  Call_AppsList_564137 = ref object of OpenApiRestCall_563564
proc url_AppsList_564139(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AppsList_564138(path: JsonNode; query: JsonNode; header: JsonNode;
                             formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists apps in an appCollection.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564140 = path.getOrDefault("subscriptionId")
  valid_564140 = validateParameter(valid_564140, JString, required = true,
                                 default = nil)
  if valid_564140 != nil:
    section.add "subscriptionId", valid_564140
  var valid_564141 = path.getOrDefault("appCollection")
  valid_564141 = validateParameter(valid_564141, JString, required = true,
                                 default = nil)
  if valid_564141 != nil:
    section.add "appCollection", valid_564141
  var valid_564142 = path.getOrDefault("resourceGroupName")
  valid_564142 = validateParameter(valid_564142, JString, required = true,
                                 default = nil)
  if valid_564142 != nil:
    section.add "resourceGroupName", valid_564142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564143 = query.getOrDefault("api-version")
  valid_564143 = validateParameter(valid_564143, JString, required = true,
                                 default = nil)
  if valid_564143 != nil:
    section.add "api-version", valid_564143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564144: Call_AppsList_564137; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists apps in an appCollection.
  ## 
  let valid = call_564144.validator(path, query, header, formData, body)
  let scheme = call_564144.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564144.url(scheme.get, call_564144.host, call_564144.base,
                         call_564144.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564144, url, valid)

proc call*(call_564145: Call_AppsList_564137; apiVersion: string;
          subscriptionId: string; appCollection: string; resourceGroupName: string): Recallable =
  ## appsList
  ## Lists apps in an appCollection.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  var path_564146 = newJObject()
  var query_564147 = newJObject()
  add(query_564147, "api-version", newJString(apiVersion))
  add(path_564146, "subscriptionId", newJString(subscriptionId))
  add(path_564146, "appCollection", newJString(appCollection))
  add(path_564146, "resourceGroupName", newJString(resourceGroupName))
  result = call_564145.call(path_564146, query_564147, nil, nil, nil)

var appsList* = Call_AppsList_564137(name: "appsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps",
                                  validator: validate_AppsList_564138, base: "",
                                  url: url_AppsList_564139,
                                  schemes: {Scheme.Https})
type
  Call_CampaignsCreate_564180 = ref object of OpenApiRestCall_563564
proc url_CampaignsCreate_564182(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsCreate_564181(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Create a push campaign (announcement, poll, data push or native push).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kind` field"
  var valid_564193 = path.getOrDefault("kind")
  valid_564193 = validateParameter(valid_564193, JString, required = true,
                                 default = newJString("announcements"))
  if valid_564193 != nil:
    section.add "kind", valid_564193
  var valid_564194 = path.getOrDefault("subscriptionId")
  valid_564194 = validateParameter(valid_564194, JString, required = true,
                                 default = nil)
  if valid_564194 != nil:
    section.add "subscriptionId", valid_564194
  var valid_564195 = path.getOrDefault("appCollection")
  valid_564195 = validateParameter(valid_564195, JString, required = true,
                                 default = nil)
  if valid_564195 != nil:
    section.add "appCollection", valid_564195
  var valid_564196 = path.getOrDefault("resourceGroupName")
  valid_564196 = validateParameter(valid_564196, JString, required = true,
                                 default = nil)
  if valid_564196 != nil:
    section.add "resourceGroupName", valid_564196
  var valid_564197 = path.getOrDefault("appName")
  valid_564197 = validateParameter(valid_564197, JString, required = true,
                                 default = nil)
  if valid_564197 != nil:
    section.add "appName", valid_564197
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
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Campaign operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_564200: Call_CampaignsCreate_564180; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a push campaign (announcement, poll, data push or native push).
  ## 
  let valid = call_564200.validator(path, query, header, formData, body)
  let scheme = call_564200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564200.url(scheme.get, call_564200.host, call_564200.base,
                         call_564200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564200, url, valid)

proc call*(call_564201: Call_CampaignsCreate_564180; apiVersion: string;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string; parameters: JsonNode; kind: string = "announcements"): Recallable =
  ## campaignsCreate
  ## Create a push campaign (announcement, poll, data push or native push).
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Campaign operation.
  var path_564202 = newJObject()
  var query_564203 = newJObject()
  var body_564204 = newJObject()
  add(query_564203, "api-version", newJString(apiVersion))
  add(path_564202, "kind", newJString(kind))
  add(path_564202, "subscriptionId", newJString(subscriptionId))
  add(path_564202, "appCollection", newJString(appCollection))
  add(path_564202, "resourceGroupName", newJString(resourceGroupName))
  add(path_564202, "appName", newJString(appName))
  if parameters != nil:
    body_564204 = parameters
  result = call_564201.call(path_564202, query_564203, nil, nil, body_564204)

var campaignsCreate* = Call_CampaignsCreate_564180(name: "campaignsCreate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}",
    validator: validate_CampaignsCreate_564181, base: "", url: url_CampaignsCreate_564182,
    schemes: {Scheme.Https})
type
  Call_CampaignsList_564148 = ref object of OpenApiRestCall_563564
proc url_CampaignsList_564150(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsList_564149(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the list of campaigns.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kind` field"
  var valid_564165 = path.getOrDefault("kind")
  valid_564165 = validateParameter(valid_564165, JString, required = true,
                                 default = newJString("announcements"))
  if valid_564165 != nil:
    section.add "kind", valid_564165
  var valid_564166 = path.getOrDefault("subscriptionId")
  valid_564166 = validateParameter(valid_564166, JString, required = true,
                                 default = nil)
  if valid_564166 != nil:
    section.add "subscriptionId", valid_564166
  var valid_564167 = path.getOrDefault("appCollection")
  valid_564167 = validateParameter(valid_564167, JString, required = true,
                                 default = nil)
  if valid_564167 != nil:
    section.add "appCollection", valid_564167
  var valid_564168 = path.getOrDefault("resourceGroupName")
  valid_564168 = validateParameter(valid_564168, JString, required = true,
                                 default = nil)
  if valid_564168 != nil:
    section.add "resourceGroupName", valid_564168
  var valid_564169 = path.getOrDefault("appName")
  valid_564169 = validateParameter(valid_564169, JString, required = true,
                                 default = nil)
  if valid_564169 != nil:
    section.add "appName", valid_564169
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Control paging of campaigns, number of campaigns to return with each call. It returns all campaigns by default. When specifying $top parameter, the response contains a `nextLink` property describing the path to get the next page if there are more results.
  ##   $orderby: JString
  ##           : Sort results by an expression which looks like `$orderby=id asc` (this example is actually the default behavior). The syntax is orderby={property} {direction} or just orderby={property}. The available sorting properties are id, name, state, activatedDate, and finishedDate. The available directions are asc (for ascending order) and desc (for descending order). When not specified the asc direction is used. Only one property at a time can be used for sorting.
  ##   $skip: JInt
  ##        : Control paging of campaigns, start results at the given offset, defaults to 0 (1st page of data).
  ##   $filter: JString
  ##          : Filter can be used to restrict the results to campaigns matching a specific state. The syntax is `$filter=state eq 'draft'`. Valid state values are: draft, scheduled, in-progress, and finished. Only the eq operator and the state property are supported.
  ##   $search: JString
  ##          : Restrict results to campaigns matching the optional `search` expression. This currently performs the search based on the name on the campaign only, case insensitive. If the campaign contains the value of the `search` parameter anywhere in the name, it matches.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564170 = query.getOrDefault("api-version")
  valid_564170 = validateParameter(valid_564170, JString, required = true,
                                 default = nil)
  if valid_564170 != nil:
    section.add "api-version", valid_564170
  var valid_564171 = query.getOrDefault("$top")
  valid_564171 = validateParameter(valid_564171, JInt, required = false, default = nil)
  if valid_564171 != nil:
    section.add "$top", valid_564171
  var valid_564172 = query.getOrDefault("$orderby")
  valid_564172 = validateParameter(valid_564172, JString, required = false,
                                 default = nil)
  if valid_564172 != nil:
    section.add "$orderby", valid_564172
  var valid_564173 = query.getOrDefault("$skip")
  valid_564173 = validateParameter(valid_564173, JInt, required = false, default = nil)
  if valid_564173 != nil:
    section.add "$skip", valid_564173
  var valid_564174 = query.getOrDefault("$filter")
  valid_564174 = validateParameter(valid_564174, JString, required = false,
                                 default = nil)
  if valid_564174 != nil:
    section.add "$filter", valid_564174
  var valid_564175 = query.getOrDefault("$search")
  valid_564175 = validateParameter(valid_564175, JString, required = false,
                                 default = nil)
  if valid_564175 != nil:
    section.add "$search", valid_564175
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564176: Call_CampaignsList_564148; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of campaigns.
  ## 
  let valid = call_564176.validator(path, query, header, formData, body)
  let scheme = call_564176.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564176.url(scheme.get, call_564176.host, call_564176.base,
                         call_564176.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564176, url, valid)

proc call*(call_564177: Call_CampaignsList_564148; apiVersion: string;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string; Top: int = 0; kind: string = "announcements";
          Orderby: string = ""; Skip: int = 0; Filter: string = ""; Search: string = ""): Recallable =
  ## campaignsList
  ## Get the list of campaigns.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : Control paging of campaigns, number of campaigns to return with each call. It returns all campaigns by default. When specifying $top parameter, the response contains a `nextLink` property describing the path to get the next page if there are more results.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Orderby: string
  ##          : Sort results by an expression which looks like `$orderby=id asc` (this example is actually the default behavior). The syntax is orderby={property} {direction} or just orderby={property}. The available sorting properties are id, name, state, activatedDate, and finishedDate. The available directions are asc (for ascending order) and desc (for descending order). When not specified the asc direction is used. Only one property at a time can be used for sorting.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   Skip: int
  ##       : Control paging of campaigns, start results at the given offset, defaults to 0 (1st page of data).
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   Filter: string
  ##         : Filter can be used to restrict the results to campaigns matching a specific state. The syntax is `$filter=state eq 'draft'`. Valid state values are: draft, scheduled, in-progress, and finished. Only the eq operator and the state property are supported.
  ##   Search: string
  ##         : Restrict results to campaigns matching the optional `search` expression. This currently performs the search based on the name on the campaign only, case insensitive. If the campaign contains the value of the `search` parameter anywhere in the name, it matches.
  var path_564178 = newJObject()
  var query_564179 = newJObject()
  add(query_564179, "api-version", newJString(apiVersion))
  add(query_564179, "$top", newJInt(Top))
  add(path_564178, "kind", newJString(kind))
  add(path_564178, "subscriptionId", newJString(subscriptionId))
  add(query_564179, "$orderby", newJString(Orderby))
  add(path_564178, "appCollection", newJString(appCollection))
  add(query_564179, "$skip", newJInt(Skip))
  add(path_564178, "resourceGroupName", newJString(resourceGroupName))
  add(path_564178, "appName", newJString(appName))
  add(query_564179, "$filter", newJString(Filter))
  add(query_564179, "$search", newJString(Search))
  result = call_564177.call(path_564178, query_564179, nil, nil, nil)

var campaignsList* = Call_CampaignsList_564148(name: "campaignsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}",
    validator: validate_CampaignsList_564149, base: "", url: url_CampaignsList_564150,
    schemes: {Scheme.Https})
type
  Call_CampaignsTestNew_564205 = ref object of OpenApiRestCall_563564
proc url_CampaignsTestNew_564207(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsTestNew_564206(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Test a new campaign on a set of devices.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kind` field"
  var valid_564208 = path.getOrDefault("kind")
  valid_564208 = validateParameter(valid_564208, JString, required = true,
                                 default = newJString("announcements"))
  if valid_564208 != nil:
    section.add "kind", valid_564208
  var valid_564209 = path.getOrDefault("subscriptionId")
  valid_564209 = validateParameter(valid_564209, JString, required = true,
                                 default = nil)
  if valid_564209 != nil:
    section.add "subscriptionId", valid_564209
  var valid_564210 = path.getOrDefault("appCollection")
  valid_564210 = validateParameter(valid_564210, JString, required = true,
                                 default = nil)
  if valid_564210 != nil:
    section.add "appCollection", valid_564210
  var valid_564211 = path.getOrDefault("resourceGroupName")
  valid_564211 = validateParameter(valid_564211, JString, required = true,
                                 default = nil)
  if valid_564211 != nil:
    section.add "resourceGroupName", valid_564211
  var valid_564212 = path.getOrDefault("appName")
  valid_564212 = validateParameter(valid_564212, JString, required = true,
                                 default = nil)
  if valid_564212 != nil:
    section.add "appName", valid_564212
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564213 = query.getOrDefault("api-version")
  valid_564213 = validateParameter(valid_564213, JString, required = true,
                                 default = nil)
  if valid_564213 != nil:
    section.add "api-version", valid_564213
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

proc call*(call_564215: Call_CampaignsTestNew_564205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Test a new campaign on a set of devices.
  ## 
  let valid = call_564215.validator(path, query, header, formData, body)
  let scheme = call_564215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564215.url(scheme.get, call_564215.host, call_564215.base,
                         call_564215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564215, url, valid)

proc call*(call_564216: Call_CampaignsTestNew_564205; apiVersion: string;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string; parameters: JsonNode; kind: string = "announcements"): Recallable =
  ## campaignsTestNew
  ## Test a new campaign on a set of devices.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Test Campaign operation.
  var path_564217 = newJObject()
  var query_564218 = newJObject()
  var body_564219 = newJObject()
  add(query_564218, "api-version", newJString(apiVersion))
  add(path_564217, "kind", newJString(kind))
  add(path_564217, "subscriptionId", newJString(subscriptionId))
  add(path_564217, "appCollection", newJString(appCollection))
  add(path_564217, "resourceGroupName", newJString(resourceGroupName))
  add(path_564217, "appName", newJString(appName))
  if parameters != nil:
    body_564219 = parameters
  result = call_564216.call(path_564217, query_564218, nil, nil, body_564219)

var campaignsTestNew* = Call_CampaignsTestNew_564205(name: "campaignsTestNew",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/test",
    validator: validate_CampaignsTestNew_564206, base: "",
    url: url_CampaignsTestNew_564207, schemes: {Scheme.Https})
type
  Call_CampaignsUpdate_564234 = ref object of OpenApiRestCall_563564
proc url_CampaignsUpdate_564236(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsUpdate_564235(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Update an existing push campaign (announcement, poll, data push or native push).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   id: JInt (required)
  ##     : Campaign identifier.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kind` field"
  var valid_564237 = path.getOrDefault("kind")
  valid_564237 = validateParameter(valid_564237, JString, required = true,
                                 default = newJString("announcements"))
  if valid_564237 != nil:
    section.add "kind", valid_564237
  var valid_564238 = path.getOrDefault("id")
  valid_564238 = validateParameter(valid_564238, JInt, required = true, default = nil)
  if valid_564238 != nil:
    section.add "id", valid_564238
  var valid_564239 = path.getOrDefault("subscriptionId")
  valid_564239 = validateParameter(valid_564239, JString, required = true,
                                 default = nil)
  if valid_564239 != nil:
    section.add "subscriptionId", valid_564239
  var valid_564240 = path.getOrDefault("appCollection")
  valid_564240 = validateParameter(valid_564240, JString, required = true,
                                 default = nil)
  if valid_564240 != nil:
    section.add "appCollection", valid_564240
  var valid_564241 = path.getOrDefault("resourceGroupName")
  valid_564241 = validateParameter(valid_564241, JString, required = true,
                                 default = nil)
  if valid_564241 != nil:
    section.add "resourceGroupName", valid_564241
  var valid_564242 = path.getOrDefault("appName")
  valid_564242 = validateParameter(valid_564242, JString, required = true,
                                 default = nil)
  if valid_564242 != nil:
    section.add "appName", valid_564242
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564243 = query.getOrDefault("api-version")
  valid_564243 = validateParameter(valid_564243, JString, required = true,
                                 default = nil)
  if valid_564243 != nil:
    section.add "api-version", valid_564243
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

proc call*(call_564245: Call_CampaignsUpdate_564234; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing push campaign (announcement, poll, data push or native push).
  ## 
  let valid = call_564245.validator(path, query, header, formData, body)
  let scheme = call_564245.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564245.url(scheme.get, call_564245.host, call_564245.base,
                         call_564245.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564245, url, valid)

proc call*(call_564246: Call_CampaignsUpdate_564234; apiVersion: string; id: int;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string; parameters: JsonNode; kind: string = "announcements"): Recallable =
  ## campaignsUpdate
  ## Update an existing push campaign (announcement, poll, data push or native push).
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   id: int (required)
  ##     : Campaign identifier.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Update Campaign operation.
  var path_564247 = newJObject()
  var query_564248 = newJObject()
  var body_564249 = newJObject()
  add(query_564248, "api-version", newJString(apiVersion))
  add(path_564247, "kind", newJString(kind))
  add(path_564247, "id", newJInt(id))
  add(path_564247, "subscriptionId", newJString(subscriptionId))
  add(path_564247, "appCollection", newJString(appCollection))
  add(path_564247, "resourceGroupName", newJString(resourceGroupName))
  add(path_564247, "appName", newJString(appName))
  if parameters != nil:
    body_564249 = parameters
  result = call_564246.call(path_564247, query_564248, nil, nil, body_564249)

var campaignsUpdate* = Call_CampaignsUpdate_564234(name: "campaignsUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}",
    validator: validate_CampaignsUpdate_564235, base: "", url: url_CampaignsUpdate_564236,
    schemes: {Scheme.Https})
type
  Call_CampaignsGet_564220 = ref object of OpenApiRestCall_563564
proc url_CampaignsGet_564222(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsGet_564221(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## The Get campaign operation retrieves information about a previously created campaign.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   id: JInt (required)
  ##     : Campaign identifier.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kind` field"
  var valid_564223 = path.getOrDefault("kind")
  valid_564223 = validateParameter(valid_564223, JString, required = true,
                                 default = newJString("announcements"))
  if valid_564223 != nil:
    section.add "kind", valid_564223
  var valid_564224 = path.getOrDefault("id")
  valid_564224 = validateParameter(valid_564224, JInt, required = true, default = nil)
  if valid_564224 != nil:
    section.add "id", valid_564224
  var valid_564225 = path.getOrDefault("subscriptionId")
  valid_564225 = validateParameter(valid_564225, JString, required = true,
                                 default = nil)
  if valid_564225 != nil:
    section.add "subscriptionId", valid_564225
  var valid_564226 = path.getOrDefault("appCollection")
  valid_564226 = validateParameter(valid_564226, JString, required = true,
                                 default = nil)
  if valid_564226 != nil:
    section.add "appCollection", valid_564226
  var valid_564227 = path.getOrDefault("resourceGroupName")
  valid_564227 = validateParameter(valid_564227, JString, required = true,
                                 default = nil)
  if valid_564227 != nil:
    section.add "resourceGroupName", valid_564227
  var valid_564228 = path.getOrDefault("appName")
  valid_564228 = validateParameter(valid_564228, JString, required = true,
                                 default = nil)
  if valid_564228 != nil:
    section.add "appName", valid_564228
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564229 = query.getOrDefault("api-version")
  valid_564229 = validateParameter(valid_564229, JString, required = true,
                                 default = nil)
  if valid_564229 != nil:
    section.add "api-version", valid_564229
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564230: Call_CampaignsGet_564220; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get campaign operation retrieves information about a previously created campaign.
  ## 
  let valid = call_564230.validator(path, query, header, formData, body)
  let scheme = call_564230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564230.url(scheme.get, call_564230.host, call_564230.base,
                         call_564230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564230, url, valid)

proc call*(call_564231: Call_CampaignsGet_564220; apiVersion: string; id: int;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string; kind: string = "announcements"): Recallable =
  ## campaignsGet
  ## The Get campaign operation retrieves information about a previously created campaign.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   id: int (required)
  ##     : Campaign identifier.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  var path_564232 = newJObject()
  var query_564233 = newJObject()
  add(query_564233, "api-version", newJString(apiVersion))
  add(path_564232, "kind", newJString(kind))
  add(path_564232, "id", newJInt(id))
  add(path_564232, "subscriptionId", newJString(subscriptionId))
  add(path_564232, "appCollection", newJString(appCollection))
  add(path_564232, "resourceGroupName", newJString(resourceGroupName))
  add(path_564232, "appName", newJString(appName))
  result = call_564231.call(path_564232, query_564233, nil, nil, nil)

var campaignsGet* = Call_CampaignsGet_564220(name: "campaignsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}",
    validator: validate_CampaignsGet_564221, base: "", url: url_CampaignsGet_564222,
    schemes: {Scheme.Https})
type
  Call_CampaignsDelete_564250 = ref object of OpenApiRestCall_563564
proc url_CampaignsDelete_564252(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsDelete_564251(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Delete a campaign previously created by a call to Create campaign.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   id: JInt (required)
  ##     : Campaign identifier.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kind` field"
  var valid_564253 = path.getOrDefault("kind")
  valid_564253 = validateParameter(valid_564253, JString, required = true,
                                 default = newJString("announcements"))
  if valid_564253 != nil:
    section.add "kind", valid_564253
  var valid_564254 = path.getOrDefault("id")
  valid_564254 = validateParameter(valid_564254, JInt, required = true, default = nil)
  if valid_564254 != nil:
    section.add "id", valid_564254
  var valid_564255 = path.getOrDefault("subscriptionId")
  valid_564255 = validateParameter(valid_564255, JString, required = true,
                                 default = nil)
  if valid_564255 != nil:
    section.add "subscriptionId", valid_564255
  var valid_564256 = path.getOrDefault("appCollection")
  valid_564256 = validateParameter(valid_564256, JString, required = true,
                                 default = nil)
  if valid_564256 != nil:
    section.add "appCollection", valid_564256
  var valid_564257 = path.getOrDefault("resourceGroupName")
  valid_564257 = validateParameter(valid_564257, JString, required = true,
                                 default = nil)
  if valid_564257 != nil:
    section.add "resourceGroupName", valid_564257
  var valid_564258 = path.getOrDefault("appName")
  valid_564258 = validateParameter(valid_564258, JString, required = true,
                                 default = nil)
  if valid_564258 != nil:
    section.add "appName", valid_564258
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564259 = query.getOrDefault("api-version")
  valid_564259 = validateParameter(valid_564259, JString, required = true,
                                 default = nil)
  if valid_564259 != nil:
    section.add "api-version", valid_564259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564260: Call_CampaignsDelete_564250; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a campaign previously created by a call to Create campaign.
  ## 
  let valid = call_564260.validator(path, query, header, formData, body)
  let scheme = call_564260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564260.url(scheme.get, call_564260.host, call_564260.base,
                         call_564260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564260, url, valid)

proc call*(call_564261: Call_CampaignsDelete_564250; apiVersion: string; id: int;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string; kind: string = "announcements"): Recallable =
  ## campaignsDelete
  ## Delete a campaign previously created by a call to Create campaign.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   id: int (required)
  ##     : Campaign identifier.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  var path_564262 = newJObject()
  var query_564263 = newJObject()
  add(query_564263, "api-version", newJString(apiVersion))
  add(path_564262, "kind", newJString(kind))
  add(path_564262, "id", newJInt(id))
  add(path_564262, "subscriptionId", newJString(subscriptionId))
  add(path_564262, "appCollection", newJString(appCollection))
  add(path_564262, "resourceGroupName", newJString(resourceGroupName))
  add(path_564262, "appName", newJString(appName))
  result = call_564261.call(path_564262, query_564263, nil, nil, nil)

var campaignsDelete* = Call_CampaignsDelete_564250(name: "campaignsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}",
    validator: validate_CampaignsDelete_564251, base: "", url: url_CampaignsDelete_564252,
    schemes: {Scheme.Https})
type
  Call_CampaignsActivate_564264 = ref object of OpenApiRestCall_563564
proc url_CampaignsActivate_564266(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsActivate_564265(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Activate a campaign previously created by a call to Create campaign.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   id: JInt (required)
  ##     : Campaign identifier.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kind` field"
  var valid_564267 = path.getOrDefault("kind")
  valid_564267 = validateParameter(valid_564267, JString, required = true,
                                 default = newJString("announcements"))
  if valid_564267 != nil:
    section.add "kind", valid_564267
  var valid_564268 = path.getOrDefault("id")
  valid_564268 = validateParameter(valid_564268, JInt, required = true, default = nil)
  if valid_564268 != nil:
    section.add "id", valid_564268
  var valid_564269 = path.getOrDefault("subscriptionId")
  valid_564269 = validateParameter(valid_564269, JString, required = true,
                                 default = nil)
  if valid_564269 != nil:
    section.add "subscriptionId", valid_564269
  var valid_564270 = path.getOrDefault("appCollection")
  valid_564270 = validateParameter(valid_564270, JString, required = true,
                                 default = nil)
  if valid_564270 != nil:
    section.add "appCollection", valid_564270
  var valid_564271 = path.getOrDefault("resourceGroupName")
  valid_564271 = validateParameter(valid_564271, JString, required = true,
                                 default = nil)
  if valid_564271 != nil:
    section.add "resourceGroupName", valid_564271
  var valid_564272 = path.getOrDefault("appName")
  valid_564272 = validateParameter(valid_564272, JString, required = true,
                                 default = nil)
  if valid_564272 != nil:
    section.add "appName", valid_564272
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564273 = query.getOrDefault("api-version")
  valid_564273 = validateParameter(valid_564273, JString, required = true,
                                 default = nil)
  if valid_564273 != nil:
    section.add "api-version", valid_564273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564274: Call_CampaignsActivate_564264; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activate a campaign previously created by a call to Create campaign.
  ## 
  let valid = call_564274.validator(path, query, header, formData, body)
  let scheme = call_564274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564274.url(scheme.get, call_564274.host, call_564274.base,
                         call_564274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564274, url, valid)

proc call*(call_564275: Call_CampaignsActivate_564264; apiVersion: string; id: int;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string; kind: string = "announcements"): Recallable =
  ## campaignsActivate
  ## Activate a campaign previously created by a call to Create campaign.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   id: int (required)
  ##     : Campaign identifier.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  var path_564276 = newJObject()
  var query_564277 = newJObject()
  add(query_564277, "api-version", newJString(apiVersion))
  add(path_564276, "kind", newJString(kind))
  add(path_564276, "id", newJInt(id))
  add(path_564276, "subscriptionId", newJString(subscriptionId))
  add(path_564276, "appCollection", newJString(appCollection))
  add(path_564276, "resourceGroupName", newJString(resourceGroupName))
  add(path_564276, "appName", newJString(appName))
  result = call_564275.call(path_564276, query_564277, nil, nil, nil)

var campaignsActivate* = Call_CampaignsActivate_564264(name: "campaignsActivate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}/activate",
    validator: validate_CampaignsActivate_564265, base: "",
    url: url_CampaignsActivate_564266, schemes: {Scheme.Https})
type
  Call_CampaignsFinish_564278 = ref object of OpenApiRestCall_563564
proc url_CampaignsFinish_564280(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsFinish_564279(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Finish a push campaign previously activated by a call to Activate campaign.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   id: JInt (required)
  ##     : Campaign identifier.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kind` field"
  var valid_564281 = path.getOrDefault("kind")
  valid_564281 = validateParameter(valid_564281, JString, required = true,
                                 default = newJString("announcements"))
  if valid_564281 != nil:
    section.add "kind", valid_564281
  var valid_564282 = path.getOrDefault("id")
  valid_564282 = validateParameter(valid_564282, JInt, required = true, default = nil)
  if valid_564282 != nil:
    section.add "id", valid_564282
  var valid_564283 = path.getOrDefault("subscriptionId")
  valid_564283 = validateParameter(valid_564283, JString, required = true,
                                 default = nil)
  if valid_564283 != nil:
    section.add "subscriptionId", valid_564283
  var valid_564284 = path.getOrDefault("appCollection")
  valid_564284 = validateParameter(valid_564284, JString, required = true,
                                 default = nil)
  if valid_564284 != nil:
    section.add "appCollection", valid_564284
  var valid_564285 = path.getOrDefault("resourceGroupName")
  valid_564285 = validateParameter(valid_564285, JString, required = true,
                                 default = nil)
  if valid_564285 != nil:
    section.add "resourceGroupName", valid_564285
  var valid_564286 = path.getOrDefault("appName")
  valid_564286 = validateParameter(valid_564286, JString, required = true,
                                 default = nil)
  if valid_564286 != nil:
    section.add "appName", valid_564286
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564287 = query.getOrDefault("api-version")
  valid_564287 = validateParameter(valid_564287, JString, required = true,
                                 default = nil)
  if valid_564287 != nil:
    section.add "api-version", valid_564287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564288: Call_CampaignsFinish_564278; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Finish a push campaign previously activated by a call to Activate campaign.
  ## 
  let valid = call_564288.validator(path, query, header, formData, body)
  let scheme = call_564288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564288.url(scheme.get, call_564288.host, call_564288.base,
                         call_564288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564288, url, valid)

proc call*(call_564289: Call_CampaignsFinish_564278; apiVersion: string; id: int;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string; kind: string = "announcements"): Recallable =
  ## campaignsFinish
  ## Finish a push campaign previously activated by a call to Activate campaign.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   id: int (required)
  ##     : Campaign identifier.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  var path_564290 = newJObject()
  var query_564291 = newJObject()
  add(query_564291, "api-version", newJString(apiVersion))
  add(path_564290, "kind", newJString(kind))
  add(path_564290, "id", newJInt(id))
  add(path_564290, "subscriptionId", newJString(subscriptionId))
  add(path_564290, "appCollection", newJString(appCollection))
  add(path_564290, "resourceGroupName", newJString(resourceGroupName))
  add(path_564290, "appName", newJString(appName))
  result = call_564289.call(path_564290, query_564291, nil, nil, nil)

var campaignsFinish* = Call_CampaignsFinish_564278(name: "campaignsFinish",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}/finish",
    validator: validate_CampaignsFinish_564279, base: "", url: url_CampaignsFinish_564280,
    schemes: {Scheme.Https})
type
  Call_CampaignsPush_564292 = ref object of OpenApiRestCall_563564
proc url_CampaignsPush_564294(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsPush_564293(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Push a previously saved campaign (created with Create campaign) to a set of devices.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   id: JInt (required)
  ##     : Campaign identifier.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kind` field"
  var valid_564295 = path.getOrDefault("kind")
  valid_564295 = validateParameter(valid_564295, JString, required = true,
                                 default = newJString("announcements"))
  if valid_564295 != nil:
    section.add "kind", valid_564295
  var valid_564296 = path.getOrDefault("id")
  valid_564296 = validateParameter(valid_564296, JInt, required = true, default = nil)
  if valid_564296 != nil:
    section.add "id", valid_564296
  var valid_564297 = path.getOrDefault("subscriptionId")
  valid_564297 = validateParameter(valid_564297, JString, required = true,
                                 default = nil)
  if valid_564297 != nil:
    section.add "subscriptionId", valid_564297
  var valid_564298 = path.getOrDefault("appCollection")
  valid_564298 = validateParameter(valid_564298, JString, required = true,
                                 default = nil)
  if valid_564298 != nil:
    section.add "appCollection", valid_564298
  var valid_564299 = path.getOrDefault("resourceGroupName")
  valid_564299 = validateParameter(valid_564299, JString, required = true,
                                 default = nil)
  if valid_564299 != nil:
    section.add "resourceGroupName", valid_564299
  var valid_564300 = path.getOrDefault("appName")
  valid_564300 = validateParameter(valid_564300, JString, required = true,
                                 default = nil)
  if valid_564300 != nil:
    section.add "appName", valid_564300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564301 = query.getOrDefault("api-version")
  valid_564301 = validateParameter(valid_564301, JString, required = true,
                                 default = nil)
  if valid_564301 != nil:
    section.add "api-version", valid_564301
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

proc call*(call_564303: Call_CampaignsPush_564292; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Push a previously saved campaign (created with Create campaign) to a set of devices.
  ## 
  let valid = call_564303.validator(path, query, header, formData, body)
  let scheme = call_564303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564303.url(scheme.get, call_564303.host, call_564303.base,
                         call_564303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564303, url, valid)

proc call*(call_564304: Call_CampaignsPush_564292; apiVersion: string; id: int;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string; parameters: JsonNode; kind: string = "announcements"): Recallable =
  ## campaignsPush
  ## Push a previously saved campaign (created with Create campaign) to a set of devices.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   id: int (required)
  ##     : Campaign identifier.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Push Campaign operation.
  var path_564305 = newJObject()
  var query_564306 = newJObject()
  var body_564307 = newJObject()
  add(query_564306, "api-version", newJString(apiVersion))
  add(path_564305, "kind", newJString(kind))
  add(path_564305, "id", newJInt(id))
  add(path_564305, "subscriptionId", newJString(subscriptionId))
  add(path_564305, "appCollection", newJString(appCollection))
  add(path_564305, "resourceGroupName", newJString(resourceGroupName))
  add(path_564305, "appName", newJString(appName))
  if parameters != nil:
    body_564307 = parameters
  result = call_564304.call(path_564305, query_564306, nil, nil, body_564307)

var campaignsPush* = Call_CampaignsPush_564292(name: "campaignsPush",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}/push",
    validator: validate_CampaignsPush_564293, base: "", url: url_CampaignsPush_564294,
    schemes: {Scheme.Https})
type
  Call_CampaignsGetStatistics_564308 = ref object of OpenApiRestCall_563564
proc url_CampaignsGetStatistics_564310(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsGetStatistics_564309(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get all the campaign statistics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   id: JInt (required)
  ##     : Campaign identifier.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kind` field"
  var valid_564311 = path.getOrDefault("kind")
  valid_564311 = validateParameter(valid_564311, JString, required = true,
                                 default = newJString("announcements"))
  if valid_564311 != nil:
    section.add "kind", valid_564311
  var valid_564312 = path.getOrDefault("id")
  valid_564312 = validateParameter(valid_564312, JInt, required = true, default = nil)
  if valid_564312 != nil:
    section.add "id", valid_564312
  var valid_564313 = path.getOrDefault("subscriptionId")
  valid_564313 = validateParameter(valid_564313, JString, required = true,
                                 default = nil)
  if valid_564313 != nil:
    section.add "subscriptionId", valid_564313
  var valid_564314 = path.getOrDefault("appCollection")
  valid_564314 = validateParameter(valid_564314, JString, required = true,
                                 default = nil)
  if valid_564314 != nil:
    section.add "appCollection", valid_564314
  var valid_564315 = path.getOrDefault("resourceGroupName")
  valid_564315 = validateParameter(valid_564315, JString, required = true,
                                 default = nil)
  if valid_564315 != nil:
    section.add "resourceGroupName", valid_564315
  var valid_564316 = path.getOrDefault("appName")
  valid_564316 = validateParameter(valid_564316, JString, required = true,
                                 default = nil)
  if valid_564316 != nil:
    section.add "appName", valid_564316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564317 = query.getOrDefault("api-version")
  valid_564317 = validateParameter(valid_564317, JString, required = true,
                                 default = nil)
  if valid_564317 != nil:
    section.add "api-version", valid_564317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564318: Call_CampaignsGetStatistics_564308; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the campaign statistics.
  ## 
  let valid = call_564318.validator(path, query, header, formData, body)
  let scheme = call_564318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564318.url(scheme.get, call_564318.host, call_564318.base,
                         call_564318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564318, url, valid)

proc call*(call_564319: Call_CampaignsGetStatistics_564308; apiVersion: string;
          id: int; subscriptionId: string; appCollection: string;
          resourceGroupName: string; appName: string; kind: string = "announcements"): Recallable =
  ## campaignsGetStatistics
  ## Get all the campaign statistics.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   id: int (required)
  ##     : Campaign identifier.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  var path_564320 = newJObject()
  var query_564321 = newJObject()
  add(query_564321, "api-version", newJString(apiVersion))
  add(path_564320, "kind", newJString(kind))
  add(path_564320, "id", newJInt(id))
  add(path_564320, "subscriptionId", newJString(subscriptionId))
  add(path_564320, "appCollection", newJString(appCollection))
  add(path_564320, "resourceGroupName", newJString(resourceGroupName))
  add(path_564320, "appName", newJString(appName))
  result = call_564319.call(path_564320, query_564321, nil, nil, nil)

var campaignsGetStatistics* = Call_CampaignsGetStatistics_564308(
    name: "campaignsGetStatistics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}/statistics",
    validator: validate_CampaignsGetStatistics_564309, base: "",
    url: url_CampaignsGetStatistics_564310, schemes: {Scheme.Https})
type
  Call_CampaignsSuspend_564322 = ref object of OpenApiRestCall_563564
proc url_CampaignsSuspend_564324(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsSuspend_564323(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Suspend a push campaign previously activated by a call to Activate campaign.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   id: JInt (required)
  ##     : Campaign identifier.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kind` field"
  var valid_564325 = path.getOrDefault("kind")
  valid_564325 = validateParameter(valid_564325, JString, required = true,
                                 default = newJString("announcements"))
  if valid_564325 != nil:
    section.add "kind", valid_564325
  var valid_564326 = path.getOrDefault("id")
  valid_564326 = validateParameter(valid_564326, JInt, required = true, default = nil)
  if valid_564326 != nil:
    section.add "id", valid_564326
  var valid_564327 = path.getOrDefault("subscriptionId")
  valid_564327 = validateParameter(valid_564327, JString, required = true,
                                 default = nil)
  if valid_564327 != nil:
    section.add "subscriptionId", valid_564327
  var valid_564328 = path.getOrDefault("appCollection")
  valid_564328 = validateParameter(valid_564328, JString, required = true,
                                 default = nil)
  if valid_564328 != nil:
    section.add "appCollection", valid_564328
  var valid_564329 = path.getOrDefault("resourceGroupName")
  valid_564329 = validateParameter(valid_564329, JString, required = true,
                                 default = nil)
  if valid_564329 != nil:
    section.add "resourceGroupName", valid_564329
  var valid_564330 = path.getOrDefault("appName")
  valid_564330 = validateParameter(valid_564330, JString, required = true,
                                 default = nil)
  if valid_564330 != nil:
    section.add "appName", valid_564330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564331 = query.getOrDefault("api-version")
  valid_564331 = validateParameter(valid_564331, JString, required = true,
                                 default = nil)
  if valid_564331 != nil:
    section.add "api-version", valid_564331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564332: Call_CampaignsSuspend_564322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suspend a push campaign previously activated by a call to Activate campaign.
  ## 
  let valid = call_564332.validator(path, query, header, formData, body)
  let scheme = call_564332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564332.url(scheme.get, call_564332.host, call_564332.base,
                         call_564332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564332, url, valid)

proc call*(call_564333: Call_CampaignsSuspend_564322; apiVersion: string; id: int;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string; kind: string = "announcements"): Recallable =
  ## campaignsSuspend
  ## Suspend a push campaign previously activated by a call to Activate campaign.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   id: int (required)
  ##     : Campaign identifier.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  var path_564334 = newJObject()
  var query_564335 = newJObject()
  add(query_564335, "api-version", newJString(apiVersion))
  add(path_564334, "kind", newJString(kind))
  add(path_564334, "id", newJInt(id))
  add(path_564334, "subscriptionId", newJString(subscriptionId))
  add(path_564334, "appCollection", newJString(appCollection))
  add(path_564334, "resourceGroupName", newJString(resourceGroupName))
  add(path_564334, "appName", newJString(appName))
  result = call_564333.call(path_564334, query_564335, nil, nil, nil)

var campaignsSuspend* = Call_CampaignsSuspend_564322(name: "campaignsSuspend",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}/suspend",
    validator: validate_CampaignsSuspend_564323, base: "",
    url: url_CampaignsSuspend_564324, schemes: {Scheme.Https})
type
  Call_CampaignsTestSaved_564336 = ref object of OpenApiRestCall_563564
proc url_CampaignsTestSaved_564338(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsTestSaved_564337(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Test an existing campaign (created with Create campaign) on a set of devices.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   id: JInt (required)
  ##     : Campaign identifier.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kind` field"
  var valid_564339 = path.getOrDefault("kind")
  valid_564339 = validateParameter(valid_564339, JString, required = true,
                                 default = newJString("announcements"))
  if valid_564339 != nil:
    section.add "kind", valid_564339
  var valid_564340 = path.getOrDefault("id")
  valid_564340 = validateParameter(valid_564340, JInt, required = true, default = nil)
  if valid_564340 != nil:
    section.add "id", valid_564340
  var valid_564341 = path.getOrDefault("subscriptionId")
  valid_564341 = validateParameter(valid_564341, JString, required = true,
                                 default = nil)
  if valid_564341 != nil:
    section.add "subscriptionId", valid_564341
  var valid_564342 = path.getOrDefault("appCollection")
  valid_564342 = validateParameter(valid_564342, JString, required = true,
                                 default = nil)
  if valid_564342 != nil:
    section.add "appCollection", valid_564342
  var valid_564343 = path.getOrDefault("resourceGroupName")
  valid_564343 = validateParameter(valid_564343, JString, required = true,
                                 default = nil)
  if valid_564343 != nil:
    section.add "resourceGroupName", valid_564343
  var valid_564344 = path.getOrDefault("appName")
  valid_564344 = validateParameter(valid_564344, JString, required = true,
                                 default = nil)
  if valid_564344 != nil:
    section.add "appName", valid_564344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564345 = query.getOrDefault("api-version")
  valid_564345 = validateParameter(valid_564345, JString, required = true,
                                 default = nil)
  if valid_564345 != nil:
    section.add "api-version", valid_564345
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

proc call*(call_564347: Call_CampaignsTestSaved_564336; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Test an existing campaign (created with Create campaign) on a set of devices.
  ## 
  let valid = call_564347.validator(path, query, header, formData, body)
  let scheme = call_564347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564347.url(scheme.get, call_564347.host, call_564347.base,
                         call_564347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564347, url, valid)

proc call*(call_564348: Call_CampaignsTestSaved_564336; apiVersion: string; id: int;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string; parameters: JsonNode; kind: string = "announcements"): Recallable =
  ## campaignsTestSaved
  ## Test an existing campaign (created with Create campaign) on a set of devices.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   id: int (required)
  ##     : Campaign identifier.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the Test Campaign operation.
  var path_564349 = newJObject()
  var query_564350 = newJObject()
  var body_564351 = newJObject()
  add(query_564350, "api-version", newJString(apiVersion))
  add(path_564349, "kind", newJString(kind))
  add(path_564349, "id", newJInt(id))
  add(path_564349, "subscriptionId", newJString(subscriptionId))
  add(path_564349, "appCollection", newJString(appCollection))
  add(path_564349, "resourceGroupName", newJString(resourceGroupName))
  add(path_564349, "appName", newJString(appName))
  if parameters != nil:
    body_564351 = parameters
  result = call_564348.call(path_564349, query_564350, nil, nil, body_564351)

var campaignsTestSaved* = Call_CampaignsTestSaved_564336(
    name: "campaignsTestSaved", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}/test",
    validator: validate_CampaignsTestSaved_564337, base: "",
    url: url_CampaignsTestSaved_564338, schemes: {Scheme.Https})
type
  Call_CampaignsGetByName_564352 = ref object of OpenApiRestCall_563564
proc url_CampaignsGetByName_564354(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsGetByName_564353(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## The Get campaign operation retrieves information about a previously created campaign.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   kind: JString (required)
  ##       : Campaign kind.
  ##   name: JString (required)
  ##       : Campaign name.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `kind` field"
  var valid_564355 = path.getOrDefault("kind")
  valid_564355 = validateParameter(valid_564355, JString, required = true,
                                 default = newJString("announcements"))
  if valid_564355 != nil:
    section.add "kind", valid_564355
  var valid_564356 = path.getOrDefault("name")
  valid_564356 = validateParameter(valid_564356, JString, required = true,
                                 default = nil)
  if valid_564356 != nil:
    section.add "name", valid_564356
  var valid_564357 = path.getOrDefault("subscriptionId")
  valid_564357 = validateParameter(valid_564357, JString, required = true,
                                 default = nil)
  if valid_564357 != nil:
    section.add "subscriptionId", valid_564357
  var valid_564358 = path.getOrDefault("appCollection")
  valid_564358 = validateParameter(valid_564358, JString, required = true,
                                 default = nil)
  if valid_564358 != nil:
    section.add "appCollection", valid_564358
  var valid_564359 = path.getOrDefault("resourceGroupName")
  valid_564359 = validateParameter(valid_564359, JString, required = true,
                                 default = nil)
  if valid_564359 != nil:
    section.add "resourceGroupName", valid_564359
  var valid_564360 = path.getOrDefault("appName")
  valid_564360 = validateParameter(valid_564360, JString, required = true,
                                 default = nil)
  if valid_564360 != nil:
    section.add "appName", valid_564360
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564361 = query.getOrDefault("api-version")
  valid_564361 = validateParameter(valid_564361, JString, required = true,
                                 default = nil)
  if valid_564361 != nil:
    section.add "api-version", valid_564361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564362: Call_CampaignsGetByName_564352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get campaign operation retrieves information about a previously created campaign.
  ## 
  let valid = call_564362.validator(path, query, header, formData, body)
  let scheme = call_564362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564362.url(scheme.get, call_564362.host, call_564362.base,
                         call_564362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564362, url, valid)

proc call*(call_564363: Call_CampaignsGetByName_564352; apiVersion: string;
          name: string; subscriptionId: string; appCollection: string;
          resourceGroupName: string; appName: string; kind: string = "announcements"): Recallable =
  ## campaignsGetByName
  ## The Get campaign operation retrieves information about a previously created campaign.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   kind: string (required)
  ##       : Campaign kind.
  ##   name: string (required)
  ##       : Campaign name.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  var path_564364 = newJObject()
  var query_564365 = newJObject()
  add(query_564365, "api-version", newJString(apiVersion))
  add(path_564364, "kind", newJString(kind))
  add(path_564364, "name", newJString(name))
  add(path_564364, "subscriptionId", newJString(subscriptionId))
  add(path_564364, "appCollection", newJString(appCollection))
  add(path_564364, "resourceGroupName", newJString(resourceGroupName))
  add(path_564364, "appName", newJString(appName))
  result = call_564363.call(path_564364, query_564365, nil, nil, nil)

var campaignsGetByName* = Call_CampaignsGetByName_564352(
    name: "campaignsGetByName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaignsByName/{kind}/{name}",
    validator: validate_CampaignsGetByName_564353, base: "",
    url: url_CampaignsGetByName_564354, schemes: {Scheme.Https})
type
  Call_DevicesList_564366 = ref object of OpenApiRestCall_563564
proc url_DevicesList_564368(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesList_564367(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Query the information associated to the devices running an application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564369 = path.getOrDefault("subscriptionId")
  valid_564369 = validateParameter(valid_564369, JString, required = true,
                                 default = nil)
  if valid_564369 != nil:
    section.add "subscriptionId", valid_564369
  var valid_564370 = path.getOrDefault("appCollection")
  valid_564370 = validateParameter(valid_564370, JString, required = true,
                                 default = nil)
  if valid_564370 != nil:
    section.add "appCollection", valid_564370
  var valid_564371 = path.getOrDefault("resourceGroupName")
  valid_564371 = validateParameter(valid_564371, JString, required = true,
                                 default = nil)
  if valid_564371 != nil:
    section.add "resourceGroupName", valid_564371
  var valid_564372 = path.getOrDefault("appName")
  valid_564372 = validateParameter(valid_564372, JString, required = true,
                                 default = nil)
  if valid_564372 != nil:
    section.add "appName", valid_564372
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
  var valid_564373 = query.getOrDefault("api-version")
  valid_564373 = validateParameter(valid_564373, JString, required = true,
                                 default = nil)
  if valid_564373 != nil:
    section.add "api-version", valid_564373
  var valid_564374 = query.getOrDefault("$top")
  valid_564374 = validateParameter(valid_564374, JInt, required = false, default = nil)
  if valid_564374 != nil:
    section.add "$top", valid_564374
  var valid_564375 = query.getOrDefault("$select")
  valid_564375 = validateParameter(valid_564375, JString, required = false,
                                 default = nil)
  if valid_564375 != nil:
    section.add "$select", valid_564375
  var valid_564376 = query.getOrDefault("$filter")
  valid_564376 = validateParameter(valid_564376, JString, required = false,
                                 default = nil)
  if valid_564376 != nil:
    section.add "$filter", valid_564376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564377: Call_DevicesList_564366; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the information associated to the devices running an application.
  ## 
  let valid = call_564377.validator(path, query, header, formData, body)
  let scheme = call_564377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564377.url(scheme.get, call_564377.host, call_564377.base,
                         call_564377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564377, url, valid)

proc call*(call_564378: Call_DevicesList_564366; apiVersion: string;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string; Top: int = 0; Select: string = ""; Filter: string = ""): Recallable =
  ## devicesList
  ## Query the information associated to the devices running an application.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : Number of devices to return with each call. Defaults to 100 and cannot return more. Passing a greater value is ignored. The response contains a `nextLink` property describing the URI path to get the next page of results if not all results could be returned at once.
  ##   Select: string
  ##         : By default all `meta` and `appInfo` properties are returned, this property is used to restrict the output to the desired properties. It also excludes all devices from the output that have none of the selected properties. In other terms, only devices having at least one of the selected property being set is part of the results. Examples: - `$select=appInfo` : select all devices having at least 1 appInfo, return them all and don’t return any meta property. - `$select=meta` : return only meta properties in the output. - `$select=appInfo,meta/firstSeen,meta/lastSeen` : return all `appInfo`, plus meta object containing only firstSeen and lastSeen properties. The format is thus a comma separated list of properties to select. Use `appInfo` to select all appInfo properties, `meta` to select all meta properties. Use `appInfo/{key}` and `meta/{key}` to select specific appInfo and meta properties.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   Filter: string
  ##         : Filter can be used to reduce the number of results. Filter is a boolean expression that can look like the following examples: * `$filter=deviceId gt 'abcdef0123456789abcdef0123456789'` * `$filter=lastModified le 1447284263690L` * `$filter=(deviceId ge 'abcdef0123456789abcdef0123456789') and (deviceId lt 'bacdef0123456789abcdef0123456789') and (lastModified gt 1447284263690L)` The first example is used automatically for paging when returning the `nextLink` property. The filter expression is a combination of checks on some properties that can be compared to their value. The available operators are: * `gt`  : greater than * `ge`  : greater than or equals * `lt`  : less than * `le`  : less than or equals * `and` : to add multiple checks (all checks must pass), optional parentheses can be used. The properties that can be used in the expression are the following: * `deviceId {operator} '{deviceIdValue}'` : a lexicographical comparison is made on the deviceId value, use single quotes for the value. * `lastModified {operator} {number}L` : returns only meta properties or appInfo properties whose last value modification timestamp compared to the specified value is matching (value is milliseconds since January 1st, 1970 UTC). Please note the `L` character after the number of milliseconds, its required when the number of milliseconds exceeds `2^31 - 1` (which is always the case for recent timestamps). Using `lastModified` excludes all devices from the output that have no property matching the timestamp criteria, like `$select`. Please note that the internal value of `lastModified` timestamp for a given property is never part of the results.
  var path_564379 = newJObject()
  var query_564380 = newJObject()
  add(query_564380, "api-version", newJString(apiVersion))
  add(query_564380, "$top", newJInt(Top))
  add(query_564380, "$select", newJString(Select))
  add(path_564379, "subscriptionId", newJString(subscriptionId))
  add(path_564379, "appCollection", newJString(appCollection))
  add(path_564379, "resourceGroupName", newJString(resourceGroupName))
  add(path_564379, "appName", newJString(appName))
  add(query_564380, "$filter", newJString(Filter))
  result = call_564378.call(path_564379, query_564380, nil, nil, nil)

var devicesList* = Call_DevicesList_564366(name: "devicesList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices",
                                        validator: validate_DevicesList_564367,
                                        base: "", url: url_DevicesList_564368,
                                        schemes: {Scheme.Https})
type
  Call_ExportTasksList_564381 = ref object of OpenApiRestCall_563564
proc url_ExportTasksList_564383(protocol: Scheme; host: string; base: string;
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

proc validate_ExportTasksList_564382(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get the list of export tasks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564384 = path.getOrDefault("subscriptionId")
  valid_564384 = validateParameter(valid_564384, JString, required = true,
                                 default = nil)
  if valid_564384 != nil:
    section.add "subscriptionId", valid_564384
  var valid_564385 = path.getOrDefault("appCollection")
  valid_564385 = validateParameter(valid_564385, JString, required = true,
                                 default = nil)
  if valid_564385 != nil:
    section.add "appCollection", valid_564385
  var valid_564386 = path.getOrDefault("resourceGroupName")
  valid_564386 = validateParameter(valid_564386, JString, required = true,
                                 default = nil)
  if valid_564386 != nil:
    section.add "resourceGroupName", valid_564386
  var valid_564387 = path.getOrDefault("appName")
  valid_564387 = validateParameter(valid_564387, JString, required = true,
                                 default = nil)
  if valid_564387 != nil:
    section.add "appName", valid_564387
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Control paging of export tasks, number of export tasks to return with each call. By default, it returns all export tasks with a default paging of 20.
  ## The response contains a `nextLink` property describing the path to get the next page if there are more results.
  ## The maximum paging limit for $top is 40.
  ##   $orderby: JString
  ##           : Sort results by an expression which looks like `$orderby=taskId asc` (default when not specified).
  ## The syntax is orderby={property} {direction} or just orderby={property}.
  ## Properties that can be specified for sorting: taskId, errorDetails, dateCreated, taskStatus, and dateCreated.
  ## The available directions are asc (for ascending order) and desc (for descending order).
  ## When not specified the asc direction is used.
  ## Only one orderby property can be specified.
  ##   $skip: JInt
  ##        : Control paging of export tasks, start results at the given offset, defaults to 0 (1st page of data).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564388 = query.getOrDefault("api-version")
  valid_564388 = validateParameter(valid_564388, JString, required = true,
                                 default = nil)
  if valid_564388 != nil:
    section.add "api-version", valid_564388
  var valid_564390 = query.getOrDefault("$top")
  valid_564390 = validateParameter(valid_564390, JInt, required = false,
                                 default = newJInt(20))
  if valid_564390 != nil:
    section.add "$top", valid_564390
  var valid_564391 = query.getOrDefault("$orderby")
  valid_564391 = validateParameter(valid_564391, JString, required = false,
                                 default = nil)
  if valid_564391 != nil:
    section.add "$orderby", valid_564391
  var valid_564392 = query.getOrDefault("$skip")
  valid_564392 = validateParameter(valid_564392, JInt, required = false,
                                 default = newJInt(0))
  if valid_564392 != nil:
    section.add "$skip", valid_564392
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564393: Call_ExportTasksList_564381; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of export tasks.
  ## 
  let valid = call_564393.validator(path, query, header, formData, body)
  let scheme = call_564393.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564393.url(scheme.get, call_564393.host, call_564393.base,
                         call_564393.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564393, url, valid)

proc call*(call_564394: Call_ExportTasksList_564381; apiVersion: string;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string; Top: int = 20; Orderby: string = ""; Skip: int = 0): Recallable =
  ## exportTasksList
  ## Get the list of export tasks.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : Control paging of export tasks, number of export tasks to return with each call. By default, it returns all export tasks with a default paging of 20.
  ## The response contains a `nextLink` property describing the path to get the next page if there are more results.
  ## The maximum paging limit for $top is 40.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Orderby: string
  ##          : Sort results by an expression which looks like `$orderby=taskId asc` (default when not specified).
  ## The syntax is orderby={property} {direction} or just orderby={property}.
  ## Properties that can be specified for sorting: taskId, errorDetails, dateCreated, taskStatus, and dateCreated.
  ## The available directions are asc (for ascending order) and desc (for descending order).
  ## When not specified the asc direction is used.
  ## Only one orderby property can be specified.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   Skip: int
  ##       : Control paging of export tasks, start results at the given offset, defaults to 0 (1st page of data).
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  var path_564395 = newJObject()
  var query_564396 = newJObject()
  add(query_564396, "api-version", newJString(apiVersion))
  add(query_564396, "$top", newJInt(Top))
  add(path_564395, "subscriptionId", newJString(subscriptionId))
  add(query_564396, "$orderby", newJString(Orderby))
  add(path_564395, "appCollection", newJString(appCollection))
  add(query_564396, "$skip", newJInt(Skip))
  add(path_564395, "resourceGroupName", newJString(resourceGroupName))
  add(path_564395, "appName", newJString(appName))
  result = call_564394.call(path_564395, query_564396, nil, nil, nil)

var exportTasksList* = Call_ExportTasksList_564381(name: "exportTasksList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks",
    validator: validate_ExportTasksList_564382, base: "", url: url_ExportTasksList_564383,
    schemes: {Scheme.Https})
type
  Call_ExportTasksCreateActivitiesTask_564397 = ref object of OpenApiRestCall_563564
proc url_ExportTasksCreateActivitiesTask_564399(protocol: Scheme; host: string;
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

proc validate_ExportTasksCreateActivitiesTask_564398(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task to export activities.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564400 = path.getOrDefault("subscriptionId")
  valid_564400 = validateParameter(valid_564400, JString, required = true,
                                 default = nil)
  if valid_564400 != nil:
    section.add "subscriptionId", valid_564400
  var valid_564401 = path.getOrDefault("appCollection")
  valid_564401 = validateParameter(valid_564401, JString, required = true,
                                 default = nil)
  if valid_564401 != nil:
    section.add "appCollection", valid_564401
  var valid_564402 = path.getOrDefault("resourceGroupName")
  valid_564402 = validateParameter(valid_564402, JString, required = true,
                                 default = nil)
  if valid_564402 != nil:
    section.add "resourceGroupName", valid_564402
  var valid_564403 = path.getOrDefault("appName")
  valid_564403 = validateParameter(valid_564403, JString, required = true,
                                 default = nil)
  if valid_564403 != nil:
    section.add "appName", valid_564403
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564404 = query.getOrDefault("api-version")
  valid_564404 = validateParameter(valid_564404, JString, required = true,
                                 default = nil)
  if valid_564404 != nil:
    section.add "api-version", valid_564404
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

proc call*(call_564406: Call_ExportTasksCreateActivitiesTask_564397;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a task to export activities.
  ## 
  let valid = call_564406.validator(path, query, header, formData, body)
  let scheme = call_564406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564406.url(scheme.get, call_564406.host, call_564406.base,
                         call_564406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564406, url, valid)

proc call*(call_564407: Call_ExportTasksCreateActivitiesTask_564397;
          apiVersion: string; subscriptionId: string; appCollection: string;
          resourceGroupName: string; appName: string; parameters: JsonNode): Recallable =
  ## exportTasksCreateActivitiesTask
  ## Creates a task to export activities.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   parameters: JObject (required)
  var path_564408 = newJObject()
  var query_564409 = newJObject()
  var body_564410 = newJObject()
  add(query_564409, "api-version", newJString(apiVersion))
  add(path_564408, "subscriptionId", newJString(subscriptionId))
  add(path_564408, "appCollection", newJString(appCollection))
  add(path_564408, "resourceGroupName", newJString(resourceGroupName))
  add(path_564408, "appName", newJString(appName))
  if parameters != nil:
    body_564410 = parameters
  result = call_564407.call(path_564408, query_564409, nil, nil, body_564410)

var exportTasksCreateActivitiesTask* = Call_ExportTasksCreateActivitiesTask_564397(
    name: "exportTasksCreateActivitiesTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/activities",
    validator: validate_ExportTasksCreateActivitiesTask_564398, base: "",
    url: url_ExportTasksCreateActivitiesTask_564399, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateCrashesTask_564411 = ref object of OpenApiRestCall_563564
proc url_ExportTasksCreateCrashesTask_564413(protocol: Scheme; host: string;
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

proc validate_ExportTasksCreateCrashesTask_564412(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task to export crashes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564414 = path.getOrDefault("subscriptionId")
  valid_564414 = validateParameter(valid_564414, JString, required = true,
                                 default = nil)
  if valid_564414 != nil:
    section.add "subscriptionId", valid_564414
  var valid_564415 = path.getOrDefault("appCollection")
  valid_564415 = validateParameter(valid_564415, JString, required = true,
                                 default = nil)
  if valid_564415 != nil:
    section.add "appCollection", valid_564415
  var valid_564416 = path.getOrDefault("resourceGroupName")
  valid_564416 = validateParameter(valid_564416, JString, required = true,
                                 default = nil)
  if valid_564416 != nil:
    section.add "resourceGroupName", valid_564416
  var valid_564417 = path.getOrDefault("appName")
  valid_564417 = validateParameter(valid_564417, JString, required = true,
                                 default = nil)
  if valid_564417 != nil:
    section.add "appName", valid_564417
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564418 = query.getOrDefault("api-version")
  valid_564418 = validateParameter(valid_564418, JString, required = true,
                                 default = nil)
  if valid_564418 != nil:
    section.add "api-version", valid_564418
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

proc call*(call_564420: Call_ExportTasksCreateCrashesTask_564411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export crashes.
  ## 
  let valid = call_564420.validator(path, query, header, formData, body)
  let scheme = call_564420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564420.url(scheme.get, call_564420.host, call_564420.base,
                         call_564420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564420, url, valid)

proc call*(call_564421: Call_ExportTasksCreateCrashesTask_564411;
          apiVersion: string; subscriptionId: string; appCollection: string;
          resourceGroupName: string; appName: string; parameters: JsonNode): Recallable =
  ## exportTasksCreateCrashesTask
  ## Creates a task to export crashes.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   parameters: JObject (required)
  var path_564422 = newJObject()
  var query_564423 = newJObject()
  var body_564424 = newJObject()
  add(query_564423, "api-version", newJString(apiVersion))
  add(path_564422, "subscriptionId", newJString(subscriptionId))
  add(path_564422, "appCollection", newJString(appCollection))
  add(path_564422, "resourceGroupName", newJString(resourceGroupName))
  add(path_564422, "appName", newJString(appName))
  if parameters != nil:
    body_564424 = parameters
  result = call_564421.call(path_564422, query_564423, nil, nil, body_564424)

var exportTasksCreateCrashesTask* = Call_ExportTasksCreateCrashesTask_564411(
    name: "exportTasksCreateCrashesTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/crashes",
    validator: validate_ExportTasksCreateCrashesTask_564412, base: "",
    url: url_ExportTasksCreateCrashesTask_564413, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateErrorsTask_564425 = ref object of OpenApiRestCall_563564
proc url_ExportTasksCreateErrorsTask_564427(protocol: Scheme; host: string;
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

proc validate_ExportTasksCreateErrorsTask_564426(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task to export errors.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564428 = path.getOrDefault("subscriptionId")
  valid_564428 = validateParameter(valid_564428, JString, required = true,
                                 default = nil)
  if valid_564428 != nil:
    section.add "subscriptionId", valid_564428
  var valid_564429 = path.getOrDefault("appCollection")
  valid_564429 = validateParameter(valid_564429, JString, required = true,
                                 default = nil)
  if valid_564429 != nil:
    section.add "appCollection", valid_564429
  var valid_564430 = path.getOrDefault("resourceGroupName")
  valid_564430 = validateParameter(valid_564430, JString, required = true,
                                 default = nil)
  if valid_564430 != nil:
    section.add "resourceGroupName", valid_564430
  var valid_564431 = path.getOrDefault("appName")
  valid_564431 = validateParameter(valid_564431, JString, required = true,
                                 default = nil)
  if valid_564431 != nil:
    section.add "appName", valid_564431
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564432 = query.getOrDefault("api-version")
  valid_564432 = validateParameter(valid_564432, JString, required = true,
                                 default = nil)
  if valid_564432 != nil:
    section.add "api-version", valid_564432
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

proc call*(call_564434: Call_ExportTasksCreateErrorsTask_564425; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export errors.
  ## 
  let valid = call_564434.validator(path, query, header, formData, body)
  let scheme = call_564434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564434.url(scheme.get, call_564434.host, call_564434.base,
                         call_564434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564434, url, valid)

proc call*(call_564435: Call_ExportTasksCreateErrorsTask_564425;
          apiVersion: string; subscriptionId: string; appCollection: string;
          resourceGroupName: string; appName: string; parameters: JsonNode): Recallable =
  ## exportTasksCreateErrorsTask
  ## Creates a task to export errors.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   parameters: JObject (required)
  var path_564436 = newJObject()
  var query_564437 = newJObject()
  var body_564438 = newJObject()
  add(query_564437, "api-version", newJString(apiVersion))
  add(path_564436, "subscriptionId", newJString(subscriptionId))
  add(path_564436, "appCollection", newJString(appCollection))
  add(path_564436, "resourceGroupName", newJString(resourceGroupName))
  add(path_564436, "appName", newJString(appName))
  if parameters != nil:
    body_564438 = parameters
  result = call_564435.call(path_564436, query_564437, nil, nil, body_564438)

var exportTasksCreateErrorsTask* = Call_ExportTasksCreateErrorsTask_564425(
    name: "exportTasksCreateErrorsTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/errors",
    validator: validate_ExportTasksCreateErrorsTask_564426, base: "",
    url: url_ExportTasksCreateErrorsTask_564427, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateEventsTask_564439 = ref object of OpenApiRestCall_563564
proc url_ExportTasksCreateEventsTask_564441(protocol: Scheme; host: string;
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

proc validate_ExportTasksCreateEventsTask_564440(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task to export events.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564442 = path.getOrDefault("subscriptionId")
  valid_564442 = validateParameter(valid_564442, JString, required = true,
                                 default = nil)
  if valid_564442 != nil:
    section.add "subscriptionId", valid_564442
  var valid_564443 = path.getOrDefault("appCollection")
  valid_564443 = validateParameter(valid_564443, JString, required = true,
                                 default = nil)
  if valid_564443 != nil:
    section.add "appCollection", valid_564443
  var valid_564444 = path.getOrDefault("resourceGroupName")
  valid_564444 = validateParameter(valid_564444, JString, required = true,
                                 default = nil)
  if valid_564444 != nil:
    section.add "resourceGroupName", valid_564444
  var valid_564445 = path.getOrDefault("appName")
  valid_564445 = validateParameter(valid_564445, JString, required = true,
                                 default = nil)
  if valid_564445 != nil:
    section.add "appName", valid_564445
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564446 = query.getOrDefault("api-version")
  valid_564446 = validateParameter(valid_564446, JString, required = true,
                                 default = nil)
  if valid_564446 != nil:
    section.add "api-version", valid_564446
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

proc call*(call_564448: Call_ExportTasksCreateEventsTask_564439; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export events.
  ## 
  let valid = call_564448.validator(path, query, header, formData, body)
  let scheme = call_564448.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564448.url(scheme.get, call_564448.host, call_564448.base,
                         call_564448.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564448, url, valid)

proc call*(call_564449: Call_ExportTasksCreateEventsTask_564439;
          apiVersion: string; subscriptionId: string; appCollection: string;
          resourceGroupName: string; appName: string; parameters: JsonNode): Recallable =
  ## exportTasksCreateEventsTask
  ## Creates a task to export events.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   parameters: JObject (required)
  var path_564450 = newJObject()
  var query_564451 = newJObject()
  var body_564452 = newJObject()
  add(query_564451, "api-version", newJString(apiVersion))
  add(path_564450, "subscriptionId", newJString(subscriptionId))
  add(path_564450, "appCollection", newJString(appCollection))
  add(path_564450, "resourceGroupName", newJString(resourceGroupName))
  add(path_564450, "appName", newJString(appName))
  if parameters != nil:
    body_564452 = parameters
  result = call_564449.call(path_564450, query_564451, nil, nil, body_564452)

var exportTasksCreateEventsTask* = Call_ExportTasksCreateEventsTask_564439(
    name: "exportTasksCreateEventsTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/events",
    validator: validate_ExportTasksCreateEventsTask_564440, base: "",
    url: url_ExportTasksCreateEventsTask_564441, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateFeedbackTaskByCampaign_564453 = ref object of OpenApiRestCall_563564
proc url_ExportTasksCreateFeedbackTaskByCampaign_564455(protocol: Scheme;
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

proc validate_ExportTasksCreateFeedbackTaskByCampaign_564454(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task to export push campaign data for a set of campaigns.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564456 = path.getOrDefault("subscriptionId")
  valid_564456 = validateParameter(valid_564456, JString, required = true,
                                 default = nil)
  if valid_564456 != nil:
    section.add "subscriptionId", valid_564456
  var valid_564457 = path.getOrDefault("appCollection")
  valid_564457 = validateParameter(valid_564457, JString, required = true,
                                 default = nil)
  if valid_564457 != nil:
    section.add "appCollection", valid_564457
  var valid_564458 = path.getOrDefault("resourceGroupName")
  valid_564458 = validateParameter(valid_564458, JString, required = true,
                                 default = nil)
  if valid_564458 != nil:
    section.add "resourceGroupName", valid_564458
  var valid_564459 = path.getOrDefault("appName")
  valid_564459 = validateParameter(valid_564459, JString, required = true,
                                 default = nil)
  if valid_564459 != nil:
    section.add "appName", valid_564459
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564460 = query.getOrDefault("api-version")
  valid_564460 = validateParameter(valid_564460, JString, required = true,
                                 default = nil)
  if valid_564460 != nil:
    section.add "api-version", valid_564460
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

proc call*(call_564462: Call_ExportTasksCreateFeedbackTaskByCampaign_564453;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a task to export push campaign data for a set of campaigns.
  ## 
  let valid = call_564462.validator(path, query, header, formData, body)
  let scheme = call_564462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564462.url(scheme.get, call_564462.host, call_564462.base,
                         call_564462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564462, url, valid)

proc call*(call_564463: Call_ExportTasksCreateFeedbackTaskByCampaign_564453;
          apiVersion: string; subscriptionId: string; appCollection: string;
          resourceGroupName: string; appName: string; parameters: JsonNode): Recallable =
  ## exportTasksCreateFeedbackTaskByCampaign
  ## Creates a task to export push campaign data for a set of campaigns.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   parameters: JObject (required)
  var path_564464 = newJObject()
  var query_564465 = newJObject()
  var body_564466 = newJObject()
  add(query_564465, "api-version", newJString(apiVersion))
  add(path_564464, "subscriptionId", newJString(subscriptionId))
  add(path_564464, "appCollection", newJString(appCollection))
  add(path_564464, "resourceGroupName", newJString(resourceGroupName))
  add(path_564464, "appName", newJString(appName))
  if parameters != nil:
    body_564466 = parameters
  result = call_564463.call(path_564464, query_564465, nil, nil, body_564466)

var exportTasksCreateFeedbackTaskByCampaign* = Call_ExportTasksCreateFeedbackTaskByCampaign_564453(
    name: "exportTasksCreateFeedbackTaskByCampaign", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/feedbackByCampaign",
    validator: validate_ExportTasksCreateFeedbackTaskByCampaign_564454, base: "",
    url: url_ExportTasksCreateFeedbackTaskByCampaign_564455,
    schemes: {Scheme.Https})
type
  Call_ExportTasksCreateFeedbackTaskByDateRange_564467 = ref object of OpenApiRestCall_563564
proc url_ExportTasksCreateFeedbackTaskByDateRange_564469(protocol: Scheme;
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

proc validate_ExportTasksCreateFeedbackTaskByDateRange_564468(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task to export push campaign data for a date range.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564470 = path.getOrDefault("subscriptionId")
  valid_564470 = validateParameter(valid_564470, JString, required = true,
                                 default = nil)
  if valid_564470 != nil:
    section.add "subscriptionId", valid_564470
  var valid_564471 = path.getOrDefault("appCollection")
  valid_564471 = validateParameter(valid_564471, JString, required = true,
                                 default = nil)
  if valid_564471 != nil:
    section.add "appCollection", valid_564471
  var valid_564472 = path.getOrDefault("resourceGroupName")
  valid_564472 = validateParameter(valid_564472, JString, required = true,
                                 default = nil)
  if valid_564472 != nil:
    section.add "resourceGroupName", valid_564472
  var valid_564473 = path.getOrDefault("appName")
  valid_564473 = validateParameter(valid_564473, JString, required = true,
                                 default = nil)
  if valid_564473 != nil:
    section.add "appName", valid_564473
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564474 = query.getOrDefault("api-version")
  valid_564474 = validateParameter(valid_564474, JString, required = true,
                                 default = nil)
  if valid_564474 != nil:
    section.add "api-version", valid_564474
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

proc call*(call_564476: Call_ExportTasksCreateFeedbackTaskByDateRange_564467;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a task to export push campaign data for a date range.
  ## 
  let valid = call_564476.validator(path, query, header, formData, body)
  let scheme = call_564476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564476.url(scheme.get, call_564476.host, call_564476.base,
                         call_564476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564476, url, valid)

proc call*(call_564477: Call_ExportTasksCreateFeedbackTaskByDateRange_564467;
          apiVersion: string; subscriptionId: string; appCollection: string;
          resourceGroupName: string; appName: string; parameters: JsonNode): Recallable =
  ## exportTasksCreateFeedbackTaskByDateRange
  ## Creates a task to export push campaign data for a date range.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   parameters: JObject (required)
  var path_564478 = newJObject()
  var query_564479 = newJObject()
  var body_564480 = newJObject()
  add(query_564479, "api-version", newJString(apiVersion))
  add(path_564478, "subscriptionId", newJString(subscriptionId))
  add(path_564478, "appCollection", newJString(appCollection))
  add(path_564478, "resourceGroupName", newJString(resourceGroupName))
  add(path_564478, "appName", newJString(appName))
  if parameters != nil:
    body_564480 = parameters
  result = call_564477.call(path_564478, query_564479, nil, nil, body_564480)

var exportTasksCreateFeedbackTaskByDateRange* = Call_ExportTasksCreateFeedbackTaskByDateRange_564467(
    name: "exportTasksCreateFeedbackTaskByDateRange", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/feedbackByDate",
    validator: validate_ExportTasksCreateFeedbackTaskByDateRange_564468, base: "",
    url: url_ExportTasksCreateFeedbackTaskByDateRange_564469,
    schemes: {Scheme.Https})
type
  Call_ExportTasksCreateJobsTask_564481 = ref object of OpenApiRestCall_563564
proc url_ExportTasksCreateJobsTask_564483(protocol: Scheme; host: string;
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

proc validate_ExportTasksCreateJobsTask_564482(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task to export jobs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564484 = path.getOrDefault("subscriptionId")
  valid_564484 = validateParameter(valid_564484, JString, required = true,
                                 default = nil)
  if valid_564484 != nil:
    section.add "subscriptionId", valid_564484
  var valid_564485 = path.getOrDefault("appCollection")
  valid_564485 = validateParameter(valid_564485, JString, required = true,
                                 default = nil)
  if valid_564485 != nil:
    section.add "appCollection", valid_564485
  var valid_564486 = path.getOrDefault("resourceGroupName")
  valid_564486 = validateParameter(valid_564486, JString, required = true,
                                 default = nil)
  if valid_564486 != nil:
    section.add "resourceGroupName", valid_564486
  var valid_564487 = path.getOrDefault("appName")
  valid_564487 = validateParameter(valid_564487, JString, required = true,
                                 default = nil)
  if valid_564487 != nil:
    section.add "appName", valid_564487
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564488 = query.getOrDefault("api-version")
  valid_564488 = validateParameter(valid_564488, JString, required = true,
                                 default = nil)
  if valid_564488 != nil:
    section.add "api-version", valid_564488
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

proc call*(call_564490: Call_ExportTasksCreateJobsTask_564481; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export jobs.
  ## 
  let valid = call_564490.validator(path, query, header, formData, body)
  let scheme = call_564490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564490.url(scheme.get, call_564490.host, call_564490.base,
                         call_564490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564490, url, valid)

proc call*(call_564491: Call_ExportTasksCreateJobsTask_564481; apiVersion: string;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string; parameters: JsonNode): Recallable =
  ## exportTasksCreateJobsTask
  ## Creates a task to export jobs.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   parameters: JObject (required)
  var path_564492 = newJObject()
  var query_564493 = newJObject()
  var body_564494 = newJObject()
  add(query_564493, "api-version", newJString(apiVersion))
  add(path_564492, "subscriptionId", newJString(subscriptionId))
  add(path_564492, "appCollection", newJString(appCollection))
  add(path_564492, "resourceGroupName", newJString(resourceGroupName))
  add(path_564492, "appName", newJString(appName))
  if parameters != nil:
    body_564494 = parameters
  result = call_564491.call(path_564492, query_564493, nil, nil, body_564494)

var exportTasksCreateJobsTask* = Call_ExportTasksCreateJobsTask_564481(
    name: "exportTasksCreateJobsTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/jobs",
    validator: validate_ExportTasksCreateJobsTask_564482, base: "",
    url: url_ExportTasksCreateJobsTask_564483, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateSessionsTask_564495 = ref object of OpenApiRestCall_563564
proc url_ExportTasksCreateSessionsTask_564497(protocol: Scheme; host: string;
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

proc validate_ExportTasksCreateSessionsTask_564496(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task to export sessions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564498 = path.getOrDefault("subscriptionId")
  valid_564498 = validateParameter(valid_564498, JString, required = true,
                                 default = nil)
  if valid_564498 != nil:
    section.add "subscriptionId", valid_564498
  var valid_564499 = path.getOrDefault("appCollection")
  valid_564499 = validateParameter(valid_564499, JString, required = true,
                                 default = nil)
  if valid_564499 != nil:
    section.add "appCollection", valid_564499
  var valid_564500 = path.getOrDefault("resourceGroupName")
  valid_564500 = validateParameter(valid_564500, JString, required = true,
                                 default = nil)
  if valid_564500 != nil:
    section.add "resourceGroupName", valid_564500
  var valid_564501 = path.getOrDefault("appName")
  valid_564501 = validateParameter(valid_564501, JString, required = true,
                                 default = nil)
  if valid_564501 != nil:
    section.add "appName", valid_564501
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564502 = query.getOrDefault("api-version")
  valid_564502 = validateParameter(valid_564502, JString, required = true,
                                 default = nil)
  if valid_564502 != nil:
    section.add "api-version", valid_564502
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

proc call*(call_564504: Call_ExportTasksCreateSessionsTask_564495; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export sessions.
  ## 
  let valid = call_564504.validator(path, query, header, formData, body)
  let scheme = call_564504.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564504.url(scheme.get, call_564504.host, call_564504.base,
                         call_564504.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564504, url, valid)

proc call*(call_564505: Call_ExportTasksCreateSessionsTask_564495;
          apiVersion: string; subscriptionId: string; appCollection: string;
          resourceGroupName: string; appName: string; parameters: JsonNode): Recallable =
  ## exportTasksCreateSessionsTask
  ## Creates a task to export sessions.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   parameters: JObject (required)
  var path_564506 = newJObject()
  var query_564507 = newJObject()
  var body_564508 = newJObject()
  add(query_564507, "api-version", newJString(apiVersion))
  add(path_564506, "subscriptionId", newJString(subscriptionId))
  add(path_564506, "appCollection", newJString(appCollection))
  add(path_564506, "resourceGroupName", newJString(resourceGroupName))
  add(path_564506, "appName", newJString(appName))
  if parameters != nil:
    body_564508 = parameters
  result = call_564505.call(path_564506, query_564507, nil, nil, body_564508)

var exportTasksCreateSessionsTask* = Call_ExportTasksCreateSessionsTask_564495(
    name: "exportTasksCreateSessionsTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/sessions",
    validator: validate_ExportTasksCreateSessionsTask_564496, base: "",
    url: url_ExportTasksCreateSessionsTask_564497, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateTagsTask_564509 = ref object of OpenApiRestCall_563564
proc url_ExportTasksCreateTagsTask_564511(protocol: Scheme; host: string;
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

proc validate_ExportTasksCreateTagsTask_564510(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task to export tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564512 = path.getOrDefault("subscriptionId")
  valid_564512 = validateParameter(valid_564512, JString, required = true,
                                 default = nil)
  if valid_564512 != nil:
    section.add "subscriptionId", valid_564512
  var valid_564513 = path.getOrDefault("appCollection")
  valid_564513 = validateParameter(valid_564513, JString, required = true,
                                 default = nil)
  if valid_564513 != nil:
    section.add "appCollection", valid_564513
  var valid_564514 = path.getOrDefault("resourceGroupName")
  valid_564514 = validateParameter(valid_564514, JString, required = true,
                                 default = nil)
  if valid_564514 != nil:
    section.add "resourceGroupName", valid_564514
  var valid_564515 = path.getOrDefault("appName")
  valid_564515 = validateParameter(valid_564515, JString, required = true,
                                 default = nil)
  if valid_564515 != nil:
    section.add "appName", valid_564515
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564516 = query.getOrDefault("api-version")
  valid_564516 = validateParameter(valid_564516, JString, required = true,
                                 default = nil)
  if valid_564516 != nil:
    section.add "api-version", valid_564516
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

proc call*(call_564518: Call_ExportTasksCreateTagsTask_564509; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export tags.
  ## 
  let valid = call_564518.validator(path, query, header, formData, body)
  let scheme = call_564518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564518.url(scheme.get, call_564518.host, call_564518.base,
                         call_564518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564518, url, valid)

proc call*(call_564519: Call_ExportTasksCreateTagsTask_564509; apiVersion: string;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string; parameters: JsonNode): Recallable =
  ## exportTasksCreateTagsTask
  ## Creates a task to export tags.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   parameters: JObject (required)
  var path_564520 = newJObject()
  var query_564521 = newJObject()
  var body_564522 = newJObject()
  add(query_564521, "api-version", newJString(apiVersion))
  add(path_564520, "subscriptionId", newJString(subscriptionId))
  add(path_564520, "appCollection", newJString(appCollection))
  add(path_564520, "resourceGroupName", newJString(resourceGroupName))
  add(path_564520, "appName", newJString(appName))
  if parameters != nil:
    body_564522 = parameters
  result = call_564519.call(path_564520, query_564521, nil, nil, body_564522)

var exportTasksCreateTagsTask* = Call_ExportTasksCreateTagsTask_564509(
    name: "exportTasksCreateTagsTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/tags",
    validator: validate_ExportTasksCreateTagsTask_564510, base: "",
    url: url_ExportTasksCreateTagsTask_564511, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateTokensTask_564523 = ref object of OpenApiRestCall_563564
proc url_ExportTasksCreateTokensTask_564525(protocol: Scheme; host: string;
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

proc validate_ExportTasksCreateTokensTask_564524(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a task to export tags.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564526 = path.getOrDefault("subscriptionId")
  valid_564526 = validateParameter(valid_564526, JString, required = true,
                                 default = nil)
  if valid_564526 != nil:
    section.add "subscriptionId", valid_564526
  var valid_564527 = path.getOrDefault("appCollection")
  valid_564527 = validateParameter(valid_564527, JString, required = true,
                                 default = nil)
  if valid_564527 != nil:
    section.add "appCollection", valid_564527
  var valid_564528 = path.getOrDefault("resourceGroupName")
  valid_564528 = validateParameter(valid_564528, JString, required = true,
                                 default = nil)
  if valid_564528 != nil:
    section.add "resourceGroupName", valid_564528
  var valid_564529 = path.getOrDefault("appName")
  valid_564529 = validateParameter(valid_564529, JString, required = true,
                                 default = nil)
  if valid_564529 != nil:
    section.add "appName", valid_564529
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564530 = query.getOrDefault("api-version")
  valid_564530 = validateParameter(valid_564530, JString, required = true,
                                 default = nil)
  if valid_564530 != nil:
    section.add "api-version", valid_564530
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

proc call*(call_564532: Call_ExportTasksCreateTokensTask_564523; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export tags.
  ## 
  let valid = call_564532.validator(path, query, header, formData, body)
  let scheme = call_564532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564532.url(scheme.get, call_564532.host, call_564532.base,
                         call_564532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564532, url, valid)

proc call*(call_564533: Call_ExportTasksCreateTokensTask_564523;
          apiVersion: string; subscriptionId: string; appCollection: string;
          resourceGroupName: string; appName: string; parameters: JsonNode): Recallable =
  ## exportTasksCreateTokensTask
  ## Creates a task to export tags.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   parameters: JObject (required)
  var path_564534 = newJObject()
  var query_564535 = newJObject()
  var body_564536 = newJObject()
  add(query_564535, "api-version", newJString(apiVersion))
  add(path_564534, "subscriptionId", newJString(subscriptionId))
  add(path_564534, "appCollection", newJString(appCollection))
  add(path_564534, "resourceGroupName", newJString(resourceGroupName))
  add(path_564534, "appName", newJString(appName))
  if parameters != nil:
    body_564536 = parameters
  result = call_564533.call(path_564534, query_564535, nil, nil, body_564536)

var exportTasksCreateTokensTask* = Call_ExportTasksCreateTokensTask_564523(
    name: "exportTasksCreateTokensTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/tokens",
    validator: validate_ExportTasksCreateTokensTask_564524, base: "",
    url: url_ExportTasksCreateTokensTask_564525, schemes: {Scheme.Https})
type
  Call_ExportTasksGet_564537 = ref object of OpenApiRestCall_563564
proc url_ExportTasksGet_564539(protocol: Scheme; host: string; base: string;
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

proc validate_ExportTasksGet_564538(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Retrieves information about a previously created export task.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Export task identifier.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_564540 = path.getOrDefault("id")
  valid_564540 = validateParameter(valid_564540, JString, required = true,
                                 default = nil)
  if valid_564540 != nil:
    section.add "id", valid_564540
  var valid_564541 = path.getOrDefault("subscriptionId")
  valid_564541 = validateParameter(valid_564541, JString, required = true,
                                 default = nil)
  if valid_564541 != nil:
    section.add "subscriptionId", valid_564541
  var valid_564542 = path.getOrDefault("appCollection")
  valid_564542 = validateParameter(valid_564542, JString, required = true,
                                 default = nil)
  if valid_564542 != nil:
    section.add "appCollection", valid_564542
  var valid_564543 = path.getOrDefault("resourceGroupName")
  valid_564543 = validateParameter(valid_564543, JString, required = true,
                                 default = nil)
  if valid_564543 != nil:
    section.add "resourceGroupName", valid_564543
  var valid_564544 = path.getOrDefault("appName")
  valid_564544 = validateParameter(valid_564544, JString, required = true,
                                 default = nil)
  if valid_564544 != nil:
    section.add "appName", valid_564544
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564545 = query.getOrDefault("api-version")
  valid_564545 = validateParameter(valid_564545, JString, required = true,
                                 default = nil)
  if valid_564545 != nil:
    section.add "api-version", valid_564545
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564546: Call_ExportTasksGet_564537; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a previously created export task.
  ## 
  let valid = call_564546.validator(path, query, header, formData, body)
  let scheme = call_564546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564546.url(scheme.get, call_564546.host, call_564546.base,
                         call_564546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564546, url, valid)

proc call*(call_564547: Call_ExportTasksGet_564537; apiVersion: string; id: string;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string): Recallable =
  ## exportTasksGet
  ## Retrieves information about a previously created export task.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   id: string (required)
  ##     : Export task identifier.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  var path_564548 = newJObject()
  var query_564549 = newJObject()
  add(query_564549, "api-version", newJString(apiVersion))
  add(path_564548, "id", newJString(id))
  add(path_564548, "subscriptionId", newJString(subscriptionId))
  add(path_564548, "appCollection", newJString(appCollection))
  add(path_564548, "resourceGroupName", newJString(resourceGroupName))
  add(path_564548, "appName", newJString(appName))
  result = call_564547.call(path_564548, query_564549, nil, nil, nil)

var exportTasksGet* = Call_ExportTasksGet_564537(name: "exportTasksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/{id}",
    validator: validate_ExportTasksGet_564538, base: "", url: url_ExportTasksGet_564539,
    schemes: {Scheme.Https})
type
  Call_ImportTasksCreate_564565 = ref object of OpenApiRestCall_563564
proc url_ImportTasksCreate_564567(protocol: Scheme; host: string; base: string;
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

proc validate_ImportTasksCreate_564566(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Creates a job to import the specified data to a storageUrl.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564568 = path.getOrDefault("subscriptionId")
  valid_564568 = validateParameter(valid_564568, JString, required = true,
                                 default = nil)
  if valid_564568 != nil:
    section.add "subscriptionId", valid_564568
  var valid_564569 = path.getOrDefault("appCollection")
  valid_564569 = validateParameter(valid_564569, JString, required = true,
                                 default = nil)
  if valid_564569 != nil:
    section.add "appCollection", valid_564569
  var valid_564570 = path.getOrDefault("resourceGroupName")
  valid_564570 = validateParameter(valid_564570, JString, required = true,
                                 default = nil)
  if valid_564570 != nil:
    section.add "resourceGroupName", valid_564570
  var valid_564571 = path.getOrDefault("appName")
  valid_564571 = validateParameter(valid_564571, JString, required = true,
                                 default = nil)
  if valid_564571 != nil:
    section.add "appName", valid_564571
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564572 = query.getOrDefault("api-version")
  valid_564572 = validateParameter(valid_564572, JString, required = true,
                                 default = nil)
  if valid_564572 != nil:
    section.add "api-version", valid_564572
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

proc call*(call_564574: Call_ImportTasksCreate_564565; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a job to import the specified data to a storageUrl.
  ## 
  let valid = call_564574.validator(path, query, header, formData, body)
  let scheme = call_564574.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564574.url(scheme.get, call_564574.host, call_564574.base,
                         call_564574.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564574, url, valid)

proc call*(call_564575: Call_ImportTasksCreate_564565; apiVersion: string;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string; parameters: JsonNode): Recallable =
  ## importTasksCreate
  ## Creates a job to import the specified data to a storageUrl.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   parameters: JObject (required)
  var path_564576 = newJObject()
  var query_564577 = newJObject()
  var body_564578 = newJObject()
  add(query_564577, "api-version", newJString(apiVersion))
  add(path_564576, "subscriptionId", newJString(subscriptionId))
  add(path_564576, "appCollection", newJString(appCollection))
  add(path_564576, "resourceGroupName", newJString(resourceGroupName))
  add(path_564576, "appName", newJString(appName))
  if parameters != nil:
    body_564578 = parameters
  result = call_564575.call(path_564576, query_564577, nil, nil, body_564578)

var importTasksCreate* = Call_ImportTasksCreate_564565(name: "importTasksCreate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/importTasks",
    validator: validate_ImportTasksCreate_564566, base: "",
    url: url_ImportTasksCreate_564567, schemes: {Scheme.Https})
type
  Call_ImportTasksList_564550 = ref object of OpenApiRestCall_563564
proc url_ImportTasksList_564552(protocol: Scheme; host: string; base: string;
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

proc validate_ImportTasksList_564551(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Get the list of import jobs.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564553 = path.getOrDefault("subscriptionId")
  valid_564553 = validateParameter(valid_564553, JString, required = true,
                                 default = nil)
  if valid_564553 != nil:
    section.add "subscriptionId", valid_564553
  var valid_564554 = path.getOrDefault("appCollection")
  valid_564554 = validateParameter(valid_564554, JString, required = true,
                                 default = nil)
  if valid_564554 != nil:
    section.add "appCollection", valid_564554
  var valid_564555 = path.getOrDefault("resourceGroupName")
  valid_564555 = validateParameter(valid_564555, JString, required = true,
                                 default = nil)
  if valid_564555 != nil:
    section.add "resourceGroupName", valid_564555
  var valid_564556 = path.getOrDefault("appName")
  valid_564556 = validateParameter(valid_564556, JString, required = true,
                                 default = nil)
  if valid_564556 != nil:
    section.add "appName", valid_564556
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $top: JInt
  ##       : Control paging of import jobs, number of import jobs to return with each call. By default, it returns all import jobs with a default paging of 20.
  ## The response contains a `nextLink` property describing the path to get the next page if there are more results.
  ## The maximum paging limit for $top is 40.
  ##   $orderby: JString
  ##           : Sort results by an expression which looks like `$orderby=jobId asc` (default when not specified).
  ## The syntax is orderby={property} {direction} or just orderby={property}.
  ## Properties that can be specified for sorting: jobId, errorDetails, dateCreated, jobStatus, and dateCreated.
  ## The available directions are asc (for ascending order) and desc (for descending order).
  ## When not specified the asc direction is used.
  ## Only one orderby property can be specified.
  ##   $skip: JInt
  ##        : Control paging of import jobs, start results at the given offset, defaults to 0 (1st page of data).
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564557 = query.getOrDefault("api-version")
  valid_564557 = validateParameter(valid_564557, JString, required = true,
                                 default = nil)
  if valid_564557 != nil:
    section.add "api-version", valid_564557
  var valid_564558 = query.getOrDefault("$top")
  valid_564558 = validateParameter(valid_564558, JInt, required = false,
                                 default = newJInt(20))
  if valid_564558 != nil:
    section.add "$top", valid_564558
  var valid_564559 = query.getOrDefault("$orderby")
  valid_564559 = validateParameter(valid_564559, JString, required = false,
                                 default = nil)
  if valid_564559 != nil:
    section.add "$orderby", valid_564559
  var valid_564560 = query.getOrDefault("$skip")
  valid_564560 = validateParameter(valid_564560, JInt, required = false,
                                 default = newJInt(0))
  if valid_564560 != nil:
    section.add "$skip", valid_564560
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564561: Call_ImportTasksList_564550; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of import jobs.
  ## 
  let valid = call_564561.validator(path, query, header, formData, body)
  let scheme = call_564561.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564561.url(scheme.get, call_564561.host, call_564561.base,
                         call_564561.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564561, url, valid)

proc call*(call_564562: Call_ImportTasksList_564550; apiVersion: string;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string; Top: int = 20; Orderby: string = ""; Skip: int = 0): Recallable =
  ## importTasksList
  ## Get the list of import jobs.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   Top: int
  ##      : Control paging of import jobs, number of import jobs to return with each call. By default, it returns all import jobs with a default paging of 20.
  ## The response contains a `nextLink` property describing the path to get the next page if there are more results.
  ## The maximum paging limit for $top is 40.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   Orderby: string
  ##          : Sort results by an expression which looks like `$orderby=jobId asc` (default when not specified).
  ## The syntax is orderby={property} {direction} or just orderby={property}.
  ## Properties that can be specified for sorting: jobId, errorDetails, dateCreated, jobStatus, and dateCreated.
  ## The available directions are asc (for ascending order) and desc (for descending order).
  ## When not specified the asc direction is used.
  ## Only one orderby property can be specified.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   Skip: int
  ##       : Control paging of import jobs, start results at the given offset, defaults to 0 (1st page of data).
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  var path_564563 = newJObject()
  var query_564564 = newJObject()
  add(query_564564, "api-version", newJString(apiVersion))
  add(query_564564, "$top", newJInt(Top))
  add(path_564563, "subscriptionId", newJString(subscriptionId))
  add(query_564564, "$orderby", newJString(Orderby))
  add(path_564563, "appCollection", newJString(appCollection))
  add(query_564564, "$skip", newJInt(Skip))
  add(path_564563, "resourceGroupName", newJString(resourceGroupName))
  add(path_564563, "appName", newJString(appName))
  result = call_564562.call(path_564563, query_564564, nil, nil, nil)

var importTasksList* = Call_ImportTasksList_564550(name: "importTasksList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/importTasks",
    validator: validate_ImportTasksList_564551, base: "", url: url_ImportTasksList_564552,
    schemes: {Scheme.Https})
type
  Call_ImportTasksGet_564579 = ref object of OpenApiRestCall_563564
proc url_ImportTasksGet_564581(protocol: Scheme; host: string; base: string;
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

proc validate_ImportTasksGet_564580(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## The Get import job operation retrieves information about a previously created import job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   id: JString (required)
  ##     : Import job identifier.
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `id` field"
  var valid_564582 = path.getOrDefault("id")
  valid_564582 = validateParameter(valid_564582, JString, required = true,
                                 default = nil)
  if valid_564582 != nil:
    section.add "id", valid_564582
  var valid_564583 = path.getOrDefault("subscriptionId")
  valid_564583 = validateParameter(valid_564583, JString, required = true,
                                 default = nil)
  if valid_564583 != nil:
    section.add "subscriptionId", valid_564583
  var valid_564584 = path.getOrDefault("appCollection")
  valid_564584 = validateParameter(valid_564584, JString, required = true,
                                 default = nil)
  if valid_564584 != nil:
    section.add "appCollection", valid_564584
  var valid_564585 = path.getOrDefault("resourceGroupName")
  valid_564585 = validateParameter(valid_564585, JString, required = true,
                                 default = nil)
  if valid_564585 != nil:
    section.add "resourceGroupName", valid_564585
  var valid_564586 = path.getOrDefault("appName")
  valid_564586 = validateParameter(valid_564586, JString, required = true,
                                 default = nil)
  if valid_564586 != nil:
    section.add "appName", valid_564586
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564587 = query.getOrDefault("api-version")
  valid_564587 = validateParameter(valid_564587, JString, required = true,
                                 default = nil)
  if valid_564587 != nil:
    section.add "api-version", valid_564587
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564588: Call_ImportTasksGet_564579; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get import job operation retrieves information about a previously created import job.
  ## 
  let valid = call_564588.validator(path, query, header, formData, body)
  let scheme = call_564588.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564588.url(scheme.get, call_564588.host, call_564588.base,
                         call_564588.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564588, url, valid)

proc call*(call_564589: Call_ImportTasksGet_564579; apiVersion: string; id: string;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string): Recallable =
  ## importTasksGet
  ## The Get import job operation retrieves information about a previously created import job.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   id: string (required)
  ##     : Import job identifier.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  var path_564590 = newJObject()
  var query_564591 = newJObject()
  add(query_564591, "api-version", newJString(apiVersion))
  add(path_564590, "id", newJString(id))
  add(path_564590, "subscriptionId", newJString(subscriptionId))
  add(path_564590, "appCollection", newJString(appCollection))
  add(path_564590, "resourceGroupName", newJString(resourceGroupName))
  add(path_564590, "appName", newJString(appName))
  result = call_564589.call(path_564590, query_564591, nil, nil, nil)

var importTasksGet* = Call_ImportTasksGet_564579(name: "importTasksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/importTasks/{id}",
    validator: validate_ImportTasksGet_564580, base: "", url: url_ImportTasksGet_564581,
    schemes: {Scheme.Https})
type
  Call_DevicesTagByDeviceId_564592 = ref object of OpenApiRestCall_563564
proc url_DevicesTagByDeviceId_564594(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesTagByDeviceId_564593(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update the tags registered for a set of devices running an application. Updates are performed asynchronously, meaning that a few seconds are needed before the modifications appear in the results of the Get device command.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564595 = path.getOrDefault("subscriptionId")
  valid_564595 = validateParameter(valid_564595, JString, required = true,
                                 default = nil)
  if valid_564595 != nil:
    section.add "subscriptionId", valid_564595
  var valid_564596 = path.getOrDefault("appCollection")
  valid_564596 = validateParameter(valid_564596, JString, required = true,
                                 default = nil)
  if valid_564596 != nil:
    section.add "appCollection", valid_564596
  var valid_564597 = path.getOrDefault("resourceGroupName")
  valid_564597 = validateParameter(valid_564597, JString, required = true,
                                 default = nil)
  if valid_564597 != nil:
    section.add "resourceGroupName", valid_564597
  var valid_564598 = path.getOrDefault("appName")
  valid_564598 = validateParameter(valid_564598, JString, required = true,
                                 default = nil)
  if valid_564598 != nil:
    section.add "appName", valid_564598
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564599 = query.getOrDefault("api-version")
  valid_564599 = validateParameter(valid_564599, JString, required = true,
                                 default = nil)
  if valid_564599 != nil:
    section.add "api-version", valid_564599
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

proc call*(call_564601: Call_DevicesTagByDeviceId_564592; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the tags registered for a set of devices running an application. Updates are performed asynchronously, meaning that a few seconds are needed before the modifications appear in the results of the Get device command.
  ## 
  ## 
  let valid = call_564601.validator(path, query, header, formData, body)
  let scheme = call_564601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564601.url(scheme.get, call_564601.host, call_564601.base,
                         call_564601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564601, url, valid)

proc call*(call_564602: Call_DevicesTagByDeviceId_564592; apiVersion: string;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string; parameters: JsonNode): Recallable =
  ## devicesTagByDeviceId
  ## Update the tags registered for a set of devices running an application. Updates are performed asynchronously, meaning that a few seconds are needed before the modifications appear in the results of the Get device command.
  ## 
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   parameters: JObject (required)
  var path_564603 = newJObject()
  var query_564604 = newJObject()
  var body_564605 = newJObject()
  add(query_564604, "api-version", newJString(apiVersion))
  add(path_564603, "subscriptionId", newJString(subscriptionId))
  add(path_564603, "appCollection", newJString(appCollection))
  add(path_564603, "resourceGroupName", newJString(resourceGroupName))
  add(path_564603, "appName", newJString(appName))
  if parameters != nil:
    body_564605 = parameters
  result = call_564602.call(path_564603, query_564604, nil, nil, body_564605)

var devicesTagByDeviceId* = Call_DevicesTagByDeviceId_564592(
    name: "devicesTagByDeviceId", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/tag",
    validator: validate_DevicesTagByDeviceId_564593, base: "",
    url: url_DevicesTagByDeviceId_564594, schemes: {Scheme.Https})
type
  Call_DevicesGetByDeviceId_564606 = ref object of OpenApiRestCall_563564
proc url_DevicesGetByDeviceId_564608(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesGetByDeviceId_564607(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the information associated to a device running an application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  ##   deviceId: JString (required)
  ##           : Device identifier.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564609 = path.getOrDefault("subscriptionId")
  valid_564609 = validateParameter(valid_564609, JString, required = true,
                                 default = nil)
  if valid_564609 != nil:
    section.add "subscriptionId", valid_564609
  var valid_564610 = path.getOrDefault("appCollection")
  valid_564610 = validateParameter(valid_564610, JString, required = true,
                                 default = nil)
  if valid_564610 != nil:
    section.add "appCollection", valid_564610
  var valid_564611 = path.getOrDefault("resourceGroupName")
  valid_564611 = validateParameter(valid_564611, JString, required = true,
                                 default = nil)
  if valid_564611 != nil:
    section.add "resourceGroupName", valid_564611
  var valid_564612 = path.getOrDefault("appName")
  valid_564612 = validateParameter(valid_564612, JString, required = true,
                                 default = nil)
  if valid_564612 != nil:
    section.add "appName", valid_564612
  var valid_564613 = path.getOrDefault("deviceId")
  valid_564613 = validateParameter(valid_564613, JString, required = true,
                                 default = nil)
  if valid_564613 != nil:
    section.add "deviceId", valid_564613
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564614 = query.getOrDefault("api-version")
  valid_564614 = validateParameter(valid_564614, JString, required = true,
                                 default = nil)
  if valid_564614 != nil:
    section.add "api-version", valid_564614
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564615: Call_DevicesGetByDeviceId_564606; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the information associated to a device running an application.
  ## 
  let valid = call_564615.validator(path, query, header, formData, body)
  let scheme = call_564615.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564615.url(scheme.get, call_564615.host, call_564615.base,
                         call_564615.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564615, url, valid)

proc call*(call_564616: Call_DevicesGetByDeviceId_564606; apiVersion: string;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string; deviceId: string): Recallable =
  ## devicesGetByDeviceId
  ## Get the information associated to a device running an application.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   deviceId: string (required)
  ##           : Device identifier.
  var path_564617 = newJObject()
  var query_564618 = newJObject()
  add(query_564618, "api-version", newJString(apiVersion))
  add(path_564617, "subscriptionId", newJString(subscriptionId))
  add(path_564617, "appCollection", newJString(appCollection))
  add(path_564617, "resourceGroupName", newJString(resourceGroupName))
  add(path_564617, "appName", newJString(appName))
  add(path_564617, "deviceId", newJString(deviceId))
  result = call_564616.call(path_564617, query_564618, nil, nil, nil)

var devicesGetByDeviceId* = Call_DevicesGetByDeviceId_564606(
    name: "devicesGetByDeviceId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/{deviceId}",
    validator: validate_DevicesGetByDeviceId_564607, base: "",
    url: url_DevicesGetByDeviceId_564608, schemes: {Scheme.Https})
type
  Call_DevicesTagByUserId_564619 = ref object of OpenApiRestCall_563564
proc url_DevicesTagByUserId_564621(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesTagByUserId_564620(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Update the tags registered for a set of users running an application. Updates are performed asynchronously, meaning that a few seconds are needed before the modifications appear in the results of the Get device command.
  ## 
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564622 = path.getOrDefault("subscriptionId")
  valid_564622 = validateParameter(valid_564622, JString, required = true,
                                 default = nil)
  if valid_564622 != nil:
    section.add "subscriptionId", valid_564622
  var valid_564623 = path.getOrDefault("appCollection")
  valid_564623 = validateParameter(valid_564623, JString, required = true,
                                 default = nil)
  if valid_564623 != nil:
    section.add "appCollection", valid_564623
  var valid_564624 = path.getOrDefault("resourceGroupName")
  valid_564624 = validateParameter(valid_564624, JString, required = true,
                                 default = nil)
  if valid_564624 != nil:
    section.add "resourceGroupName", valid_564624
  var valid_564625 = path.getOrDefault("appName")
  valid_564625 = validateParameter(valid_564625, JString, required = true,
                                 default = nil)
  if valid_564625 != nil:
    section.add "appName", valid_564625
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564626 = query.getOrDefault("api-version")
  valid_564626 = validateParameter(valid_564626, JString, required = true,
                                 default = nil)
  if valid_564626 != nil:
    section.add "api-version", valid_564626
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

proc call*(call_564628: Call_DevicesTagByUserId_564619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the tags registered for a set of users running an application. Updates are performed asynchronously, meaning that a few seconds are needed before the modifications appear in the results of the Get device command.
  ## 
  ## 
  let valid = call_564628.validator(path, query, header, formData, body)
  let scheme = call_564628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564628.url(scheme.get, call_564628.host, call_564628.base,
                         call_564628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564628, url, valid)

proc call*(call_564629: Call_DevicesTagByUserId_564619; apiVersion: string;
          subscriptionId: string; appCollection: string; resourceGroupName: string;
          appName: string; parameters: JsonNode): Recallable =
  ## devicesTagByUserId
  ## Update the tags registered for a set of users running an application. Updates are performed asynchronously, meaning that a few seconds are needed before the modifications appear in the results of the Get device command.
  ## 
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  ##   parameters: JObject (required)
  var path_564630 = newJObject()
  var query_564631 = newJObject()
  var body_564632 = newJObject()
  add(query_564631, "api-version", newJString(apiVersion))
  add(path_564630, "subscriptionId", newJString(subscriptionId))
  add(path_564630, "appCollection", newJString(appCollection))
  add(path_564630, "resourceGroupName", newJString(resourceGroupName))
  add(path_564630, "appName", newJString(appName))
  if parameters != nil:
    body_564632 = parameters
  result = call_564629.call(path_564630, query_564631, nil, nil, body_564632)

var devicesTagByUserId* = Call_DevicesTagByUserId_564619(
    name: "devicesTagByUserId", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/users/tag",
    validator: validate_DevicesTagByUserId_564620, base: "",
    url: url_DevicesTagByUserId_564621, schemes: {Scheme.Https})
type
  Call_DevicesGetByUserId_564633 = ref object of OpenApiRestCall_563564
proc url_DevicesGetByUserId_564635(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesGetByUserId_564634(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get the information associated to a device running an application using the user identifier.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   userId: JString (required)
  ##         : User identifier.
  ##   appCollection: JString (required)
  ##                : Application collection.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   appName: JString (required)
  ##          : Application resource name.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564636 = path.getOrDefault("subscriptionId")
  valid_564636 = validateParameter(valid_564636, JString, required = true,
                                 default = nil)
  if valid_564636 != nil:
    section.add "subscriptionId", valid_564636
  var valid_564637 = path.getOrDefault("userId")
  valid_564637 = validateParameter(valid_564637, JString, required = true,
                                 default = nil)
  if valid_564637 != nil:
    section.add "userId", valid_564637
  var valid_564638 = path.getOrDefault("appCollection")
  valid_564638 = validateParameter(valid_564638, JString, required = true,
                                 default = nil)
  if valid_564638 != nil:
    section.add "appCollection", valid_564638
  var valid_564639 = path.getOrDefault("resourceGroupName")
  valid_564639 = validateParameter(valid_564639, JString, required = true,
                                 default = nil)
  if valid_564639 != nil:
    section.add "resourceGroupName", valid_564639
  var valid_564640 = path.getOrDefault("appName")
  valid_564640 = validateParameter(valid_564640, JString, required = true,
                                 default = nil)
  if valid_564640 != nil:
    section.add "appName", valid_564640
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564641 = query.getOrDefault("api-version")
  valid_564641 = validateParameter(valid_564641, JString, required = true,
                                 default = nil)
  if valid_564641 != nil:
    section.add "api-version", valid_564641
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564642: Call_DevicesGetByUserId_564633; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the information associated to a device running an application using the user identifier.
  ## 
  let valid = call_564642.validator(path, query, header, formData, body)
  let scheme = call_564642.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564642.url(scheme.get, call_564642.host, call_564642.base,
                         call_564642.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564642, url, valid)

proc call*(call_564643: Call_DevicesGetByUserId_564633; apiVersion: string;
          subscriptionId: string; userId: string; appCollection: string;
          resourceGroupName: string; appName: string): Recallable =
  ## devicesGetByUserId
  ## Get the information associated to a device running an application using the user identifier.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   userId: string (required)
  ##         : User identifier.
  ##   appCollection: string (required)
  ##                : Application collection.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   appName: string (required)
  ##          : Application resource name.
  var path_564644 = newJObject()
  var query_564645 = newJObject()
  add(query_564645, "api-version", newJString(apiVersion))
  add(path_564644, "subscriptionId", newJString(subscriptionId))
  add(path_564644, "userId", newJString(userId))
  add(path_564644, "appCollection", newJString(appCollection))
  add(path_564644, "resourceGroupName", newJString(resourceGroupName))
  add(path_564644, "appName", newJString(appName))
  result = call_564643.call(path_564644, query_564645, nil, nil, nil)

var devicesGetByUserId* = Call_DevicesGetByUserId_564633(
    name: "devicesGetByUserId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/users/{userId}",
    validator: validate_DevicesGetByUserId_564634, base: "",
    url: url_DevicesGetByUserId_564635, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
