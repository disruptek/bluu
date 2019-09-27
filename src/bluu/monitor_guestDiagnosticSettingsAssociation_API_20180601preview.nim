
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Guest Diagnostic Settings Association
## version: 2018-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## API to Add/Remove/List Guest Diagnostics Settings Association for Azure Resources
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

  OpenApiRestCall_593409 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593409](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593409): Option[Scheme] {.used.} =
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
  macServiceName = "monitor-guestDiagnosticSettingsAssociation_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GuestDiagnosticsSettingsAssociationList_593631 = ref object of OpenApiRestCall_593409
proc url_GuestDiagnosticsSettingsAssociationList_593633(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/guestDiagnosticSettingsAssociations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestDiagnosticsSettingsAssociationList_593632(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a list of all guest diagnostic settings association in a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593806 = path.getOrDefault("subscriptionId")
  valid_593806 = validateParameter(valid_593806, JString, required = true,
                                 default = nil)
  if valid_593806 != nil:
    section.add "subscriptionId", valid_593806
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593807 = query.getOrDefault("api-version")
  valid_593807 = validateParameter(valid_593807, JString, required = true,
                                 default = nil)
  if valid_593807 != nil:
    section.add "api-version", valid_593807
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593830: Call_GuestDiagnosticsSettingsAssociationList_593631;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a list of all guest diagnostic settings association in a subscription.
  ## 
  let valid = call_593830.validator(path, query, header, formData, body)
  let scheme = call_593830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593830.url(scheme.get, call_593830.host, call_593830.base,
                         call_593830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593830, url, valid)

proc call*(call_593901: Call_GuestDiagnosticsSettingsAssociationList_593631;
          apiVersion: string; subscriptionId: string): Recallable =
  ## guestDiagnosticsSettingsAssociationList
  ## Get a list of all guest diagnostic settings association in a subscription.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription Id.
  var path_593902 = newJObject()
  var query_593904 = newJObject()
  add(query_593904, "api-version", newJString(apiVersion))
  add(path_593902, "subscriptionId", newJString(subscriptionId))
  result = call_593901.call(path_593902, query_593904, nil, nil, nil)

var guestDiagnosticsSettingsAssociationList* = Call_GuestDiagnosticsSettingsAssociationList_593631(
    name: "guestDiagnosticsSettingsAssociationList", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/microsoft.insights/guestDiagnosticSettingsAssociations",
    validator: validate_GuestDiagnosticsSettingsAssociationList_593632, base: "",
    url: url_GuestDiagnosticsSettingsAssociationList_593633,
    schemes: {Scheme.Https})
type
  Call_GuestDiagnosticsSettingsAssociationListByResourceGroup_593943 = ref object of OpenApiRestCall_593409
proc url_GuestDiagnosticsSettingsAssociationListByResourceGroup_593945(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
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
        kind: ConstantSegment, value: "/providers/microsoft.insights/guestDiagnosticSettingsAssociations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestDiagnosticsSettingsAssociationListByResourceGroup_593944(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Get a list of all guest diagnostic settings association in a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group.
  ##   subscriptionId: JString (required)
  ##                 : The Azure subscription Id.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593946 = path.getOrDefault("resourceGroupName")
  valid_593946 = validateParameter(valid_593946, JString, required = true,
                                 default = nil)
  if valid_593946 != nil:
    section.add "resourceGroupName", valid_593946
  var valid_593947 = path.getOrDefault("subscriptionId")
  valid_593947 = validateParameter(valid_593947, JString, required = true,
                                 default = nil)
  if valid_593947 != nil:
    section.add "subscriptionId", valid_593947
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593948 = query.getOrDefault("api-version")
  valid_593948 = validateParameter(valid_593948, JString, required = true,
                                 default = nil)
  if valid_593948 != nil:
    section.add "api-version", valid_593948
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593949: Call_GuestDiagnosticsSettingsAssociationListByResourceGroup_593943;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a list of all guest diagnostic settings association in a resource group.
  ## 
  let valid = call_593949.validator(path, query, header, formData, body)
  let scheme = call_593949.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593949.url(scheme.get, call_593949.host, call_593949.base,
                         call_593949.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593949, url, valid)

proc call*(call_593950: Call_GuestDiagnosticsSettingsAssociationListByResourceGroup_593943;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## guestDiagnosticsSettingsAssociationListByResourceGroup
  ## Get a list of all guest diagnostic settings association in a resource group.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : The Azure subscription Id.
  var path_593951 = newJObject()
  var query_593952 = newJObject()
  add(path_593951, "resourceGroupName", newJString(resourceGroupName))
  add(query_593952, "api-version", newJString(apiVersion))
  add(path_593951, "subscriptionId", newJString(subscriptionId))
  result = call_593950.call(path_593951, query_593952, nil, nil, nil)

var guestDiagnosticsSettingsAssociationListByResourceGroup* = Call_GuestDiagnosticsSettingsAssociationListByResourceGroup_593943(
    name: "guestDiagnosticsSettingsAssociationListByResourceGroup",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/microsoft.insights/guestDiagnosticSettingsAssociations",
    validator: validate_GuestDiagnosticsSettingsAssociationListByResourceGroup_593944,
    base: "", url: url_GuestDiagnosticsSettingsAssociationListByResourceGroup_593945,
    schemes: {Scheme.Https})
type
  Call_GuestDiagnosticsSettingsAssociationCreateOrUpdate_593963 = ref object of OpenApiRestCall_593409
proc url_GuestDiagnosticsSettingsAssociationCreateOrUpdate_593965(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "associationName" in path, "`associationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/guestDiagnosticSettingsAssociation/"),
               (kind: VariableSegment, value: "associationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestDiagnosticsSettingsAssociationCreateOrUpdate_593964(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates or updates guest diagnostics settings association.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  ##   associationName: JString (required)
  ##                  : The name of the diagnostic settings association.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_593966 = path.getOrDefault("resourceUri")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "resourceUri", valid_593966
  var valid_593967 = path.getOrDefault("associationName")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "associationName", valid_593967
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593968 = query.getOrDefault("api-version")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "api-version", valid_593968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   diagnosticSettingsAssociation: JObject (required)
  ##                                : The diagnostic settings association to create or update.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_593970: Call_GuestDiagnosticsSettingsAssociationCreateOrUpdate_593963;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates or updates guest diagnostics settings association.
  ## 
  let valid = call_593970.validator(path, query, header, formData, body)
  let scheme = call_593970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593970.url(scheme.get, call_593970.host, call_593970.base,
                         call_593970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593970, url, valid)

proc call*(call_593971: Call_GuestDiagnosticsSettingsAssociationCreateOrUpdate_593963;
          apiVersion: string; resourceUri: string; associationName: string;
          diagnosticSettingsAssociation: JsonNode): Recallable =
  ## guestDiagnosticsSettingsAssociationCreateOrUpdate
  ## Creates or updates guest diagnostics settings association.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceUri: string (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  ##   associationName: string (required)
  ##                  : The name of the diagnostic settings association.
  ##   diagnosticSettingsAssociation: JObject (required)
  ##                                : The diagnostic settings association to create or update.
  var path_593972 = newJObject()
  var query_593973 = newJObject()
  var body_593974 = newJObject()
  add(query_593973, "api-version", newJString(apiVersion))
  add(path_593972, "resourceUri", newJString(resourceUri))
  add(path_593972, "associationName", newJString(associationName))
  if diagnosticSettingsAssociation != nil:
    body_593974 = diagnosticSettingsAssociation
  result = call_593971.call(path_593972, query_593973, nil, nil, body_593974)

var guestDiagnosticsSettingsAssociationCreateOrUpdate* = Call_GuestDiagnosticsSettingsAssociationCreateOrUpdate_593963(
    name: "guestDiagnosticsSettingsAssociationCreateOrUpdate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/guestDiagnosticSettingsAssociation/{associationName}",
    validator: validate_GuestDiagnosticsSettingsAssociationCreateOrUpdate_593964,
    base: "", url: url_GuestDiagnosticsSettingsAssociationCreateOrUpdate_593965,
    schemes: {Scheme.Https})
type
  Call_GuestDiagnosticsSettingsAssociationGet_593953 = ref object of OpenApiRestCall_593409
proc url_GuestDiagnosticsSettingsAssociationGet_593955(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "associationName" in path, "`associationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/guestDiagnosticSettingsAssociation/"),
               (kind: VariableSegment, value: "associationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestDiagnosticsSettingsAssociationGet_593954(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets guest diagnostics association settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  ##   associationName: JString (required)
  ##                  : The name of the diagnostic settings association.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_593956 = path.getOrDefault("resourceUri")
  valid_593956 = validateParameter(valid_593956, JString, required = true,
                                 default = nil)
  if valid_593956 != nil:
    section.add "resourceUri", valid_593956
  var valid_593957 = path.getOrDefault("associationName")
  valid_593957 = validateParameter(valid_593957, JString, required = true,
                                 default = nil)
  if valid_593957 != nil:
    section.add "associationName", valid_593957
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593958 = query.getOrDefault("api-version")
  valid_593958 = validateParameter(valid_593958, JString, required = true,
                                 default = nil)
  if valid_593958 != nil:
    section.add "api-version", valid_593958
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593959: Call_GuestDiagnosticsSettingsAssociationGet_593953;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets guest diagnostics association settings.
  ## 
  let valid = call_593959.validator(path, query, header, formData, body)
  let scheme = call_593959.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593959.url(scheme.get, call_593959.host, call_593959.base,
                         call_593959.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593959, url, valid)

proc call*(call_593960: Call_GuestDiagnosticsSettingsAssociationGet_593953;
          apiVersion: string; resourceUri: string; associationName: string): Recallable =
  ## guestDiagnosticsSettingsAssociationGet
  ## Gets guest diagnostics association settings.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceUri: string (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  ##   associationName: string (required)
  ##                  : The name of the diagnostic settings association.
  var path_593961 = newJObject()
  var query_593962 = newJObject()
  add(query_593962, "api-version", newJString(apiVersion))
  add(path_593961, "resourceUri", newJString(resourceUri))
  add(path_593961, "associationName", newJString(associationName))
  result = call_593960.call(path_593961, query_593962, nil, nil, nil)

var guestDiagnosticsSettingsAssociationGet* = Call_GuestDiagnosticsSettingsAssociationGet_593953(
    name: "guestDiagnosticsSettingsAssociationGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/guestDiagnosticSettingsAssociation/{associationName}",
    validator: validate_GuestDiagnosticsSettingsAssociationGet_593954, base: "",
    url: url_GuestDiagnosticsSettingsAssociationGet_593955,
    schemes: {Scheme.Https})
type
  Call_GuestDiagnosticsSettingsAssociationUpdate_593985 = ref object of OpenApiRestCall_593409
proc url_GuestDiagnosticsSettingsAssociationUpdate_593987(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "associationName" in path, "`associationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/guestDiagnosticSettingsAssociation/"),
               (kind: VariableSegment, value: "associationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestDiagnosticsSettingsAssociationUpdate_593986(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing guestDiagnosticsSettingsAssociation Resource. To update other fields use the CreateOrUpdate method
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  ##   associationName: JString (required)
  ##                  : The name of the diagnostic settings association.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_594005 = path.getOrDefault("resourceUri")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "resourceUri", valid_594005
  var valid_594006 = path.getOrDefault("associationName")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "associationName", valid_594006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594007 = query.getOrDefault("api-version")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "api-version", valid_594007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594009: Call_GuestDiagnosticsSettingsAssociationUpdate_593985;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing guestDiagnosticsSettingsAssociation Resource. To update other fields use the CreateOrUpdate method
  ## 
  let valid = call_594009.validator(path, query, header, formData, body)
  let scheme = call_594009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594009.url(scheme.get, call_594009.host, call_594009.base,
                         call_594009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594009, url, valid)

proc call*(call_594010: Call_GuestDiagnosticsSettingsAssociationUpdate_593985;
          apiVersion: string; resourceUri: string; parameters: JsonNode;
          associationName: string): Recallable =
  ## guestDiagnosticsSettingsAssociationUpdate
  ## Updates an existing guestDiagnosticsSettingsAssociation Resource. To update other fields use the CreateOrUpdate method
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceUri: string (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  ##   parameters: JObject (required)
  ##             : Parameters supplied to the operation.
  ##   associationName: string (required)
  ##                  : The name of the diagnostic settings association.
  var path_594011 = newJObject()
  var query_594012 = newJObject()
  var body_594013 = newJObject()
  add(query_594012, "api-version", newJString(apiVersion))
  add(path_594011, "resourceUri", newJString(resourceUri))
  if parameters != nil:
    body_594013 = parameters
  add(path_594011, "associationName", newJString(associationName))
  result = call_594010.call(path_594011, query_594012, nil, nil, body_594013)

var guestDiagnosticsSettingsAssociationUpdate* = Call_GuestDiagnosticsSettingsAssociationUpdate_593985(
    name: "guestDiagnosticsSettingsAssociationUpdate", meth: HttpMethod.HttpPatch,
    host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/guestDiagnosticSettingsAssociation/{associationName}",
    validator: validate_GuestDiagnosticsSettingsAssociationUpdate_593986,
    base: "", url: url_GuestDiagnosticsSettingsAssociationUpdate_593987,
    schemes: {Scheme.Https})
type
  Call_GuestDiagnosticsSettingsAssociationDelete_593975 = ref object of OpenApiRestCall_593409
proc url_GuestDiagnosticsSettingsAssociationDelete_593977(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resourceUri" in path, "`resourceUri` is a required path parameter"
  assert "associationName" in path, "`associationName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceUri"), (
        kind: ConstantSegment, value: "/providers/microsoft.insights/guestDiagnosticSettingsAssociation/"),
               (kind: VariableSegment, value: "associationName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GuestDiagnosticsSettingsAssociationDelete_593976(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete guest diagnostics association settings.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceUri: JString (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  ##   associationName: JString (required)
  ##                  : The name of the diagnostic settings association.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceUri` field"
  var valid_593978 = path.getOrDefault("resourceUri")
  valid_593978 = validateParameter(valid_593978, JString, required = true,
                                 default = nil)
  if valid_593978 != nil:
    section.add "resourceUri", valid_593978
  var valid_593979 = path.getOrDefault("associationName")
  valid_593979 = validateParameter(valid_593979, JString, required = true,
                                 default = nil)
  if valid_593979 != nil:
    section.add "associationName", valid_593979
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593980 = query.getOrDefault("api-version")
  valid_593980 = validateParameter(valid_593980, JString, required = true,
                                 default = nil)
  if valid_593980 != nil:
    section.add "api-version", valid_593980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593981: Call_GuestDiagnosticsSettingsAssociationDelete_593975;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete guest diagnostics association settings.
  ## 
  let valid = call_593981.validator(path, query, header, formData, body)
  let scheme = call_593981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593981.url(scheme.get, call_593981.host, call_593981.base,
                         call_593981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593981, url, valid)

proc call*(call_593982: Call_GuestDiagnosticsSettingsAssociationDelete_593975;
          apiVersion: string; resourceUri: string; associationName: string): Recallable =
  ## guestDiagnosticsSettingsAssociationDelete
  ## Delete guest diagnostics association settings.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   resourceUri: string (required)
  ##              : The fully qualified ID of the resource, including the resource name and resource type.
  ##   associationName: string (required)
  ##                  : The name of the diagnostic settings association.
  var path_593983 = newJObject()
  var query_593984 = newJObject()
  add(query_593984, "api-version", newJString(apiVersion))
  add(path_593983, "resourceUri", newJString(resourceUri))
  add(path_593983, "associationName", newJString(associationName))
  result = call_593982.call(path_593983, query_593984, nil, nil, nil)

var guestDiagnosticsSettingsAssociationDelete* = Call_GuestDiagnosticsSettingsAssociationDelete_593975(
    name: "guestDiagnosticsSettingsAssociationDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/{resourceUri}/providers/microsoft.insights/guestDiagnosticSettingsAssociation/{associationName}",
    validator: validate_GuestDiagnosticsSettingsAssociationDelete_593976,
    base: "", url: url_GuestDiagnosticsSettingsAssociationDelete_593977,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
