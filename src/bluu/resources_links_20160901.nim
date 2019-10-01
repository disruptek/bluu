
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ManagementLinkClient
## version: 2016-09-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Azure resources can be linked together to form logical relationships. You can establish links between resources belonging to different resource groups. However, all the linked resources must belong to the same subscription. Each resource can be linked to 50 other resources. If any of the linked resources are deleted or moved, the link owner must clean up the remaining link.
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

  OpenApiRestCall_567641 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567641](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567641): Option[Scheme] {.used.} =
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
  macServiceName = "resources-links"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_567863 = ref object of OpenApiRestCall_567641
proc url_OperationsList_567865(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_567864(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Microsoft.Resources REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568024 = query.getOrDefault("api-version")
  valid_568024 = validateParameter(valid_568024, JString, required = true,
                                 default = nil)
  if valid_568024 != nil:
    section.add "api-version", valid_568024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568047: Call_OperationsList_567863; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Microsoft.Resources REST API operations.
  ## 
  let valid = call_568047.validator(path, query, header, formData, body)
  let scheme = call_568047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568047.url(scheme.get, call_568047.host, call_568047.base,
                         call_568047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568047, url, valid)

proc call*(call_568118: Call_OperationsList_567863; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Microsoft.Resources REST API operations.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  var query_568119 = newJObject()
  add(query_568119, "api-version", newJString(apiVersion))
  result = call_568118.call(nil, query_568119, nil, nil, nil)

var operationsList* = Call_OperationsList_567863(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Resources/operations",
    validator: validate_OperationsList_567864, base: "", url: url_OperationsList_567865,
    schemes: {Scheme.Https})
type
  Call_ResourceLinksListAtSubscription_568159 = ref object of OpenApiRestCall_567641
proc url_ResourceLinksListAtSubscription_568161(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Resources/links")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceLinksListAtSubscription_568160(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets all the linked resources for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_568177 = path.getOrDefault("subscriptionId")
  valid_568177 = validateParameter(valid_568177, JString, required = true,
                                 default = nil)
  if valid_568177 != nil:
    section.add "subscriptionId", valid_568177
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply on the list resource links operation. The supported filter for list resource links is targetId. For example, $filter=targetId eq {value}
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568178 = query.getOrDefault("api-version")
  valid_568178 = validateParameter(valid_568178, JString, required = true,
                                 default = nil)
  if valid_568178 != nil:
    section.add "api-version", valid_568178
  var valid_568179 = query.getOrDefault("$filter")
  valid_568179 = validateParameter(valid_568179, JString, required = false,
                                 default = nil)
  if valid_568179 != nil:
    section.add "$filter", valid_568179
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568180: Call_ResourceLinksListAtSubscription_568159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets all the linked resources for the subscription.
  ## 
  let valid = call_568180.validator(path, query, header, formData, body)
  let scheme = call_568180.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568180.url(scheme.get, call_568180.host, call_568180.base,
                         call_568180.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568180, url, valid)

proc call*(call_568181: Call_ResourceLinksListAtSubscription_568159;
          apiVersion: string; subscriptionId: string; Filter: string = ""): Recallable =
  ## resourceLinksListAtSubscription
  ## Gets all the linked resources for the subscription.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  ##   Filter: string
  ##         : The filter to apply on the list resource links operation. The supported filter for list resource links is targetId. For example, $filter=targetId eq {value}
  var path_568182 = newJObject()
  var query_568183 = newJObject()
  add(query_568183, "api-version", newJString(apiVersion))
  add(path_568182, "subscriptionId", newJString(subscriptionId))
  add(query_568183, "$filter", newJString(Filter))
  result = call_568181.call(path_568182, query_568183, nil, nil, nil)

var resourceLinksListAtSubscription* = Call_ResourceLinksListAtSubscription_568159(
    name: "resourceLinksListAtSubscription", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Resources/links",
    validator: validate_ResourceLinksListAtSubscription_568160, base: "",
    url: url_ResourceLinksListAtSubscription_568161, schemes: {Scheme.Https})
type
  Call_ResourceLinksCreateOrUpdate_568193 = ref object of OpenApiRestCall_567641
proc url_ResourceLinksCreateOrUpdate_568195(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceLinksCreateOrUpdate_568194(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates a resource link between the specified resources.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   linkId: JString (required)
  ##         : The fully qualified ID of the resource link. Use the format, 
  ## /subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/{provider-namespace}/{resource-type}/{resource-name}/Microsoft.Resources/links/{link-name}. For example, 
  ## /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myGroup/Microsoft.Web/sites/mySite/Microsoft.Resources/links/myLink
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `linkId` field"
  var valid_568213 = path.getOrDefault("linkId")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "linkId", valid_568213
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568214 = query.getOrDefault("api-version")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "api-version", valid_568214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   parameters: JObject (required)
  ##             : Parameters for creating or updating a resource link.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568216: Call_ResourceLinksCreateOrUpdate_568193; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates a resource link between the specified resources.
  ## 
  let valid = call_568216.validator(path, query, header, formData, body)
  let scheme = call_568216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568216.url(scheme.get, call_568216.host, call_568216.base,
                         call_568216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568216, url, valid)

proc call*(call_568217: Call_ResourceLinksCreateOrUpdate_568193;
          apiVersion: string; parameters: JsonNode; linkId: string): Recallable =
  ## resourceLinksCreateOrUpdate
  ## Creates or updates a resource link between the specified resources.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   parameters: JObject (required)
  ##             : Parameters for creating or updating a resource link.
  ##   linkId: string (required)
  ##         : The fully qualified ID of the resource link. Use the format, 
  ## /subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/{provider-namespace}/{resource-type}/{resource-name}/Microsoft.Resources/links/{link-name}. For example, 
  ## /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myGroup/Microsoft.Web/sites/mySite/Microsoft.Resources/links/myLink
  var path_568218 = newJObject()
  var query_568219 = newJObject()
  var body_568220 = newJObject()
  add(query_568219, "api-version", newJString(apiVersion))
  if parameters != nil:
    body_568220 = parameters
  add(path_568218, "linkId", newJString(linkId))
  result = call_568217.call(path_568218, query_568219, nil, nil, body_568220)

var resourceLinksCreateOrUpdate* = Call_ResourceLinksCreateOrUpdate_568193(
    name: "resourceLinksCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/{linkId}",
    validator: validate_ResourceLinksCreateOrUpdate_568194, base: "",
    url: url_ResourceLinksCreateOrUpdate_568195, schemes: {Scheme.Https})
type
  Call_ResourceLinksGet_568184 = ref object of OpenApiRestCall_567641
proc url_ResourceLinksGet_568186(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceLinksGet_568185(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets a resource link with the specified ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   linkId: JString (required)
  ##         : The fully qualified Id of the resource link. For example, 
  ## /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myGroup/Microsoft.Web/sites/mySite/Microsoft.Resources/links/myLink
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `linkId` field"
  var valid_568187 = path.getOrDefault("linkId")
  valid_568187 = validateParameter(valid_568187, JString, required = true,
                                 default = nil)
  if valid_568187 != nil:
    section.add "linkId", valid_568187
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568188 = query.getOrDefault("api-version")
  valid_568188 = validateParameter(valid_568188, JString, required = true,
                                 default = nil)
  if valid_568188 != nil:
    section.add "api-version", valid_568188
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568189: Call_ResourceLinksGet_568184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a resource link with the specified ID.
  ## 
  let valid = call_568189.validator(path, query, header, formData, body)
  let scheme = call_568189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568189.url(scheme.get, call_568189.host, call_568189.base,
                         call_568189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568189, url, valid)

proc call*(call_568190: Call_ResourceLinksGet_568184; apiVersion: string;
          linkId: string): Recallable =
  ## resourceLinksGet
  ## Gets a resource link with the specified ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   linkId: string (required)
  ##         : The fully qualified Id of the resource link. For example, 
  ## /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myGroup/Microsoft.Web/sites/mySite/Microsoft.Resources/links/myLink
  var path_568191 = newJObject()
  var query_568192 = newJObject()
  add(query_568192, "api-version", newJString(apiVersion))
  add(path_568191, "linkId", newJString(linkId))
  result = call_568190.call(path_568191, query_568192, nil, nil, nil)

var resourceLinksGet* = Call_ResourceLinksGet_568184(name: "resourceLinksGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/{linkId}",
    validator: validate_ResourceLinksGet_568185, base: "",
    url: url_ResourceLinksGet_568186, schemes: {Scheme.Https})
type
  Call_ResourceLinksDelete_568221 = ref object of OpenApiRestCall_567641
proc url_ResourceLinksDelete_568223(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceLinksDelete_568222(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes a resource link with the specified ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   linkId: JString (required)
  ##         : The fully qualified ID of the resource link. Use the format, 
  ## /subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/{provider-namespace}/{resource-type}/{resource-name}/Microsoft.Resources/links/{link-name}. For example, 
  ## /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myGroup/Microsoft.Web/sites/mySite/Microsoft.Resources/links/myLink
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `linkId` field"
  var valid_568224 = path.getOrDefault("linkId")
  valid_568224 = validateParameter(valid_568224, JString, required = true,
                                 default = nil)
  if valid_568224 != nil:
    section.add "linkId", valid_568224
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568225 = query.getOrDefault("api-version")
  valid_568225 = validateParameter(valid_568225, JString, required = true,
                                 default = nil)
  if valid_568225 != nil:
    section.add "api-version", valid_568225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568226: Call_ResourceLinksDelete_568221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a resource link with the specified ID.
  ## 
  let valid = call_568226.validator(path, query, header, formData, body)
  let scheme = call_568226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568226.url(scheme.get, call_568226.host, call_568226.base,
                         call_568226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568226, url, valid)

proc call*(call_568227: Call_ResourceLinksDelete_568221; apiVersion: string;
          linkId: string): Recallable =
  ## resourceLinksDelete
  ## Deletes a resource link with the specified ID.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   linkId: string (required)
  ##         : The fully qualified ID of the resource link. Use the format, 
  ## /subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/{provider-namespace}/{resource-type}/{resource-name}/Microsoft.Resources/links/{link-name}. For example, 
  ## /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myGroup/Microsoft.Web/sites/mySite/Microsoft.Resources/links/myLink
  var path_568228 = newJObject()
  var query_568229 = newJObject()
  add(query_568229, "api-version", newJString(apiVersion))
  add(path_568228, "linkId", newJString(linkId))
  result = call_568227.call(path_568228, query_568229, nil, nil, nil)

var resourceLinksDelete* = Call_ResourceLinksDelete_568221(
    name: "resourceLinksDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/{linkId}",
    validator: validate_ResourceLinksDelete_568222, base: "",
    url: url_ResourceLinksDelete_568223, schemes: {Scheme.Https})
type
  Call_ResourceLinksListAtSourceScope_568230 = ref object of OpenApiRestCall_567641
proc url_ResourceLinksListAtSourceScope_568232(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "scope" in path, "`scope` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "scope"), (kind: ConstantSegment,
        value: "/providers/Microsoft.Resources/links")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceLinksListAtSourceScope_568231(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a list of resource links at and below the specified source scope.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   scope: JString (required)
  ##        : The fully qualified ID of the scope for getting the resource links. For example, to list resource links at and under a resource group, set the scope to /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myGroup.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `scope` field"
  var valid_568233 = path.getOrDefault("scope")
  valid_568233 = validateParameter(valid_568233, JString, required = true,
                                 default = nil)
  if valid_568233 != nil:
    section.add "scope", valid_568233
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for the operation.
  ##   $filter: JString
  ##          : The filter to apply when getting resource links. To get links only at the specified scope (not below the scope), use Filter.atScope().
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568234 = query.getOrDefault("api-version")
  valid_568234 = validateParameter(valid_568234, JString, required = true,
                                 default = nil)
  if valid_568234 != nil:
    section.add "api-version", valid_568234
  var valid_568248 = query.getOrDefault("$filter")
  valid_568248 = validateParameter(valid_568248, JString, required = false,
                                 default = newJString("atScope()"))
  if valid_568248 != nil:
    section.add "$filter", valid_568248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568249: Call_ResourceLinksListAtSourceScope_568230; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a list of resource links at and below the specified source scope.
  ## 
  let valid = call_568249.validator(path, query, header, formData, body)
  let scheme = call_568249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568249.url(scheme.get, call_568249.host, call_568249.base,
                         call_568249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568249, url, valid)

proc call*(call_568250: Call_ResourceLinksListAtSourceScope_568230;
          apiVersion: string; scope: string; Filter: string = "atScope()"): Recallable =
  ## resourceLinksListAtSourceScope
  ## Gets a list of resource links at and below the specified source scope.
  ##   apiVersion: string (required)
  ##             : The API version to use for the operation.
  ##   scope: string (required)
  ##        : The fully qualified ID of the scope for getting the resource links. For example, to list resource links at and under a resource group, set the scope to /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myGroup.
  ##   Filter: string
  ##         : The filter to apply when getting resource links. To get links only at the specified scope (not below the scope), use Filter.atScope().
  var path_568251 = newJObject()
  var query_568252 = newJObject()
  add(query_568252, "api-version", newJString(apiVersion))
  add(path_568251, "scope", newJString(scope))
  add(query_568252, "$filter", newJString(Filter))
  result = call_568250.call(path_568251, query_568252, nil, nil, nil)

var resourceLinksListAtSourceScope* = Call_ResourceLinksListAtSourceScope_568230(
    name: "resourceLinksListAtSourceScope", meth: HttpMethod.HttpGet,
    host: "management.azure.com",
    route: "/{scope}/providers/Microsoft.Resources/links",
    validator: validate_ResourceLinksListAtSourceScope_568231, base: "",
    url: url_ResourceLinksListAtSourceScope_568232, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
