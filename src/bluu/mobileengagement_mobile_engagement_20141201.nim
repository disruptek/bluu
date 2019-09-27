
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  macServiceName = "mobileengagement-mobile-engagement"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AppCollectionsList_593659 = ref object of OpenApiRestCall_593437
proc url_AppCollectionsList_593661(protocol: Scheme; host: string; base: string;
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

proc validate_AppCollectionsList_593660(path: JsonNode; query: JsonNode;
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
  var valid_593834 = path.getOrDefault("subscriptionId")
  valid_593834 = validateParameter(valid_593834, JString, required = true,
                                 default = nil)
  if valid_593834 != nil:
    section.add "subscriptionId", valid_593834
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593835 = query.getOrDefault("api-version")
  valid_593835 = validateParameter(valid_593835, JString, required = true,
                                 default = nil)
  if valid_593835 != nil:
    section.add "api-version", valid_593835
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593858: Call_AppCollectionsList_593659; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists app collections in a subscription.
  ## 
  let valid = call_593858.validator(path, query, header, formData, body)
  let scheme = call_593858.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593858.url(scheme.get, call_593858.host, call_593858.base,
                         call_593858.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593858, url, valid)

proc call*(call_593929: Call_AppCollectionsList_593659; apiVersion: string;
          subscriptionId: string): Recallable =
  ## appCollectionsList
  ## Lists app collections in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_593930 = newJObject()
  var query_593932 = newJObject()
  add(query_593932, "api-version", newJString(apiVersion))
  add(path_593930, "subscriptionId", newJString(subscriptionId))
  result = call_593929.call(path_593930, query_593932, nil, nil, nil)

var appCollectionsList* = Call_AppCollectionsList_593659(
    name: "appCollectionsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MobileEngagement/appCollections",
    validator: validate_AppCollectionsList_593660, base: "",
    url: url_AppCollectionsList_593661, schemes: {Scheme.Https})
type
  Call_AppCollectionsCheckNameAvailability_593971 = ref object of OpenApiRestCall_593437
proc url_AppCollectionsCheckNameAvailability_593973(protocol: Scheme; host: string;
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

proc validate_AppCollectionsCheckNameAvailability_593972(path: JsonNode;
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
  var valid_593991 = path.getOrDefault("subscriptionId")
  valid_593991 = validateParameter(valid_593991, JString, required = true,
                                 default = nil)
  if valid_593991 != nil:
    section.add "subscriptionId", valid_593991
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593992 = query.getOrDefault("api-version")
  valid_593992 = validateParameter(valid_593992, JString, required = true,
                                 default = nil)
  if valid_593992 != nil:
    section.add "api-version", valid_593992
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

proc call*(call_593994: Call_AppCollectionsCheckNameAvailability_593971;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks availability of an app collection name in the Engagement domain.
  ## 
  let valid = call_593994.validator(path, query, header, formData, body)
  let scheme = call_593994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593994.url(scheme.get, call_593994.host, call_593994.base,
                         call_593994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593994, url, valid)

proc call*(call_593995: Call_AppCollectionsCheckNameAvailability_593971;
          apiVersion: string; subscriptionId: string; parameters: JsonNode): Recallable =
  ## appCollectionsCheckNameAvailability
  ## Checks availability of an app collection name in the Engagement domain.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   parameters: JObject (required)
  var path_593996 = newJObject()
  var query_593997 = newJObject()
  var body_593998 = newJObject()
  add(query_593997, "api-version", newJString(apiVersion))
  add(path_593996, "subscriptionId", newJString(subscriptionId))
  if parameters != nil:
    body_593998 = parameters
  result = call_593995.call(path_593996, query_593997, nil, nil, body_593998)

var appCollectionsCheckNameAvailability* = Call_AppCollectionsCheckNameAvailability_593971(
    name: "appCollectionsCheckNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MobileEngagement/checkAppCollectionNameAvailability",
    validator: validate_AppCollectionsCheckNameAvailability_593972, base: "",
    url: url_AppCollectionsCheckNameAvailability_593973, schemes: {Scheme.Https})
type
  Call_SupportedPlatformsList_593999 = ref object of OpenApiRestCall_593437
proc url_SupportedPlatformsList_594001(protocol: Scheme; host: string; base: string;
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

proc validate_SupportedPlatformsList_594000(path: JsonNode; query: JsonNode;
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
  var valid_594002 = path.getOrDefault("subscriptionId")
  valid_594002 = validateParameter(valid_594002, JString, required = true,
                                 default = nil)
  if valid_594002 != nil:
    section.add "subscriptionId", valid_594002
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594003 = query.getOrDefault("api-version")
  valid_594003 = validateParameter(valid_594003, JString, required = true,
                                 default = nil)
  if valid_594003 != nil:
    section.add "api-version", valid_594003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594004: Call_SupportedPlatformsList_593999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists supported platforms for Engagement applications.
  ## 
  let valid = call_594004.validator(path, query, header, formData, body)
  let scheme = call_594004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594004.url(scheme.get, call_594004.host, call_594004.base,
                         call_594004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594004, url, valid)

proc call*(call_594005: Call_SupportedPlatformsList_593999; apiVersion: string;
          subscriptionId: string): Recallable =
  ## supportedPlatformsList
  ## Lists supported platforms for Engagement applications.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : Gets subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_594006 = newJObject()
  var query_594007 = newJObject()
  add(query_594007, "api-version", newJString(apiVersion))
  add(path_594006, "subscriptionId", newJString(subscriptionId))
  result = call_594005.call(path_594006, query_594007, nil, nil, nil)

var supportedPlatformsList* = Call_SupportedPlatformsList_593999(
    name: "supportedPlatformsList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.MobileEngagement/supportedPlatforms",
    validator: validate_SupportedPlatformsList_594000, base: "",
    url: url_SupportedPlatformsList_594001, schemes: {Scheme.Https})
type
  Call_AppsList_594008 = ref object of OpenApiRestCall_593437
proc url_AppsList_594010(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_AppsList_594009(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594011 = path.getOrDefault("resourceGroupName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "resourceGroupName", valid_594011
  var valid_594012 = path.getOrDefault("subscriptionId")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "subscriptionId", valid_594012
  var valid_594013 = path.getOrDefault("appCollection")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "appCollection", valid_594013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594014 = query.getOrDefault("api-version")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "api-version", valid_594014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_AppsList_594008; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists apps in an appCollection.
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_AppsList_594008; resourceGroupName: string;
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
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  add(path_594017, "resourceGroupName", newJString(resourceGroupName))
  add(query_594018, "api-version", newJString(apiVersion))
  add(path_594017, "subscriptionId", newJString(subscriptionId))
  add(path_594017, "appCollection", newJString(appCollection))
  result = call_594016.call(path_594017, query_594018, nil, nil, nil)

var appsList* = Call_AppsList_594008(name: "appsList", meth: HttpMethod.HttpGet,
                                  host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps",
                                  validator: validate_AppsList_594009, base: "",
                                  url: url_AppsList_594010,
                                  schemes: {Scheme.Https})
type
  Call_CampaignsCreate_594051 = ref object of OpenApiRestCall_593437
proc url_CampaignsCreate_594053(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsCreate_594052(path: JsonNode; query: JsonNode;
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
  var valid_594064 = path.getOrDefault("resourceGroupName")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "resourceGroupName", valid_594064
  var valid_594065 = path.getOrDefault("appName")
  valid_594065 = validateParameter(valid_594065, JString, required = true,
                                 default = nil)
  if valid_594065 != nil:
    section.add "appName", valid_594065
  var valid_594066 = path.getOrDefault("subscriptionId")
  valid_594066 = validateParameter(valid_594066, JString, required = true,
                                 default = nil)
  if valid_594066 != nil:
    section.add "subscriptionId", valid_594066
  var valid_594067 = path.getOrDefault("kind")
  valid_594067 = validateParameter(valid_594067, JString, required = true,
                                 default = newJString("announcements"))
  if valid_594067 != nil:
    section.add "kind", valid_594067
  var valid_594068 = path.getOrDefault("appCollection")
  valid_594068 = validateParameter(valid_594068, JString, required = true,
                                 default = nil)
  if valid_594068 != nil:
    section.add "appCollection", valid_594068
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594069 = query.getOrDefault("api-version")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "api-version", valid_594069
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

proc call*(call_594071: Call_CampaignsCreate_594051; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a push campaign (announcement, poll, data push or native push).
  ## 
  let valid = call_594071.validator(path, query, header, formData, body)
  let scheme = call_594071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594071.url(scheme.get, call_594071.host, call_594071.base,
                         call_594071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594071, url, valid)

proc call*(call_594072: Call_CampaignsCreate_594051; resourceGroupName: string;
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
  var path_594073 = newJObject()
  var query_594074 = newJObject()
  var body_594075 = newJObject()
  add(path_594073, "resourceGroupName", newJString(resourceGroupName))
  add(query_594074, "api-version", newJString(apiVersion))
  add(path_594073, "appName", newJString(appName))
  add(path_594073, "subscriptionId", newJString(subscriptionId))
  add(path_594073, "kind", newJString(kind))
  add(path_594073, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_594075 = parameters
  result = call_594072.call(path_594073, query_594074, nil, nil, body_594075)

var campaignsCreate* = Call_CampaignsCreate_594051(name: "campaignsCreate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}",
    validator: validate_CampaignsCreate_594052, base: "", url: url_CampaignsCreate_594053,
    schemes: {Scheme.Https})
type
  Call_CampaignsList_594019 = ref object of OpenApiRestCall_593437
proc url_CampaignsList_594021(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsList_594020(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594023 = path.getOrDefault("resourceGroupName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "resourceGroupName", valid_594023
  var valid_594024 = path.getOrDefault("appName")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "appName", valid_594024
  var valid_594025 = path.getOrDefault("subscriptionId")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "subscriptionId", valid_594025
  var valid_594039 = path.getOrDefault("kind")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = newJString("announcements"))
  if valid_594039 != nil:
    section.add "kind", valid_594039
  var valid_594040 = path.getOrDefault("appCollection")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "appCollection", valid_594040
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
  var valid_594041 = query.getOrDefault("$orderby")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "$orderby", valid_594041
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594042 = query.getOrDefault("api-version")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "api-version", valid_594042
  var valid_594043 = query.getOrDefault("$top")
  valid_594043 = validateParameter(valid_594043, JInt, required = false, default = nil)
  if valid_594043 != nil:
    section.add "$top", valid_594043
  var valid_594044 = query.getOrDefault("$skip")
  valid_594044 = validateParameter(valid_594044, JInt, required = false, default = nil)
  if valid_594044 != nil:
    section.add "$skip", valid_594044
  var valid_594045 = query.getOrDefault("$search")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "$search", valid_594045
  var valid_594046 = query.getOrDefault("$filter")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "$filter", valid_594046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594047: Call_CampaignsList_594019; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of campaigns.
  ## 
  let valid = call_594047.validator(path, query, header, formData, body)
  let scheme = call_594047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594047.url(scheme.get, call_594047.host, call_594047.base,
                         call_594047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594047, url, valid)

proc call*(call_594048: Call_CampaignsList_594019; resourceGroupName: string;
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
  var path_594049 = newJObject()
  var query_594050 = newJObject()
  add(query_594050, "$orderby", newJString(Orderby))
  add(path_594049, "resourceGroupName", newJString(resourceGroupName))
  add(query_594050, "api-version", newJString(apiVersion))
  add(path_594049, "appName", newJString(appName))
  add(path_594049, "subscriptionId", newJString(subscriptionId))
  add(query_594050, "$top", newJInt(Top))
  add(path_594049, "kind", newJString(kind))
  add(query_594050, "$skip", newJInt(Skip))
  add(path_594049, "appCollection", newJString(appCollection))
  add(query_594050, "$search", newJString(Search))
  add(query_594050, "$filter", newJString(Filter))
  result = call_594048.call(path_594049, query_594050, nil, nil, nil)

var campaignsList* = Call_CampaignsList_594019(name: "campaignsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}",
    validator: validate_CampaignsList_594020, base: "", url: url_CampaignsList_594021,
    schemes: {Scheme.Https})
type
  Call_CampaignsTestNew_594076 = ref object of OpenApiRestCall_593437
proc url_CampaignsTestNew_594078(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsTestNew_594077(path: JsonNode; query: JsonNode;
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
  var valid_594079 = path.getOrDefault("resourceGroupName")
  valid_594079 = validateParameter(valid_594079, JString, required = true,
                                 default = nil)
  if valid_594079 != nil:
    section.add "resourceGroupName", valid_594079
  var valid_594080 = path.getOrDefault("appName")
  valid_594080 = validateParameter(valid_594080, JString, required = true,
                                 default = nil)
  if valid_594080 != nil:
    section.add "appName", valid_594080
  var valid_594081 = path.getOrDefault("subscriptionId")
  valid_594081 = validateParameter(valid_594081, JString, required = true,
                                 default = nil)
  if valid_594081 != nil:
    section.add "subscriptionId", valid_594081
  var valid_594082 = path.getOrDefault("kind")
  valid_594082 = validateParameter(valid_594082, JString, required = true,
                                 default = newJString("announcements"))
  if valid_594082 != nil:
    section.add "kind", valid_594082
  var valid_594083 = path.getOrDefault("appCollection")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "appCollection", valid_594083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594084 = query.getOrDefault("api-version")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "api-version", valid_594084
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

proc call*(call_594086: Call_CampaignsTestNew_594076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Test a new campaign on a set of devices.
  ## 
  let valid = call_594086.validator(path, query, header, formData, body)
  let scheme = call_594086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594086.url(scheme.get, call_594086.host, call_594086.base,
                         call_594086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594086, url, valid)

proc call*(call_594087: Call_CampaignsTestNew_594076; resourceGroupName: string;
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
  var path_594088 = newJObject()
  var query_594089 = newJObject()
  var body_594090 = newJObject()
  add(path_594088, "resourceGroupName", newJString(resourceGroupName))
  add(query_594089, "api-version", newJString(apiVersion))
  add(path_594088, "appName", newJString(appName))
  add(path_594088, "subscriptionId", newJString(subscriptionId))
  add(path_594088, "kind", newJString(kind))
  add(path_594088, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_594090 = parameters
  result = call_594087.call(path_594088, query_594089, nil, nil, body_594090)

var campaignsTestNew* = Call_CampaignsTestNew_594076(name: "campaignsTestNew",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/test",
    validator: validate_CampaignsTestNew_594077, base: "",
    url: url_CampaignsTestNew_594078, schemes: {Scheme.Https})
type
  Call_CampaignsUpdate_594105 = ref object of OpenApiRestCall_593437
proc url_CampaignsUpdate_594107(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsUpdate_594106(path: JsonNode; query: JsonNode;
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
  var valid_594108 = path.getOrDefault("resourceGroupName")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "resourceGroupName", valid_594108
  var valid_594109 = path.getOrDefault("appName")
  valid_594109 = validateParameter(valid_594109, JString, required = true,
                                 default = nil)
  if valid_594109 != nil:
    section.add "appName", valid_594109
  var valid_594110 = path.getOrDefault("subscriptionId")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "subscriptionId", valid_594110
  var valid_594111 = path.getOrDefault("kind")
  valid_594111 = validateParameter(valid_594111, JString, required = true,
                                 default = newJString("announcements"))
  if valid_594111 != nil:
    section.add "kind", valid_594111
  var valid_594112 = path.getOrDefault("id")
  valid_594112 = validateParameter(valid_594112, JInt, required = true, default = nil)
  if valid_594112 != nil:
    section.add "id", valid_594112
  var valid_594113 = path.getOrDefault("appCollection")
  valid_594113 = validateParameter(valid_594113, JString, required = true,
                                 default = nil)
  if valid_594113 != nil:
    section.add "appCollection", valid_594113
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594114 = query.getOrDefault("api-version")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "api-version", valid_594114
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

proc call*(call_594116: Call_CampaignsUpdate_594105; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update an existing push campaign (announcement, poll, data push or native push).
  ## 
  let valid = call_594116.validator(path, query, header, formData, body)
  let scheme = call_594116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594116.url(scheme.get, call_594116.host, call_594116.base,
                         call_594116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594116, url, valid)

proc call*(call_594117: Call_CampaignsUpdate_594105; resourceGroupName: string;
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
  var path_594118 = newJObject()
  var query_594119 = newJObject()
  var body_594120 = newJObject()
  add(path_594118, "resourceGroupName", newJString(resourceGroupName))
  add(query_594119, "api-version", newJString(apiVersion))
  add(path_594118, "appName", newJString(appName))
  add(path_594118, "subscriptionId", newJString(subscriptionId))
  add(path_594118, "kind", newJString(kind))
  add(path_594118, "id", newJInt(id))
  add(path_594118, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_594120 = parameters
  result = call_594117.call(path_594118, query_594119, nil, nil, body_594120)

var campaignsUpdate* = Call_CampaignsUpdate_594105(name: "campaignsUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}",
    validator: validate_CampaignsUpdate_594106, base: "", url: url_CampaignsUpdate_594107,
    schemes: {Scheme.Https})
type
  Call_CampaignsGet_594091 = ref object of OpenApiRestCall_593437
proc url_CampaignsGet_594093(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsGet_594092(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594094 = path.getOrDefault("resourceGroupName")
  valid_594094 = validateParameter(valid_594094, JString, required = true,
                                 default = nil)
  if valid_594094 != nil:
    section.add "resourceGroupName", valid_594094
  var valid_594095 = path.getOrDefault("appName")
  valid_594095 = validateParameter(valid_594095, JString, required = true,
                                 default = nil)
  if valid_594095 != nil:
    section.add "appName", valid_594095
  var valid_594096 = path.getOrDefault("subscriptionId")
  valid_594096 = validateParameter(valid_594096, JString, required = true,
                                 default = nil)
  if valid_594096 != nil:
    section.add "subscriptionId", valid_594096
  var valid_594097 = path.getOrDefault("kind")
  valid_594097 = validateParameter(valid_594097, JString, required = true,
                                 default = newJString("announcements"))
  if valid_594097 != nil:
    section.add "kind", valid_594097
  var valid_594098 = path.getOrDefault("id")
  valid_594098 = validateParameter(valid_594098, JInt, required = true, default = nil)
  if valid_594098 != nil:
    section.add "id", valid_594098
  var valid_594099 = path.getOrDefault("appCollection")
  valid_594099 = validateParameter(valid_594099, JString, required = true,
                                 default = nil)
  if valid_594099 != nil:
    section.add "appCollection", valid_594099
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594100 = query.getOrDefault("api-version")
  valid_594100 = validateParameter(valid_594100, JString, required = true,
                                 default = nil)
  if valid_594100 != nil:
    section.add "api-version", valid_594100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594101: Call_CampaignsGet_594091; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get campaign operation retrieves information about a previously created campaign.
  ## 
  let valid = call_594101.validator(path, query, header, formData, body)
  let scheme = call_594101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594101.url(scheme.get, call_594101.host, call_594101.base,
                         call_594101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594101, url, valid)

proc call*(call_594102: Call_CampaignsGet_594091; resourceGroupName: string;
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
  var path_594103 = newJObject()
  var query_594104 = newJObject()
  add(path_594103, "resourceGroupName", newJString(resourceGroupName))
  add(query_594104, "api-version", newJString(apiVersion))
  add(path_594103, "appName", newJString(appName))
  add(path_594103, "subscriptionId", newJString(subscriptionId))
  add(path_594103, "kind", newJString(kind))
  add(path_594103, "id", newJInt(id))
  add(path_594103, "appCollection", newJString(appCollection))
  result = call_594102.call(path_594103, query_594104, nil, nil, nil)

var campaignsGet* = Call_CampaignsGet_594091(name: "campaignsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}",
    validator: validate_CampaignsGet_594092, base: "", url: url_CampaignsGet_594093,
    schemes: {Scheme.Https})
type
  Call_CampaignsDelete_594121 = ref object of OpenApiRestCall_593437
proc url_CampaignsDelete_594123(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsDelete_594122(path: JsonNode; query: JsonNode;
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
  var valid_594124 = path.getOrDefault("resourceGroupName")
  valid_594124 = validateParameter(valid_594124, JString, required = true,
                                 default = nil)
  if valid_594124 != nil:
    section.add "resourceGroupName", valid_594124
  var valid_594125 = path.getOrDefault("appName")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "appName", valid_594125
  var valid_594126 = path.getOrDefault("subscriptionId")
  valid_594126 = validateParameter(valid_594126, JString, required = true,
                                 default = nil)
  if valid_594126 != nil:
    section.add "subscriptionId", valid_594126
  var valid_594127 = path.getOrDefault("kind")
  valid_594127 = validateParameter(valid_594127, JString, required = true,
                                 default = newJString("announcements"))
  if valid_594127 != nil:
    section.add "kind", valid_594127
  var valid_594128 = path.getOrDefault("id")
  valid_594128 = validateParameter(valid_594128, JInt, required = true, default = nil)
  if valid_594128 != nil:
    section.add "id", valid_594128
  var valid_594129 = path.getOrDefault("appCollection")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "appCollection", valid_594129
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594130 = query.getOrDefault("api-version")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "api-version", valid_594130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594131: Call_CampaignsDelete_594121; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete a campaign previously created by a call to Create campaign.
  ## 
  let valid = call_594131.validator(path, query, header, formData, body)
  let scheme = call_594131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594131.url(scheme.get, call_594131.host, call_594131.base,
                         call_594131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594131, url, valid)

proc call*(call_594132: Call_CampaignsDelete_594121; resourceGroupName: string;
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
  var path_594133 = newJObject()
  var query_594134 = newJObject()
  add(path_594133, "resourceGroupName", newJString(resourceGroupName))
  add(query_594134, "api-version", newJString(apiVersion))
  add(path_594133, "appName", newJString(appName))
  add(path_594133, "subscriptionId", newJString(subscriptionId))
  add(path_594133, "kind", newJString(kind))
  add(path_594133, "id", newJInt(id))
  add(path_594133, "appCollection", newJString(appCollection))
  result = call_594132.call(path_594133, query_594134, nil, nil, nil)

var campaignsDelete* = Call_CampaignsDelete_594121(name: "campaignsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}",
    validator: validate_CampaignsDelete_594122, base: "", url: url_CampaignsDelete_594123,
    schemes: {Scheme.Https})
type
  Call_CampaignsActivate_594135 = ref object of OpenApiRestCall_593437
proc url_CampaignsActivate_594137(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsActivate_594136(path: JsonNode; query: JsonNode;
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
  var valid_594138 = path.getOrDefault("resourceGroupName")
  valid_594138 = validateParameter(valid_594138, JString, required = true,
                                 default = nil)
  if valid_594138 != nil:
    section.add "resourceGroupName", valid_594138
  var valid_594139 = path.getOrDefault("appName")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "appName", valid_594139
  var valid_594140 = path.getOrDefault("subscriptionId")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "subscriptionId", valid_594140
  var valid_594141 = path.getOrDefault("kind")
  valid_594141 = validateParameter(valid_594141, JString, required = true,
                                 default = newJString("announcements"))
  if valid_594141 != nil:
    section.add "kind", valid_594141
  var valid_594142 = path.getOrDefault("id")
  valid_594142 = validateParameter(valid_594142, JInt, required = true, default = nil)
  if valid_594142 != nil:
    section.add "id", valid_594142
  var valid_594143 = path.getOrDefault("appCollection")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "appCollection", valid_594143
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594144 = query.getOrDefault("api-version")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "api-version", valid_594144
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594145: Call_CampaignsActivate_594135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Activate a campaign previously created by a call to Create campaign.
  ## 
  let valid = call_594145.validator(path, query, header, formData, body)
  let scheme = call_594145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594145.url(scheme.get, call_594145.host, call_594145.base,
                         call_594145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594145, url, valid)

proc call*(call_594146: Call_CampaignsActivate_594135; resourceGroupName: string;
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
  var path_594147 = newJObject()
  var query_594148 = newJObject()
  add(path_594147, "resourceGroupName", newJString(resourceGroupName))
  add(query_594148, "api-version", newJString(apiVersion))
  add(path_594147, "appName", newJString(appName))
  add(path_594147, "subscriptionId", newJString(subscriptionId))
  add(path_594147, "kind", newJString(kind))
  add(path_594147, "id", newJInt(id))
  add(path_594147, "appCollection", newJString(appCollection))
  result = call_594146.call(path_594147, query_594148, nil, nil, nil)

var campaignsActivate* = Call_CampaignsActivate_594135(name: "campaignsActivate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}/activate",
    validator: validate_CampaignsActivate_594136, base: "",
    url: url_CampaignsActivate_594137, schemes: {Scheme.Https})
type
  Call_CampaignsFinish_594149 = ref object of OpenApiRestCall_593437
proc url_CampaignsFinish_594151(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsFinish_594150(path: JsonNode; query: JsonNode;
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
  var valid_594152 = path.getOrDefault("resourceGroupName")
  valid_594152 = validateParameter(valid_594152, JString, required = true,
                                 default = nil)
  if valid_594152 != nil:
    section.add "resourceGroupName", valid_594152
  var valid_594153 = path.getOrDefault("appName")
  valid_594153 = validateParameter(valid_594153, JString, required = true,
                                 default = nil)
  if valid_594153 != nil:
    section.add "appName", valid_594153
  var valid_594154 = path.getOrDefault("subscriptionId")
  valid_594154 = validateParameter(valid_594154, JString, required = true,
                                 default = nil)
  if valid_594154 != nil:
    section.add "subscriptionId", valid_594154
  var valid_594155 = path.getOrDefault("kind")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = newJString("announcements"))
  if valid_594155 != nil:
    section.add "kind", valid_594155
  var valid_594156 = path.getOrDefault("id")
  valid_594156 = validateParameter(valid_594156, JInt, required = true, default = nil)
  if valid_594156 != nil:
    section.add "id", valid_594156
  var valid_594157 = path.getOrDefault("appCollection")
  valid_594157 = validateParameter(valid_594157, JString, required = true,
                                 default = nil)
  if valid_594157 != nil:
    section.add "appCollection", valid_594157
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594158 = query.getOrDefault("api-version")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "api-version", valid_594158
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594159: Call_CampaignsFinish_594149; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Finish a push campaign previously activated by a call to Activate campaign.
  ## 
  let valid = call_594159.validator(path, query, header, formData, body)
  let scheme = call_594159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594159.url(scheme.get, call_594159.host, call_594159.base,
                         call_594159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594159, url, valid)

proc call*(call_594160: Call_CampaignsFinish_594149; resourceGroupName: string;
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
  var path_594161 = newJObject()
  var query_594162 = newJObject()
  add(path_594161, "resourceGroupName", newJString(resourceGroupName))
  add(query_594162, "api-version", newJString(apiVersion))
  add(path_594161, "appName", newJString(appName))
  add(path_594161, "subscriptionId", newJString(subscriptionId))
  add(path_594161, "kind", newJString(kind))
  add(path_594161, "id", newJInt(id))
  add(path_594161, "appCollection", newJString(appCollection))
  result = call_594160.call(path_594161, query_594162, nil, nil, nil)

var campaignsFinish* = Call_CampaignsFinish_594149(name: "campaignsFinish",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}/finish",
    validator: validate_CampaignsFinish_594150, base: "", url: url_CampaignsFinish_594151,
    schemes: {Scheme.Https})
type
  Call_CampaignsPush_594163 = ref object of OpenApiRestCall_593437
proc url_CampaignsPush_594165(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsPush_594164(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594166 = path.getOrDefault("resourceGroupName")
  valid_594166 = validateParameter(valid_594166, JString, required = true,
                                 default = nil)
  if valid_594166 != nil:
    section.add "resourceGroupName", valid_594166
  var valid_594167 = path.getOrDefault("appName")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "appName", valid_594167
  var valid_594168 = path.getOrDefault("subscriptionId")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "subscriptionId", valid_594168
  var valid_594169 = path.getOrDefault("kind")
  valid_594169 = validateParameter(valid_594169, JString, required = true,
                                 default = newJString("announcements"))
  if valid_594169 != nil:
    section.add "kind", valid_594169
  var valid_594170 = path.getOrDefault("id")
  valid_594170 = validateParameter(valid_594170, JInt, required = true, default = nil)
  if valid_594170 != nil:
    section.add "id", valid_594170
  var valid_594171 = path.getOrDefault("appCollection")
  valid_594171 = validateParameter(valid_594171, JString, required = true,
                                 default = nil)
  if valid_594171 != nil:
    section.add "appCollection", valid_594171
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594172 = query.getOrDefault("api-version")
  valid_594172 = validateParameter(valid_594172, JString, required = true,
                                 default = nil)
  if valid_594172 != nil:
    section.add "api-version", valid_594172
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

proc call*(call_594174: Call_CampaignsPush_594163; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Push a previously saved campaign (created with Create campaign) to a set of devices.
  ## 
  let valid = call_594174.validator(path, query, header, formData, body)
  let scheme = call_594174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594174.url(scheme.get, call_594174.host, call_594174.base,
                         call_594174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594174, url, valid)

proc call*(call_594175: Call_CampaignsPush_594163; resourceGroupName: string;
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
  var path_594176 = newJObject()
  var query_594177 = newJObject()
  var body_594178 = newJObject()
  add(path_594176, "resourceGroupName", newJString(resourceGroupName))
  add(query_594177, "api-version", newJString(apiVersion))
  add(path_594176, "appName", newJString(appName))
  add(path_594176, "subscriptionId", newJString(subscriptionId))
  add(path_594176, "kind", newJString(kind))
  add(path_594176, "id", newJInt(id))
  add(path_594176, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_594178 = parameters
  result = call_594175.call(path_594176, query_594177, nil, nil, body_594178)

var campaignsPush* = Call_CampaignsPush_594163(name: "campaignsPush",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}/push",
    validator: validate_CampaignsPush_594164, base: "", url: url_CampaignsPush_594165,
    schemes: {Scheme.Https})
type
  Call_CampaignsGetStatistics_594179 = ref object of OpenApiRestCall_593437
proc url_CampaignsGetStatistics_594181(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsGetStatistics_594180(path: JsonNode; query: JsonNode;
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
  var valid_594182 = path.getOrDefault("resourceGroupName")
  valid_594182 = validateParameter(valid_594182, JString, required = true,
                                 default = nil)
  if valid_594182 != nil:
    section.add "resourceGroupName", valid_594182
  var valid_594183 = path.getOrDefault("appName")
  valid_594183 = validateParameter(valid_594183, JString, required = true,
                                 default = nil)
  if valid_594183 != nil:
    section.add "appName", valid_594183
  var valid_594184 = path.getOrDefault("subscriptionId")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "subscriptionId", valid_594184
  var valid_594185 = path.getOrDefault("kind")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = newJString("announcements"))
  if valid_594185 != nil:
    section.add "kind", valid_594185
  var valid_594186 = path.getOrDefault("id")
  valid_594186 = validateParameter(valid_594186, JInt, required = true, default = nil)
  if valid_594186 != nil:
    section.add "id", valid_594186
  var valid_594187 = path.getOrDefault("appCollection")
  valid_594187 = validateParameter(valid_594187, JString, required = true,
                                 default = nil)
  if valid_594187 != nil:
    section.add "appCollection", valid_594187
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594188 = query.getOrDefault("api-version")
  valid_594188 = validateParameter(valid_594188, JString, required = true,
                                 default = nil)
  if valid_594188 != nil:
    section.add "api-version", valid_594188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594189: Call_CampaignsGetStatistics_594179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get all the campaign statistics.
  ## 
  let valid = call_594189.validator(path, query, header, formData, body)
  let scheme = call_594189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594189.url(scheme.get, call_594189.host, call_594189.base,
                         call_594189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594189, url, valid)

proc call*(call_594190: Call_CampaignsGetStatistics_594179;
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
  var path_594191 = newJObject()
  var query_594192 = newJObject()
  add(path_594191, "resourceGroupName", newJString(resourceGroupName))
  add(query_594192, "api-version", newJString(apiVersion))
  add(path_594191, "appName", newJString(appName))
  add(path_594191, "subscriptionId", newJString(subscriptionId))
  add(path_594191, "kind", newJString(kind))
  add(path_594191, "id", newJInt(id))
  add(path_594191, "appCollection", newJString(appCollection))
  result = call_594190.call(path_594191, query_594192, nil, nil, nil)

var campaignsGetStatistics* = Call_CampaignsGetStatistics_594179(
    name: "campaignsGetStatistics", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}/statistics",
    validator: validate_CampaignsGetStatistics_594180, base: "",
    url: url_CampaignsGetStatistics_594181, schemes: {Scheme.Https})
type
  Call_CampaignsSuspend_594193 = ref object of OpenApiRestCall_593437
proc url_CampaignsSuspend_594195(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsSuspend_594194(path: JsonNode; query: JsonNode;
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
  var valid_594196 = path.getOrDefault("resourceGroupName")
  valid_594196 = validateParameter(valid_594196, JString, required = true,
                                 default = nil)
  if valid_594196 != nil:
    section.add "resourceGroupName", valid_594196
  var valid_594197 = path.getOrDefault("appName")
  valid_594197 = validateParameter(valid_594197, JString, required = true,
                                 default = nil)
  if valid_594197 != nil:
    section.add "appName", valid_594197
  var valid_594198 = path.getOrDefault("subscriptionId")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "subscriptionId", valid_594198
  var valid_594199 = path.getOrDefault("kind")
  valid_594199 = validateParameter(valid_594199, JString, required = true,
                                 default = newJString("announcements"))
  if valid_594199 != nil:
    section.add "kind", valid_594199
  var valid_594200 = path.getOrDefault("id")
  valid_594200 = validateParameter(valid_594200, JInt, required = true, default = nil)
  if valid_594200 != nil:
    section.add "id", valid_594200
  var valid_594201 = path.getOrDefault("appCollection")
  valid_594201 = validateParameter(valid_594201, JString, required = true,
                                 default = nil)
  if valid_594201 != nil:
    section.add "appCollection", valid_594201
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594202 = query.getOrDefault("api-version")
  valid_594202 = validateParameter(valid_594202, JString, required = true,
                                 default = nil)
  if valid_594202 != nil:
    section.add "api-version", valid_594202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594203: Call_CampaignsSuspend_594193; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Suspend a push campaign previously activated by a call to Activate campaign.
  ## 
  let valid = call_594203.validator(path, query, header, formData, body)
  let scheme = call_594203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594203.url(scheme.get, call_594203.host, call_594203.base,
                         call_594203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594203, url, valid)

proc call*(call_594204: Call_CampaignsSuspend_594193; resourceGroupName: string;
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
  var path_594205 = newJObject()
  var query_594206 = newJObject()
  add(path_594205, "resourceGroupName", newJString(resourceGroupName))
  add(query_594206, "api-version", newJString(apiVersion))
  add(path_594205, "appName", newJString(appName))
  add(path_594205, "subscriptionId", newJString(subscriptionId))
  add(path_594205, "kind", newJString(kind))
  add(path_594205, "id", newJInt(id))
  add(path_594205, "appCollection", newJString(appCollection))
  result = call_594204.call(path_594205, query_594206, nil, nil, nil)

var campaignsSuspend* = Call_CampaignsSuspend_594193(name: "campaignsSuspend",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}/suspend",
    validator: validate_CampaignsSuspend_594194, base: "",
    url: url_CampaignsSuspend_594195, schemes: {Scheme.Https})
type
  Call_CampaignsTestSaved_594207 = ref object of OpenApiRestCall_593437
proc url_CampaignsTestSaved_594209(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsTestSaved_594208(path: JsonNode; query: JsonNode;
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
  var valid_594210 = path.getOrDefault("resourceGroupName")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "resourceGroupName", valid_594210
  var valid_594211 = path.getOrDefault("appName")
  valid_594211 = validateParameter(valid_594211, JString, required = true,
                                 default = nil)
  if valid_594211 != nil:
    section.add "appName", valid_594211
  var valid_594212 = path.getOrDefault("subscriptionId")
  valid_594212 = validateParameter(valid_594212, JString, required = true,
                                 default = nil)
  if valid_594212 != nil:
    section.add "subscriptionId", valid_594212
  var valid_594213 = path.getOrDefault("kind")
  valid_594213 = validateParameter(valid_594213, JString, required = true,
                                 default = newJString("announcements"))
  if valid_594213 != nil:
    section.add "kind", valid_594213
  var valid_594214 = path.getOrDefault("id")
  valid_594214 = validateParameter(valid_594214, JInt, required = true, default = nil)
  if valid_594214 != nil:
    section.add "id", valid_594214
  var valid_594215 = path.getOrDefault("appCollection")
  valid_594215 = validateParameter(valid_594215, JString, required = true,
                                 default = nil)
  if valid_594215 != nil:
    section.add "appCollection", valid_594215
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594216 = query.getOrDefault("api-version")
  valid_594216 = validateParameter(valid_594216, JString, required = true,
                                 default = nil)
  if valid_594216 != nil:
    section.add "api-version", valid_594216
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

proc call*(call_594218: Call_CampaignsTestSaved_594207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Test an existing campaign (created with Create campaign) on a set of devices.
  ## 
  let valid = call_594218.validator(path, query, header, formData, body)
  let scheme = call_594218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594218.url(scheme.get, call_594218.host, call_594218.base,
                         call_594218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594218, url, valid)

proc call*(call_594219: Call_CampaignsTestSaved_594207; resourceGroupName: string;
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
  var path_594220 = newJObject()
  var query_594221 = newJObject()
  var body_594222 = newJObject()
  add(path_594220, "resourceGroupName", newJString(resourceGroupName))
  add(query_594221, "api-version", newJString(apiVersion))
  add(path_594220, "appName", newJString(appName))
  add(path_594220, "subscriptionId", newJString(subscriptionId))
  add(path_594220, "kind", newJString(kind))
  add(path_594220, "id", newJInt(id))
  add(path_594220, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_594222 = parameters
  result = call_594219.call(path_594220, query_594221, nil, nil, body_594222)

var campaignsTestSaved* = Call_CampaignsTestSaved_594207(
    name: "campaignsTestSaved", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaigns/{kind}/{id}/test",
    validator: validate_CampaignsTestSaved_594208, base: "",
    url: url_CampaignsTestSaved_594209, schemes: {Scheme.Https})
type
  Call_CampaignsGetByName_594223 = ref object of OpenApiRestCall_593437
proc url_CampaignsGetByName_594225(protocol: Scheme; host: string; base: string;
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

proc validate_CampaignsGetByName_594224(path: JsonNode; query: JsonNode;
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
  var valid_594226 = path.getOrDefault("resourceGroupName")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "resourceGroupName", valid_594226
  var valid_594227 = path.getOrDefault("name")
  valid_594227 = validateParameter(valid_594227, JString, required = true,
                                 default = nil)
  if valid_594227 != nil:
    section.add "name", valid_594227
  var valid_594228 = path.getOrDefault("appName")
  valid_594228 = validateParameter(valid_594228, JString, required = true,
                                 default = nil)
  if valid_594228 != nil:
    section.add "appName", valid_594228
  var valid_594229 = path.getOrDefault("subscriptionId")
  valid_594229 = validateParameter(valid_594229, JString, required = true,
                                 default = nil)
  if valid_594229 != nil:
    section.add "subscriptionId", valid_594229
  var valid_594230 = path.getOrDefault("kind")
  valid_594230 = validateParameter(valid_594230, JString, required = true,
                                 default = newJString("announcements"))
  if valid_594230 != nil:
    section.add "kind", valid_594230
  var valid_594231 = path.getOrDefault("appCollection")
  valid_594231 = validateParameter(valid_594231, JString, required = true,
                                 default = nil)
  if valid_594231 != nil:
    section.add "appCollection", valid_594231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594232 = query.getOrDefault("api-version")
  valid_594232 = validateParameter(valid_594232, JString, required = true,
                                 default = nil)
  if valid_594232 != nil:
    section.add "api-version", valid_594232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594233: Call_CampaignsGetByName_594223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get campaign operation retrieves information about a previously created campaign.
  ## 
  let valid = call_594233.validator(path, query, header, formData, body)
  let scheme = call_594233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594233.url(scheme.get, call_594233.host, call_594233.base,
                         call_594233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594233, url, valid)

proc call*(call_594234: Call_CampaignsGetByName_594223; resourceGroupName: string;
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
  var path_594235 = newJObject()
  var query_594236 = newJObject()
  add(path_594235, "resourceGroupName", newJString(resourceGroupName))
  add(query_594236, "api-version", newJString(apiVersion))
  add(path_594235, "name", newJString(name))
  add(path_594235, "appName", newJString(appName))
  add(path_594235, "subscriptionId", newJString(subscriptionId))
  add(path_594235, "kind", newJString(kind))
  add(path_594235, "appCollection", newJString(appCollection))
  result = call_594234.call(path_594235, query_594236, nil, nil, nil)

var campaignsGetByName* = Call_CampaignsGetByName_594223(
    name: "campaignsGetByName", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/campaignsByName/{kind}/{name}",
    validator: validate_CampaignsGetByName_594224, base: "",
    url: url_CampaignsGetByName_594225, schemes: {Scheme.Https})
type
  Call_DevicesList_594237 = ref object of OpenApiRestCall_593437
proc url_DevicesList_594239(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesList_594238(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_594240 = path.getOrDefault("resourceGroupName")
  valid_594240 = validateParameter(valid_594240, JString, required = true,
                                 default = nil)
  if valid_594240 != nil:
    section.add "resourceGroupName", valid_594240
  var valid_594241 = path.getOrDefault("appName")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "appName", valid_594241
  var valid_594242 = path.getOrDefault("subscriptionId")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "subscriptionId", valid_594242
  var valid_594243 = path.getOrDefault("appCollection")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "appCollection", valid_594243
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
  var valid_594244 = query.getOrDefault("api-version")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "api-version", valid_594244
  var valid_594245 = query.getOrDefault("$top")
  valid_594245 = validateParameter(valid_594245, JInt, required = false, default = nil)
  if valid_594245 != nil:
    section.add "$top", valid_594245
  var valid_594246 = query.getOrDefault("$select")
  valid_594246 = validateParameter(valid_594246, JString, required = false,
                                 default = nil)
  if valid_594246 != nil:
    section.add "$select", valid_594246
  var valid_594247 = query.getOrDefault("$filter")
  valid_594247 = validateParameter(valid_594247, JString, required = false,
                                 default = nil)
  if valid_594247 != nil:
    section.add "$filter", valid_594247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594248: Call_DevicesList_594237; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Query the information associated to the devices running an application.
  ## 
  let valid = call_594248.validator(path, query, header, formData, body)
  let scheme = call_594248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594248.url(scheme.get, call_594248.host, call_594248.base,
                         call_594248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594248, url, valid)

proc call*(call_594249: Call_DevicesList_594237; resourceGroupName: string;
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
  var path_594250 = newJObject()
  var query_594251 = newJObject()
  add(path_594250, "resourceGroupName", newJString(resourceGroupName))
  add(query_594251, "api-version", newJString(apiVersion))
  add(path_594250, "appName", newJString(appName))
  add(path_594250, "subscriptionId", newJString(subscriptionId))
  add(query_594251, "$top", newJInt(Top))
  add(query_594251, "$select", newJString(Select))
  add(path_594250, "appCollection", newJString(appCollection))
  add(query_594251, "$filter", newJString(Filter))
  result = call_594249.call(path_594250, query_594251, nil, nil, nil)

var devicesList* = Call_DevicesList_594237(name: "devicesList",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices",
                                        validator: validate_DevicesList_594238,
                                        base: "", url: url_DevicesList_594239,
                                        schemes: {Scheme.Https})
type
  Call_ExportTasksList_594252 = ref object of OpenApiRestCall_593437
proc url_ExportTasksList_594254(protocol: Scheme; host: string; base: string;
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

proc validate_ExportTasksList_594253(path: JsonNode; query: JsonNode;
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
  var valid_594255 = path.getOrDefault("resourceGroupName")
  valid_594255 = validateParameter(valid_594255, JString, required = true,
                                 default = nil)
  if valid_594255 != nil:
    section.add "resourceGroupName", valid_594255
  var valid_594256 = path.getOrDefault("appName")
  valid_594256 = validateParameter(valid_594256, JString, required = true,
                                 default = nil)
  if valid_594256 != nil:
    section.add "appName", valid_594256
  var valid_594257 = path.getOrDefault("subscriptionId")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "subscriptionId", valid_594257
  var valid_594258 = path.getOrDefault("appCollection")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "appCollection", valid_594258
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
  var valid_594259 = query.getOrDefault("$orderby")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "$orderby", valid_594259
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594260 = query.getOrDefault("api-version")
  valid_594260 = validateParameter(valid_594260, JString, required = true,
                                 default = nil)
  if valid_594260 != nil:
    section.add "api-version", valid_594260
  var valid_594262 = query.getOrDefault("$top")
  valid_594262 = validateParameter(valid_594262, JInt, required = false,
                                 default = newJInt(20))
  if valid_594262 != nil:
    section.add "$top", valid_594262
  var valid_594263 = query.getOrDefault("$skip")
  valid_594263 = validateParameter(valid_594263, JInt, required = false,
                                 default = newJInt(0))
  if valid_594263 != nil:
    section.add "$skip", valid_594263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594264: Call_ExportTasksList_594252; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of export tasks.
  ## 
  let valid = call_594264.validator(path, query, header, formData, body)
  let scheme = call_594264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594264.url(scheme.get, call_594264.host, call_594264.base,
                         call_594264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594264, url, valid)

proc call*(call_594265: Call_ExportTasksList_594252; resourceGroupName: string;
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
  var path_594266 = newJObject()
  var query_594267 = newJObject()
  add(query_594267, "$orderby", newJString(Orderby))
  add(path_594266, "resourceGroupName", newJString(resourceGroupName))
  add(query_594267, "api-version", newJString(apiVersion))
  add(path_594266, "appName", newJString(appName))
  add(path_594266, "subscriptionId", newJString(subscriptionId))
  add(query_594267, "$top", newJInt(Top))
  add(query_594267, "$skip", newJInt(Skip))
  add(path_594266, "appCollection", newJString(appCollection))
  result = call_594265.call(path_594266, query_594267, nil, nil, nil)

var exportTasksList* = Call_ExportTasksList_594252(name: "exportTasksList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks",
    validator: validate_ExportTasksList_594253, base: "", url: url_ExportTasksList_594254,
    schemes: {Scheme.Https})
type
  Call_ExportTasksCreateActivitiesTask_594268 = ref object of OpenApiRestCall_593437
proc url_ExportTasksCreateActivitiesTask_594270(protocol: Scheme; host: string;
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

proc validate_ExportTasksCreateActivitiesTask_594269(path: JsonNode;
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
  var valid_594271 = path.getOrDefault("resourceGroupName")
  valid_594271 = validateParameter(valid_594271, JString, required = true,
                                 default = nil)
  if valid_594271 != nil:
    section.add "resourceGroupName", valid_594271
  var valid_594272 = path.getOrDefault("appName")
  valid_594272 = validateParameter(valid_594272, JString, required = true,
                                 default = nil)
  if valid_594272 != nil:
    section.add "appName", valid_594272
  var valid_594273 = path.getOrDefault("subscriptionId")
  valid_594273 = validateParameter(valid_594273, JString, required = true,
                                 default = nil)
  if valid_594273 != nil:
    section.add "subscriptionId", valid_594273
  var valid_594274 = path.getOrDefault("appCollection")
  valid_594274 = validateParameter(valid_594274, JString, required = true,
                                 default = nil)
  if valid_594274 != nil:
    section.add "appCollection", valid_594274
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594275 = query.getOrDefault("api-version")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "api-version", valid_594275
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

proc call*(call_594277: Call_ExportTasksCreateActivitiesTask_594268;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a task to export activities.
  ## 
  let valid = call_594277.validator(path, query, header, formData, body)
  let scheme = call_594277.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594277.url(scheme.get, call_594277.host, call_594277.base,
                         call_594277.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594277, url, valid)

proc call*(call_594278: Call_ExportTasksCreateActivitiesTask_594268;
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
  var path_594279 = newJObject()
  var query_594280 = newJObject()
  var body_594281 = newJObject()
  add(path_594279, "resourceGroupName", newJString(resourceGroupName))
  add(query_594280, "api-version", newJString(apiVersion))
  add(path_594279, "appName", newJString(appName))
  add(path_594279, "subscriptionId", newJString(subscriptionId))
  add(path_594279, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_594281 = parameters
  result = call_594278.call(path_594279, query_594280, nil, nil, body_594281)

var exportTasksCreateActivitiesTask* = Call_ExportTasksCreateActivitiesTask_594268(
    name: "exportTasksCreateActivitiesTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/activities",
    validator: validate_ExportTasksCreateActivitiesTask_594269, base: "",
    url: url_ExportTasksCreateActivitiesTask_594270, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateCrashesTask_594282 = ref object of OpenApiRestCall_593437
proc url_ExportTasksCreateCrashesTask_594284(protocol: Scheme; host: string;
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

proc validate_ExportTasksCreateCrashesTask_594283(path: JsonNode; query: JsonNode;
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
  var valid_594285 = path.getOrDefault("resourceGroupName")
  valid_594285 = validateParameter(valid_594285, JString, required = true,
                                 default = nil)
  if valid_594285 != nil:
    section.add "resourceGroupName", valid_594285
  var valid_594286 = path.getOrDefault("appName")
  valid_594286 = validateParameter(valid_594286, JString, required = true,
                                 default = nil)
  if valid_594286 != nil:
    section.add "appName", valid_594286
  var valid_594287 = path.getOrDefault("subscriptionId")
  valid_594287 = validateParameter(valid_594287, JString, required = true,
                                 default = nil)
  if valid_594287 != nil:
    section.add "subscriptionId", valid_594287
  var valid_594288 = path.getOrDefault("appCollection")
  valid_594288 = validateParameter(valid_594288, JString, required = true,
                                 default = nil)
  if valid_594288 != nil:
    section.add "appCollection", valid_594288
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594289 = query.getOrDefault("api-version")
  valid_594289 = validateParameter(valid_594289, JString, required = true,
                                 default = nil)
  if valid_594289 != nil:
    section.add "api-version", valid_594289
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

proc call*(call_594291: Call_ExportTasksCreateCrashesTask_594282; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export crashes.
  ## 
  let valid = call_594291.validator(path, query, header, formData, body)
  let scheme = call_594291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594291.url(scheme.get, call_594291.host, call_594291.base,
                         call_594291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594291, url, valid)

proc call*(call_594292: Call_ExportTasksCreateCrashesTask_594282;
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
  var path_594293 = newJObject()
  var query_594294 = newJObject()
  var body_594295 = newJObject()
  add(path_594293, "resourceGroupName", newJString(resourceGroupName))
  add(query_594294, "api-version", newJString(apiVersion))
  add(path_594293, "appName", newJString(appName))
  add(path_594293, "subscriptionId", newJString(subscriptionId))
  add(path_594293, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_594295 = parameters
  result = call_594292.call(path_594293, query_594294, nil, nil, body_594295)

var exportTasksCreateCrashesTask* = Call_ExportTasksCreateCrashesTask_594282(
    name: "exportTasksCreateCrashesTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/crashes",
    validator: validate_ExportTasksCreateCrashesTask_594283, base: "",
    url: url_ExportTasksCreateCrashesTask_594284, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateErrorsTask_594296 = ref object of OpenApiRestCall_593437
proc url_ExportTasksCreateErrorsTask_594298(protocol: Scheme; host: string;
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

proc validate_ExportTasksCreateErrorsTask_594297(path: JsonNode; query: JsonNode;
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
  var valid_594299 = path.getOrDefault("resourceGroupName")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "resourceGroupName", valid_594299
  var valid_594300 = path.getOrDefault("appName")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "appName", valid_594300
  var valid_594301 = path.getOrDefault("subscriptionId")
  valid_594301 = validateParameter(valid_594301, JString, required = true,
                                 default = nil)
  if valid_594301 != nil:
    section.add "subscriptionId", valid_594301
  var valid_594302 = path.getOrDefault("appCollection")
  valid_594302 = validateParameter(valid_594302, JString, required = true,
                                 default = nil)
  if valid_594302 != nil:
    section.add "appCollection", valid_594302
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594303 = query.getOrDefault("api-version")
  valid_594303 = validateParameter(valid_594303, JString, required = true,
                                 default = nil)
  if valid_594303 != nil:
    section.add "api-version", valid_594303
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

proc call*(call_594305: Call_ExportTasksCreateErrorsTask_594296; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export errors.
  ## 
  let valid = call_594305.validator(path, query, header, formData, body)
  let scheme = call_594305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594305.url(scheme.get, call_594305.host, call_594305.base,
                         call_594305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594305, url, valid)

proc call*(call_594306: Call_ExportTasksCreateErrorsTask_594296;
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
  var path_594307 = newJObject()
  var query_594308 = newJObject()
  var body_594309 = newJObject()
  add(path_594307, "resourceGroupName", newJString(resourceGroupName))
  add(query_594308, "api-version", newJString(apiVersion))
  add(path_594307, "appName", newJString(appName))
  add(path_594307, "subscriptionId", newJString(subscriptionId))
  add(path_594307, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_594309 = parameters
  result = call_594306.call(path_594307, query_594308, nil, nil, body_594309)

var exportTasksCreateErrorsTask* = Call_ExportTasksCreateErrorsTask_594296(
    name: "exportTasksCreateErrorsTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/errors",
    validator: validate_ExportTasksCreateErrorsTask_594297, base: "",
    url: url_ExportTasksCreateErrorsTask_594298, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateEventsTask_594310 = ref object of OpenApiRestCall_593437
proc url_ExportTasksCreateEventsTask_594312(protocol: Scheme; host: string;
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

proc validate_ExportTasksCreateEventsTask_594311(path: JsonNode; query: JsonNode;
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
  var valid_594313 = path.getOrDefault("resourceGroupName")
  valid_594313 = validateParameter(valid_594313, JString, required = true,
                                 default = nil)
  if valid_594313 != nil:
    section.add "resourceGroupName", valid_594313
  var valid_594314 = path.getOrDefault("appName")
  valid_594314 = validateParameter(valid_594314, JString, required = true,
                                 default = nil)
  if valid_594314 != nil:
    section.add "appName", valid_594314
  var valid_594315 = path.getOrDefault("subscriptionId")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "subscriptionId", valid_594315
  var valid_594316 = path.getOrDefault("appCollection")
  valid_594316 = validateParameter(valid_594316, JString, required = true,
                                 default = nil)
  if valid_594316 != nil:
    section.add "appCollection", valid_594316
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594317 = query.getOrDefault("api-version")
  valid_594317 = validateParameter(valid_594317, JString, required = true,
                                 default = nil)
  if valid_594317 != nil:
    section.add "api-version", valid_594317
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

proc call*(call_594319: Call_ExportTasksCreateEventsTask_594310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export events.
  ## 
  let valid = call_594319.validator(path, query, header, formData, body)
  let scheme = call_594319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594319.url(scheme.get, call_594319.host, call_594319.base,
                         call_594319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594319, url, valid)

proc call*(call_594320: Call_ExportTasksCreateEventsTask_594310;
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
  var path_594321 = newJObject()
  var query_594322 = newJObject()
  var body_594323 = newJObject()
  add(path_594321, "resourceGroupName", newJString(resourceGroupName))
  add(query_594322, "api-version", newJString(apiVersion))
  add(path_594321, "appName", newJString(appName))
  add(path_594321, "subscriptionId", newJString(subscriptionId))
  add(path_594321, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_594323 = parameters
  result = call_594320.call(path_594321, query_594322, nil, nil, body_594323)

var exportTasksCreateEventsTask* = Call_ExportTasksCreateEventsTask_594310(
    name: "exportTasksCreateEventsTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/events",
    validator: validate_ExportTasksCreateEventsTask_594311, base: "",
    url: url_ExportTasksCreateEventsTask_594312, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateFeedbackTaskByCampaign_594324 = ref object of OpenApiRestCall_593437
proc url_ExportTasksCreateFeedbackTaskByCampaign_594326(protocol: Scheme;
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

proc validate_ExportTasksCreateFeedbackTaskByCampaign_594325(path: JsonNode;
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
  var valid_594327 = path.getOrDefault("resourceGroupName")
  valid_594327 = validateParameter(valid_594327, JString, required = true,
                                 default = nil)
  if valid_594327 != nil:
    section.add "resourceGroupName", valid_594327
  var valid_594328 = path.getOrDefault("appName")
  valid_594328 = validateParameter(valid_594328, JString, required = true,
                                 default = nil)
  if valid_594328 != nil:
    section.add "appName", valid_594328
  var valid_594329 = path.getOrDefault("subscriptionId")
  valid_594329 = validateParameter(valid_594329, JString, required = true,
                                 default = nil)
  if valid_594329 != nil:
    section.add "subscriptionId", valid_594329
  var valid_594330 = path.getOrDefault("appCollection")
  valid_594330 = validateParameter(valid_594330, JString, required = true,
                                 default = nil)
  if valid_594330 != nil:
    section.add "appCollection", valid_594330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594331 = query.getOrDefault("api-version")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "api-version", valid_594331
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

proc call*(call_594333: Call_ExportTasksCreateFeedbackTaskByCampaign_594324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a task to export push campaign data for a set of campaigns.
  ## 
  let valid = call_594333.validator(path, query, header, formData, body)
  let scheme = call_594333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594333.url(scheme.get, call_594333.host, call_594333.base,
                         call_594333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594333, url, valid)

proc call*(call_594334: Call_ExportTasksCreateFeedbackTaskByCampaign_594324;
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
  var path_594335 = newJObject()
  var query_594336 = newJObject()
  var body_594337 = newJObject()
  add(path_594335, "resourceGroupName", newJString(resourceGroupName))
  add(query_594336, "api-version", newJString(apiVersion))
  add(path_594335, "appName", newJString(appName))
  add(path_594335, "subscriptionId", newJString(subscriptionId))
  add(path_594335, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_594337 = parameters
  result = call_594334.call(path_594335, query_594336, nil, nil, body_594337)

var exportTasksCreateFeedbackTaskByCampaign* = Call_ExportTasksCreateFeedbackTaskByCampaign_594324(
    name: "exportTasksCreateFeedbackTaskByCampaign", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/feedbackByCampaign",
    validator: validate_ExportTasksCreateFeedbackTaskByCampaign_594325, base: "",
    url: url_ExportTasksCreateFeedbackTaskByCampaign_594326,
    schemes: {Scheme.Https})
type
  Call_ExportTasksCreateFeedbackTaskByDateRange_594338 = ref object of OpenApiRestCall_593437
proc url_ExportTasksCreateFeedbackTaskByDateRange_594340(protocol: Scheme;
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

proc validate_ExportTasksCreateFeedbackTaskByDateRange_594339(path: JsonNode;
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
  var valid_594341 = path.getOrDefault("resourceGroupName")
  valid_594341 = validateParameter(valid_594341, JString, required = true,
                                 default = nil)
  if valid_594341 != nil:
    section.add "resourceGroupName", valid_594341
  var valid_594342 = path.getOrDefault("appName")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "appName", valid_594342
  var valid_594343 = path.getOrDefault("subscriptionId")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "subscriptionId", valid_594343
  var valid_594344 = path.getOrDefault("appCollection")
  valid_594344 = validateParameter(valid_594344, JString, required = true,
                                 default = nil)
  if valid_594344 != nil:
    section.add "appCollection", valid_594344
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594345 = query.getOrDefault("api-version")
  valid_594345 = validateParameter(valid_594345, JString, required = true,
                                 default = nil)
  if valid_594345 != nil:
    section.add "api-version", valid_594345
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

proc call*(call_594347: Call_ExportTasksCreateFeedbackTaskByDateRange_594338;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a task to export push campaign data for a date range.
  ## 
  let valid = call_594347.validator(path, query, header, formData, body)
  let scheme = call_594347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594347.url(scheme.get, call_594347.host, call_594347.base,
                         call_594347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594347, url, valid)

proc call*(call_594348: Call_ExportTasksCreateFeedbackTaskByDateRange_594338;
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
  var path_594349 = newJObject()
  var query_594350 = newJObject()
  var body_594351 = newJObject()
  add(path_594349, "resourceGroupName", newJString(resourceGroupName))
  add(query_594350, "api-version", newJString(apiVersion))
  add(path_594349, "appName", newJString(appName))
  add(path_594349, "subscriptionId", newJString(subscriptionId))
  add(path_594349, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_594351 = parameters
  result = call_594348.call(path_594349, query_594350, nil, nil, body_594351)

var exportTasksCreateFeedbackTaskByDateRange* = Call_ExportTasksCreateFeedbackTaskByDateRange_594338(
    name: "exportTasksCreateFeedbackTaskByDateRange", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/feedbackByDate",
    validator: validate_ExportTasksCreateFeedbackTaskByDateRange_594339, base: "",
    url: url_ExportTasksCreateFeedbackTaskByDateRange_594340,
    schemes: {Scheme.Https})
type
  Call_ExportTasksCreateJobsTask_594352 = ref object of OpenApiRestCall_593437
proc url_ExportTasksCreateJobsTask_594354(protocol: Scheme; host: string;
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

proc validate_ExportTasksCreateJobsTask_594353(path: JsonNode; query: JsonNode;
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
  var valid_594355 = path.getOrDefault("resourceGroupName")
  valid_594355 = validateParameter(valid_594355, JString, required = true,
                                 default = nil)
  if valid_594355 != nil:
    section.add "resourceGroupName", valid_594355
  var valid_594356 = path.getOrDefault("appName")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "appName", valid_594356
  var valid_594357 = path.getOrDefault("subscriptionId")
  valid_594357 = validateParameter(valid_594357, JString, required = true,
                                 default = nil)
  if valid_594357 != nil:
    section.add "subscriptionId", valid_594357
  var valid_594358 = path.getOrDefault("appCollection")
  valid_594358 = validateParameter(valid_594358, JString, required = true,
                                 default = nil)
  if valid_594358 != nil:
    section.add "appCollection", valid_594358
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594359 = query.getOrDefault("api-version")
  valid_594359 = validateParameter(valid_594359, JString, required = true,
                                 default = nil)
  if valid_594359 != nil:
    section.add "api-version", valid_594359
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

proc call*(call_594361: Call_ExportTasksCreateJobsTask_594352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export jobs.
  ## 
  let valid = call_594361.validator(path, query, header, formData, body)
  let scheme = call_594361.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594361.url(scheme.get, call_594361.host, call_594361.base,
                         call_594361.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594361, url, valid)

proc call*(call_594362: Call_ExportTasksCreateJobsTask_594352;
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
  var path_594363 = newJObject()
  var query_594364 = newJObject()
  var body_594365 = newJObject()
  add(path_594363, "resourceGroupName", newJString(resourceGroupName))
  add(query_594364, "api-version", newJString(apiVersion))
  add(path_594363, "appName", newJString(appName))
  add(path_594363, "subscriptionId", newJString(subscriptionId))
  add(path_594363, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_594365 = parameters
  result = call_594362.call(path_594363, query_594364, nil, nil, body_594365)

var exportTasksCreateJobsTask* = Call_ExportTasksCreateJobsTask_594352(
    name: "exportTasksCreateJobsTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/jobs",
    validator: validate_ExportTasksCreateJobsTask_594353, base: "",
    url: url_ExportTasksCreateJobsTask_594354, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateSessionsTask_594366 = ref object of OpenApiRestCall_593437
proc url_ExportTasksCreateSessionsTask_594368(protocol: Scheme; host: string;
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

proc validate_ExportTasksCreateSessionsTask_594367(path: JsonNode; query: JsonNode;
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
  var valid_594369 = path.getOrDefault("resourceGroupName")
  valid_594369 = validateParameter(valid_594369, JString, required = true,
                                 default = nil)
  if valid_594369 != nil:
    section.add "resourceGroupName", valid_594369
  var valid_594370 = path.getOrDefault("appName")
  valid_594370 = validateParameter(valid_594370, JString, required = true,
                                 default = nil)
  if valid_594370 != nil:
    section.add "appName", valid_594370
  var valid_594371 = path.getOrDefault("subscriptionId")
  valid_594371 = validateParameter(valid_594371, JString, required = true,
                                 default = nil)
  if valid_594371 != nil:
    section.add "subscriptionId", valid_594371
  var valid_594372 = path.getOrDefault("appCollection")
  valid_594372 = validateParameter(valid_594372, JString, required = true,
                                 default = nil)
  if valid_594372 != nil:
    section.add "appCollection", valid_594372
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594373 = query.getOrDefault("api-version")
  valid_594373 = validateParameter(valid_594373, JString, required = true,
                                 default = nil)
  if valid_594373 != nil:
    section.add "api-version", valid_594373
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

proc call*(call_594375: Call_ExportTasksCreateSessionsTask_594366; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export sessions.
  ## 
  let valid = call_594375.validator(path, query, header, formData, body)
  let scheme = call_594375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594375.url(scheme.get, call_594375.host, call_594375.base,
                         call_594375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594375, url, valid)

proc call*(call_594376: Call_ExportTasksCreateSessionsTask_594366;
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
  var path_594377 = newJObject()
  var query_594378 = newJObject()
  var body_594379 = newJObject()
  add(path_594377, "resourceGroupName", newJString(resourceGroupName))
  add(query_594378, "api-version", newJString(apiVersion))
  add(path_594377, "appName", newJString(appName))
  add(path_594377, "subscriptionId", newJString(subscriptionId))
  add(path_594377, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_594379 = parameters
  result = call_594376.call(path_594377, query_594378, nil, nil, body_594379)

var exportTasksCreateSessionsTask* = Call_ExportTasksCreateSessionsTask_594366(
    name: "exportTasksCreateSessionsTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/sessions",
    validator: validate_ExportTasksCreateSessionsTask_594367, base: "",
    url: url_ExportTasksCreateSessionsTask_594368, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateTagsTask_594380 = ref object of OpenApiRestCall_593437
proc url_ExportTasksCreateTagsTask_594382(protocol: Scheme; host: string;
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

proc validate_ExportTasksCreateTagsTask_594381(path: JsonNode; query: JsonNode;
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
  var valid_594383 = path.getOrDefault("resourceGroupName")
  valid_594383 = validateParameter(valid_594383, JString, required = true,
                                 default = nil)
  if valid_594383 != nil:
    section.add "resourceGroupName", valid_594383
  var valid_594384 = path.getOrDefault("appName")
  valid_594384 = validateParameter(valid_594384, JString, required = true,
                                 default = nil)
  if valid_594384 != nil:
    section.add "appName", valid_594384
  var valid_594385 = path.getOrDefault("subscriptionId")
  valid_594385 = validateParameter(valid_594385, JString, required = true,
                                 default = nil)
  if valid_594385 != nil:
    section.add "subscriptionId", valid_594385
  var valid_594386 = path.getOrDefault("appCollection")
  valid_594386 = validateParameter(valid_594386, JString, required = true,
                                 default = nil)
  if valid_594386 != nil:
    section.add "appCollection", valid_594386
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594387 = query.getOrDefault("api-version")
  valid_594387 = validateParameter(valid_594387, JString, required = true,
                                 default = nil)
  if valid_594387 != nil:
    section.add "api-version", valid_594387
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

proc call*(call_594389: Call_ExportTasksCreateTagsTask_594380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export tags.
  ## 
  let valid = call_594389.validator(path, query, header, formData, body)
  let scheme = call_594389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594389.url(scheme.get, call_594389.host, call_594389.base,
                         call_594389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594389, url, valid)

proc call*(call_594390: Call_ExportTasksCreateTagsTask_594380;
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
  var path_594391 = newJObject()
  var query_594392 = newJObject()
  var body_594393 = newJObject()
  add(path_594391, "resourceGroupName", newJString(resourceGroupName))
  add(query_594392, "api-version", newJString(apiVersion))
  add(path_594391, "appName", newJString(appName))
  add(path_594391, "subscriptionId", newJString(subscriptionId))
  add(path_594391, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_594393 = parameters
  result = call_594390.call(path_594391, query_594392, nil, nil, body_594393)

var exportTasksCreateTagsTask* = Call_ExportTasksCreateTagsTask_594380(
    name: "exportTasksCreateTagsTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/tags",
    validator: validate_ExportTasksCreateTagsTask_594381, base: "",
    url: url_ExportTasksCreateTagsTask_594382, schemes: {Scheme.Https})
type
  Call_ExportTasksCreateTokensTask_594394 = ref object of OpenApiRestCall_593437
proc url_ExportTasksCreateTokensTask_594396(protocol: Scheme; host: string;
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

proc validate_ExportTasksCreateTokensTask_594395(path: JsonNode; query: JsonNode;
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
  var valid_594397 = path.getOrDefault("resourceGroupName")
  valid_594397 = validateParameter(valid_594397, JString, required = true,
                                 default = nil)
  if valid_594397 != nil:
    section.add "resourceGroupName", valid_594397
  var valid_594398 = path.getOrDefault("appName")
  valid_594398 = validateParameter(valid_594398, JString, required = true,
                                 default = nil)
  if valid_594398 != nil:
    section.add "appName", valid_594398
  var valid_594399 = path.getOrDefault("subscriptionId")
  valid_594399 = validateParameter(valid_594399, JString, required = true,
                                 default = nil)
  if valid_594399 != nil:
    section.add "subscriptionId", valid_594399
  var valid_594400 = path.getOrDefault("appCollection")
  valid_594400 = validateParameter(valid_594400, JString, required = true,
                                 default = nil)
  if valid_594400 != nil:
    section.add "appCollection", valid_594400
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594401 = query.getOrDefault("api-version")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = nil)
  if valid_594401 != nil:
    section.add "api-version", valid_594401
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

proc call*(call_594403: Call_ExportTasksCreateTokensTask_594394; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a task to export tags.
  ## 
  let valid = call_594403.validator(path, query, header, formData, body)
  let scheme = call_594403.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594403.url(scheme.get, call_594403.host, call_594403.base,
                         call_594403.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594403, url, valid)

proc call*(call_594404: Call_ExportTasksCreateTokensTask_594394;
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
  var path_594405 = newJObject()
  var query_594406 = newJObject()
  var body_594407 = newJObject()
  add(path_594405, "resourceGroupName", newJString(resourceGroupName))
  add(query_594406, "api-version", newJString(apiVersion))
  add(path_594405, "appName", newJString(appName))
  add(path_594405, "subscriptionId", newJString(subscriptionId))
  add(path_594405, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_594407 = parameters
  result = call_594404.call(path_594405, query_594406, nil, nil, body_594407)

var exportTasksCreateTokensTask* = Call_ExportTasksCreateTokensTask_594394(
    name: "exportTasksCreateTokensTask", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/tokens",
    validator: validate_ExportTasksCreateTokensTask_594395, base: "",
    url: url_ExportTasksCreateTokensTask_594396, schemes: {Scheme.Https})
type
  Call_ExportTasksGet_594408 = ref object of OpenApiRestCall_593437
proc url_ExportTasksGet_594410(protocol: Scheme; host: string; base: string;
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

proc validate_ExportTasksGet_594409(path: JsonNode; query: JsonNode;
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
  var valid_594411 = path.getOrDefault("resourceGroupName")
  valid_594411 = validateParameter(valid_594411, JString, required = true,
                                 default = nil)
  if valid_594411 != nil:
    section.add "resourceGroupName", valid_594411
  var valid_594412 = path.getOrDefault("appName")
  valid_594412 = validateParameter(valid_594412, JString, required = true,
                                 default = nil)
  if valid_594412 != nil:
    section.add "appName", valid_594412
  var valid_594413 = path.getOrDefault("subscriptionId")
  valid_594413 = validateParameter(valid_594413, JString, required = true,
                                 default = nil)
  if valid_594413 != nil:
    section.add "subscriptionId", valid_594413
  var valid_594414 = path.getOrDefault("id")
  valid_594414 = validateParameter(valid_594414, JString, required = true,
                                 default = nil)
  if valid_594414 != nil:
    section.add "id", valid_594414
  var valid_594415 = path.getOrDefault("appCollection")
  valid_594415 = validateParameter(valid_594415, JString, required = true,
                                 default = nil)
  if valid_594415 != nil:
    section.add "appCollection", valid_594415
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594416 = query.getOrDefault("api-version")
  valid_594416 = validateParameter(valid_594416, JString, required = true,
                                 default = nil)
  if valid_594416 != nil:
    section.add "api-version", valid_594416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594417: Call_ExportTasksGet_594408; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves information about a previously created export task.
  ## 
  let valid = call_594417.validator(path, query, header, formData, body)
  let scheme = call_594417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594417.url(scheme.get, call_594417.host, call_594417.base,
                         call_594417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594417, url, valid)

proc call*(call_594418: Call_ExportTasksGet_594408; resourceGroupName: string;
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
  var path_594419 = newJObject()
  var query_594420 = newJObject()
  add(path_594419, "resourceGroupName", newJString(resourceGroupName))
  add(query_594420, "api-version", newJString(apiVersion))
  add(path_594419, "appName", newJString(appName))
  add(path_594419, "subscriptionId", newJString(subscriptionId))
  add(path_594419, "id", newJString(id))
  add(path_594419, "appCollection", newJString(appCollection))
  result = call_594418.call(path_594419, query_594420, nil, nil, nil)

var exportTasksGet* = Call_ExportTasksGet_594408(name: "exportTasksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/exportTasks/{id}",
    validator: validate_ExportTasksGet_594409, base: "", url: url_ExportTasksGet_594410,
    schemes: {Scheme.Https})
type
  Call_ImportTasksCreate_594436 = ref object of OpenApiRestCall_593437
proc url_ImportTasksCreate_594438(protocol: Scheme; host: string; base: string;
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

proc validate_ImportTasksCreate_594437(path: JsonNode; query: JsonNode;
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
  var valid_594439 = path.getOrDefault("resourceGroupName")
  valid_594439 = validateParameter(valid_594439, JString, required = true,
                                 default = nil)
  if valid_594439 != nil:
    section.add "resourceGroupName", valid_594439
  var valid_594440 = path.getOrDefault("appName")
  valid_594440 = validateParameter(valid_594440, JString, required = true,
                                 default = nil)
  if valid_594440 != nil:
    section.add "appName", valid_594440
  var valid_594441 = path.getOrDefault("subscriptionId")
  valid_594441 = validateParameter(valid_594441, JString, required = true,
                                 default = nil)
  if valid_594441 != nil:
    section.add "subscriptionId", valid_594441
  var valid_594442 = path.getOrDefault("appCollection")
  valid_594442 = validateParameter(valid_594442, JString, required = true,
                                 default = nil)
  if valid_594442 != nil:
    section.add "appCollection", valid_594442
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594443 = query.getOrDefault("api-version")
  valid_594443 = validateParameter(valid_594443, JString, required = true,
                                 default = nil)
  if valid_594443 != nil:
    section.add "api-version", valid_594443
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

proc call*(call_594445: Call_ImportTasksCreate_594436; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a job to import the specified data to a storageUrl.
  ## 
  let valid = call_594445.validator(path, query, header, formData, body)
  let scheme = call_594445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594445.url(scheme.get, call_594445.host, call_594445.base,
                         call_594445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594445, url, valid)

proc call*(call_594446: Call_ImportTasksCreate_594436; resourceGroupName: string;
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
  var path_594447 = newJObject()
  var query_594448 = newJObject()
  var body_594449 = newJObject()
  add(path_594447, "resourceGroupName", newJString(resourceGroupName))
  add(query_594448, "api-version", newJString(apiVersion))
  add(path_594447, "appName", newJString(appName))
  add(path_594447, "subscriptionId", newJString(subscriptionId))
  add(path_594447, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_594449 = parameters
  result = call_594446.call(path_594447, query_594448, nil, nil, body_594449)

var importTasksCreate* = Call_ImportTasksCreate_594436(name: "importTasksCreate",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/importTasks",
    validator: validate_ImportTasksCreate_594437, base: "",
    url: url_ImportTasksCreate_594438, schemes: {Scheme.Https})
type
  Call_ImportTasksList_594421 = ref object of OpenApiRestCall_593437
proc url_ImportTasksList_594423(protocol: Scheme; host: string; base: string;
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

proc validate_ImportTasksList_594422(path: JsonNode; query: JsonNode;
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
  var valid_594424 = path.getOrDefault("resourceGroupName")
  valid_594424 = validateParameter(valid_594424, JString, required = true,
                                 default = nil)
  if valid_594424 != nil:
    section.add "resourceGroupName", valid_594424
  var valid_594425 = path.getOrDefault("appName")
  valid_594425 = validateParameter(valid_594425, JString, required = true,
                                 default = nil)
  if valid_594425 != nil:
    section.add "appName", valid_594425
  var valid_594426 = path.getOrDefault("subscriptionId")
  valid_594426 = validateParameter(valid_594426, JString, required = true,
                                 default = nil)
  if valid_594426 != nil:
    section.add "subscriptionId", valid_594426
  var valid_594427 = path.getOrDefault("appCollection")
  valid_594427 = validateParameter(valid_594427, JString, required = true,
                                 default = nil)
  if valid_594427 != nil:
    section.add "appCollection", valid_594427
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
  var valid_594428 = query.getOrDefault("$orderby")
  valid_594428 = validateParameter(valid_594428, JString, required = false,
                                 default = nil)
  if valid_594428 != nil:
    section.add "$orderby", valid_594428
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594429 = query.getOrDefault("api-version")
  valid_594429 = validateParameter(valid_594429, JString, required = true,
                                 default = nil)
  if valid_594429 != nil:
    section.add "api-version", valid_594429
  var valid_594430 = query.getOrDefault("$top")
  valid_594430 = validateParameter(valid_594430, JInt, required = false,
                                 default = newJInt(20))
  if valid_594430 != nil:
    section.add "$top", valid_594430
  var valid_594431 = query.getOrDefault("$skip")
  valid_594431 = validateParameter(valid_594431, JInt, required = false,
                                 default = newJInt(0))
  if valid_594431 != nil:
    section.add "$skip", valid_594431
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594432: Call_ImportTasksList_594421; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the list of import jobs.
  ## 
  let valid = call_594432.validator(path, query, header, formData, body)
  let scheme = call_594432.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594432.url(scheme.get, call_594432.host, call_594432.base,
                         call_594432.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594432, url, valid)

proc call*(call_594433: Call_ImportTasksList_594421; resourceGroupName: string;
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
  var path_594434 = newJObject()
  var query_594435 = newJObject()
  add(query_594435, "$orderby", newJString(Orderby))
  add(path_594434, "resourceGroupName", newJString(resourceGroupName))
  add(query_594435, "api-version", newJString(apiVersion))
  add(path_594434, "appName", newJString(appName))
  add(path_594434, "subscriptionId", newJString(subscriptionId))
  add(query_594435, "$top", newJInt(Top))
  add(query_594435, "$skip", newJInt(Skip))
  add(path_594434, "appCollection", newJString(appCollection))
  result = call_594433.call(path_594434, query_594435, nil, nil, nil)

var importTasksList* = Call_ImportTasksList_594421(name: "importTasksList",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/importTasks",
    validator: validate_ImportTasksList_594422, base: "", url: url_ImportTasksList_594423,
    schemes: {Scheme.Https})
type
  Call_ImportTasksGet_594450 = ref object of OpenApiRestCall_593437
proc url_ImportTasksGet_594452(protocol: Scheme; host: string; base: string;
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

proc validate_ImportTasksGet_594451(path: JsonNode; query: JsonNode;
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
  var valid_594453 = path.getOrDefault("resourceGroupName")
  valid_594453 = validateParameter(valid_594453, JString, required = true,
                                 default = nil)
  if valid_594453 != nil:
    section.add "resourceGroupName", valid_594453
  var valid_594454 = path.getOrDefault("appName")
  valid_594454 = validateParameter(valid_594454, JString, required = true,
                                 default = nil)
  if valid_594454 != nil:
    section.add "appName", valid_594454
  var valid_594455 = path.getOrDefault("subscriptionId")
  valid_594455 = validateParameter(valid_594455, JString, required = true,
                                 default = nil)
  if valid_594455 != nil:
    section.add "subscriptionId", valid_594455
  var valid_594456 = path.getOrDefault("id")
  valid_594456 = validateParameter(valid_594456, JString, required = true,
                                 default = nil)
  if valid_594456 != nil:
    section.add "id", valid_594456
  var valid_594457 = path.getOrDefault("appCollection")
  valid_594457 = validateParameter(valid_594457, JString, required = true,
                                 default = nil)
  if valid_594457 != nil:
    section.add "appCollection", valid_594457
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594458 = query.getOrDefault("api-version")
  valid_594458 = validateParameter(valid_594458, JString, required = true,
                                 default = nil)
  if valid_594458 != nil:
    section.add "api-version", valid_594458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594459: Call_ImportTasksGet_594450; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## The Get import job operation retrieves information about a previously created import job.
  ## 
  let valid = call_594459.validator(path, query, header, formData, body)
  let scheme = call_594459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594459.url(scheme.get, call_594459.host, call_594459.base,
                         call_594459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594459, url, valid)

proc call*(call_594460: Call_ImportTasksGet_594450; resourceGroupName: string;
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
  var path_594461 = newJObject()
  var query_594462 = newJObject()
  add(path_594461, "resourceGroupName", newJString(resourceGroupName))
  add(query_594462, "api-version", newJString(apiVersion))
  add(path_594461, "appName", newJString(appName))
  add(path_594461, "subscriptionId", newJString(subscriptionId))
  add(path_594461, "id", newJString(id))
  add(path_594461, "appCollection", newJString(appCollection))
  result = call_594460.call(path_594461, query_594462, nil, nil, nil)

var importTasksGet* = Call_ImportTasksGet_594450(name: "importTasksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/importTasks/{id}",
    validator: validate_ImportTasksGet_594451, base: "", url: url_ImportTasksGet_594452,
    schemes: {Scheme.Https})
type
  Call_DevicesTagByDeviceId_594463 = ref object of OpenApiRestCall_593437
proc url_DevicesTagByDeviceId_594465(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesTagByDeviceId_594464(path: JsonNode; query: JsonNode;
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
  var valid_594466 = path.getOrDefault("resourceGroupName")
  valid_594466 = validateParameter(valid_594466, JString, required = true,
                                 default = nil)
  if valid_594466 != nil:
    section.add "resourceGroupName", valid_594466
  var valid_594467 = path.getOrDefault("appName")
  valid_594467 = validateParameter(valid_594467, JString, required = true,
                                 default = nil)
  if valid_594467 != nil:
    section.add "appName", valid_594467
  var valid_594468 = path.getOrDefault("subscriptionId")
  valid_594468 = validateParameter(valid_594468, JString, required = true,
                                 default = nil)
  if valid_594468 != nil:
    section.add "subscriptionId", valid_594468
  var valid_594469 = path.getOrDefault("appCollection")
  valid_594469 = validateParameter(valid_594469, JString, required = true,
                                 default = nil)
  if valid_594469 != nil:
    section.add "appCollection", valid_594469
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594470 = query.getOrDefault("api-version")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "api-version", valid_594470
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

proc call*(call_594472: Call_DevicesTagByDeviceId_594463; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the tags registered for a set of devices running an application. Updates are performed asynchronously, meaning that a few seconds are needed before the modifications appear in the results of the Get device command.
  ## 
  ## 
  let valid = call_594472.validator(path, query, header, formData, body)
  let scheme = call_594472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594472.url(scheme.get, call_594472.host, call_594472.base,
                         call_594472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594472, url, valid)

proc call*(call_594473: Call_DevicesTagByDeviceId_594463;
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
  var path_594474 = newJObject()
  var query_594475 = newJObject()
  var body_594476 = newJObject()
  add(path_594474, "resourceGroupName", newJString(resourceGroupName))
  add(query_594475, "api-version", newJString(apiVersion))
  add(path_594474, "appName", newJString(appName))
  add(path_594474, "subscriptionId", newJString(subscriptionId))
  add(path_594474, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_594476 = parameters
  result = call_594473.call(path_594474, query_594475, nil, nil, body_594476)

var devicesTagByDeviceId* = Call_DevicesTagByDeviceId_594463(
    name: "devicesTagByDeviceId", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/tag",
    validator: validate_DevicesTagByDeviceId_594464, base: "",
    url: url_DevicesTagByDeviceId_594465, schemes: {Scheme.Https})
type
  Call_DevicesGetByDeviceId_594477 = ref object of OpenApiRestCall_593437
proc url_DevicesGetByDeviceId_594479(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesGetByDeviceId_594478(path: JsonNode; query: JsonNode;
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
  var valid_594480 = path.getOrDefault("resourceGroupName")
  valid_594480 = validateParameter(valid_594480, JString, required = true,
                                 default = nil)
  if valid_594480 != nil:
    section.add "resourceGroupName", valid_594480
  var valid_594481 = path.getOrDefault("appName")
  valid_594481 = validateParameter(valid_594481, JString, required = true,
                                 default = nil)
  if valid_594481 != nil:
    section.add "appName", valid_594481
  var valid_594482 = path.getOrDefault("deviceId")
  valid_594482 = validateParameter(valid_594482, JString, required = true,
                                 default = nil)
  if valid_594482 != nil:
    section.add "deviceId", valid_594482
  var valid_594483 = path.getOrDefault("subscriptionId")
  valid_594483 = validateParameter(valid_594483, JString, required = true,
                                 default = nil)
  if valid_594483 != nil:
    section.add "subscriptionId", valid_594483
  var valid_594484 = path.getOrDefault("appCollection")
  valid_594484 = validateParameter(valid_594484, JString, required = true,
                                 default = nil)
  if valid_594484 != nil:
    section.add "appCollection", valid_594484
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594485 = query.getOrDefault("api-version")
  valid_594485 = validateParameter(valid_594485, JString, required = true,
                                 default = nil)
  if valid_594485 != nil:
    section.add "api-version", valid_594485
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594486: Call_DevicesGetByDeviceId_594477; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the information associated to a device running an application.
  ## 
  let valid = call_594486.validator(path, query, header, formData, body)
  let scheme = call_594486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594486.url(scheme.get, call_594486.host, call_594486.base,
                         call_594486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594486, url, valid)

proc call*(call_594487: Call_DevicesGetByDeviceId_594477;
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
  var path_594488 = newJObject()
  var query_594489 = newJObject()
  add(path_594488, "resourceGroupName", newJString(resourceGroupName))
  add(query_594489, "api-version", newJString(apiVersion))
  add(path_594488, "appName", newJString(appName))
  add(path_594488, "deviceId", newJString(deviceId))
  add(path_594488, "subscriptionId", newJString(subscriptionId))
  add(path_594488, "appCollection", newJString(appCollection))
  result = call_594487.call(path_594488, query_594489, nil, nil, nil)

var devicesGetByDeviceId* = Call_DevicesGetByDeviceId_594477(
    name: "devicesGetByDeviceId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/devices/{deviceId}",
    validator: validate_DevicesGetByDeviceId_594478, base: "",
    url: url_DevicesGetByDeviceId_594479, schemes: {Scheme.Https})
type
  Call_DevicesTagByUserId_594490 = ref object of OpenApiRestCall_593437
proc url_DevicesTagByUserId_594492(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesTagByUserId_594491(path: JsonNode; query: JsonNode;
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
  var valid_594493 = path.getOrDefault("resourceGroupName")
  valid_594493 = validateParameter(valid_594493, JString, required = true,
                                 default = nil)
  if valid_594493 != nil:
    section.add "resourceGroupName", valid_594493
  var valid_594494 = path.getOrDefault("appName")
  valid_594494 = validateParameter(valid_594494, JString, required = true,
                                 default = nil)
  if valid_594494 != nil:
    section.add "appName", valid_594494
  var valid_594495 = path.getOrDefault("subscriptionId")
  valid_594495 = validateParameter(valid_594495, JString, required = true,
                                 default = nil)
  if valid_594495 != nil:
    section.add "subscriptionId", valid_594495
  var valid_594496 = path.getOrDefault("appCollection")
  valid_594496 = validateParameter(valid_594496, JString, required = true,
                                 default = nil)
  if valid_594496 != nil:
    section.add "appCollection", valid_594496
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594497 = query.getOrDefault("api-version")
  valid_594497 = validateParameter(valid_594497, JString, required = true,
                                 default = nil)
  if valid_594497 != nil:
    section.add "api-version", valid_594497
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

proc call*(call_594499: Call_DevicesTagByUserId_594490; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update the tags registered for a set of users running an application. Updates are performed asynchronously, meaning that a few seconds are needed before the modifications appear in the results of the Get device command.
  ## 
  ## 
  let valid = call_594499.validator(path, query, header, formData, body)
  let scheme = call_594499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594499.url(scheme.get, call_594499.host, call_594499.base,
                         call_594499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594499, url, valid)

proc call*(call_594500: Call_DevicesTagByUserId_594490; resourceGroupName: string;
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
  var path_594501 = newJObject()
  var query_594502 = newJObject()
  var body_594503 = newJObject()
  add(path_594501, "resourceGroupName", newJString(resourceGroupName))
  add(query_594502, "api-version", newJString(apiVersion))
  add(path_594501, "appName", newJString(appName))
  add(path_594501, "subscriptionId", newJString(subscriptionId))
  add(path_594501, "appCollection", newJString(appCollection))
  if parameters != nil:
    body_594503 = parameters
  result = call_594500.call(path_594501, query_594502, nil, nil, body_594503)

var devicesTagByUserId* = Call_DevicesTagByUserId_594490(
    name: "devicesTagByUserId", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/users/tag",
    validator: validate_DevicesTagByUserId_594491, base: "",
    url: url_DevicesTagByUserId_594492, schemes: {Scheme.Https})
type
  Call_DevicesGetByUserId_594504 = ref object of OpenApiRestCall_593437
proc url_DevicesGetByUserId_594506(protocol: Scheme; host: string; base: string;
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

proc validate_DevicesGetByUserId_594505(path: JsonNode; query: JsonNode;
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
  var valid_594507 = path.getOrDefault("resourceGroupName")
  valid_594507 = validateParameter(valid_594507, JString, required = true,
                                 default = nil)
  if valid_594507 != nil:
    section.add "resourceGroupName", valid_594507
  var valid_594508 = path.getOrDefault("appName")
  valid_594508 = validateParameter(valid_594508, JString, required = true,
                                 default = nil)
  if valid_594508 != nil:
    section.add "appName", valid_594508
  var valid_594509 = path.getOrDefault("subscriptionId")
  valid_594509 = validateParameter(valid_594509, JString, required = true,
                                 default = nil)
  if valid_594509 != nil:
    section.add "subscriptionId", valid_594509
  var valid_594510 = path.getOrDefault("appCollection")
  valid_594510 = validateParameter(valid_594510, JString, required = true,
                                 default = nil)
  if valid_594510 != nil:
    section.add "appCollection", valid_594510
  var valid_594511 = path.getOrDefault("userId")
  valid_594511 = validateParameter(valid_594511, JString, required = true,
                                 default = nil)
  if valid_594511 != nil:
    section.add "userId", valid_594511
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594512 = query.getOrDefault("api-version")
  valid_594512 = validateParameter(valid_594512, JString, required = true,
                                 default = nil)
  if valid_594512 != nil:
    section.add "api-version", valid_594512
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594513: Call_DevicesGetByUserId_594504; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get the information associated to a device running an application using the user identifier.
  ## 
  let valid = call_594513.validator(path, query, header, formData, body)
  let scheme = call_594513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594513.url(scheme.get, call_594513.host, call_594513.base,
                         call_594513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594513, url, valid)

proc call*(call_594514: Call_DevicesGetByUserId_594504; resourceGroupName: string;
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
  var path_594515 = newJObject()
  var query_594516 = newJObject()
  add(path_594515, "resourceGroupName", newJString(resourceGroupName))
  add(query_594516, "api-version", newJString(apiVersion))
  add(path_594515, "appName", newJString(appName))
  add(path_594515, "subscriptionId", newJString(subscriptionId))
  add(path_594515, "appCollection", newJString(appCollection))
  add(path_594515, "userId", newJString(userId))
  result = call_594514.call(path_594515, query_594516, nil, nil, nil)

var devicesGetByUserId* = Call_DevicesGetByUserId_594504(
    name: "devicesGetByUserId", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MobileEngagement/appcollections/{appCollection}/apps/{appName}/users/{userId}",
    validator: validate_DevicesGetByUserId_594505, base: "",
    url: url_DevicesGetByUserId_594506, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
